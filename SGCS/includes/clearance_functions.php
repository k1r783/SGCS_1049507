<?php

require_once __DIR__ . '/../config/database.php';


/*
|--------------------------------------------------------------------------
| GENERAL HELPERS
|--------------------------------------------------------------------------
*/

function clean_input($value)
{
    return trim(strip_tags((string)$value));
}


function clean_message($value, $max = 500)
{
    return substr(clean_input($value), 0, (int)$max);
}


function academic_display_label($value, $fallback = 'None')
{
    $value = trim((string)$value);

    if (
        $value === '' ||
        stripos($value, 'unmapped') !== false ||
        stripos($value, 'needs admin review') !== false
    ) {
        return $fallback;
    }

    return $value;
}


function is_valid_email($email)
{
    return filter_var($email, FILTER_VALIDATE_EMAIL) !== false;
}


function normalize_phone_number($code, $phone)
{
    $phone = preg_replace('/[^0-9]/', '', (string)$phone);

    $allowedCodes = [
        '+254',
        '+255',
        '+256',
        '+250',
        '+1',
        '+44'
    ];

    if (
        !in_array($code, $allowedCodes, true) ||
        $phone === ''
    ) {
        return false;
    }

    $prefix = substr($code, 1);

    /*
     * Remove country prefix if the user typed it.
     */
    if (strpos($phone, $prefix) === 0) {
        $phone = substr(
            $phone,
            strlen($prefix)
        );
    }

    /*
     * Remove local leading zero.
     */
    $phone = ltrim($phone, '0');

    if (
        strlen($phone) < 6 ||
        strlen($phone) > 14
    ) {
        return false;
    }

    return $code . $phone;
}


function value_exists(
    $pdo,
    $table,
    $column,
    $value,
    $exclude = null,
    $idColumn = null
) {
    /*
     * Whitelist tables and columns to prevent SQL injection.
     */
    $allowed = [
        'students' => [
            'registration_no',
            'email',
            'phone',
            'national_id_passport_no'
        ],
        'users' => [
            'username',
            'email'
        ]
    ];

    if (
        !isset($allowed[$table]) ||
        !in_array($column, $allowed[$table], true)
    ) {
        return false;
    }

    $sql = "SELECT 1 FROM {$table} WHERE {$column} = ?";
    $args = [$value];

    if (
        $exclude !== null &&
        $idColumn !== null
    ) {
        $sql .= " AND {$idColumn} <> ?";
        $args[] = $exclude;
    }

    $sql .= ' LIMIT 1';

    $stmt = $pdo->prepare($sql);
    $stmt->execute($args);

    return (bool)$stmt->fetchColumn();
}


/*
|--------------------------------------------------------------------------
| STUDENT / USER LOOKUPS
|--------------------------------------------------------------------------
*/

function get_student_by_user($pdo, $user)
{
    if (
        !$user ||
        strtolower((string)($user['role'] ?? '')) !== 'student'
    ) {
        return null;
    }

    $studentId = (int)($user['linked_id'] ?? 0);

    if ($studentId <= 0) {
        return null;
    }

    $stmt = $pdo->prepare(
        'SELECT
            s.*,
            sc.school_name,
            COALESCE(i.institute_name, s.institute) AS institute_name,
            COALESCE(p.programme_name, s.programme) AS programme_name,
            p.qualification_type_id,
            qt.qualification_name,
            gs.set_name,
            gs.is_active AS graduation_set_active

        FROM students s

        LEFT JOIN schools sc
            ON sc.school_id = s.school_id

        LEFT JOIN institutes i
            ON i.institute_id = s.institute_id

        LEFT JOIN programmes p
            ON p.programme_id = s.programme_id

        LEFT JOIN qualification_types qt
            ON qt.qualification_type_id = p.qualification_type_id

        LEFT JOIN graduation_sets gs
            ON gs.graduation_set_id = s.graduation_set_id

        WHERE s.student_id = ?

        LIMIT 1'
    );

    $stmt->execute([$studentId]);

    return $stmt->fetch(PDO::FETCH_ASSOC);
}


function get_student_user_id($pdo, $studentId)
{
    $stmt = $pdo->prepare(
        "SELECT user_id
         FROM users
         WHERE role = 'student'
         AND linked_id = ?
         AND deleted_at IS NULL
         LIMIT 1"
    );

    $stmt->execute([(int)$studentId]);

    $userId = $stmt->fetchColumn();

    return $userId !== false
        ? (int)$userId
        : null;
}


function get_user_institute_id($pdo, $userId)
{
    $stmt = $pdo->prepare(
        'SELECT institute_id
         FROM users
         WHERE user_id = ?
         LIMIT 1'
    );

    $stmt->execute([(int)$userId]);

    $instituteId = $stmt->fetchColumn();

    return (
        $instituteId !== false &&
        $instituteId !== null &&
        (int)$instituteId > 0
    )
        ? (int)$instituteId
        : null;
}


/*
 * Return the school assigned to a school-scoped Dean account.
 */
function get_user_school_id($pdo, $userId)
{
    $stmt = $pdo->prepare(
        'SELECT school_id
         FROM users
         WHERE user_id = ?
         LIMIT 1'
    );

    $stmt->execute([(int)$userId]);

    $schoolId = $stmt->fetchColumn();

    return (
        $schoolId !== false &&
        $schoolId !== null &&
        (int)$schoolId > 0
    )
        ? (int)$schoolId
        : null;
}


/*
|--------------------------------------------------------------------------
| DEPARTMENTS / OFFICERS
|--------------------------------------------------------------------------
*/

function get_departments($pdo)
{
    return $pdo->query(
        'SELECT *
         FROM departments
         ORDER BY sequence_no ASC, dept_id ASC'
    )->fetchAll(PDO::FETCH_ASSOC);
}


function get_institute_director_department($pdo)
{
    /*
     * First clearance workflow stage.
     *
     * Supports installations using either:
     * - Institute Director
     * - Institute
     */

    $stmt = $pdo->prepare(
        "SELECT *
         FROM departments
         WHERE LOWER(TRIM(dept_name))
         IN ('institute director', 'institute')
         ORDER BY
            CASE LOWER(TRIM(dept_name))
                WHEN 'institute director' THEN 0
                WHEN 'institute' THEN 1
                ELSE 2
            END,
            sequence_no ASC
         LIMIT 1"
    );

    $stmt->execute();

    $department = $stmt->fetch(PDO::FETCH_ASSOC);

    if ($department) {
        return $department;
    }

    /*
     * Last-resort fallback:
     * use workflow stage 1.
     */
    $stmt = $pdo->prepare(
        'SELECT *
         FROM departments
         WHERE sequence_no = 1
         ORDER BY dept_id ASC
         LIMIT 1'
    );

    $stmt->execute();

    return $stmt->fetch(PDO::FETCH_ASSOC);
}


function get_dean_department($pdo)
{
    /*
     * Shared Dean workflow stage.
     *
     * Supports common department names used in SGCS.
     */
    $stmt = $pdo->prepare(
        "SELECT *
         FROM departments
         WHERE LOWER(TRIM(dept_name))
         IN
         (
             'dean',
             'dean''s office',
             'deans office',
             'school dean'
         )
         ORDER BY sequence_no ASC, dept_id ASC
         LIMIT 1"
    );

    $stmt->execute();

    return $stmt->fetch(PDO::FETCH_ASSOC);
}


