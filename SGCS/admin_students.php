<?php

require_once __DIR__ . '/includes/auth.php';

require_role('admin');

require_once __DIR__ . '/includes/clearance_functions.php';

$message = '';
$error = '';
$fieldErrors = [];
$old = [];
$editingId = 0;




$schools = $pdo->query(
    'SELECT *
     FROM schools
     ORDER BY school_name'
)->fetchAll();

$institutes = $pdo->query(
    'SELECT i.*, s.school_name
     FROM institutes i
     LEFT JOIN schools s
        ON s.school_id = i.school_id
     ORDER BY i.institute_name'
)->fetchAll();

$programmes = $pdo->query(
    'SELECT p.*, i.institute_name, qt.qualification_name
     FROM programmes p
     JOIN institutes i
        ON i.institute_id = p.institute_id
     LEFT JOIN qualification_types qt
        ON qt.qualification_type_id = p.qualification_type_id
     ORDER BY p.programme_name'
)->fetchAll();

$specialisations = $pdo->query(
    'SELECT ps.*, p.programme_name
     FROM programme_specialisations ps
     JOIN programmes p
        ON p.programme_id = ps.programme_id
     ORDER BY p.programme_name, ps.specialisation_name'
)->fetchAll();




function get_student_form_data()
{
    return [
        'registration_no' => clean_input($_POST['registration_no'] ?? ''),
        'first_name' => clean_message($_POST['first_name'] ?? '', 60),
        'middle_name' => clean_message($_POST['middle_name'] ?? '', 60),
        'last_name' => clean_message($_POST['last_name'] ?? '', 60),
        'gender' => clean_input($_POST['gender'] ?? ''),
        'national_id_passport_no' => clean_message(
            $_POST['national_id_passport_no'] ?? '',
            30
        ),
        'email' => clean_input($_POST['email'] ?? ''),
        'country_code' => clean_input($_POST['country_code'] ?? '+254'),
        'phone' => clean_input($_POST['phone'] ?? ''),
        'school_id' => $_POST['school_id'] ?? '',
        'institute_id' => $_POST['institute_id'] ?? '',
        'programme_id' => $_POST['programme_id'] ?? '',
        'specialisation_id' => $_POST['specialisation_id'] ?? ''
    ];
}




