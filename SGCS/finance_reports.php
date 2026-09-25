<?php
require_once __DIR__ . '/includes/auth.php';
require_once __DIR__ . '/includes/clearance_functions.php';

require_login();

$user = current_user();
$role = strtolower(trim((string)($user['role'] ?? '')));
$department = get_assigned_department($pdo, $user);
$departmentName = strtolower(trim((string)($department['dept_name'] ?? '')));

if ($role !== 'finance_officer' && $departmentName !== 'finance office') {
    http_response_code(403);
    exit('Not authorized.');
}

require __DIR__ . '/reports_dashboard.php';
