<?php

require_once __DIR__ . '/includes/auth.php';
require_role('admin');

require_once __DIR__ . '/includes/clearance_functions.php';

$message = '';
$error = '';



$roles = [
    'director',
    'librarian',
    'finance_officer',
    'dean',
    'university_store',
    'registrar',
    'none'
];

$roleLabels = [
    'director'         => 'Director',
    'librarian'        => 'Librarian',
    'finance_officer'  => 'Finance Officer',
    'dean'             => 'Dean of School',
    'university_store' => 'University Store',
    'registrar'        => 'Academic Registrar',
    'none'             => 'None'
];




$roleDepartments = [
    'director'         => 'Institute',
    'librarian'        => 'Library',
    'finance_officer'  => 'Finance Office',
    'dean'             => "Dean's Office",
    'university_store' => 'University Store Office',
    'registrar'        => 'Registry'
];




$schools = $pdo->query(
    'SELECT school_id, school_name
     FROM schools
     ORDER BY school_name'
)->fetchAll(PDO::FETCH_ASSOC);

$institutes = $pdo->query(
    'SELECT
        i.institute_id,
        i.institute_name,
        i.school_id,
        s.school_name
     FROM institutes i
     LEFT JOIN schools s
        ON s.school_id = i.school_id
     ORDER BY i.institute_name'
)->fetchAll(PDO::FETCH_ASSOC);

$programmes = $pdo->query(
    'SELECT
        p.programme_id,
        p.programme_name,
        p.institute_id,
        i.institute_name
     FROM programmes p
     JOIN institutes i
        ON i.institute_id = p.institute_id
     ORDER BY p.programme_name'
)->fetchAll(PDO::FETCH_ASSOC);

$departments = get_departments($pdo);



$departmentByName = [];

foreach ($departments as $department) {

    $name = strtolower(
        trim(
            (string)$department['dept_name']
        )
    );

    $departmentByName[$name] =
        (int)$department['dept_id'];
}


/*Get department id for role*/

function get_role_department_id(
    $role,
    $roleDepartments,
    $departmentByName
) {

    if (!isset($roleDepartments[$role])) {
        return null;
    }

    $departmentName = strtolower(
        trim(
            $roleDepartments[$role]
        )
    );

    if (!isset($departmentByName[$departmentName])) {
        throw new Exception(
            'The department "' .
            $roleDepartments[$role] .
            '" does not exist in the database.'
        );
    }

    return (int)$departmentByName[$departmentName];
}


function validate_user_assignment(
    $pdo,
    $role,
    $schoolId,
    $instituteId,
    $programmeId,
    $departmentId,
    $roleDepartments,
    $departmentByName
) {

    

    $expectedDepartmentId =
        get_role_department_id(
            $role,
            $roleDepartments,
            $departmentByName
        );

    if (
        $expectedDepartmentId !== null &&
        (int)$departmentId !== (int)$expectedDepartmentId
    ) {

        throw new Exception(
            'The ' .
            $roleDepartments[$role] .
            ' department is required for the selected role.'
        );
    }


    /* Director*/

    if ($role === 'director') {

        if (!$instituteId) {

            throw new Exception(
                'A Director must be assigned an Institute.'
            );
        }

        /* Director's department is Institute.*/
    }


    /*Dean*/

    if ($role === 'dean') {

        if (!$schoolId) {

            throw new Exception(
                'A Dean must be assigned a School.'
            );
        }
    }


    /*Programme must belong to selected institute*/

    if ($programmeId) {

        if (!$instituteId) {

            throw new Exception(
                'Please select an Institute for the selected Programme.'
            );
        }

        $stmt = $pdo->prepare(
            'SELECT 1
             FROM programmes
             WHERE programme_id = ?
             AND institute_id = ?
             LIMIT 1'
        );

        $stmt->execute([
            $programmeId,
            $instituteId
        ]);

        if (!$stmt->fetchColumn()) {

            throw new Exception(
                'The selected Programme does not belong to the selected Institute.'
            );
        }
    }


    /*Institute must belong to selected school*/

    if ($instituteId && $schoolId) {

        $stmt = $pdo->prepare(
            'SELECT 1
             FROM institutes
             WHERE institute_id = ?
             AND school_id = ?
             LIMIT 1'
        );

        $stmt->execute([
            $instituteId,
            $schoolId
        ]);

        if (!$stmt->fetchColumn()) {

            throw new Exception(
                'The selected Institute does not belong to the selected School.'
            );
        }
    }
}


/*prevent duplicates*/

