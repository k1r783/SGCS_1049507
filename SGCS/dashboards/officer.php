<?php
require_once __DIR__ . '/../includes/auth.php';
require_role([
    'officer',
    'librarian',
    'finance_officer',
    'university_store',
    'director',
    'registrar',
    'dean'
]);
require_once __DIR__ . '/../includes/clearance_functions.php';

$department = get_assigned_department($pdo, current_user());
$notifications = get_notifications($pdo, $_SESSION['user_id'], 4);

$dashboard_name = $department['dept_name'] ?? 'Department';
$dashboardRole = strtolower(trim((string)($_SESSION['role'] ?? '')));
$page_title = $dashboard_name . ' Dashboard';
require_once __DIR__ . '/../includes/header.php';
?>

<section class="dashboard">
    <div class="dashboard-top">
        <div>
            <h1><?php echo $dashboardRole === 'university_store' ? 'Lydia Chepkemoi Langat' : htmlspecialchars($dashboard_name) . ' Dashboard'; ?></h1>
            <p>Welcome, <?php echo $dashboardRole === 'university_store' ? 'Lydia Chepkemoi Langat' : htmlspecialchars($_SESSION['full_name']); ?>.</p>
        </div>
        <span class="badge"><?php echo role_label($_SESSION['role']); ?></span>
    </div>

    <div class="dashboard-box">
        <h2><?php echo htmlspecialchars($dashboard_name); ?> Clearance</h2>
        <p>Review only the clearance requests currently assigned to your department in the sequential workflow.</p>
        <div class="action-row">
            <a class="button" href="<?php echo BASE_URL; ?>officer_requests.php">Pending Requests</a>
            <a class="button secondary" href="<?php echo BASE_URL; ?>officer_history.php">Approval History</a>
            <?php
            $dashboardDeptName = strtolower(trim((string)($dashboard_name ?? '')));
            ?>
            <?php if ($dashboardRole === 'dean'): ?>
                <a class="button secondary" href="<?php echo BASE_URL; ?>reports_dashboard.php">School Reports</a>
            <?php elseif ($dashboardRole === 'librarian' || strpos($dashboardDeptName, 'library') !== false): ?>
                <a class="button secondary" href="<?php echo BASE_URL; ?>reports_dashboard.php">Reports</a>
            <?php elseif ($dashboardRole === 'finance_officer' || strpos($dashboardDeptName, 'finance') !== false): ?>
                <a class="button secondary" href="<?php echo BASE_URL; ?>finance_reports.php">Reports</a>
            <?php elseif ($dashboardRole === 'university_store' || strpos($dashboardDeptName, 'store') !== false): ?>
                <a class="button secondary" href="<?php echo BASE_URL; ?>university_store_reports.php">Reports</a>
            <?php endif; ?>
            <a class="button secondary" href="<?php echo BASE_URL; ?>notifications.php">Notifications</a>
        </div>

        <h2>Recent Notifications</h2>
        <?php if ($notifications): ?>
            <ul class="simple-list">
                <?php foreach ($notifications as $notification): ?>
                    <li><?php echo htmlspecialchars($notification['message']); ?></li>
                <?php endforeach; ?>
            </ul>
        <?php else: ?>
            <p>No notifications yet.</p>
        <?php endif; ?>
    </div>
</section>

<?php require_once __DIR__ . '/../includes/footer.php'; ?>
