<?php
require_once __DIR__ . '/includes/auth.php';
require_role('student');

header('Location: ' . BASE_URL . 'notifications.php');
exit;
?>