function validate_unique_role_assignment(
    $pdo,
    $role,
    $schoolId,
    $instituteId,
    $excludeUserId = null
) {

    $role = strtolower(
        trim(
            (string)$role
        )
    );


   

    if ($role === 'dean' && $schoolId) {

        $sql =
            "SELECT full_name
             FROM users
             WHERE LOWER(TRIM(role)) = 'dean'
             AND school_id = ?
             AND account_status = 'Active'
             AND deleted_at IS NULL";

        $params = [
            (int)$schoolId
        ];

        if ($excludeUserId !== null) {

            $sql .= ' AND user_id <> ?';

            $params[] =
                (int)$excludeUserId;
        }

        $sql .= ' LIMIT 1';

        $stmt = $pdo->prepare($sql);

        $stmt->execute($params);

        $existing =
            $stmt->fetch(PDO::FETCH_ASSOC);

        if ($existing) {

            throw new Exception(
                'This School already has an active Dean: ' .
                $existing['full_name'] .
                '. Please deactivate or reassign the current Dean first.'
            );
        }
    }


   

    if ($role === 'director' && $instituteId) {

        $sql =
            "SELECT full_name
             FROM users
             WHERE LOWER(TRIM(role)) = 'director'
             AND institute_id = ?
             AND account_status = 'Active'
             AND deleted_at IS NULL";

        $params = [
            (int)$instituteId
        ];

        if ($excludeUserId !== null) {

            $sql .= ' AND user_id <> ?';

            $params[] =
                (int)$excludeUserId;
        }

        $sql .= ' LIMIT 1';

        $stmt = $pdo->prepare($sql);

        $stmt->execute($params);

        $existing =
            $stmt->fetch(PDO::FETCH_ASSOC);

        if ($existing) {

            throw new Exception(
                'This Institute already has an active Director: ' .
                $existing['full_name'] .
                '. Please deactivate or reassign the current Director first.'
            );
        }
    }
}




