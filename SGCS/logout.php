<?php
require_once __DIR__ . '/includes/auth.php';
require_once __DIR__ . '/includes/clearance_functions.php';

if (is_logged_in()) {
    log_audit($pdo, $_SESSION['user_id'], 'logout', 'User logged out.');
}

$_SESSION = [];

if (ini_get('session.use_cookies')) {
    $params = session_get_cookie_params();
    setcookie(session_name(), '', time() - 42000, $params['path'], $params['domain'], $params['secure'], $params['httponly']);
}

session_destroy();
header('Location: ' . BASE_URL . 'login.php');
exit;
?>