function validate_student_data(
    $pdo,
    &$old,
    &$fieldErrors,
    $studentId = 0
) {
    $registration = $old['registration_no'];
    $first = $old['first_name'];
    $last = $old['last_name'];
    $gender = $old['gender'];
    $identity = $old['national_id_passport_no'];
    $email = $old['email'];
    $countryCode = $old['country_code'];
    $phoneInput = $old['phone'];
    $schoolId = (int)$old['school_id'];
    $instituteId = (int)$old['institute_id'];
    $programmeId = (int)$old['programme_id'];

    $specialisationId =
        $old['specialisation_id'] !== ''
            ? (int)$old['specialisation_id']
            : null;

    $phone = normalize_phone_number(
        $countryCode,
        $phoneInput
    );


    

    if ($registration === '') {
        $fieldErrors['registration_no'] =
            'Registration number is required.';
    }




    if ($first === '') {
        $fieldErrors['first_name'] =
            'First name is required.';
    }


    

    if ($last === '') {
        $fieldErrors['last_name'] =
            'Last name is required.';
    }


    

    if (!in_array(
        $gender,
        ['Male', 'Female', 'Other'],
        true
    )) {
        $fieldErrors['gender'] =
            'Please select a valid gender.';
    }




    if ($identity === '') {

        $fieldErrors['national_id_passport_no'] =
            'National ID or Passport number is required.';

    } elseif (strlen(trim($identity)) < 6) {

        $fieldErrors['national_id_passport_no'] =
            'National ID or Passport number must contain at least 6 digits or characters.';
    }   


    

    if ($email === '') {
        $fieldErrors['email'] =
            'Email address is required.';
    } elseif (!is_valid_email($email)) {
        $fieldErrors['email'] =
            'Please enter a valid email address.';
    }


   

$phoneDigits = preg_replace('/\D+/', '', $phone);

    if ($phone === '') {

        $fieldErrors['phone'] =
            'Phone number is required.';

    } elseif (strlen($phoneDigits) < 8) {

        $fieldErrors['phone'] =
            'Phone number must contain at least 8 digits.';
    }


   

    if (!$schoolId) {
        $fieldErrors['school_id'] =
            'Please select a school.';
    }


  

    if (!$instituteId) {
        $fieldErrors['institute_id'] =
            'Please select an institute.';
    }


   

    if (!$programmeId) {
        $fieldErrors['programme_id'] =
            'Please select a programme.';
    }


   
    if (!empty($fieldErrors)) {
        return false;
    }



    $stmt = $pdo->prepare(
        'SELECT 1
         FROM institutes
         WHERE institute_id = ?
         AND school_id = ?'
    );

    $stmt->execute([
        $instituteId,
        $schoolId
    ]);

    if (!$stmt->fetchColumn()) {

        $fieldErrors['institute_id'] =
            'The selected institute does not belong to the selected school.';

        return false;
    }


  

    $stmt = $pdo->prepare(
        'SELECT 1
         FROM programmes
         WHERE programme_id = ?
         AND institute_id = ?'
    );

    $stmt->execute([
        $programmeId,
        $instituteId
    ]);

    if (!$stmt->fetchColumn()) {

        $fieldErrors['programme_id'] =
            'The selected programme does not belong to the selected institute.';

        return false;
    }


  

    if ($specialisationId) {

        $stmt = $pdo->prepare(
            'SELECT 1
             FROM programme_specialisations
             WHERE specialisation_id = ?
             AND programme_id = ?'
        );

        $stmt->execute([
            $specialisationId,
            $programmeId
        ]);

        if (!$stmt->fetchColumn()) {

            $fieldErrors['specialisation_id'] =
                'The selected specialisation does not belong to this programme.';

            return false;
        }
    }


   

    $stmt = $pdo->prepare(
        'SELECT student_id
         FROM students
         WHERE registration_no = ?
         AND student_id <> ?'
    );

    $stmt->execute([
        $registration,
        $studentId
    ]);

    if ($stmt->fetchColumn()) {

        $fieldErrors['registration_no'] =
            'This registration number is already in use.';

        return false;
    }


   

    $stmt = $pdo->prepare(
        'SELECT student_id
         FROM students
         WHERE email = ?
         AND student_id <> ?'
    );

    $stmt->execute([
        $email,
        $studentId
    ]);

    if ($stmt->fetchColumn()) {

        $fieldErrors['email'] =
            'This email address is already in use.';

        return false;
    }


   

    $stmt = $pdo->prepare(
        "SELECT user_id
         FROM users
         WHERE email = ?
         AND NOT (
             role = 'student'
             AND linked_id = ?
         )"
    );

    $stmt->execute([
        $email,
        $studentId
    ]);

    if ($stmt->fetchColumn()) {

        $fieldErrors['email'] =
            'This email address is already in use.';

        return false;
    }


   

    $stmt = $pdo->prepare(
        'SELECT student_id
         FROM students
         WHERE phone = ?
         AND student_id <> ?'
    );

    $stmt->execute([
        $phone,
        $studentId
    ]);

    if ($stmt->fetchColumn()) {

        $fieldErrors['phone'] =
            'This phone number is already in use.';

        return false;
    }



    $username = strtolower(trim($registration));



    $stmt = $pdo->prepare(
        "SELECT user_id
         FROM users
         WHERE username = ?
         AND NOT (
             role = 'student'
             AND linked_id = ?
         )"
    );

    $stmt->execute([
        $username,
        $studentId
    ]);

    if ($stmt->fetchColumn()) {

        $fieldErrors['registration_no'] =
            'This registration number creates a username already in use.';

        return false;
    }


    return [
        'phone' => $phone,
        'username' => $username
    ];
}


/* Handle Form Action*/

