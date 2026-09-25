<?php
require_once __DIR__ . '/includes/auth.php';
require_role([
    'officer',
    'librarian',
    'finance_officer',
    'university_store',
    'director',
    'registrar',
    'dean'
]);
require_once __DIR__ . '/includes/clearance_functions.php';

$user = current_user();
$department = get_assigned_department($pdo, $user);
$history = [];

if ($department) {
    $sql = "SELECT ar.*, s.registration_no, s.full_name, cr.overall_status
            FROM approval_records ar
            INNER JOIN clearance_requests cr ON ar.request_id = cr.request_id
            INNER JOIN students s ON cr.student_id = s.student_id
            WHERE ar.dept_id = ? AND ar.status <> 'Pending'";
    $params = [(int)$department['dept_id']];

    if (($user['role'] ?? '') === 'director') {
        $instituteId = get_user_institute_id($pdo, $user['user_id']);
        if (!$instituteId) { $history = []; } else {
            $sql .= ' AND s.institute_id = ?'; $params[] = (int)$instituteId;
        }
    } elseif (($user['role'] ?? '') === 'dean') {
        $schoolId = get_user_school_id($pdo, $user['user_id']);
        if (!$schoolId) { $history = []; } else {
            $sql .= ' AND s.school_id = ?'; $params[] = (int)$schoolId;
        }
    }

    if (!(($user['role'] ?? '') === 'director' && !isset($instituteId)) && !(($user['role'] ?? '') === 'dean' && !isset($schoolId))) {
        $sql .= ' ORDER BY ar.decided_at DESC';
        $stmt = $pdo->prepare($sql);
        $stmt->execute($params);
        $history = $stmt->fetchAll();
    }
}

$page_title = 'Approval History';
require_once __DIR__ . '/includes/header.php';
?>
<section class="dashboard">
    <div class="dashboard-top"><h1>Approval History</h1><a href="<?php echo BASE_URL; ?>dashboard.php">Back to dashboard</a></div>
    <div class="dashboard-box">
        <p><strong>Assigned department:</strong> <?php echo htmlspecialchars($department['dept_name'] ?? 'None'); ?></p>
        <?php if (($user['role'] ?? '') === 'dean'): ?><p><strong>Scope:</strong> Only students in your assigned school.</p><?php endif; ?>
        <?php if (!$history): ?><p>No approval history yet.</p><?php else: ?>
        <table class="data-table"><thead><tr><th>Student</th><th>Reg No.</th><th>Decision</th><th>Comments</th><th>Overall Status</th><th>Date</th></tr></thead><tbody>
        <?php foreach ($history as $row): ?><tr><td><?php echo htmlspecialchars($row['full_name']); ?></td><td><?php echo htmlspecialchars($row['registration_no']); ?></td><td><?php echo htmlspecialchars($row['status']); ?></td><td><?php echo htmlspecialchars($row['comments'] ?? '-'); ?></td><td><?php echo htmlspecialchars($row['overall_status']); ?></td><td><?php echo htmlspecialchars($row['decided_at']); ?></td></tr><?php endforeach; ?>
        </tbody></table><?php endif; ?>
    </div>
</section>
<?php require_once __DIR__ . '/includes/footer.php'; ?>