if ($_SERVER['REQUEST_METHOD'] === 'POST') {

    $action =
        clean_input(
            $_POST['action'] ?? ''
        );

    $id =
        (int)(
            $_POST['user_id'] ?? 0
        );


    try {

        

        if (
            $action === 'create' ||
            $action === 'edit'
        ) {

            
            $username =
                trim(
                    $_POST['username'] ?? ''
                );

            $name =
                clean_message(
                    $_POST['full_name'] ?? '',
                    100
                );

            $email =
                clean_input(
                    $_POST['email'] ?? ''
                );

            $role =
                strtolower(
                    trim(
                        clean_input(
                            $_POST['role'] ?? ''
                        )
                    )
                );


            $schoolId =
                (
                    isset($_POST['school_id']) &&
                    $_POST['school_id'] !== ''
                )
                ? (int)$_POST['school_id']
                : null;


            $instituteId =
                (
                    isset($_POST['institute_id']) &&
                    $_POST['institute_id'] !== ''
                )
                ? (int)$_POST['institute_id']
                : null;


            $programmeId =
                (
                    isset($_POST['programme_id']) &&
                    $_POST['programme_id'] !== ''
                )
                ? (int)$_POST['programme_id']
                : null;



            if ($username === '') {

                throw new Exception(
                    'Username is required.'
                );
            }


            if ($name === '') {

                throw new Exception(
                    'Full Name is required.'
                );
            }


            if (!is_valid_email($email)) {

                throw new Exception(
                    'Enter a valid email address.'
                );
            }


            if (!in_array($role, $roles, true)) {

                throw new Exception(
                    'Please select a valid administrative role.'
                );
            }


           

            if ($action === 'edit') {

                if ($id <= 0) {

                    throw new Exception(
                        'Invalid user selected.'
                    );
                }

                $checkUser =
                    $pdo->prepare(
                        "SELECT user_id
                         FROM users
                         WHERE user_id = ?
                         AND role <> 'student'
                         AND deleted_at IS NULL
                         LIMIT 1"
                    );

                $checkUser->execute([
                    $id
                ]);

                if (!$checkUser->fetch()) {

                    throw new Exception(
                        'The selected user account could not be found.'
                    );
                }
            }


            /* The selected ROLE controls the DEPARTMENT.*/

            $departmentId =
                get_role_department_id(
                    $role,
                    $roleDepartments,
                    $departmentByName
                );


            /* None role */

            if ($role === 'none') {

                $schoolId = null;
                $instituteId = null;
                $programmeId = null;
                $departmentId = null;
            }


            /* Roles that do NOT require academic structure. These are administrative offices. */

            if (
                $role === 'librarian' ||
                $role === 'finance_officer' ||
                $role === 'university_store' ||
                $role === 'registrar'
            ) {

                $schoolId = null;
                $instituteId = null;
                $programmeId = null;
            }


            

            if ($role === 'director') {

                $schoolId = null;
                $programmeId = null;

                if (!$instituteId) {

                    throw new Exception(
                        'A Director must be assigned an Institute.'
                    );
                }
            }


           
            if ($role === 'dean') {

                $instituteId = null;
                $programmeId = null;

                if (!$schoolId) {

                    throw new Exception(
                        'A Dean must be assigned a School.'
                    );
                }
            }


           

            validate_user_assignment(
                $pdo,
                $role,
                $schoolId,
                $instituteId,
                $programmeId,
                $departmentId,
                $roleDepartments,
                $departmentByName
            );


            

            validate_unique_role_assignment(
                $pdo,
                $role,
                $schoolId,
                $instituteId,
                $action === 'edit'
                    ? $id
                    : null
            );


          

            if (
                value_exists(
                    $pdo,
                    'users',
                    'username',
                    $username,
                    $action === 'edit'
                        ? $id
                        : null,
                    'user_id'
                )
            ) {

                throw new Exception(
                    'That username is already in use.'
                );
            }


           

            if (
                value_exists(
                    $pdo,
                    'users',
                    'email',
                    $email,
                    $action === 'edit'
                        ? $id
                        : null,
                    'user_id'
                )
                ||
                value_exists(
                    $pdo,
                    'students',
                    'email',
                    $email
                )
            ) {

                throw new Exception(
                    'That email is already in use.'
                );
            }



            if ($action === 'create') {

                $password =
                    $_POST['password'] ?? '';

                $confirm =
                    $_POST['confirm_password'] ?? '';


                if (strlen($password) < 8) {

                    throw new Exception(
                        'Password must contain at least 8 characters.'
                    );
                }


                if ($password !== $confirm) {

                    throw new Exception(
                        'New Password and Confirm Password must match.'
                    );
                }


                $stmt =
                    $pdo->prepare(
                        'INSERT INTO users
                        (
                            username,
                            password_hash,
                            role,
                            school_id,
                            institute_id,
                            department_id,
                            programme_id,
                            full_name,
                            email,
                            account_status
                        )
                        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)'
                    );


                $stmt->execute([
                    $username,
                    password_hash(
                        $password,
                        PASSWORD_DEFAULT
                    ),
                    $role,
                    $schoolId,
                    $instituteId,
                    $departmentId,
                    $programmeId,
                    $name,
                    $email,
                    'Active'
                ]);


                log_audit(
                    $pdo,
                    $_SESSION['user_id'],
                    'user_created',
                    'Administrator created ' .
                    $roleLabels[$role] .
                    ': ' .
                    $name
                );


                header(
                    'Location: ' .
                    BASE_URL .
                    'admin_users.php?created=1'
                );

                exit;
            }



            $stmt =
                $pdo->prepare(
                    "UPDATE users
                     SET
                        username = ?,
                        role = ?,
                        school_id = ?,
                        institute_id = ?,
                        department_id = ?,
                        programme_id = ?,
                        full_name = ?,
                        email = ?
                     WHERE user_id = ?
                     AND role <> 'student'"
                );


            $stmt->execute([
                $username,
                $role,
                $schoolId,
                $instituteId,
                $departmentId,
                $programmeId,
                $name,
                $email,
                $id
            ]);


            log_audit(
                $pdo,
                $_SESSION['user_id'],
                'user_updated',
                'Administrator updated ' .
                $roleLabels[$role] .
                ': ' .
                $name
            );


            header(
                'Location: ' .
                BASE_URL .
                'admin_users.php?updated=1'
            );

            exit;
        }


    

        elseif (
            $action === 'status' &&
            $id
        ) {

            $status =
                clean_input(
                    $_POST['account_status'] ?? ''
                ) === 'Inactive'
                ? 'Inactive'
                : 'Active';


            $userStmt =
                $pdo->prepare(
                    "SELECT
                        user_id,
                        full_name,
                        role,
                        school_id,
                        institute_id,
                        account_status
                     FROM users
                     WHERE user_id = ?
                     AND user_id <> ?
                     AND role <> 'student'
                     AND deleted_at IS NULL
                     LIMIT 1"
                );


            $userStmt->execute([
                $id,
                $_SESSION['user_id']
            ]);


            $targetUser =
                $userStmt->fetch(
                    PDO::FETCH_ASSOC
                );


            if (!$targetUser) {

                throw new Exception(
                    'The selected user account could not be found.'
                );
            }


            if ($status === 'Active') {

                validate_unique_role_assignment(
                    $pdo,
                    $targetUser['role'],
                    !empty($targetUser['school_id'])
                        ? (int)$targetUser['school_id']
                        : null,
                    !empty($targetUser['institute_id'])
                        ? (int)$targetUser['institute_id']
                        : null,
                    (int)$targetUser['user_id']
                );
            }


            $stmt =
                $pdo->prepare(
                    "UPDATE users
                     SET account_status = ?
                     WHERE user_id = ?
                     AND user_id <> ?
                     AND role <> 'student'"
                );


            $stmt->execute([
                $status,
                $id,
                $_SESSION['user_id']
            ]);


            log_audit(
                $pdo,
                $_SESSION['user_id'],
                'user_status_updated',
                'Administrator changed account status for user #' .
                $id .
                ' to ' .
                $status
            );


            header(
                'Location: ' .
                BASE_URL .
                'admin_users.php?status_updated=1'
            );

            exit;
        }



        elseif (
            $action === 'reset' &&
            $id
        ) {

            $password =
                $_POST['password'] ?? '';

            $confirm =
                $_POST['confirm_password'] ?? '';


            if (
                strlen($password) < 8 ||
                $password !== $confirm
            ) {

                throw new Exception(
                    'Provide matching passwords of at least 8 characters.'
                );
            }


            $stmt =
                $pdo->prepare(
                    "UPDATE users
                     SET password_hash = ?
                     WHERE user_id = ?
                     AND role <> 'student'"
                );


            $stmt->execute([
                password_hash(
                    $password,
                    PASSWORD_DEFAULT
                ),
                $id
            ]);


            log_audit(
                $pdo,
                $_SESSION['user_id'],
                'password_reset',
                'Administrator reset password for user #' .
                $id
            );


            header(
                'Location: ' .
                BASE_URL .
                'admin_users.php?password_reset=1'
            );

            exit;
        }


        else {

            throw new Exception(
                'Invalid action.'
            );
        }

    } catch (Exception $e) {

        $error =
            $e->getMessage();
    }
}