if ($_SERVER['REQUEST_METHOD'] === 'POST') {

    $action = clean_input($_POST['action'] ?? '');

    try {


        


        if ($action === 'create') {

            $old = get_student_form_data();

            $password = $_POST['password'] ?? '';
            $confirm = $_POST['confirm_password'] ?? '';

            $validation = validate_student_data(
                $pdo,
                $old,
                $fieldErrors,
                0
            );


            if (strlen($password) < 8) {

                $fieldErrors['password'] =
                    'Password must contain at least 8 characters.';
            }


            if ($confirm === '') {

                $fieldErrors['confirm_password'] =
                    'Please confirm the password.';

            } elseif ($password !== $confirm) {

                $fieldErrors['confirm_password'] =
                    'Passwords do not match.';
            }


            if (!$validation || !empty($fieldErrors)) {

                throw new Exception(
                    'Please correct the highlighted fields.'
                );
            }


            $registration = $old['registration_no'];
            $first = $old['first_name'];
            $middle = $old['middle_name'];
            $last = $old['last_name'];
            $gender = $old['gender'];
            $identity = $old['national_id_passport_no'];
            $email = $old['email'];

            $schoolId = (int)$old['school_id'];
            $instituteId = (int)$old['institute_id'];
            $programmeId = (int)$old['programme_id'];

            $specialisationId =
                $old['specialisation_id'] !== ''
                    ? (int)$old['specialisation_id']
                    : null;

            $phone = $validation['phone'];
            $username = $validation['username'];

            $fullName = trim(
                $first . ' ' .
                $middle . ' ' .
                $last
            );

            $status = 'Active';


            $pdo->beginTransaction();


            $stmt = $pdo->prepare(
                'INSERT INTO students
                (
                    registration_no,
                    full_name,
                    first_name,
                    middle_name,
                    last_name,
                    gender,
                    national_id_passport_no,
                    email,
                    phone,
                    school_id,
                    institute_id,
                    programme_id,
                    specialisation_id,
                    programme,
                    institute,
                    account_status
                )
                SELECT
                    ?,
                    ?,
                    ?,
                    ?,
                    ?,
                    ?,
                    ?,
                    ?,
                    ?,
                    ?,
                    ?,
                    ?,
                    ?,
                    p.programme_name,
                    i.institute_name,
                    ?
                FROM programmes p
                JOIN institutes i
                    ON i.institute_id = p.institute_id
                WHERE p.programme_id = ?'
            );

            $stmt->execute([
                $registration,
                $fullName,
                $first,
                $middle ?: null,
                $last,
                $gender,
                $identity,
                $email,
                $phone,
                $schoolId,
                $instituteId,
                $programmeId,
                $specialisationId,
                $status,
                $programmeId
            ]);


            if (!$stmt->rowCount()) {

                throw new Exception(
                    'Unable to save the student academic assignment.'
                );
            }


            $studentId = $pdo->lastInsertId();


            /* Create Student Login */

            $pdo->prepare(
                "INSERT INTO users
                (
                    username,
                    password_hash,
                    role,
                    linked_id,
                    school_id,
                    institute_id,
                    programme_id,
                    full_name,
                    email,
                    account_status
                )
                VALUES
                (
                    ?,
                    ?,
                    'student',
                    ?,
                    ?,
                    ?,
                    ?,
                    ?,
                    ?,
                    ?
                )"
            )->execute([
                $username,
                password_hash(
                    $password,
                    PASSWORD_DEFAULT
                ),
                $studentId,
                $schoolId,
                $instituteId,
                $programmeId,
                $fullName,
                $email,
                $status
            ]);


            log_audit(
                $pdo,
                $_SESSION['user_id'],
                'student_created',
                'Created student ' . $registration
            );


            $pdo->commit();


            $message =
                'Student account created successfully. Username: ' .
                $username;

            $old = [];
        }




        elseif ($action === 'edit') {

            $editingId = (int)(
                $_POST['student_id'] ?? 0
            );

            if (!$editingId) {

                throw new Exception(
                    'Invalid student selected for editing.'
                );
            }


            $old = get_student_form_data();

            $validation = validate_student_data(
                $pdo,
                $old,
                $fieldErrors,
                $editingId
            );


            if (!$validation || !empty($fieldErrors)) {

                throw new Exception(
                    'Please correct the highlighted fields.'
                );
            }


            $registration = $old['registration_no'];
            $first = $old['first_name'];
            $middle = $old['middle_name'];
            $last = $old['last_name'];
            $gender = $old['gender'];
            $identity = $old['national_id_passport_no'];
            $email = $old['email'];

            $schoolId = (int)$old['school_id'];
            $instituteId = (int)$old['institute_id'];
            $programmeId = (int)$old['programme_id'];

            $specialisationId =
                $old['specialisation_id'] !== ''
                    ? (int)$old['specialisation_id']
                    : null;

            $phone = $validation['phone'];
            $username = $validation['username'];

            $fullName = trim(
                $first . ' ' .
                $middle . ' ' .
                $last
            );


            $pdo->beginTransaction();


            $stmt = $pdo->prepare(
                'UPDATE students s
                 JOIN programmes p
                    ON p.programme_id = ?
                 JOIN institutes i
                    ON i.institute_id = p.institute_id
                 SET
                    s.registration_no = ?,
                    s.full_name = ?,
                    s.first_name = ?,
                    s.middle_name = ?,
                    s.last_name = ?,
                    s.gender = ?,
                    s.national_id_passport_no = ?,
                    s.email = ?,
                    s.phone = ?,
                    s.school_id = ?,
                    s.institute_id = ?,
                    s.programme_id = ?,
                    s.specialisation_id = ?,
                    s.programme = p.programme_name,
                    s.institute = i.institute_name
                 WHERE s.student_id = ?'
            );

            $stmt->execute([
                $programmeId,
                $registration,
                $fullName,
                $first,
                $middle ?: null,
                $last,
                $gender,
                $identity,
                $email,
                $phone,
                $schoolId,
                $instituteId,
                $programmeId,
                $specialisationId,
                $editingId
            ]);


           

            $pdo->prepare(
                "UPDATE users
                 SET
                    username = ?,
                    school_id = ?,
                    institute_id = ?,
                    programme_id = ?,
                    full_name = ?,
                    email = ?
                 WHERE role = 'student'
                 AND linked_id = ?"
            )->execute([
                $username,
                $schoolId,
                $instituteId,
                $programmeId,
                $fullName,
                $email,
                $editingId
            ]);


            log_audit(
                $pdo,
                $_SESSION['user_id'],
                'student_updated',
                'Updated student ' . $registration
            );


            $pdo->commit();


            $message =
                'Student information updated successfully.';

            $old = [];
            $editingId = 0;
        }


       

        elseif ($action === 'status') {

            $studentId = (int)(
                $_POST['student_id'] ?? 0
            );

            if (!$studentId) {
                throw new Exception('Invalid student selected.');
            }

            $status =
                clean_input(
                    $_POST['account_status'] ?? ''
                ) === 'Inactive'
                    ? 'Inactive'
                    : 'Active';


            $pdo->beginTransaction();


            $pdo->prepare(
                'UPDATE students
                 SET account_status = ?
                 WHERE student_id = ?'
            )->execute([
                $status,
                $studentId
            ]);


            $pdo->prepare(
                "UPDATE users
                 SET account_status = ?
                 WHERE role = 'student'
                 AND linked_id = ?"
            )->execute([
                $status,
                $studentId
            ]);


            $pdo->commit();

            $message =
                'Student account status updated.';
        }


       

        elseif ($action === 'delete') {

            $studentId = (int)(
                $_POST['student_id'] ?? 0
            );

            if (!$studentId) {
                throw new Exception('Invalid student selected.');
            }


            $pdo->beginTransaction();


            $pdo->prepare(
                "UPDATE users
                 SET account_status = 'Inactive',
                     deleted_at = NOW()
                 WHERE role = 'student'
                 AND linked_id = ?"
            )->execute([
                $studentId
            ]);


            $pdo->prepare(
                "UPDATE students
                 SET account_status = 'Inactive'
                 WHERE student_id = ?"
            )->execute([
                $studentId
            ]);


            $pdo->commit();

            $message =
                'Student account soft-deleted.';
        }

    } catch (Exception $e) {

        if ($pdo->inTransaction()) {
            $pdo->rollBack();
        }

        $error = $e->getMessage();
    }
}





