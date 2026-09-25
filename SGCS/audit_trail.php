<?php
require_once __DIR__ . '/includes/auth.php';
require_role(['registrar', 'admin']);
require_once __DIR__ . '/includes/clearance_functions.php';

$logs = get_recent_audit_logs($pdo, 100);

$page_title = 'Audit Trail';
require_once __DIR__ . '/includes/header.php';
?>

<section class="dashboard">
    <div class="dashboard-top">
        <h1>Audit Trail</h1>
        <a href="<?php echo BASE_URL; ?>dashboard.php">Back to dashboard</a>
    </div>

    <div class="dashboard-box">
        <?php if ($logs): ?>
            <table class="data-table">
                <thead>
                    <tr>
                        <th>Date</th>
                        <th>User</th>
                        <th>Role</th>
                        <th>Action</th>
                        <th>Details</th>
                    </tr>
                </thead>
                <tbody>
                    <?php foreach ($logs as $log): ?>
                        <tr>
                            <td><?php echo htmlspecialchars($log['created_at']); ?></td>
                            <td><?php echo htmlspecialchars($log['full_name'] ?? 'System'); ?></td>
                            <td><?php echo htmlspecialchars($log['role'] ?? '-'); ?></td>
                            <td><?php echo htmlspecialchars($log['action']); ?></td>
                            <td><?php echo htmlspecialchars($log['details'] ?? ''); ?></td>
                        </tr>
                    <?php endforeach; ?>
                </tbody>
            </table>
        <?php else: ?>
            <p>No audit log entries yet.</p>
        <?php endif; ?>
    </div>
</section>

<?php require_once __DIR__ . '/includes/footer.php'; ?>