if (isset($_GET['updated'])) {
    $message =
        'User account updated successfully.';
}

if (isset($_GET['created'])) {
    $message =
        'User account created successfully.';
}

if (isset($_GET['status_updated'])) {
    $message =
        'Account status updated successfully.';
}


if (isset($_GET['password_reset'])) {
    $message =
        'Password reset successfully.';
}




$editUser = null;

$editUserId =
    isset($_GET['edit_user'])
    ? (int)$_GET['edit_user']
    : 0;


if ($editUserId > 0) {

    $stmt =
        $pdo->prepare(
            "SELECT *
             FROM users
             WHERE user_id = ?
             AND role <> 'student'
             AND deleted_at IS NULL
             LIMIT 1"
        );


    $stmt->execute([
        $editUserId
    ]);


    $editUser =
        $stmt->fetch(
            PDO::FETCH_ASSOC
        );


    if (!$editUser) {

        $error =
            'The selected user account could not be found.';
    }
}




$search =
    clean_input(
        $_GET['search'] ?? ''
    );


$sql = '
SELECT
    u.*,
    s.school_name,
    i.institute_name,
    p.programme_name,
    d.dept_name

FROM users u

LEFT JOIN schools s
    ON s.school_id = u.school_id

LEFT JOIN institutes i
    ON i.institute_id = u.institute_id

LEFT JOIN programmes p
    ON p.programme_id = u.programme_id

LEFT JOIN departments d
    ON d.dept_id = u.department_id

WHERE u.role <> \'student\'
AND u.deleted_at IS NULL
';


$params = [];


if ($search !== '') {

    $sql .= '
    AND (
        u.username LIKE ?
        OR u.full_name LIKE ?
        OR u.email LIKE ?
    )';


    $params = [
        "%$search%",
        "%$search%",
        "%$search%"
    ];
}


$sql .= '
ORDER BY u.created_at DESC
';


$q =
    $pdo->prepare($sql);

$q->execute($params);

$users =
    $q->fetchAll(
        PDO::FETCH_ASSOC
    );


$page_title =
    'Manage Users';

require_once __DIR__ . '/includes/header.php';

?>