function get_assigned_department($pdo, $user)
{
    if (!$user) {
        return null;
    }

    $role = strtolower(
        (string)($user['role'] ?? '')
    );

    /*
     * Directors use the shared Institute Director
     * workflow department and are restricted
     * by institute_id.
     */
    if ($role === 'director') {

        $instituteId = get_user_institute_id(
            $pdo,
            $user['user_id']
        );

        if (!$instituteId) {
            return null;
        }

        return get_institute_director_department($pdo);
    }

    /*
     * All school Deans use the same Dean workflow stage.
     *
     * The student list is then restricted by:
     *
     * student.school_id = dean.school_id
     */
    if ($role === 'dean') {

        $schoolId = get_user_school_id(
            $pdo,
            $user['user_id']
        );

        if (!$schoolId) {
            return null;
        }

        return get_dean_department($pdo);
    }

    # Use the department saved on the user's account first.
    $stmt = $pdo->prepare(
        'SELECT d.*
         FROM departments d
         INNER JOIN users u ON u.department_id = d.dept_id
         WHERE u.user_id = ?
         LIMIT 1'
    );

    $stmt->execute([
        (int)$user['user_id']
    ]);

    $department = $stmt->fetch(PDO::FETCH_ASSOC);

    if ($department) {
        return $department;
    }

    # Keep the old department assignment as a fallback.
    $stmt = $pdo->prepare(
        'SELECT *
         FROM departments
         WHERE officer_user_id = ?
         LIMIT 1'
    );

    $stmt->execute([
        (int)$user['user_id']
    ]);

    return $stmt->fetch(PDO::FETCH_ASSOC);
}


function get_institute_directors($pdo, $instituteId)
{
    $stmt = $pdo->prepare(
        "SELECT user_id
         FROM users
         WHERE LOWER(role) = 'director'
         AND account_status = 'Active'
         AND deleted_at IS NULL
         AND institute_id = ?"
    );

    $stmt->execute([
        (int)$instituteId
    ]);

    return $stmt->fetchAll(PDO::FETCH_ASSOC);
}


/*
|--------------------------------------------------------------------------
| CLEARANCE REQUEST LOOKUPS
|--------------------------------------------------------------------------
*/

function get_latest_clearance_request($pdo, $studentId)
{
    $stmt = $pdo->prepare(
        'SELECT
            cr.*,
            d.dept_name AS current_department

         FROM clearance_requests cr

         LEFT JOIN departments d
            ON d.dept_id = cr.current_dept_id

         WHERE cr.student_id = ?

         ORDER BY cr.request_id DESC

         LIMIT 1'
    );

    $stmt->execute([
        (int)$studentId
    ]);

    return $stmt->fetch(PDO::FETCH_ASSOC);
}


/*
|--------------------------------------------------------------------------
| NOTIFICATIONS
|--------------------------------------------------------------------------
*/

function add_notification(
    $pdo,
    $userId,
    $type,
    $message
) {
    $userId = (int)$userId;
    $type = trim((string)$type);
    $message = trim((string)$message);

    if (
        $userId <= 0 ||
        $type === '' ||
        $message === ''
    ) {
        return false;
    }

    try {

        /*
         * Confirm recipient exists.
         */
        $check = $pdo->prepare(
            'SELECT user_id
             FROM users
             WHERE user_id = ?
             AND deleted_at IS NULL
             LIMIT 1'
        );

        $check->execute([$userId]);

        if (!$check->fetchColumn()) {

            error_log(
                'Notification recipient not found: '
                . $userId
            );

            return false;
        }

        $stmt = $pdo->prepare(
            'INSERT INTO notifications
            (
                recipient_user_id,
                notif_type,
                message
            )
            VALUES
            (
                ?,
                ?,
                ?
            )'
        );

        $saved = $stmt->execute([
            $userId,
            $type,
            $message
        ]);

        if (!$saved) {

            $error = $stmt->errorInfo();

            error_log(
                'Notification insert failed for user '
                . $userId
                . ': '
                . ($error[2] ?? 'Unknown database error')
            );

            return false;
        }

        return true;

    } catch (PDOException $e) {

        error_log(
            'Notification database error: '
            . $e->getMessage()
        );

        return false;
    }
}


function get_notifications(
    $pdo,
    $userId,
    $limit = 5
) {
    $userId = (int)$userId;
    $limit = (int)$limit;

    if ($userId <= 0) {
        return [];
    }

    if ($limit < 1) {
        $limit = 1;
    }

    if ($limit > 100) {
        $limit = 100;
    }

    try {

        /*
         * LIMIT is integer-controlled internally,
         * so direct concatenation is safe here.
         */
        $stmt = $pdo->prepare(
            'SELECT *
             FROM notifications
             WHERE recipient_user_id = ?
             ORDER BY sent_at DESC
             LIMIT ' . $limit
        );

        $stmt->execute([$userId]);

        return $stmt->fetchAll(
            PDO::FETCH_ASSOC
        );

    } catch (PDOException $e) {

        error_log(
            'Notification retrieval error: '
            . $e->getMessage()
        );

        return [];
    }
}


/*
|--------------------------------------------------------------------------
| AUDIT LOGGING
|--------------------------------------------------------------------------
*/

function log_audit($pdo, $id, $action, $details = '')
{
    try {

        /*
         * Failed login attempts may not have a valid user ID.
         *
         * Do not attempt to insert an invalid foreign key value.
         */
        if ($id === null || (int)$id <= 0) {

            return false;
        }

        $stmt = $pdo->prepare(
            'INSERT INTO audit_logs
            (
                user_id,
                action,
                details
            )
            VALUES
            (
                ?,
                ?,
                ?
            )'
        );

        return $stmt->execute([
            (int)$id,
            clean_message($action, 100),
            clean_message($details, 1000)
        ]);

    } catch (PDOException $e) {

        /*
         * Audit logging must never stop login or clearance workflows.
         */
        error_log(
            'Audit log error: '
            . $e->getMessage()
        );

        return false;
    }
}


/*
|--------------------------------------------------------------------------
| STUDENT PROFILE
|--------------------------------------------------------------------------
*/

function profile_display_name(
    $student,
    $order = null
) {
    $order = $order ?: (
        $student['certificate_name_order']
        ?? 'first_middle_last'
    );

    $first = trim(
        (string)($student['first_name'] ?? '')
    );

    $middle = trim(
        (string)($student['middle_name'] ?? '')
    );

    $last = trim(
        (string)($student['last_name'] ?? '')
    );

    $fullName = trim(
        (string)($student['full_name'] ?? '')
    );

    if (!$first && !$last) {
        return $fullName;
    }

    if ($order === 'last_first_middle') {
        return trim(
            $last . ' '
            . $first . ' '
            . $middle
        );
    }

    return trim(
        $first . ' '
        . $middle . ' '
        . $last
    );
}


/*
|--------------------------------------------------------------------------
| DOCUMENTS
|--------------------------------------------------------------------------
*/

function get_current_documents(
    $pdo,
    $studentId
) {
    $stmt = $pdo->prepare(
        "SELECT *
         FROM supporting_documents
         WHERE student_id = ?
         AND status <> 'Replaced'
         ORDER BY uploaded_at DESC, document_id DESC"
    );

    $stmt->execute([
        (int)$studentId
    ]);

    $documents = [];

    foreach (
        $stmt->fetchAll(PDO::FETCH_ASSOC)
        as $row
    ) {

        if (
            !isset(
                $documents[
                    $row['document_type']
                ]
            )
        ) {
            $documents[
                $row['document_type']
            ] = $row;
        }
    }

    return $documents;
}


/*
|--------------------------------------------------------------------------
| GRADUATION SET ELIGIBILITY
|--------------------------------------------------------------------------
*/

