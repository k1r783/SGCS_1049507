<?php

require_once __DIR__ . '/../config/config.php';


/* SESSION*/

if (session_status() === PHP_SESSION_NONE) {

    session_name(SESSION_NAME);

    session_set_cookie_params([
        'lifetime' => 0,
        'path' => '/',
        'secure' => (
            !empty($_SERVER['HTTPS'])
            && $_SERVER['HTTPS'] !== 'off'
        ),
        'httponly' => true,
        'samesite' => 'Lax'
    ]);

    session_start();
}


/*VALID SYSTEM ROLES*/

function valid_system_roles()
{
    return [
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
}


/* ROLE → DEPARTMENT*/

function role_department_name($role)
{
    $mapping = [

        'director' =>
            'Institute',

        'librarian' =>
            'Library',

        'finance_officer' =>
            'Finance Office',

        'dean' =>
            "Dean's Office",

        'university_store' =>
            'University Store Office',

        'registrar' =>
            'Registry'
    ];

    return $mapping[$role] ?? null;
}


/*AUTHENTICATION*/

function is_logged_in()
{
    return !empty($_SESSION['user_id']);
}


/* CURRENT USER*/

function current_user()
{
    if (!is_logged_in()) {
        return null;
    }

    return [

        'user_id' =>
            $_SESSION['user_id'] ?? null,

        'username' =>
            $_SESSION['username'] ?? '',

        'full_name' =>
            $_SESSION['full_name'] ?? '',

        'role' =>
            $_SESSION['role'] ?? '',

        'linked_id' =>
            $_SESSION['linked_id'] ?? null,

        /*
         * Dean school restriction.
         */
        'school_id' =>
            $_SESSION['school_id'] ?? null,

        /*
         * Institute Director restriction.
         */
        'institute_id' =>
            $_SESSION['institute_id'] ?? null,

        /*
         * Departmental officer restriction.
         */
        'department_id' =>
            $_SESSION['department_id'] ?? null
    ];
}


/* REQUIRE LOGIN*/

function require_login()
{
    if (!is_logged_in()) {

        header(
            'Location: '
            . BASE_URL
            . 'login.php'
        );

        exit;
    }

    $role = strtolower(
        trim(
            (string)(
                $_SESSION['role'] ?? ''
            )
        )
    );

    if ($role === 'none') {

        header(
            'Location: '
            . BASE_URL
            . 'logout.php'
        );

        exit;
    }
}


/*REQUIRE ROLE*/

function require_role($roles)
{
    require_login();

    if (!is_array($roles)) {
        $roles = [$roles];
    }

    $currentRole =
        strtolower(
            trim(
                (string)(
                    $_SESSION['role'] ?? ''
                )
            )
        );

    /*Normalize requested roles as well.*/
    $roles = array_map(
        function ($role) {
            return strtolower(
                trim(
                    (string)$role
                )
            );
        },
        $roles
    );

    if (!in_array(
        $currentRole,
        $roles,
        true
    )) {

        http_response_code(403);

        exit('Not authorized.');
    }
}


/* ROLE CONFIGURATION VALIDATION*/

function validate_current_role_configuration()
{
    if (!is_logged_in()) {
        return true;
    }

    $role =
        strtolower(
            trim(
                (string)(
                    $_SESSION['role'] ?? ''
                )
            )
        );

    if ($role === '') {
        return false;
    }

    /*Every role must be a recognized system role. */
    if (!in_array(
        $role,
        valid_system_roles(),
        true
    )) {
        return false;
    }

    return true;
}


/*CSRF PROTECTION*/

function csrf_token()
{
    if (empty($_SESSION['csrf_token'])) {

        $_SESSION['csrf_token'] =
            bin2hex(
                random_bytes(32)
            );
    }

    return $_SESSION['csrf_token'];
}


function csrf_field()
{
    return
        '<input type="hidden" '
        . 'name="csrf_token" '
        . 'value="'
        . htmlspecialchars(
            csrf_token(),
            ENT_QUOTES,
            'UTF-8'
        )
        . '">';
}


function verify_csrf()
{
    if (
        ($_SERVER['REQUEST_METHOD'] ?? 'GET')
        !== 'POST'
    ) {
        return;
    }

    $token =
        $_POST['csrf_token']
        ?? '';

    if (
        !is_string($token)
        || empty($_SESSION['csrf_token'])
        || !hash_equals(
            $_SESSION['csrf_token'],
            $token
        )
    ) {

        http_response_code(419);

        exit(
            'Invalid form submission. '
            . 'Please reload and try again.'
        );
    }
}


/* ROLE LABELS*/

function role_label($role)
{
    $labels = [

        'student' =>
            'Student',

        'officer' =>
            'Departmental Officer',

        'director' =>
            'Institute Director',

        'librarian' =>
            'Librarian',

        'finance_officer' =>
            'Finance Officer',

        'dean' =>
            'Dean of School',

        'university_store' =>
            'University Store',

        'registrar' =>
            'Academic Registrar',

        'admin' =>
            'System Administrator'
    ];

    return
        $labels[$role]
        ?? ucfirst(
            (string)$role
        );
}


/*ROLE TYPE HELPERS*/

function is_departmental_officer_role($role)
{
    return in_array(
        strtolower(
            trim(
                (string)$role
            )
        ),
        [
            'librarian',
            'finance_officer',
            'university_store'
        ],
        true
    );
}


function is_management_role($role)
{
    return in_array(
        strtolower(
            trim(
                (string)$role
            )
        ),
        [
            'director',
            'dean',
            'registrar',
            'admin'
        ],
        true
    );
}


function is_officer_role($role)
{
    return in_array(
        strtolower(
            trim(
                (string)$role
            )
        ),
        [
            'officer',
            'librarian',
            'finance_officer',
            'university_store'
        ],
        true
    );
}

?>