<section class="dashboard">

    <div class="dashboard-top">

        <h1>
            Manage Administrative Users
        </h1>

        <a href="<?php echo BASE_URL; ?>dashboard.php">
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


        <!-- CREATE USER -->

        <h2>Create User</h2>


        <form
            class="filter-form"
            method="post"
            data-user-form
        >

            <input
                type="hidden"
                name="action"
                value="create"
            >


            <div class="form-group">

                <label>Username</label>

                <input
                    name="username"
                    required
                >

            </div>


            <div class="form-group">

                <label>Full Name</label>

                <input
                    name="full_name"
                    required
                >

            </div>


            <div class="form-group">

                <label>Email</label>

                <input
                    type="email"
                    name="email"
                    required
                >

            </div>


            <div class="form-group">

                <label>Role</label>

                <select
                    name="role"
                    class="role-select"
                    required
                >

                    <option value="">
                        Select Role
                    </option>

                    <?php foreach ($roles as $role): ?>

                        <option
                            value="<?= htmlspecialchars($role) ?>"
                        >
                            <?= htmlspecialchars(
                                $roleLabels[$role]
                            ) ?>
                        </option>

                    <?php endforeach; ?>

                </select>

            </div>


            <div class="form-group">

                <label>School</label>

                <select
                    name="school_id"
                    class="school-select"
                >

                    <option value="">
                        None
                    </option>

                    <?php foreach ($schools as $x): ?>

                        <option
                            value="<?= (int)$x['school_id'] ?>"
                        >
                            <?= htmlspecialchars(
                                $x['school_name']
                            ) ?>
                        </option>

                    <?php endforeach; ?>

                </select>

            </div>


            <div class="form-group">

                <label>Institute</label>

                <select
                    name="institute_id"
                    class="institute-select"
                >

                    <option value="">
                        None
                    </option>

                    <?php foreach ($institutes as $x): ?>

                        <option
                            value="<?= (int)$x['institute_id'] ?>"
                            data-school-id="<?= (int)$x['school_id'] ?>"
                        >
                            <?= htmlspecialchars(
                                $x['institute_name']
                            ) ?>
                        </option>

                    <?php endforeach; ?>

                </select>

            </div>


            <div class="form-group">

                <label>Programme</label>

                <select
                    name="programme_id"
                    class="programme-select"
                >

                    <option value="">
                        None
                    </option>

                    <?php foreach ($programmes as $x): ?>

                        <option
                            value="<?= (int)$x['programme_id'] ?>"
                            data-institute-id="<?= (int)$x['institute_id'] ?>"
                        >
                            <?= htmlspecialchars(
                                $x['programme_name']
                            ) ?>
                        </option>

                    <?php endforeach; ?>

                </select>

            </div>


            <div class="form-group">

                <label>Department</label>

                <select
                    name="department_id"
                    class="department-select"
                    required
                >

                    <option value="">
                        Select Department
                    </option>

                    <?php foreach ($departments as $x): ?>

                        <option
                            value="<?= (int)$x['dept_id'] ?>"
                        >
                            <?= htmlspecialchars(
                                $x['dept_name']
                            ) ?>
                        </option>

                    <?php endforeach; ?>

                </select>

            </div>


            <div class="form-group">

                <label>New Password</label>

                <input
                    type="password"
                    name="password"
                    minlength="8"
                    required
                >

            </div>


            <div class="form-group">

                <label>Confirm Password</label>

                <input
                    type="password"
                    name="confirm_password"
                    minlength="8"
                    required
                >

            </div>


            <button type="submit">
                Create User
            </button>

        </form>


        <!-- EDIT USER -->

        <?php if ($editUser): ?>

            <hr style="margin:35px 0;">


            <div class="edit-user-section">

                <div class="edit-user-header">

                    <div>

                        <h2>Edit User</h2>

                        <p>
                            Editing:
                            <strong>
                                <?= htmlspecialchars(
                                    $editUser['full_name']
                                ) ?>
                            </strong>
                        </p>

                    </div>


                    <a
                        href="<?= BASE_URL ?>admin_users.php"
                        class="button secondary"
                    >
                        Cancel Edit
                    </a>

                </div>


                <form
                    class="filter-form"
                    method="post"
                    data-user-form
                >

                    <input
                        type="hidden"
                        name="action"
                        value="edit"
                    >


                    <input
                        type="hidden"
                        name="user_id"
                        value="<?= (int)$editUser['user_id'] ?>"
                    >


                    <div class="form-group">

                        <label>Username</label>

                        <input
                            name="username"
                            value="<?= htmlspecialchars(
                                $editUser['username']
                            ) ?>"
                            required
                        >

                    </div>


                    <div class="form-group">

                        <label>Full Name</label>

                        <input
                            name="full_name"
                            value="<?= htmlspecialchars(
                                $editUser['full_name']
                            ) ?>"
                            required
                        >

                    </div>


                    <div class="form-group">

                        <label>Email</label>

                        <input
                            type="email"
                            name="email"
                            value="<?= htmlspecialchars(
                                $editUser['email']
                            ) ?>"
                            required
                        >

                    </div>


                    <div class="form-group">

                        <label>Role</label>

                        <select
                            name="role"
                            class="role-select"
                            required
                        >

                            <?php foreach ($roles as $role): ?>

                                <option
                                    value="<?= htmlspecialchars($role) ?>"
                                    <?= strtolower(trim((string)$editUser['role'])) === $role
                                        ? 'selected'
                                        : '' ?>
                                >
                                    <?= htmlspecialchars(
                                        $roleLabels[$role]
                                    ) ?>
                                </option>

                            <?php endforeach; ?>

                        </select>

                    </div>


                    <div class="form-group">

                        <label>School</label>

                        <select
                            name="school_id"
                            class="school-select"
                        >

                            <option value="">
                                None
                            </option>

                            <?php foreach ($schools as $x): ?>

                                <option
                                    value="<?= (int)$x['school_id'] ?>"
                                    <?= (int)($editUser['school_id'] ?? 0)
                                        === (int)$x['school_id']
                                        ? 'selected'
                                        : '' ?>
                                >
                                    <?= htmlspecialchars(
                                        $x['school_name']
                                    ) ?>
                                </option>

                            <?php endforeach; ?>

                        </select>

                    </div>


                    <div class="form-group">

                        <label>Institute</label>

                        <select
                            name="institute_id"
                            class="institute-select"
                        >

                            <option value="">
                                None
                            </option>

                            <?php foreach ($institutes as $x): ?>

                                <option
                                    value="<?= (int)$x['institute_id'] ?>"
                                    data-school-id="<?= (int)$x['school_id'] ?>"
                                    <?= (int)($editUser['institute_id'] ?? 0)
                                        === (int)$x['institute_id']
                                        ? 'selected'
                                        : '' ?>
                                >
                                    <?= htmlspecialchars(
                                        $x['institute_name']
                                    ) ?>
                                </option>

                            <?php endforeach; ?>

                        </select>

                    </div>


                    <div class="form-group">

                        <label>Programme</label>

                        <select
                            name="programme_id"
                            class="programme-select"
                        >

                            <option value="">
                                None
                            </option>

                            <?php foreach ($programmes as $x): ?>

                                <option
                                    value="<?= (int)$x['programme_id'] ?>"
                                    data-institute-id="<?= (int)$x['institute_id'] ?>"
                                    <?= (int)($editUser['programme_id'] ?? 0)
                                        === (int)$x['programme_id']
                                        ? 'selected'
                                        : '' ?>
                                >
                                    <?= htmlspecialchars(
                                        $x['programme_name']
                                    ) ?>
                                </option>

                            <?php endforeach; ?>

                        </select>

                    </div>


                    <div class="form-group">

                        <label>Department</label>

                        <select
                            name="department_id"
                            class="department-select"
                            required
                        >

                            <option value="">
                                Select Department
                            </option>

                            <?php foreach ($departments as $x): ?>

                                <option
                                    value="<?= (int)$x['dept_id'] ?>"
                                    <?= (int)($editUser['department_id'] ?? 0)
                                        === (int)$x['dept_id']
                                        ? 'selected'
                                        : '' ?>
                                >
                                    <?= htmlspecialchars(
                                        $x['dept_name']
                                    ) ?>
                                </option>

                            <?php endforeach; ?>

                        </select>

                    </div>


                    <button type="submit">
                        Save Changes
                    </button>

                </form>

            </div>

        <?php endif; ?>


        <!--  EXISTING USERS -->

        <hr style="margin:35px 0;">


        <h2>
            Existing Administrative Users
        </h2>


        <form
            class="filter-form"
            method="get"
            action="<?= BASE_URL ?>admin_users.php"
        >

            <div class="form-group">

                <label>Search</label>

                <input
                    name="search"
                    value="<?= htmlspecialchars($search) ?>"
                    placeholder="Name, username or email"
                >

            </div>

            <button type="submit">
                Search
            </button>

        </form>


        <div style="overflow-x:auto;">

            <table class="data-table">

                <thead>

                    <tr>

                        <th>User</th>

                        <th>Role</th>

                        <th>Department</th>

                        <th>School</th>

                        <th>Institute</th>

                        <th>Status</th>

                        <th>Actions</th>

                    </tr>

                </thead>


                <tbody>

                    <?php if ($users): ?>

                        <?php foreach ($users as $u): ?>

                            <?php

                            $userRole =
                                strtolower(
                                    trim(
                                        (string)$u['role']
                                    )
                                );

                            $displayRole =
                                $roleLabels[$userRole]
                                ?? ucfirst(
                                    $userRole
                                );

                            ?>

                            <tr>

                                <td>

                                    <strong>
                                        <?= htmlspecialchars(
                                            $u['full_name']
                                        ) ?>
                                    </strong>

                                    <br>

                                    <small>
                                        <?= htmlspecialchars(
                                            $u['username']
                                        ) ?>

                                        ·

                                        <?= htmlspecialchars(
                                            $u['email']
                                        ) ?>
                                    </small>

                                </td>


                                <td>

                                    <?= htmlspecialchars(
                                        $displayRole
                                    ) ?>

                                </td>


                                <td>

                                    <?= htmlspecialchars(
                                        $u['dept_name']
                                        ?? 'None'
                                    ) ?>

                                </td>


                                <td>

                                    <?= htmlspecialchars(
                                        $u['school_name']
                                        ?? 'None'
                                    ) ?>

                                </td>


                                <td>

                                    <?= htmlspecialchars(
                                        $u['institute_name']
                                        ?? 'None'
                                    ) ?>

                                </td>


                                <td>

                                    <?= htmlspecialchars(
                                        $u['account_status']
                                    ) ?>

                                </td>


                                <td class="user-actions">


                                    <!-- EDIT -->

                                    <form
                                        class="inline-form"
                                        method="get"
                                        action="<?= BASE_URL ?>admin_users.php"
                                    >

                                        <input
                                            type="hidden"
                                            name="edit_user"
                                            value="<?= (int)$u['user_id'] ?>"
                                        >

                                        <button
                                            type="submit"
                                            class="action-button"
                                        >
                                            Edit User
                                        </button>

                                    </form>


                                    <?php if (
                                        (int)$u['user_id'] !==
                                        (int)$_SESSION['user_id']
                                    ): ?>


                                        <!-- ACTIVATE / DEACTIVATE -->

                                        <form
                                            class="inline-form"
                                            method="post"
                                        >

                                            <input
                                                type="hidden"
                                                name="user_id"
                                                value="<?= (int)$u['user_id'] ?>"
                                            >

                                            <input
                                                type="hidden"
                                                name="account_status"
                                                value="<?= $u['account_status'] === 'Active'
                                                    ? 'Inactive'
                                                    : 'Active' ?>"
                                            >

                                            <button
                                                type="submit"
                                                name="action"
                                                value="status"
                                                class="action-button"
                                            >

                                                <?= $u['account_status'] === 'Active'
                                                    ? 'Deactivate'
                                                    : 'Activate' ?>

                                            </button>

                                        </form>


                                    <?php endif; ?>


                                    <!-- RESET PASSWORD -->

                                    <form
                                        class="inline-form password-form"
                                        method="post"
                                    >

                                        <input
                                            type="hidden"
                                            name="action"
                                            value="reset"
                                        >

                                        <input
                                            type="hidden"
                                            name="user_id"
                                            value="<?= (int)$u['user_id'] ?>"
                                        >

                                        <input
                                            type="password"
                                            name="password"
                                            minlength="8"
                                            placeholder="New password"
                                            required
                                        >

                                        <input
                                            type="password"
                                            name="confirm_password"
                                            minlength="8"
                                            placeholder="Confirm password"
                                            required
                                        >

                                        <button
                                            type="submit"
                                            class="secondary action-button"
                                        >
                                            Reset Password
                                        </button>

                                    </form>

                                </td>

                            </tr>

                        <?php endforeach; ?>


                    <?php else: ?>

                        <tr>

                            <td
                                colspan="7"
                                style="text-align:center;"
                            >
                                No administrative users found.
                            </td>

                        </tr>

                    <?php endif; ?>

                </tbody>

            </table>

        </div>

    </div>

