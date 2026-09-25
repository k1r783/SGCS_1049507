<?php
require_once __DIR__ . '/../includes/auth.php';
require_role('director');
require_once __DIR__ . '/../includes/clearance_functions.php';
$directorUser = current_user();
$department = get_assigned_department($pdo, $directorUser);
$directorInstituteId = get_user_institute_id($pdo, $directorUser['user_id']);
$instituteStmt = $pdo->prepare('SELECT institute_name FROM institutes WHERE institute_id=?');
$instituteStmt->execute([$directorInstituteId]);
$directorInstituteName = $instituteStmt->fetchColumn() ?: 'Unassigned Institute';
$directorCounts = $department ? get_review_counts($pdo, $department, $directorUser) : ['Pending'=>0,'Rejected'=>0,'Approved'=>0];
$notifications = get_notifications($pdo, $_SESSION['user_id'], 4);
$page_title = 'Institute Director Dashboard';
require_once __DIR__ . '/../includes/header.php';
?>

<section class="dashboard">
    <div class="dashboard-top">
        <div>
            <h1>Institute Director Dashboard</h1>
            <p>Welcome, <?php echo htmlspecialchars($_SESSION['full_name']); ?>.</p>
        </div>
        <span class="badge"><?php echo role_label($_SESSION['role']); ?></span>
    </div>

    <div class="dashboard-box">
        <h2>Institute Director Clearance Review</h2>
        <p>The Institute Director is the first approval stage in the Tangaza University graduation clearance workflow.</p>
        <div class="action-row">
            <a class="button" href="<?php echo BASE_URL; ?>officer_requests.php">Pending Requests</a>
            <a class="button secondary" href="<?php echo BASE_URL; ?>officer_history.php">Approval History</a>
            <a class="button secondary" href="<?php echo BASE_URL; ?>reports_dashboard.php">Department Reports</a>
            <a class="button secondary" href="<?php echo BASE_URL; ?>notifications.php">Notifications</a>
        </div>

        <h2>Institute-Scoped Queue</h2>
        <p><strong>Assigned institute:</strong> <?php echo htmlspecialchars($directorInstituteName); ?></p>
        <p>You can review only clearance requests belonging to students assigned to this institute.</p>
        <div class="summary-row">
            <div class="status-pending"><strong>Pending</strong><span><?php echo (int)$directorCounts['Pending']; ?></span></div>
            <div class="status-rejected"><strong>Rejected</strong><span><?php echo (int)$directorCounts['Rejected']; ?></span></div>
            <div class="status-approved"><strong>Approved</strong><span><?php echo (int)$directorCounts['Approved']; ?></span></div>
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
