<?php
require_once __DIR__ . '/../includes/auth.php';
require_role('admin');
$page_title = 'Admin Dashboard';
require_once __DIR__ . '/../includes/header.php';
?>

<section class="dashboard">
    <div class="dashboard-top">
        <div>
            <h1>Admin Dashboard</h1>
            <p>Welcome, <?php echo htmlspecialchars($_SESSION['full_name']); ?>.</p>
        </div>
        <span class="badge"><?php echo role_label($_SESSION['role']); ?></span>
    </div>

    <div class="dashboard-box">
        <h2>System Administration</h2>
        <p>Manage user accounts, roles, departments, students and system activity.</p>
        <div class="action-row">
            <a class="button" href="<?php echo BASE_URL; ?>admin_users.php">Manage Users</a><a class="button" href="<?php echo BASE_URL; ?>admin_students.php">Student Management</a><a class="button" href="<?php echo BASE_URL; ?>admin_academic.php">Academic Structure</a><a class="button" href="<?php echo BASE_URL; ?>admin_graduation_sets.php">Graduation Setup</a>
            <a class="button" href="<?php echo BASE_URL; ?>reports_dashboard.php">Reports</a>
            <a class="button secondary" href="<?php echo BASE_URL; ?>audit_trail.php">Audit Trail</a>
            <a class="button secondary" href="<?php echo BASE_URL; ?>notifications.php">Notifications</a>
        </div>
    </div>
</section>

<?php require_once __DIR__ . '/../includes/footer.php'; ?>