if (
    !$editingId &&
    isset($_GET['edit'])
) {
    $editingId = (int)$_GET['edit'];
}




if ($editingId && empty($old)) {

    $stmt = $pdo->prepare(
        'SELECT *
         FROM students
         WHERE student_id = ?'
    );

    $stmt->execute([
        $editingId
    ]);

    $editStudent = $stmt->fetch();


    if (!$editStudent) {

        $editingId = 0;

        $error =
            'The selected student could not be found.';

    } else {

        $old = [

            'registration_no' =>
                $editStudent['registration_no'] ?? '',

            'first_name' =>
                $editStudent['first_name'] ?? '',

            'middle_name' =>
                $editStudent['middle_name'] ?? '',

            'last_name' =>
                $editStudent['last_name'] ?? '',

            'gender' =>
                $editStudent['gender'] ?? '',

            'national_id_passport_no' =>
                $editStudent['national_id_passport_no'] ?? '',

            'email' =>
                $editStudent['email'] ?? '',

            'country_code' =>
                '+254',

            'phone' =>
                $editStudent['phone'] ?? '',

            'school_id' =>
                $editStudent['school_id'] ?? '',

            'institute_id' =>
                $editStudent['institute_id'] ?? '',

            'programme_id' =>
                $editStudent['programme_id'] ?? '',

            'specialisation_id' =>
                $editStudent['specialisation_id'] ?? ''
        ];
    }
}



$search = clean_input(
    $_GET['search'] ?? ''
);