function get_graduation_session_status(
    $pdo,
    $student
) {
    $qualificationTypeId = (int)(
        $student['qualification_type_id'] ?? 0
    );

    $stmt = $pdo->prepare(
        'SELECT gs.*
         FROM graduation_sets gs
         WHERE gs.is_active = 1
         AND (
             NOT EXISTS
             (
                 SELECT 1
                 FROM graduation_set_qualification_types m
                 WHERE m.graduation_set_id = gs.graduation_set_id
             )
             OR EXISTS
             (
                 SELECT 1
                 FROM graduation_set_qualification_types m
                 WHERE m.graduation_set_id = gs.graduation_set_id
                 AND m.qualification_type_id = ?
             )
         )
         ORDER BY gs.graduation_set_id DESC
         LIMIT 1'
    );

    $stmt->execute([
        $qualificationTypeId
    ]);

    $set = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$set) {
        return [
            'status' => 'unavailable',
            'set' => null
        ];
    }

    if (
        !empty($set['starts_at'])
        && strtotime($set['starts_at']) > time()
    ) {
        return [
            'status' => 'not_started',
            'set' => $set
        ];
    }

    if (
        !empty($set['ends_at'])
        && strtotime($set['ends_at']) < time()
    ) {
        return [
            'status' => 'expired',
            'set' => $set
        ];
    }

    return [
        'status' => 'available',
        'set' => $set
    ];
}


function get_active_compatible_graduation_set(
    $pdo,
    $student
) {
    $qualificationTypeId = (int)(
        $student['qualification_type_id'] ?? 0
    );

    $stmt = $pdo->prepare(
        'SELECT gs.*
         FROM graduation_sets gs
         WHERE gs.is_active = 1
         AND (
             gs.starts_at IS NULL
             OR gs.starts_at <= NOW()
         )
         AND (
             gs.ends_at IS NULL
             OR gs.ends_at >= NOW()
         )
         AND (
             NOT EXISTS
             (
                 SELECT 1
                 FROM graduation_set_qualification_types m
                 WHERE m.graduation_set_id =
                       gs.graduation_set_id
             )
             OR EXISTS
             (
                 SELECT 1
                 FROM graduation_set_qualification_types m
                 WHERE m.graduation_set_id =
                       gs.graduation_set_id
                 AND m.qualification_type_id = ?
             )
         )
         ORDER BY gs.graduation_set_id DESC
         LIMIT 1'
    );

    $stmt->execute([
        $qualificationTypeId
    ]);

    return $stmt->fetch(PDO::FETCH_ASSOC);
}


function profile_completion_missing(
    $pdo,
    $student
) {
    $missing = [];

    $activeSet =
        get_active_compatible_graduation_set(
            $pdo,
            $student
        );

    if (!$activeSet) {
        $missing[] =
            'an active graduation set for your qualification';
    }

    $required = [
        'first_name' => 'first name',
        'last_name' => 'last name',
        'email' => 'email address',
        'phone' => 'phone number',
        'school_id' => 'school',
        'institute_id' => 'institute',
        'programme_id' => 'programme'
    ];

    foreach (
        $required as $key => $label
    ) {
        if (empty($student[$key])) {
            $missing[] = $label;
        }
    }

    $documents =
        get_current_documents(
            $pdo,
            $student['student_id']
        );

    $requiredDocuments = [
        'id_passport' =>
            'National ID or Passport',

        'final_year_project' =>
            'Final Year Project'
    ];

    foreach (
        $requiredDocuments as $key => $label
    ) {
        if (empty($documents[$key])) {
            $missing[] = $label;
        }
    }

    if (
        empty(
            $student[
                'certificate_name_confirmed_at'
            ]
        )
    ) {
        $missing[] =
            'confirmed Final Approval name';
    }

    return $missing;
}


function clearance_eligibility(
    $pdo,
    $student
) {
    $missing =
        profile_completion_missing(
            $pdo,
            $student
        );

    $activeSet =
        get_active_compatible_graduation_set(
            $pdo,
            $student
        );

    $activeSetId = (int)(
        $activeSet['graduation_set_id'] ?? 0
    );

    if ($activeSetId <= 0) {
        return $missing;
    }

    /*
     * Prevent duplicate active clearance requests.
     */
    $stmt = $pdo->prepare(
        "SELECT 1
         FROM clearance_requests
         WHERE student_id = ?
         AND graduation_set_id = ?
         AND overall_status IN
         (
            'Pending',
            'In Progress'
         )
         LIMIT 1"
    );

    $stmt->execute([
        (int)$student['student_id'],
        $activeSetId
    ]);

    if ($stmt->fetchColumn()) {
        $missing[] =
            'an existing active clearance request';
    }

    return $missing;
}


/*
|--------------------------------------------------------------------------
| DOCUMENT UPLOAD
|--------------------------------------------------------------------------
*/

function save_document(
    $pdo,
    $student,
    $type,
    $file
) {
    $allowedTypes = [
        'id_passport',
        'final_year_project'
    ];

    if (
        !in_array(
            $type,
            $allowedTypes,
            true
        )
    ) {
        return 'Invalid document type.';
    }

    if (
        !$file ||
        !isset($file['error']) ||
        $file['error'] !== UPLOAD_ERR_OK ||
        !isset($file['size']) ||
        $file['size'] > 5 * 1024 * 1024
    ) {
        return 'Upload a PDF smaller than 5 MB.';
    }

    if (
        empty($file['tmp_name']) ||
        !is_uploaded_file($file['tmp_name'])
    ) {
        return 'Invalid uploaded file.';
    }

    $mime = (
        new finfo(FILEINFO_MIME_TYPE)
    )->file(
        $file['tmp_name']
    );

    if ($mime !== 'application/pdf') {
        return 'Only validated PDF documents are accepted.';
    }

    $dir =
        __DIR__
        . '/../private_uploads/documents';

    if (
        !is_dir($dir) &&
        !mkdir(
            $dir,
            0700,
            true
        )
    ) {
        return 'Secure upload storage is unavailable.';
    }

    $name =
        bin2hex(
            random_bytes(18)
        )
        . '.pdf';

    $destination =
        $dir
        . '/'
        . $name;

    if (
        !move_uploaded_file(
            $file['tmp_name'],
            $destination
        )
    ) {
        return 'Document could not be saved.';
    }

    try {

        $pdo->beginTransaction();

        /*
         * Replace previous current document.
         */
        $pdo->prepare(
            "UPDATE supporting_documents
             SET
                status = 'Replaced',
                replaced_at = NOW()
             WHERE student_id = ?
             AND document_type = ?
             AND status <> 'Replaced'"
        )->execute([
            (int)$student['student_id'],
            $type
        ]);

        $request =
            get_latest_clearance_request(
                $pdo,
                $student['student_id']
            );

        $pdo->prepare(
            "INSERT INTO supporting_documents
            (
                request_id,
                student_id,
                document_type,
                filename,
                file_path,
                stored_name,
                mime_type,
                status
            )
            VALUES
            (
                ?,
                ?,
                ?,
                ?,
                ?,
                ?,
                ?,
                'Pending'
            )"
        )->execute([
            $request
                ? (int)$request['request_id']
                : null,

            (int)$student['student_id'],
            $type,

            (string)$file['name'],

            'private_uploads/documents/'
            . $name,

            $name,
            $mime
        ]);

        if (
            isset($_SESSION['user_id'])
        ) {
            log_audit(
                $pdo,
                $_SESSION['user_id'],
                'document_uploaded',
                $type
                . ' uploaded for student #'
                . $student['student_id']
            );
        }

        $pdo->commit();

        return 'Document uploaded successfully.';

    } catch (Exception $e) {

        if ($pdo->inTransaction()) {
            $pdo->rollBack();
        }

        @unlink($destination);

        error_log(
            'Document upload database error: '
            . $e->getMessage()
        );

        return 'Document could not be recorded.';
    }
}


