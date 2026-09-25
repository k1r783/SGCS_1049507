<?php

require_once __DIR__ . '/config/database.php';
require_once __DIR__ . '/includes/auth.php';
require_once __DIR__ . '/includes/clearance_functions.php';


/* NORMALIZE USER ROLE
Converts role values into the exact role names used by SGCS.*/

function normalize_user_role($role)
{
    $role = strtolower(
        trim(
            (string)$role
        )
    );

    /*Convert spaces and hyphens to underscores.*/
    $role = preg_replace(
        '/[\s-]+/',
        '_',
        $role
    );

    /* Remove accidental surrounding underscores.*/
    $role = trim(
        $role,
        '_'
    );

    /*Role aliases.*/
    $roleAliases = [

        'student' =>
            'student',

        'officer' =>
            'officer',

        'departmental_officer' =>
            'officer',

        'director' =>
            'director',

        'institute_director' =>
            'director',

        'registrar' =>
            'registrar',

        'academic_registrar' =>
            'registrar',

        'admin' =>
            'admin',

        'administrator' =>
            'admin',

        'system_administrator' =>
            'admin',

        'dean' =>
            'dean',

        'dean_of_students' =>
            'dean',

        'librarian' =>
            'librarian',

        'library' =>
            'librarian',

        'finance_officer' =>
            'finance_officer',

        'finance' =>
            'finance_officer',

        'university_store' =>
            'university_store',

        'store' =>
            'university_store'
    ];

    return $roleAliases[$role]
        ?? $role;
}


/* ALREADY LOGGED IN*/

if (is_logged_in()) {

    header(
        'Location: '
        . BASE_URL
        . 'dashboard.php'
    );

    exit;
}


$page_title = 'Login';

$error = '';


/* LOGIN*/