$sql = "
    SELECT
        s.*,
        sc.school_name,
        i.institute_name,
        p.programme_name,
        ps.specialisation_name,
        u.username,
        u.deleted_at
    FROM students s
    LEFT JOIN schools sc
        ON sc.school_id = s.school_id
    LEFT JOIN institutes i
        ON i.institute_id = s.institute_id
    LEFT JOIN programmes p
        ON p.programme_id = s.programme_id
    LEFT JOIN programme_specialisations ps
        ON ps.specialisation_id = s.specialisation_id
    LEFT JOIN users u
        ON u.role = 'student'
        AND u.linked_id = s.student_id
    WHERE 1 = 1
";

$params = [];

if ($search !== '') {

    $sql .= "
        AND
        (
            s.registration_no LIKE ?
            OR s.full_name LIKE ?
            OR s.email LIKE ?
        )
    ";

    $params = [
        "%$search%",
        "%$search%",
        "%$search%"
    ];
}

$sql .= "
    ORDER BY s.student_id DESC
";


$stmt = $pdo->prepare($sql);
$stmt->execute($params);

$students = $stmt->fetchAll();


$page_title = 'Student Management';

require_once __DIR__ . '/includes/header.php';

?>

<section class="dashboard">

    <div class="dashboard-top">

        <h1>Student Management</h1>

        <a href="dashboard.php">
            Back to dashboard
        </a>

    </div>


    <div class="dashboard-box">


        <?php if ($message): ?>

            <div class="success">
                <?= htmlspecialchars($message) ?>
            </div>

        <?php endif; ?>


        <?php if ($error): ?>

            <div class="alert">
                <?= htmlspecialchars($error) ?>
            </div>

        <?php endif; ?>


        <h2>
            <?= $editingId
                ? 'Edit Student'
                : 'Create Student Account'
            ?>
        </h2>


        <?php if ($editingId): ?>

            <p style="margin-bottom:20px;">

                <a
                    href="<?= htmlspecialchars(
                        basename($_SERVER['PHP_SELF'])
                    ) ?>"
                >
                    Cancel Edit
                </a>

            </p>

        <?php endif; ?>


        <form
            class="filter-form"
            method="post"
            data-academic-form
        >

            <input
                type="hidden"
                name="action"
                value="<?= $editingId ? 'edit' : 'create' ?>"
            >


            <?php if ($editingId): ?>

                <input
                    type="hidden"
                    name="student_id"
                    value="<?= $editingId ?>"
                >

            <?php endif; ?>


            <div class="form-group">

                <label>Registration Number</label>

                <input
                    name="registration_no"
                    value="<?= htmlspecialchars($old['registration_no'] ?? '') ?>"
                    class="<?= isset($fieldErrors['registration_no']) ? 'input-error' : '' ?>"
                    required
                >

                <?php if (isset($fieldErrors['registration_no'])): ?>

                    <small class="field-error">
                        <?= htmlspecialchars($fieldErrors['registration_no']) ?>
                    </small>

                <?php endif; ?>

            </div>


            <div class="form-group">

                <label>First Name</label>

                <input
                    name="first_name"
                    value="<?= htmlspecialchars($old['first_name'] ?? '') ?>"
                    class="<?= isset($fieldErrors['first_name']) ? 'input-error' : '' ?>"
                    required
                >

                <?php if (isset($fieldErrors['first_name'])): ?>

                    <small class="field-error">
                        <?= htmlspecialchars($fieldErrors['first_name']) ?>
                    </small>

                <?php endif; ?>

            </div>


            <div class="form-group">

                <label>Middle Name</label>

                <input
                    name="middle_name"
                    value="<?= htmlspecialchars($old['middle_name'] ?? '') ?>"
                >

            </div>


            <div class="form-group">

                <label>Last Name</label>

                <input
                    name="last_name"
                    value="<?= htmlspecialchars($old['last_name'] ?? '') ?>"
                    class="<?= isset($fieldErrors['last_name']) ? 'input-error' : '' ?>"
                    required
                >

                <?php if (isset($fieldErrors['last_name'])): ?>

                    <small class="field-error">
                        <?= htmlspecialchars($fieldErrors['last_name']) ?>
                    </small>

                <?php endif; ?>

            </div>


            <div class="form-group">

                <label>Gender</label>

                <select
                    name="gender"
                    class="<?= isset($fieldErrors['gender']) ? 'input-error' : '' ?>"
                    required
                >

                    <option value="">Select</option>

                    <option
                        value="Male"
                        <?= ($old['gender'] ?? '') === 'Male' ? 'selected' : '' ?>
                    >
                        Male
                    </option>

                    <option
                        value="Female"
                        <?= ($old['gender'] ?? '') === 'Female' ? 'selected' : '' ?>
                    >
                        Female
                    </option>

                    <option
                        value="Other"
                        <?= ($old['gender'] ?? '') === 'Other' ? 'selected' : '' ?>
                    >
                        Other
                    </option>

                </select>

                <?php if (isset($fieldErrors['gender'])): ?>

                    <small class="field-error">
                        <?= htmlspecialchars($fieldErrors['gender']) ?>
                    </small>

                <?php endif; ?>

            </div>


            <div class="form-group">

                <label>National ID/Passport Number</label>

                <input
                    name="national_id_passport_no"
                    value="<?= htmlspecialchars($old['national_id_passport_no'] ?? '') ?>"
                    class="<?= isset($fieldErrors['national_id_passport_no']) ? 'input-error' : '' ?>"
                    minlength="6"
                    maxlength="30"
                    required
                >

                <?php if (isset($fieldErrors['national_id_passport_no'])): ?>

                    <small class="field-error">
                        <?= htmlspecialchars($fieldErrors['national_id_passport_no']) ?>
                    </small>

                <?php endif; ?>

            </div>


            <div class="form-group">

                <label>Email</label>

                <input
                    type="email"
                    name="email"
                    value="<?= htmlspecialchars($old['email'] ?? '') ?>"
                    class="<?= isset($fieldErrors['email']) ? 'input-error' : '' ?>"
                    required
                >

                <?php if (isset($fieldErrors['email'])): ?>

                    <small class="field-error">
                        <?= htmlspecialchars($fieldErrors['email']) ?>
                    </small>

                <?php endif; ?>

            </div>


            <div class="form-group">

                <label>Country Code</label>

                <select name="country_code">

                    <option
                        value="+254"
                        <?= ($old['country_code'] ?? '+254') === '+254' ? 'selected' : '' ?>
                    >
                        Kenya (+254)
                    </option>

                    <option
                        value="+255"
                        <?= ($old['country_code'] ?? '') === '+255' ? 'selected' : '' ?>
                    >
                        Tanzania (+255)
                    </option>

                    <option
                        value="+256"
                        <?= ($old['country_code'] ?? '') === '+256' ? 'selected' : '' ?>
                    >
                        Uganda (+256)
                    </option>

                    <option
                        value="+250"
                        <?= ($old['country_code'] ?? '') === '+250' ? 'selected' : '' ?>
                    >
                        Rwanda (+250)
                    </option>

                    <option
                        value="+1"
                        <?= ($old['country_code'] ?? '') === '+1' ? 'selected' : '' ?>
                    >
                        United States/Canada (+1)
                    </option>

                    <option
                        value="+44"
                        <?= ($old['country_code'] ?? '') === '+44' ? 'selected' : '' ?>
                    >
                        United Kingdom (+44)
                    </option>

                </select>

            </div>


            <div class="form-group">

                <label>Phone</label>

                <input
                    type="tel"
                    name="phone"
                    value="<?= htmlspecialchars($old['phone'] ?? '') ?>"
                    minlength="8"
                    required
                >

                <?php if (isset($fieldErrors['phone'])): ?>

                    <small class="field-error">
                        <?= htmlspecialchars($fieldErrors['phone']) ?>
                    </small>

                <?php endif; ?>

            </div>


            <div class="form-group">

                <label>School</label>

                <select
                    name="school_id"
                    class="<?= isset($fieldErrors['school_id']) ? 'input-error' : '' ?>"
                    required
                >

                    <option value="">Select</option>

                    <?php foreach ($schools as $x): ?>

                        <option
                            value="<?= $x['school_id'] ?>"
                            <?= (string)($old['school_id'] ?? '') === (string)$x['school_id'] ? 'selected' : '' ?>
                        >
                            <?= htmlspecialchars(
                                academic_display_label(
                                    $x['school_name']
                                )
                            ) ?>
                        </option>

                    <?php endforeach; ?>

                </select>

                <?php if (isset($fieldErrors['school_id'])): ?>

                    <small class="field-error">
                        <?= htmlspecialchars($fieldErrors['school_id']) ?>
                    </small>

                <?php endif; ?>

            </div>


            <div class="form-group">

                <label>Institute</label>

                <select
                    name="institute_id"
                    class="<?= isset($fieldErrors['institute_id']) ? 'input-error' : '' ?>"
                    required
                >

                    <option value="">Select</option>

                    <?php foreach ($institutes as $x): ?>

                        <option
                            value="<?= $x['institute_id'] ?>"
                            data-school-id="<?= $x['school_id'] ?? '' ?>"
                            <?= (string)($old['institute_id'] ?? '') === (string)$x['institute_id'] ? 'selected' : '' ?>
                        >
                            <?= htmlspecialchars(
                                academic_display_label(
                                    $x['institute_name']
                                )
                            ) ?>
                        </option>

                    <?php endforeach; ?>

                </select>

                <?php if (isset($fieldErrors['institute_id'])): ?>

                    <small class="field-error">
                        <?= htmlspecialchars($fieldErrors['institute_id']) ?>
                    </small>

                <?php endif; ?>

            </div>


            <div class="form-group">

                <label>Programme</label>

                <select
                    name="programme_id"
                    class="<?= isset($fieldErrors['programme_id']) ? 'input-error' : '' ?>"
                    required
                >

                    <option value="">Select</option>

                    <?php foreach ($programmes as $x): ?>

                        <option
                            value="<?= $x['programme_id'] ?>"
                            data-institute-id="<?= $x['institute_id'] ?>"
                            <?= (string)($old['programme_id'] ?? '') === (string)$x['programme_id'] ? 'selected' : '' ?>
                        >
                            <?= htmlspecialchars(
                                academic_display_label(
                                    $x['programme_name']
                                )
                            ) ?>
                        </option>

                    <?php endforeach; ?>

                </select>

                <?php if (isset($fieldErrors['programme_id'])): ?>

                    <small class="field-error">
                        <?= htmlspecialchars($fieldErrors['programme_id']) ?>
                    </small>

                <?php endif; ?>

            </div>


            <div class="form-group">

                <label>Specialisation</label>

                <select
                    name="specialisation_id"
                    class="<?= isset($fieldErrors['specialisation_id']) ? 'input-error' : '' ?>"
                >

                    <option value="">
                        None
                    </option>

                    <?php foreach ($specialisations as $x): ?>

                        <option
                            value="<?= $x['specialisation_id'] ?>"
                            data-programme-id="<?= $x['programme_id'] ?>"
                            <?= (string)($old['specialisation_id'] ?? '') === (string)$x['specialisation_id'] ? 'selected' : '' ?>
                        >
                            <?= htmlspecialchars(
                                $x['specialisation_name']
                            ) ?>
                        </option>

                    <?php endforeach; ?>

                </select>

                <?php if (isset($fieldErrors['specialisation_id'])): ?>

                    <small class="field-error">
                        <?= htmlspecialchars($fieldErrors['specialisation_id']) ?>
                    </small>

                <?php endif; ?>

            </div>


            <?php if (!$editingId): ?>


                <div class="form-group">

                    <label>New Password</label>

                    <input
                        type="password"
                        name="password"
                        minlength="8"
                        class="<?= isset($fieldErrors['password']) ? 'input-error' : '' ?>"
                        required
                    >

                    <?php if (isset($fieldErrors['password'])): ?>

                        <small class="field-error">
                            <?= htmlspecialchars($fieldErrors['password']) ?>
                        </small>

                    <?php endif; ?>

                </div>


                <div class="form-group">

                    <label>Confirm Password</label>

                    <input
                        type="password"
                        name="confirm_password"
                        minlength="8"
                        class="<?= isset($fieldErrors['confirm_password']) ? 'input-error' : '' ?>"
                        required
                    >

                    <?php if (isset($fieldErrors['confirm_password'])): ?>

                        <small class="field-error">
                            <?= htmlspecialchars(
                                $fieldErrors['confirm_password']
                            ) ?>
                        </small>

                    <?php endif; ?>

                </div>


            <?php endif; ?>


            <button type="submit">

                <?= $editingId
                    ? 'Save Changes'
                    : 'Create Student'
                ?>

            </button>

        </form>


        <h2>Students</h2>


        <form
            class="filter-form"
            method="get"
        >

            <div class="form-group">

                <label>Search</label>

                <input
                    name="search"
                    value="<?= htmlspecialchars($search) ?>"
                    placeholder="Registration number, name or email"
                >

            </div>

            <button type="submit">
                Search
            </button>

        </form>


        <table class="data-table">

            <thead>

                <tr>

                    <th>Student</th>
                    <th>Academic Assignment</th>
                    <th>Specialisation</th>
                    <th>Account</th>
                    <th>Actions</th>

                </tr>

            </thead>


            <tbody>

                <?php if (empty($students)): ?>

                    <tr>

                        <td colspan="5">
                            No students found.
                        </td>

                    </tr>

                <?php endif; ?>


                <?php foreach ($students as $s): ?>

                    <tr>

                        <td>

                            <?= htmlspecialchars(
                                $s['full_name']
                            ) ?>

                            <br>

                            <small>

                                <?= htmlspecialchars(
                                    $s['registration_no'] .
                                    ' · ' .
                                    $s['email']
                                ) ?>

                            </small>

                        </td>


                        <td>

                            <?= htmlspecialchars(

                                academic_display_label(
                                    $s['school_name'] ?? 'None'
                                )

                                . ' / ' .

                                academic_display_label(
                                    $s['institute_name'] ?? 'None'
                                )

                                . ' / ' .

                                academic_display_label(
                                    $s['programme_name'] ?? 'None'
                                )

                            ) ?>

                        </td>


                        <td>

                            <?= htmlspecialchars(
                                $s['specialisation_name'] ?? 'None'
                            ) ?>

                        </td>


                        <td>

                            <?= htmlspecialchars(
                                $s['account_status']
                            ) ?>

                        </td>


                        <td>


                            <a
                                href="?edit=<?= $s['student_id'] ?>"
                                class="secondary"
                            >
                                Edit
                            </a>


                            <form
                                class="inline-form"
                                method="post"
                            >

                                <input
                                    type="hidden"
                                    name="student_id"
                                    value="<?= $s['student_id'] ?>"
                                >

                                <input
                                    type="hidden"
                                    name="account_status"
                                    value="<?= $s['account_status'] === 'Active' ? 'Inactive' : 'Active' ?>"
                                >

                                <button
                                    name="action"
                                    value="status"
                                    type="submit"
                                >

                                    <?= $s['account_status'] === 'Active'
                                        ? 'Deactivate'
                                        : 'Activate'
                                    ?>

                                </button>


                                <button
                                    class="danger"
                                    name="action"
                                    value="delete"
                                    type="submit"
                                    onclick="return confirm('Are you sure you want to soft delete this student?');"
                                >
                                    Soft Delete
                                </button>

                            </form>

                        </td>

                    </tr>

                <?php endforeach; ?>

            </tbody>

        </table>

    </div>