/*
|--------------------------------------------------------------------------
| RESUBMISSION
|--------------------------------------------------------------------------
*/

function resubmit_clearance_request(
    $pdo,
    $request,
    $studentUser
) {
    if (
        !$request ||
        ($request['overall_status'] ?? '')
        !== 'Rejected'
    ) {
        return 'This request cannot be resubmitted.';
    }

    $stmt = $pdo->prepare(
        "SELECT dept_id
         FROM approval_records
         WHERE request_id = ?
         AND status = 'Rejected'
         ORDER BY approval_id DESC
         LIMIT 1"
    );

    $stmt->execute([
        (int)$request['request_id']
    ]);

    $deptId = $stmt->fetchColumn();

    if (!$deptId) {
        return
            'The rejecting department could not be identified.';
    }

    try {

        $pdo->beginTransaction();

        /*
         * Create a fresh pending review
         * for the rejecting department.
         */
        $pdo->prepare(
            "INSERT INTO approval_records
            (
                request_id,
                dept_id,
                status
            )
            VALUES
            (
                ?,
                ?,
                'Pending'
            )"
        )->execute([
            (int)$request['request_id'],
            (int)$deptId
        ]);

        $pdo->prepare(
            "UPDATE clearance_requests
             SET
                overall_status = 'In Progress',
                current_dept_id = ?
             WHERE request_id = ?"
        )->execute([
            (int)$deptId,
            (int)$request['request_id']
        ]);

        /*
         * Determine department details.
         */
        $deptStmt = $pdo->prepare(
            'SELECT *
             FROM departments
             WHERE dept_id = ?
             LIMIT 1'
        );

        $deptStmt->execute([
            (int)$deptId
        ]);

        $department =
            $deptStmt->fetch(PDO::FETCH_ASSOC);

        /*
         * If this is the Institute Director stage,
         * notify all Directors for the student's institute.
         */
        $firstStage =
            get_institute_director_department($pdo);

        if (
            $firstStage &&
            (int)$firstStage['dept_id']
            === (int)$deptId
        ) {

            $studentStmt = $pdo->prepare(
                'SELECT institute_id
                 FROM students
                 WHERE student_id = ?
                 LIMIT 1'
            );

            $studentStmt->execute([
                (int)$request['student_id']
            ]);

            $instituteId =
                $studentStmt->fetchColumn();

            if ($instituteId) {

                $directors =
                    get_institute_directors(
                        $pdo,
                        $instituteId
                    );

                foreach (
                    $directors as $director
                ) {
                    add_notification(
                        $pdo,
                        $director['user_id'],
                        'resubmitted_request',
                        'A corrected clearance request awaits re-review.'
                    );
                }
            }

        } elseif (
            $department &&
            !empty(
                $department['officer_user_id']
            )
        ) {

            add_notification(
                $pdo,
                $department['officer_user_id'],
                'resubmitted_request',
                'A corrected clearance request awaits re-review.'
            );
        }

        add_notification(
            $pdo,
            $studentUser,
            'clearance_resubmitted',
            'Your request has returned to the department that rejected it.'
        );

        log_audit(
            $pdo,
            $studentUser,
            'clearance_resubmitted',
            'Request #'
            . $request['request_id']
            . ' returned to department #'
            . $deptId
        );

        $pdo->commit();

        return
            'Your request was resubmitted to the rejecting department.';

    } catch (Exception $e) {

        if ($pdo->inTransaction()) {
            $pdo->rollBack();
        }

        error_log(
            'Clearance resubmission error: '
            . $e->getMessage()
        );

        return 'Resubmission failed.';
    }
}


/*
|--------------------------------------------------------------------------
| INITIATE CLEARANCE
|--------------------------------------------------------------------------
*/

function initiate_clearance(
    $pdo,
    $student,
    $userId
) {
    $missing =
        clearance_eligibility(
            $pdo,
            $student
        );

    if ($missing) {
        return [
            'error' =>
                'Clearance cannot be initiated: '
                . implode(', ', $missing)
                . '.'
        ];
    }

    $activeSet =
        get_active_compatible_graduation_set(
            $pdo,
            $student
        );

    if (!$activeSet) {
        return [
            'error' =>
                'No compatible active graduation set is available.'
        ];
    }

    $first =
        get_institute_director_department($pdo);

    if (!$first) {
        return [
            'error' =>
                'The Institute Director stage is not configured.'
        ];
    }

    $instituteId = (int)(
        $student['institute_id'] ?? 0
    );

    if ($instituteId <= 0) {
        return [
            'error' =>
                'Your institute is not properly assigned.'
        ];
    }

    $directors =
        get_institute_directors(
            $pdo,
            $instituteId
        );

    if (!$directors) {
        return [
            'error' =>
                'No active Institute Director is assigned to your institute.'
        ];
    }

    try {

        $pdo->beginTransaction();

        /*
         * Create clearance request.
         */
        $stmt = $pdo->prepare(
            "INSERT INTO clearance_requests
            (
                student_id,
                graduation_set_id,
                overall_status,
                current_dept_id
            )
            VALUES
            (
                ?,
                ?,
                'Pending',
                ?
            )"
        );

        $stmt->execute([
            (int)$student['student_id'],
            (int)$activeSet['graduation_set_id'],
            (int)$first['dept_id']
        ]);

        $requestId =
            (int)$pdo->lastInsertId();

        /*
         * Create pending approval records
         * for every workflow department.
         */
        $approval = $pdo->prepare(
            "INSERT INTO approval_records
            (
                request_id,
                dept_id,
                status
            )
            VALUES
            (
                ?,
                ?,
                'Pending'
            )"
        );

        foreach (
            get_departments($pdo)
            as $department
        ) {
            $approval->execute([
                $requestId,
                (int)$department['dept_id']
            ]);
        }

        /*
         * Notify all Institute Directors
         * assigned to the student's institute.
         */
        foreach (
            $directors as $director
        ) {
            add_notification(
                $pdo,
                $director['user_id'],
                'pending_clearance_request',
                'A clearance request from your institute awaits Institute Director review.'
            );
        }

        /*
         * Notify student.
         */
        add_notification(
            $pdo,
            $userId,
            'clearance_started',
            'Your clearance request was initiated.'
        );

        log_audit(
            $pdo,
            $userId,
            'clearance_request_created',
            'Request #' . $requestId
        );

        $pdo->commit();

        return [
            'request_id' => $requestId
        ];

    } catch (Exception $e) {

        if ($pdo->inTransaction()) {
            $pdo->rollBack();
        }

        error_log(
            'Clearance initiation error: '
            . $e->getMessage()
        );

        return [
            'error' =>
                'Clearance request could not be created.'
        ];
    }
}


/*
|--------------------------------------------------------------------------
| REVIEW AUTHORIZATION
|--------------------------------------------------------------------------
*/

