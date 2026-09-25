<?php
require_once __DIR__ . '/includes/auth.php';
require_login();
require_once __DIR__ . '/includes/clearance_functions.php';

$id = (int) ($_GET['id'] ?? 0);

$stmt = $pdo->prepare(
    'SELECT sd.*,
            cr.student_id AS request_student_id,
            cr.current_dept_id,
            cr.overall_status
     FROM supporting_documents sd
     LEFT JOIN clearance_requests cr
        ON cr.request_id = sd.request_id
     WHERE sd.document_id = ?
     LIMIT 1'
);

$stmt->execute([$id]);
$document = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$document) {
    http_response_code(404);
    exit('Document not found.');
}

$user = current_user();
$allowed = false;

if ($user['role'] === 'student') {

    $allowed =
        (int) $user['linked_id'] ===
        (int) $document['student_id'];

} elseif ($user['role'] === 'admin') {

    $allowed = true;

} elseif ($user['role'] === 'director') {

    $institute = get_user_institute_id(
        $pdo,
        $user['user_id']
    );

    $s = $pdo->prepare(
        'SELECT 1
         FROM students
         WHERE student_id = ?
         AND institute_id = ?'
    );

    $s->execute([
        $document['student_id'],
        $institute
    ]);

    $allowed = (bool) $s->fetchColumn();

} else {

    $department = get_assigned_department(
        $pdo,
        $user
    );

    if ($department) {

        $departmentName = strtolower(
            trim(
                (string) $department['dept_name']
            )
        );

        # Library can view the student's Final Year Project during review.
        # The document may have been uploaded before the clearance request.
        if (
            ($user['role'] === 'librarian' || $user['role'] === 'officer')
            && $departmentName === 'library'
            && strtolower(trim((string)$document['document_type'])) === 'final_year_project'
        ) {

            $s = $pdo->prepare(
                "SELECT 1
                 FROM clearance_requests cr
                 INNER JOIN approval_records ar
                    ON ar.request_id = cr.request_id
                 WHERE cr.student_id = ?
                 AND cr.current_dept_id = ?
                 AND cr.overall_status IN ('Pending', 'In Progress')
                 AND ar.dept_id = ?
                 AND ar.status = 'Pending'
                 LIMIT 1"
            );

            $s->execute([
                (int)$document['student_id'],
                (int)$department['dept_id'],
                (int)$department['dept_id']
            ]);

            $allowed = (bool)$s->fetchColumn();

        } else {

            $s = $pdo->prepare(
                'SELECT 1
                 FROM approval_records
                 WHERE request_id = ?
                 AND dept_id = ?
                 LIMIT 1'
            );

            $s->execute([
                (int) $document['request_id'],
                (int) $department['dept_id']
            ]);

            $allowed =
                (bool) $s->fetchColumn()
                && (
                    $user['role'] === 'registrar'
                    || (
                        $departmentName === 'library'
                        && $document['document_type'] === 'final_year_project'
                    )
                );
        }
    }
}

if (!$allowed) {
    http_response_code(403);
    exit('Not authorized.');
}

$relative = str_replace(
    ['/','\\'],
    DIRECTORY_SEPARATOR,
    $document['file_path']
);

$path =
    __DIR__
    . DIRECTORY_SEPARATOR
    . $relative;

if (!is_file($path)) {
    http_response_code(404);
    exit('Stored file unavailable.');
}

header('Content-Type: application/pdf');
header('Content-Disposition: inline; filename="document.pdf"');
header('X-Content-Type-Options: nosniff');
header('Content-Length: ' . filesize($path));

readfile($path);
exit;