</section>


<script>

document.addEventListener(
    'DOMContentLoaded',
    function () {

        const schoolSelect =
            document.querySelector(
                '[name="school_id"]'
            );

        const instituteSelect =
            document.querySelector(
                '[name="institute_id"]'
            );

        const programmeSelect =
            document.querySelector(
                '[name="programme_id"]'
            );

        const specialisationSelect =
            document.querySelector(
                '[name="specialisation_id"]'
            );


        function filterInstitutes(resetValue) {

            if (!schoolSelect || !instituteSelect) {
                return;
            }

            const schoolId =
                schoolSelect.value;

            instituteSelect
                .querySelectorAll(
                    'option[data-school-id]'
                )
                .forEach(function (option) {

                    const show =
                        schoolId !== ''
                        &&
                        option.dataset.schoolId === schoolId;

                    option.hidden = !show;
                    option.disabled = !show;

                });

            if (resetValue) {
                instituteSelect.value = '';
            }
        }


        function filterProgrammes(resetValue) {

            if (!instituteSelect || !programmeSelect) {
                return;
            }

            const instituteId =
                instituteSelect.value;

            programmeSelect
                .querySelectorAll(
                    'option[data-institute-id]'
                )
                .forEach(function (option) {

                    const show =
                        instituteId !== ''
                        &&
                        option.dataset.instituteId === instituteId;

                    option.hidden = !show;
                    option.disabled = !show;

                });

            if (resetValue) {
                programmeSelect.value = '';
            }
        }


        function filterSpecialisations(resetValue) {

            if (
                !programmeSelect ||
                !specialisationSelect
            ) {
                return;
            }

            const programmeId =
                programmeSelect.value;

            specialisationSelect
                .querySelectorAll(
                    'option[data-programme-id]'
                )
                .forEach(function (option) {

                    const show =
                        programmeId !== ''
                        &&
                        option.dataset.programmeId === programmeId;

                    option.hidden = !show;
                    option.disabled = !show;

                });

            if (resetValue) {
                specialisationSelect.value = '';
            }
        }


        if (schoolSelect) {

            schoolSelect.addEventListener(
                'change',
                function () {

                    filterInstitutes(true);
                    filterProgrammes(true);
                    filterSpecialisations(true);

                }
            );
        }


        if (instituteSelect) {

            instituteSelect.addEventListener(
                'change',
                function () {

                    filterProgrammes(true);
                    filterSpecialisations(true);

                }
            );
        }


        if (programmeSelect) {

            programmeSelect.addEventListener(
                'change',
                function () {

                    filterSpecialisations(true);

                }
            );
        }


       

        filterInstitutes(false);
        filterProgrammes(false);
        filterSpecialisations(false);

    }
);

</script>


<?php

require_once __DIR__ . '/includes/footer.php';

?>