</section>


<style>

.user-actions {
    min-width: 260px;
}

.inline-form {
    margin-bottom: 10px;
}

.action-button {
    width: 100%;
}

.password-form {
    display: flex;
    flex-direction: column;
    gap: 8px;
}

.password-form input {
    width: 100%;
    box-sizing: border-box;
}

.edit-user-section {
    padding: 20px;
    border: 1px solid #ddd;
    border-radius: 8px;
}

.edit-user-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 15px;
    margin-bottom: 20px;
}

.role-select,
.department-select {
    font-weight: 500;
}

@media (max-width: 768px) {

    .edit-user-header {
        flex-direction: column;
        align-items: flex-start;
    }

}

</style>


<script>

document.addEventListener(
    'DOMContentLoaded',
    function () {

        const roleDepartmentMap = {

            director: 'Institute',

            librarian: 'Library',

            finance_officer: 'Finance Office',

            dean: "Dean's Office",

            university_store: 'University Store Office',

            registrar: 'Registry'

        };


        document
            .querySelectorAll('[data-user-form]')
            .forEach(function (form) {

                const roleSelect =
                    form.querySelector('.role-select');

                const departmentSelect =
                    form.querySelector('.department-select');

                const schoolSelect =
                    form.querySelector('.school-select');

                const instituteSelect =
                    form.querySelector('.institute-select');

                const programmeSelect =
                    form.querySelector('.programme-select');


                if (
                    !roleSelect ||
                    !departmentSelect
                ) {
                    return;
                }


               
                function selectDepartmentByName(name) {

                    if (!name) {
                        return;
                    }

                    const target =
                        name
                            .trim()
                            .toLowerCase();


                    for (
                        let i = 0;
                        i < departmentSelect.options.length;
                        i++
                    ) {

                        const option =
                            departmentSelect.options[i];

                        if (
                            option.text
                                .trim()
                                .toLowerCase()
                            === target
                        ) {

                            departmentSelect.value =
                                option.value;

                            return;
                        }
                    }
                }


                /* Apply role configuration*/

                function applyRoleConfiguration() {

                    const role =
                        roleSelect.value;


                    const departmentName =
                        roleDepartmentMap[role];


                    /* Automatically select department*/

                    if (departmentName) {

                        selectDepartmentByName(
                            departmentName
                        );

                        /*Department is controlled by role.*/
                        departmentSelect.disabled = true;

                    } else {

                        departmentSelect.disabled = false;
                    }


                    /* A None user cannot be assigned to any area. */

                    if (role === 'none') {

                        if (schoolSelect) {
                            schoolSelect.value = '';
                            schoolSelect.disabled = true;
                        }

                        if (instituteSelect) {
                            instituteSelect.value = '';
                            instituteSelect.disabled = true;
                        }

                        if (programmeSelect) {
                            programmeSelect.value = '';
                            programmeSelect.disabled = true;
                        }

                        if (departmentSelect) {
                            departmentSelect.value = '';
                            departmentSelect.disabled = true;
                        }

                    }


                    /* Librarian / Finance / Store / Registrar */

                    else if (
                        role === 'librarian' ||
                        role === 'finance_officer' ||
                        role === 'university_store' ||
                        role === 'registrar'
                    ) {

                        if (schoolSelect) {
                            schoolSelect.value = '';
                            schoolSelect.disabled = true;
                        }

                        if (instituteSelect) {
                            instituteSelect.value = '';
                            instituteSelect.disabled = true;
                        }

                        if (programmeSelect) {
                            programmeSelect.value = '';
                            programmeSelect.disabled = true;
                        }

                    }


                    /* Director*/

                    else if (role === 'director') {

                        if (schoolSelect) {
                            schoolSelect.value = '';
                            schoolSelect.disabled = true;
                        }

                        if (instituteSelect) {
                            instituteSelect.disabled = false;
                        }

                        if (programmeSelect) {
                            programmeSelect.value = '';
                            programmeSelect.disabled = true;
                        }

                    }


                   

                    else if (role === 'dean') {

                        if (schoolSelect) {
                            schoolSelect.disabled = false;
                        }

                        if (instituteSelect) {
                            instituteSelect.value = '';
                            instituteSelect.disabled = true;
                        }

                        if (programmeSelect) {
                            programmeSelect.value = '';
                            programmeSelect.disabled = true;
                        }

                    }



                    else {

                        if (schoolSelect) {
                            schoolSelect.disabled = false;
                        }

                        if (instituteSelect) {
                            instituteSelect.disabled = false;
                        }

                        if (programmeSelect) {
                            programmeSelect.disabled = false;
                        }

                    }
                }


               
                function filterInstitutes() {

                    if (!schoolSelect || !instituteSelect) {
                        return;
                    }

                    const schoolId =
                        schoolSelect.value;


                    Array.from(
                        instituteSelect.options
                    ).forEach(function (option) {

                        if (
                            option.value === ''
                        ) {
                            option.hidden = false;
                            return;
                        }


                        const optionSchool =
                            option.getAttribute(
                                'data-school-id'
                            );


                        option.hidden =
                            schoolId !== '' &&
                            optionSchool !== schoolId;

                    });


                    if (
                        instituteSelect.value !== ''
                    ) {

                        const selected =
                            instituteSelect
                                .selectedOptions[0];

                        if (
                            selected &&
                            selected.hidden
                        ) {

                            instituteSelect.value = '';
                        }
                    }
                }


                

                function filterProgrammes() {

                    if (!instituteSelect || !programmeSelect) {
                        return;
                    }

                    const instituteId =
                        instituteSelect.value;


                    Array.from(
                        programmeSelect.options
                    ).forEach(function (option) {

                        if (
                            option.value === ''
                        ) {
                            option.hidden = false;
                            return;
                        }


                        const optionInstitute =
                            option.getAttribute(
                                'data-institute-id'
                            );


                        option.hidden =
                            instituteId !== '' &&
                            optionInstitute !== instituteId;

                    });


                    if (
                        programmeSelect.value !== ''
                    ) {

                        const selected =
                            programmeSelect
                                .selectedOptions[0];

                        if (
                            selected &&
                            selected.hidden
                        ) {

                            programmeSelect.value = '';
                        }
                    }
                }


                /* Events*/

                roleSelect.addEventListener(
                    'change',
                    function () {

                        applyRoleConfiguration();

                        filterInstitutes();

                        filterProgrammes();

                    }
                );


                if (schoolSelect) {

                    schoolSelect.addEventListener(
                        'change',
                        function () {

                            filterInstitutes();

                            filterProgrammes();

                        }
                    );
                }


                if (instituteSelect) {

                    instituteSelect.addEventListener(
                        'change',
                        function () {

                            filterProgrammes();

                        }
                    );
                }


                /*Initial setup*/

                filterInstitutes();

                filterProgrammes();

                applyRoleConfiguration();

            });

    }
);

</script>


<?php

require_once __DIR__ . '/includes/footer.php';

?>