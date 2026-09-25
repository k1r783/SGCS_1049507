<?php
require_once __DIR__ . '/includes/auth.php';
require_login();

$role = $_SESSION['role'];

if ($role === 'student') {
    require __DIR__ . '/dashboards/student.php';
} elseif (in_array($role, [
    'officer',
    'librarian',
    'finance_officer',
    'university_store',
    'dean'
], true)) {
    require __DIR__ . '/dashboards/officer.php';
} elseif ($role === 'director') {
    require __DIR__ . '/dashboards/director.php';
} elseif ($role === 'registrar') {
    require __DIR__ . '/dashboards/registrar.php';
} elseif ($role === 'admin') {
    require __DIR__ . '/dashboards/admin.php';
} else {
    header('Location: ' . BASE_URL . 'logout.php');
    exit;
}
?>