function authorized_review_request(
    $pdo,
    $requestId,
    $department,
    $user
) {
    if (
        !$department ||
        empty($department['dept_id'])
    ) {
        return null;
    }

    $sql =
        'SELECT
            cr.*,
            s.student_id,
            s.school_id,
            s.institute_id,
            s.full_name,
            s.registration_no,
            s.programme

         FROM clearance_requests cr

         JOIN students s
            ON s.student_id = cr.student_id

         WHERE cr.request_id = ?
         AND cr.current_dept_id = ?
         AND cr.overall_status IN
         (
            \'Pending\',
            \'In Progress\'
         )
         AND EXISTS
         (
            SELECT 1
            FROM approval_records ar
            WHERE ar.request_id = cr.request_id
            AND ar.dept_id = ?
            AND ar.status = \'Pending\'
         )';

    $args = [
        (int)$requestId,
        (int)$department['dept_id'],
        (int)$department['dept_id']
    ];

    $role = strtolower(
        (string)($user['role'] ?? '')
    );

    /*
     * Directors only review students
     * from their assigned institute.
     */
    if ($role === 'director') {

        $instituteId =
            get_user_institute_id(
                $pdo,
                $user['user_id']
            );

        if (!$instituteId) {
            return null;
        }

        $sql .=
            ' AND s.institute_id = ?';

        $args[] =
            (int)$instituteId;
    }

    /*
     * Deans only review students
     * from their assigned school.
     */
    if ($role === 'dean') {

        $schoolId =
            get_user_school_id(
                $pdo,
                $user['user_id']
            );

        if (!$schoolId) {
            return null;
        }

        $sql .=
            ' AND s.school_id = ?';

        $args[] =
            (int)$schoolId;
    }

    $stmt = $pdo->prepare(
        $sql . ' LIMIT 1'
    );

    $stmt->execute($args);

    return $stmt->fetch(
        PDO::FETCH_ASSOC
    );
}


/*
|--------------------------------------------------------------------------
| LIBRARY CHECK
|--------------------------------------------------------------------------
*/

function save_library_physical_check(
    $pdo,
    $requestId,
    $deptId,
    $officerId,
    $yes
) {
    $stmt = $pdo->prepare(
        'INSERT INTO department_review_checks
        (
            request_id,
            dept_id,
            physical_fyp_submitted,
            checked_by,
            checked_at
        )
        VALUES
        (
            ?,
            ?,
            ?,
            ?,
            NOW()
        )

        ON DUPLICATE KEY UPDATE

            physical_fyp_submitted =
                VALUES(physical_fyp_submitted),

            checked_by =
                VALUES(checked_by),

            checked_at =
                NOW()'
    );

    return $stmt->execute([
        (int)$requestId,
        (int)$deptId,
        $yes ? 1 : 0,
        (int)$officerId
    ]);
}


/*
|--------------------------------------------------------------------------
| WORKFLOW NOTIFICATION RECIPIENTS
|--------------------------------------------------------------------------
*/

function get_active_school_deans($pdo, $schoolId)
{
    if (!(int)$schoolId) return [];

    $stmt = $pdo->prepare(
        "SELECT user_id
         FROM users
         WHERE LOWER(TRIM(role)) = 'dean'
           AND school_id = ?
           AND account_status = 'Active'
           AND deleted_at IS NULL"
    );
    $stmt->execute([(int)$schoolId]);
    return $stmt->fetchAll(PDO::FETCH_ASSOC);
}

function notify_next_clearance_stage($pdo, $request, $next)
{
    $nextName = strtolower(trim((string)($next['dept_name'] ?? '')));
    $message = 'A clearance request is awaiting your review.';

    $directorStage = get_institute_director_department($pdo);
    if ($directorStage && (int)$next['dept_id'] === (int)$directorStage['dept_id']) {
        foreach (get_institute_directors($pdo, (int)($request['institute_id'] ?? 0)) as $director) {
            add_notification($pdo, (int)$director['user_id'], 'pending_clearance_request', $message);
        }
        return;
    }

    /* Shared Dean stage: notify the active Dean(s) for this student's school. */
    if (str_contains($nextName, 'dean')) {
        foreach (get_active_school_deans($pdo, (int)($request['school_id'] ?? 0)) as $dean) {
            add_notification($pdo, (int)$dean['user_id'], 'pending_clearance_request', $message);
        }
        return;
    }

    if (!empty($next['officer_user_id'])) {
        add_notification($pdo, (int)$next['officer_user_id'], 'pending_clearance_request', $message);
    }
}


/* UPDATE CLEARANCE DECISION*/

function update_clearance_decision(
    $pdo,
    $requestId,
    $department,
    $user,
    $decision,
    $comment,
    $physicalFyp = null
) {
    $comment =
        clean_message($comment);

    if (
        !in_array(
            $decision,
            ['Approved', 'Rejected'],
            true
        )
    ) {
        return 'Invalid clearance decision.';
    }

    if (
        $decision === 'Rejected' &&
        $comment === ''
    ) {
        return
            'A meaningful rejection reason is required.';
    }

    $request =
        authorized_review_request(
            $pdo,
            $requestId,
            $department,
            $user
        );

    if (!$request) {
        return
            'This request is not assigned to your authorized queue.';
    }

    $departmentName =
        strtolower(
            trim(
                (string)(
                    $department['dept_name']
                    ?? ''
                )
            )
        );

    /*Library-specific requirements.*/
    if (
        $departmentName === 'library' &&
        $decision === 'Approved'
    ) {

        if ($physicalFyp !== true) {
            return
                'Library approval requires confirmation that the physical Final Year Project was submitted.';
        }

        $documents =
            get_current_documents(
                $pdo,
                $request['student_id']
            );

        if (
            empty(
                $documents[
                    'final_year_project'
                ]
            )
        ) {
            return
                'Library approval requires the student Final Year Project PDF.';
        }
    }

    try {

        $pdo->beginTransaction();

        /* Save Library physical project check.*/
        if (
            $departmentName === 'library' &&
            $physicalFyp !== null
        ) {
            save_library_physical_check(
                $pdo,
                $requestId,
                $department['dept_id'],
                $user['user_id'],
                $physicalFyp
            );
        }

        /* Find the current pending approval.*/
        $approval = $pdo->prepare(
            "SELECT approval_id
             FROM approval_records
             WHERE request_id = ?
             AND dept_id = ?
             AND status = 'Pending'
             ORDER BY approval_id DESC
             LIMIT 1"
        );

        $approval->execute([
            (int)$requestId,
            (int)$department['dept_id']
        ]);

        $approvalId =
            $approval->fetchColumn();

        if (!$approvalId) {
            throw new Exception(
                'No pending review exists.'
            );
        }

        /*Record decision.*/
        $pdo->prepare(
            'UPDATE approval_records
             SET
                status = ?,
                officer_id = ?,
                officer_institute_id = ?,
                comments = ?,
                decided_at = NOW()
             WHERE approval_id = ?'
        )->execute([
            $decision,
            (int)$user['user_id'],

            get_user_institute_id(
                $pdo,
                $user['user_id']
            ) ?: null,

            $comment,
            (int)$approvalId
        ]);

        $studentUser =
            get_student_user_id(
                $pdo,
                $request['student_id']
            );

        /* REJECTION */
        if ($decision === 'Rejected') {

            /* Keep current department as the rejecting department so resubmission can clearly return there. */
            $pdo->prepare(
                "UPDATE clearance_requests
                 SET
                    overall_status = 'Rejected',
                    current_dept_id = ?
                 WHERE request_id = ?"
            )->execute([
                (int)$department['dept_id'],
                (int)$requestId
            ]);

            if ($studentUser) {
                add_notification(
                    $pdo,
                    $studentUser,
                    'clearance_rejected',
                    'Your clearance was rejected by '
                    . $department['dept_name']
                    . ': '
                    . $comment
                );
            }

            log_audit(
                $pdo,
                $user['user_id'],
                'clearance_rejected',
                'Request #'
                . $requestId
                . ' rejected at '
                . $department['dept_name']
            );

            $pdo->commit();

            return
                'Rejection recorded and student notified.';
        }

        /* APPROVAL Find next workflow department.*/
        $nextStmt = $pdo->prepare(
            'SELECT *
             FROM departments
             WHERE sequence_no >
             (
                SELECT sequence_no
                FROM departments
                WHERE dept_id = ?
             )
             ORDER BY sequence_no ASC
             LIMIT 1'
        );

        $nextStmt->execute([
            (int)$department['dept_id']
        ]);

        $next =
            $nextStmt->fetch(
                PDO::FETCH_ASSOC
            );

        if ($next) {

            /*Move clearance forward. */
            $pdo->prepare(
                "UPDATE clearance_requests
                 SET
                    overall_status = 'In Progress',
                    current_dept_id = ?
                 WHERE request_id = ?"
            )->execute([
                (int)$next['dept_id'],
                (int)$requestId
            ]);

            /*Notify student.*/
            if ($studentUser) {
                add_notification(
                    $pdo,
                    $studentUser,
                    'clearance_updated',
                    'Your clearance has moved to '
                    . $next['dept_name']
                    . '.'
                );
            }

            /* Notify the authorized user(s) at the next stage. Directors are scoped by institute and Deans by school.*/
            notify_next_clearance_stage(
                $pdo,
                $request,
                $next
            );

        } else {

            /*FINAL APPROVAL*/
            $latest = $pdo->prepare(
                "SELECT
                    d.dept_id,
                    ar.status

                 FROM departments d

                 LEFT JOIN approval_records ar
                    ON ar.approval_id =
                    (
                        SELECT x.approval_id
                        FROM approval_records x
                        WHERE x.request_id = ?
                        AND x.dept_id = d.dept_id
                        ORDER BY x.approval_id DESC
                        LIMIT 1
                    )

                 ORDER BY d.sequence_no ASC"
            );

            $latest->execute([
                (int)$requestId
            ]);

            foreach (
                $latest->fetchAll(
                    PDO::FETCH_ASSOC
                )
                as $row
            ) {

                if (
                    ($row['status'] ?? '')
                    !== 'Approved'
                ) {
                    throw new Exception(
                        'Final Approval requires every workflow stage to be approved.'
                    );
                }
            }

            /*Mark clearance final.*/
            $pdo->prepare(
                "UPDATE clearance_requests
                 SET
                    overall_status = 'Final',
                    current_dept_id = NULL
                 WHERE request_id = ?"
            )->execute([
                (int)$requestId
            ]);

            /*Avoid duplicate final approval records.*/
            $checkFinal = $pdo->prepare(
                'SELECT 1
                 FROM final_approvals
                 WHERE request_id = ?
                 LIMIT 1'
            );

            $checkFinal->execute([
                (int)$requestId
            ]);

            if (!$checkFinal->fetchColumn()) {

                $pdo->prepare(
                    'INSERT INTO final_approvals
                    (
                        request_id
                    )
                    VALUES
                    (
                        ?
                    )'
                )->execute([
                    (int)$requestId
                ]);
            }

            if ($studentUser) {
                add_notification(
                    $pdo,
                    $studentUser,
                    'final_approval_generated',
                    'Your Final Approval has been granted by the Academic Registrar.'
                );
            }
        }

        log_audit(
            $pdo,
            $user['user_id'],
            'clearance_approved',
            'Request #'
            . $requestId
            . ' approved at '
            . $department['dept_name']
        );

        $pdo->commit();

        return 'Decision saved.';

    } catch (Exception $e) {

        if ($pdo->inTransaction()) {
            $pdo->rollBack();
        }

        error_log(
            'Clearance decision error: '
            . $e->getMessage()
        );

        return
            'Decision could not be saved: '
            . $e->getMessage();
    }
}