if (
    ($_SERVER['REQUEST_METHOD'] ?? 'GET')
    === 'POST'
) {

    verify_csrf();


    /*GET LOGIN DETAILS*/

    
    $username = trim(
        $_POST['username'] ?? ''
    );

    $password =
        $_POST['password']
        ?? '';


    /*BASIC VALIDATION*/

    if (
        $username === ''
        || $password === ''
    ) {

        $error =
            'Please enter both username and password.';

    } elseif (
        strlen($username) > 100
    ) {

        $error =
            'Username is too long.';

    } else {


        /*GET USER*/

        $stmt = $pdo->prepare(
            "SELECT
                user_id,
                username,
                password_hash,
                full_name,
                role,
                linked_id,
                school_id,
                institute_id,
                department_id,
                programme_id,
                account_status,
                deleted_at

             FROM users

             WHERE username = ?

             AND account_status = 'Active'

             AND deleted_at IS NULL

             LIMIT 1"
        );


        $stmt->execute([
            $username
        ]);


        $user =
            $stmt->fetch(
                PDO::FETCH_ASSOC
            );


        /*VERIFY PASSWORD*/

        if (
            $user
            && password_verify(
                $password,
                $user['password_hash']
            )
        ) {


            /*NORMALIZE DATABASE ROLE*/

            $role =
                normalize_user_role(
                    $user['role'] ?? ''
                );


            /* ALLOWED ROLES*/

            $allowedRoles = [

                'student',

                'officer',

                'director',

                'librarian',

                'finance_officer',

                'dean',

                'university_store',

                'registrar',

                'admin',

                'none'
            ];


            /*VALIDATE ROLE*/

            if (
                !in_array(
                    $role,
                    $allowedRoles,
                    true
                )
            ) {

                $error =
                    'This account has an invalid role configuration.';

            } else {


                /* USE NORMALIZED ROLE*/

                $user['role'] =
                    $role;


                /* DEAN VALIDATION
                 A Dean must have a school.
                */

                if (
                    $role === 'dean'
                    &&
                    (
                        empty(
                            $user['school_id']
                        )
                        ||
                        (int)$user['school_id'] <= 0
                    )
                ) {

                    $error =
                        'Your Dean account is not assigned to a school. '
                        . 'Please contact the administrator.';

                } else {


                    /*LOGIN SUCCESS*/

                    session_regenerate_id(
                        true
                    );


                    /*BASIC SESSION DATA*/

                    $_SESSION['user_id'] =
                        (int)$user['user_id'];


                    /*Username remains exactly as stored.
                    */
                    $_SESSION['username'] =
                        $user['username'];


                    $_SESSION['full_name'] =
                        $user['full_name'];


                    /*IMPORTANT ROLE FIX*/

                    $_SESSION['role'] =
                        $role;


                    /*LINKED ID*/

                    $_SESSION['linked_id'] =
                        $user['linked_id'] !== null
                            ? (int)$user['linked_id']
                            : null;


                    /*SCHOOL ACCESS*/

                    $_SESSION['school_id'] =
                        !empty(
                            $user['school_id']
                        )
                            ? (int)$user['school_id']
                            : null;


                    /*INSTITUTE ACCESS*/

                    $_SESSION['institute_id'] =
                        !empty(
                            $user['institute_id']
                        )
                            ? (int)$user['institute_id']
                            : null;


                    /*DEPARTMENT ACCESS*/

                    $_SESSION['department_id'] =
                        !empty(
                            $user['department_id']
                        )
                            ? (int)$user['department_id']
                            : null;


                    /*FALLBACK DEPARTMENT LOOKUP*/

                    if (
                        empty(
                            $_SESSION['department_id']
                        )
                    ) {

                        try {

                            $deptStmt =
                                $pdo->prepare(
                                    "SELECT dept_id
                                     FROM departments
                                     WHERE officer_user_id = ?
                                     LIMIT 1"
                                );


                            $deptStmt->execute([
                                $user['user_id']
                            ]);


                            $departmentId =
                                $deptStmt->fetchColumn();


                            if (
                                $departmentId
                                &&
                                (int)$departmentId > 0
                            ) {

                                $_SESSION['department_id'] =
                                    (int)$departmentId;
                            }

                        } catch (Exception $departmentError) {

                            /*
                            | Do not prevent login merely because the
                            | optional department lookup fails.
                            */
                            $_SESSION['department_id'] =
                                $_SESSION['department_id']
                                ?? null;
                        }
                    }


                    /*AUDIT LOG*/

                    log_audit(
                        $pdo,
                        $user['user_id'],
                        'login',
                        'User logged in successfully.'
                    );


                    /*REDIRECT TO DASHBOARD*/

                    header(
                        'Location: '
                        . BASE_URL
                        . 'dashboard.php'
                    );

                    exit;
                }
            }

        } else {


            /*FAILED LOGIN*/

            log_audit(
                $pdo,
                null,
                'failed_login',
                'Failed login attempt for username: '
                . clean_message(
                    $username,
                    50
                )
            );


            $error =
                'Invalid username or password.';
        }
    }
}


require_once __DIR__ . '/includes/header.php';

?>


<section class="login-page">

    <form
        class="login-box"
        method="post"
        action="<?php echo htmlspecialchars(
            BASE_URL . 'login.php',
            ENT_QUOTES,
            'UTF-8'
        ); ?>"
    >

        <h1>Login</h1>

        <?php echo csrf_field(); ?>


        <p>
            Use your SGCS account to access
            the clearance dashboard.
        </p>


        <?php if ($error): ?>

            <div class="alert">

                <?php
                echo htmlspecialchars(
                    $error,
                    ENT_QUOTES,
                    'UTF-8'
                );
                ?>

            </div>

        <?php endif; ?>


        <div class="form-group">

            <label for="username">
                Username
            </label>

            <input
                type="text"
                id="username"
                name="username"
                maxlength="100"
                autocomplete="username"
                required
                value="<?php echo htmlspecialchars(
                    $_POST['username'] ?? '',
                    ENT_QUOTES,
                    'UTF-8'
                ); ?>"
            >

        </div>


        <div class="form-group">

            <label for="password">
                Password
            </label>

            <input
                type="password"
                id="password"
                name="password"
                autocomplete="current-password"
                required
            >

        </div>


        <button type="submit">
            Login
        </button>


        <p class="form-links">

            <a
                href="<?php echo htmlspecialchars(
                    BASE_URL . 'forgot_password.php',
                    ENT_QUOTES,
                    'UTF-8'
                ); ?>"
            >
                Forgot password?
            </a>

        </p>

    </form>

</section>


<?php

require_once __DIR__ . '/includes/footer.php';

?>