/*REVIEW QUEUE*/

function get_review_queue(
    $pdo,
    $department,
    $user
) {
    if (
        !$department ||
        empty($department['dept_id'])
    ) {
        return [];
    }

    $sql =
        "SELECT
            cr.request_id,
            cr.submitted_at,
            cr.overall_status,
            s.student_id,
            s.registration_no,
            s.full_name,
            s.programme,
            s.school_id,
            s.institute_id

         FROM clearance_requests cr

         JOIN students s
            ON s.student_id = cr.student_id

         WHERE cr.current_dept_id = ?
         AND cr.overall_status IN
         (
            'Pending',
            'In Progress'
         )";

    $args = [
        (int)$department['dept_id']
    ];

    $role = strtolower(
        (string)($user['role'] ?? '')
    );

    /* Directors see only students from their institute.*/
    if ($role === 'director') {

        $instituteId =
            get_user_institute_id(
                $pdo,
                $user['user_id']
            );

        if (!$instituteId) {
            return [];
        }

        $sql .=
            ' AND s.institute_id = ?';

        $args[] =
            (int)$instituteId;

    } elseif ($role === 'dean') {

        /* Deans see only students from their assigned school.*/
        $schoolId =
            get_user_school_id(
                $pdo,
                $user['user_id']
            );

        if (!$schoolId) {
            return [];
        }

        $sql .=
            ' AND s.school_id = ?';

        $args[] =
            (int)$schoolId;
    }

    $sql .=
        ' ORDER BY cr.submitted_at ASC';

    $stmt = $pdo->prepare($sql);

    $stmt->execute($args);

    return $stmt->fetchAll(
        PDO::FETCH_ASSOC
    );
}


/*REVIEW COUNTS*/

function get_review_counts(
    $pdo,
    $department,
    $user
) {
    $out = [
        'Pending' => 0,
        'Rejected' => 0,
        'Approved' => 0
    ];

    if (
        !$department ||
        empty($department['dept_id'])
    ) {
        return $out;
    }

    $deptId =
        (int)$department['dept_id'];

    $userId =
        (int)($user['user_id'] ?? 0);

    $role =
        strtolower(
            (string)($user['role'] ?? '')
        );

    $isDirector =
        $role === 'director';

    $isSchoolDean =
        $role === 'dean';

    $instituteId =
        $isDirector
            ? get_user_institute_id(
                $pdo,
                $userId
            )
            : null;

    $schoolId =
        $isSchoolDean
            ? get_user_school_id(
                $pdo,
                $userId
            )
            : null;

    /*Pending = live queue only. */
    $pendingSql =
        "SELECT COUNT(*)
         FROM clearance_requests cr
         JOIN students s
            ON s.student_id = cr.student_id
         WHERE cr.current_dept_id = ?
         AND cr.overall_status IN
         (
            'Pending',
            'In Progress'
         )";

    $args = [$deptId];

    if ($isDirector) {

        if (!$instituteId) {
            return $out;
        }

        $pendingSql .=
            ' AND s.institute_id = ?';

        $args[] =
            (int)$instituteId;

    } elseif ($isSchoolDean) {

        if (!$schoolId) {
            return $out;
        }

        $pendingSql .=
            ' AND s.school_id = ?';

        $args[] =
            (int)$schoolId;
    }

    $stmt =
        $pdo->prepare($pendingSql);

    $stmt->execute($args);

    $out['Pending'] =
        (int)$stmt->fetchColumn();

    /*Historical Approved / Rejected decisions for this department.*/
    foreach (
        ['Approved', 'Rejected']
        as $status
    ) {

        $sql =
            "SELECT COUNT(*)
             FROM approval_records ar

             JOIN clearance_requests cr
                ON cr.request_id = ar.request_id

             JOIN students s
                ON s.student_id = cr.student_id

             WHERE ar.dept_id = ?
             AND ar.status = ?";

        $countArgs = [
            $deptId,
            $status
        ];

        if ($isDirector) {

            $sql .=
                ' AND s.institute_id = ?';

            $countArgs[] =
                (int)$instituteId;

        } elseif ($isSchoolDean) {

            $sql .=
                ' AND s.school_id = ?';

            $countArgs[] =
                (int)$schoolId;
        }

        $stmt =
            $pdo->prepare($sql);

        $stmt->execute(
            $countArgs
        );

        $out[$status] =
            (int)$stmt->fetchColumn();
    }

    return $out;
}


/*CLEARANCE PROGRESS*/

function get_progress_for_request(
    $pdo,
    $id
) {
    $stmt = $pdo->prepare(
        'SELECT
            d.*,
            ar.status,
            ar.comments,
            ar.decided_at,
            u.full_name AS officer_name

         FROM departments d

         LEFT JOIN approval_records ar
            ON ar.approval_id =
            (
                SELECT ar2.approval_id
                FROM approval_records ar2
                WHERE ar2.request_id = ?
                AND ar2.dept_id = d.dept_id
                ORDER BY ar2.approval_id DESC
                LIMIT 1
            )

         LEFT JOIN users u
            ON u.user_id = ar.officer_id

         ORDER BY d.sequence_no ASC'
    );

    $stmt->execute([
        (int)$id
    ]);

    return $stmt->fetchAll(
        PDO::FETCH_ASSOC
    );
}


/*GENERAL REPORTS*/

function get_clearance_summary($pdo)
{
    return $pdo->query(
        'SELECT
            overall_status,
            COUNT(*) AS total
         FROM clearance_requests
         GROUP BY overall_status'
    )->fetchAll(PDO::FETCH_ASSOC);
}


function get_department_report(
    $pdo,
    $deptId = null
) {
    $sql =
        "SELECT
            d.dept_id,
            d.dept_name,

            SUM(
                ar.status = 'Pending'
            ) AS pending_total,

            SUM(
                ar.status = 'Approved'
            ) AS approved_total,

            SUM(
                ar.status = 'Rejected'
            ) AS rejected_total,

            COUNT(
                ar.approval_id
            ) AS total_records

         FROM departments d

         LEFT JOIN approval_records ar
            ON ar.dept_id = d.dept_id";

    $args = [];

    if ($deptId) {

        $sql .=
            ' WHERE d.dept_id = ?';

        $args[] =
            (int)$deptId;
    }

    $sql .=
        ' GROUP BY d.dept_id, d.dept_name
          ORDER BY d.sequence_no ASC';

    $stmt =
        $pdo->prepare($sql);

    $stmt->execute($args);

    return $stmt->fetchAll(
        PDO::FETCH_ASSOC
    );
}


function get_clearance_report_rows(
    $pdo,
    $status = '',
    $deptId = ''
) {
    $sql =
        'SELECT
            cr.*,
            s.registration_no,
            s.full_name,
            s.programme,
            s.institute,
            d.dept_name AS current_department

         FROM clearance_requests cr

         JOIN students s
            ON s.student_id = cr.student_id

         LEFT JOIN departments d
            ON d.dept_id = cr.current_dept_id

         WHERE 1 = 1';

    $args = [];

    if ($status !== '') {

        $sql .=
            ' AND cr.overall_status = ?';

        $args[] = $status;
    }

    if ($deptId !== '') {

        $sql .=
            ' AND cr.current_dept_id = ?';

        $args[] =
            (int)$deptId;
    }

    $sql .=
        ' ORDER BY cr.submitted_at DESC';

    $stmt =
        $pdo->prepare($sql);

    $stmt->execute($args);

    return $stmt->fetchAll(
        PDO::FETCH_ASSOC
    );
}


/*REPORT SCOPING*/

function get_report_scope_institute_id(
    $pdo,
    $user
) {
    if (
        strtolower(
            (string)($user['role'] ?? '')
        ) === 'director'
    ) {
        return get_user_institute_id(
            $pdo,
            (int)$user['user_id']
        );
    }

    return null;
}


function get_report_scope_school_id(
    $pdo,
    $user
) {
    if (
        strtolower(
            (string)($user['role'] ?? '')
        ) === 'dean'
    ) {
        return get_user_school_id(
            $pdo,
            (int)$user['user_id']
        );
    }

    return null;
}


/*CLEARANCE REPORT SUMMARY*/

function get_clearance_report_summary(
    $pdo,
    $user
) {
    $instituteId =
        get_report_scope_institute_id(
            $pdo,
            $user
        );

    $schoolId =
        get_report_scope_school_id(
            $pdo,
            $user
        );

    /*Count only the latest decision per request and department.*/
    $sql =
        "SELECT
            ar.status,
            COUNT(*) AS total

         FROM approval_records ar

         JOIN clearance_requests cr
            ON cr.request_id = ar.request_id

         JOIN students s
            ON s.student_id = cr.student_id

         WHERE ar.approval_id =
         (
             SELECT MAX(ar2.approval_id)
             FROM approval_records ar2
             WHERE ar2.request_id =
                   ar.request_id
             AND ar2.dept_id =
                 ar.dept_id
         )";

    $params = [];

    if ($instituteId !== null) {

        $sql .=
            ' AND s.institute_id = ?';

        $params[] =
            (int)$instituteId;

    } elseif ($schoolId !== null) {

        $sql .=
            ' AND s.school_id = ?';

        $params[] =
            (int)$schoolId;
    }

    $sql .=
        ' GROUP BY ar.status';

    $stmt =
        $pdo->prepare($sql);

    $stmt->execute($params);

    $summary = [
        'Pending' => 0,
        'Approved' => 0,
        'Rejected' => 0
    ];

    foreach (
        $stmt->fetchAll(
            PDO::FETCH_ASSOC
        )
        as $row
    ) {

        if (
            isset(
                $summary[
                    $row['status']
                ]
            )
        ) {
            $summary[
                $row['status']
            ] =
                (int)$row['total'];
        }
    }

    return $summary;
}


/*REPORT ROWS V3*/

function get_clearance_report_rows_v3(
    $pdo,
    $user,
    $status = '',
    $deptId = ''
) {
    $allowedStatuses = [
        'Pending',
        'Approved',
        'Rejected'
    ];

    if (
        !in_array(
            $status,
            $allowedStatuses,
            true
        )
    ) {
        $status = '';
    }

    $deptId =
        ctype_digit(
            (string)$deptId
        )
            ? (int)$deptId
            : 0;

    $sql =
        "SELECT
            ar.approval_id,
            ar.dept_id,
            ar.status AS approval_status,
            ar.comments,
            ar.assigned_at,
            ar.decided_at,

            cr.request_id,
            cr.overall_status,
            cr.current_dept_id,
            cr.graduation_set_id,

            s.student_id,
            s.registration_no,
            s.full_name AS student_name,
            s.school_id,
            s.programme_id,
            s.academic_year,
            s.stage,

            COALESCE(
                p.programme_name,
                s.programme,
                'None'
            ) AS programme,

            s.institute_id,

            i.institute_name,

            d.dept_name,

            gs.set_name AS graduation_set_name,
            gs.graduation_year,

            u.full_name AS officer_name

         FROM approval_records ar

         JOIN clearance_requests cr
            ON cr.request_id = ar.request_id

         JOIN students s
            ON s.student_id = cr.student_id

         LEFT JOIN programmes p
            ON p.programme_id = s.programme_id

         LEFT JOIN institutes i
            ON i.institute_id = s.institute_id

         LEFT JOIN departments d
            ON d.dept_id = ar.dept_id

         LEFT JOIN graduation_sets gs
            ON gs.graduation_set_id = cr.graduation_set_id

         LEFT JOIN users u
            ON u.user_id = ar.officer_id

         WHERE ar.approval_id =
         (
             SELECT MAX(ar2.approval_id)
             FROM approval_records ar2
             WHERE ar2.request_id =
                   ar.request_id
             AND ar2.dept_id =
                 ar.dept_id
         )";

    $params = [];

    $schoolId =
        get_report_scope_school_id(
            $pdo,
            $user
        );

    $instituteId =
        get_report_scope_institute_id(
            $pdo,
            $user
        );

    if ($instituteId !== null) {

        $sql .=
            ' AND s.institute_id = ?';

        $params[] =
            (int)$instituteId;

    } elseif ($schoolId !== null) {

        $sql .=
            ' AND s.school_id = ?';

        $params[] =
            (int)$schoolId;
    }

    if ($status !== '') {

        $sql .=
            ' AND ar.status = ?';

        $params[] = $status;
    }

    if ($deptId > 0) {

        $sql .=
            " AND ar.dept_id = ?
              AND
              (
                  ar.status <> 'Pending'
                  OR
                  (
                      ar.status = 'Pending'
                      AND cr.current_dept_id = ?
                      AND cr.overall_status IN ('Pending', 'In Progress')
                  )
              )";

        $params[] = $deptId;
        $params[] = $deptId;
    }

    $sql .=
        " ORDER BY
            s.full_name ASC,
            COALESCE(
                ar.decided_at,
                ar.assigned_at
            ) DESC";

    $stmt =
        $pdo->prepare($sql);

    $stmt->execute($params);

    return $stmt->fetchAll(
        PDO::FETCH_ASSOC
    );
}


/*DIRECTOR REPORT*/

function get_director_clearance_report_summary_rows(
    $pdo,
    $user,
    $status = ''
) {
    $instituteId =
        get_report_scope_institute_id(
            $pdo,
            $user
        );

    if ($instituteId === null) {
        return [];
    }

    $allowedStatuses = [
        'Pending',
        'Approved',
        'Rejected'
    ];

    if (
        !in_array(
            $status,
            $allowedStatuses,
            true
        )
    ) {
        $status = '';
    }

    $sql =
        "SELECT
            cr.request_id,
            cr.overall_status,

            s.student_id,
            s.registration_no,
            s.full_name AS student_name,
            s.school_id,
            s.programme_id,
            s.academic_year,
            s.stage,

            COALESCE(
                p.programme_name,
                s.programme,
                'None'
            ) AS programme,

            i.institute_name,

            gs.graduation_set_id,
            gs.set_name AS graduation_set_name,
            gs.graduation_year,

            COUNT(
                latest.approval_id
            ) AS total_departments,

            SUM(
                latest.status = 'Approved'
            ) AS approved_count,

            SUM(
                latest.status = 'Pending'
            ) AS pending_count,

            SUM(
                latest.status = 'Rejected'
            ) AS rejected_count,

            MAX(
                COALESCE(
                    latest.decided_at,
                    latest.assigned_at
                )
            ) AS last_action_at

         FROM clearance_requests cr

         JOIN students s
            ON s.student_id = cr.student_id

         LEFT JOIN programmes p
            ON p.programme_id = s.programme_id

         LEFT JOIN institutes i
            ON i.institute_id = s.institute_id

         LEFT JOIN graduation_sets gs
            ON gs.graduation_set_id = cr.graduation_set_id

         LEFT JOIN approval_records latest
            ON latest.request_id =
               cr.request_id

            AND latest.approval_id =
            (
                SELECT MAX(ar2.approval_id)
                FROM approval_records ar2
                WHERE ar2.request_id =
                      cr.request_id
                AND ar2.dept_id =
                    latest.dept_id
            )

         WHERE s.institute_id = ?";

    $params = [
        (int)$instituteId
    ];

    if ($status !== '') {

        $sql .=
            " AND EXISTS
            (
                SELECT 1
                FROM approval_records latest_filter
                WHERE latest_filter.request_id =
                      cr.request_id

                AND latest_filter.approval_id =
                (
                    SELECT MAX(ax.approval_id)
                    FROM approval_records ax
                    WHERE ax.request_id =
                          latest_filter.request_id
                    AND ax.dept_id =
                        latest_filter.dept_id
                )

                AND latest_filter.status = ?
            )";

        $params[] = $status;
    }

    $sql .=
        " GROUP BY
            cr.request_id,
            cr.overall_status,
            s.student_id,
            s.registration_no,
            s.full_name,
            p.programme_name,
            s.programme,
            i.institute_name,
            gs.graduation_set_id,
            gs.set_name,
            gs.graduation_year

          ORDER BY

            CASE

                WHEN SUM(
                    latest.status = 'Rejected'
                ) > 0 THEN 1

                WHEN SUM(
                    latest.status = 'Pending'
                ) > 0 THEN 2

                ELSE 3

            END,

            s.full_name ASC";

    $stmt =
        $pdo->prepare($sql);

    $stmt->execute($params);

    return $stmt->fetchAll(
        PDO::FETCH_ASSOC
    );
}


/*REQUEST LATEST REVIEWS*/

function get_clearance_request_latest_reviews(
    $pdo,
    $requestId,
    $user
) {
    $requestId = (int)$requestId;

    $instituteId =
        get_report_scope_institute_id(
            $pdo,
            $user
        );

    $schoolId =
        get_report_scope_school_id(
            $pdo,
            $user
        );

    $sql =
        "SELECT
            ar.*,

            d.dept_name,

            u.full_name AS officer_name,

            s.full_name AS student_name,

            s.registration_no,

            COALESCE(
                p.programme_name,
                s.programme,
                'None'
            ) AS programme,

            i.institute_name

         FROM clearance_requests cr

         JOIN students s
            ON s.student_id = cr.student_id

         LEFT JOIN programmes p
            ON p.programme_id = s.programme_id

         LEFT JOIN institutes i
            ON i.institute_id = s.institute_id

         JOIN approval_records ar
            ON ar.request_id = cr.request_id

         LEFT JOIN departments d
            ON d.dept_id = ar.dept_id

         LEFT JOIN users u
            ON u.user_id = ar.officer_id

         WHERE cr.request_id = ?

         AND ar.approval_id =
         (
             SELECT MAX(a2.approval_id)
             FROM approval_records a2
             WHERE a2.request_id =
                   ar.request_id
             AND a2.dept_id =
                 ar.dept_id
         )";

    $params = [$requestId];

    if ($instituteId !== null) {

        $sql .=
            ' AND s.institute_id = ?';

        $params[] =
            (int)$instituteId;

    } elseif ($schoolId !== null) {

        $sql .=
            ' AND s.school_id = ?';

        $params[] =
            (int)$schoolId;
    }

    $sql .=
        ' ORDER BY
            d.sequence_no ASC,
            d.dept_name ASC';

    $stmt =
        $pdo->prepare($sql);

    $stmt->execute($params);

    return $stmt->fetchAll(
        PDO::FETCH_ASSOC
    );
}


/*AUDIT LOGS*/

function get_recent_audit_logs(
    $pdo,
    $limit = 50
) {
    $limit = (int)$limit;

    if ($limit < 1) {
        $limit = 1;
    }

    if ($limit > 100) {
        $limit = 100;
    }

    $stmt = $pdo->prepare(
        'SELECT
            al.*,
            u.full_name,
            u.role

         FROM audit_logs al

         LEFT JOIN users u
            ON u.user_id = al.user_id

         ORDER BY al.created_at DESC

         LIMIT ' . $limit
    );

    $stmt->execute();

    return $stmt->fetchAll(
        PDO::FETCH_ASSOC
    );
}

?>