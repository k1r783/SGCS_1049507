<?php
require_once __DIR__ . '/../config/database.php';
require_once __DIR__ . '/auth.php';

$page_title = $page_title ?? APP_SHORT_NAME;
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?php echo htmlspecialchars($page_title); ?> - <?php echo APP_SHORT_NAME; ?></title>
    <link rel="stylesheet" href="<?php echo BASE_URL; ?>assets/css/style.css">
    <script defer src="<?php echo BASE_URL; ?>assets/js/academic-dropdowns.js"></script>
</head>
<body>
    <header class="site-header">
        <a class="brand" href="<?php echo BASE_URL; ?>index.php">
            <span class="brand-mark">SG</span>
            <span>
                <strong><?php echo APP_SHORT_NAME; ?></strong>
                <small>Tangaza University</small>
            </span>
        </a>
        <nav class="nav-links">
            <a href="<?php echo BASE_URL; ?>index.php">Home</a>
            <?php if (is_logged_in()): ?>
                <a href="<?php echo BASE_URL; ?>dashboard.php">Dashboard</a>
                <?php
                $headerUnread = 0;
                try {
                    $headerStmt = $pdo->prepare('SELECT COUNT(*) FROM notifications WHERE recipient_user_id = ? AND is_read = 0');
                    $headerStmt->execute([(int)($_SESSION['user_id'] ?? 0)]);
                    $headerUnread = (int)$headerStmt->fetchColumn();
                } catch (Throwable $e) {
                    $headerUnread = 0;
                }
                ?>
                <a href="<?php echo BASE_URL; ?>notifications.php">Notifications<?php if ($headerUnread > 0): ?> <span class="notification-badge"><?php echo $headerUnread > 99 ? '99+' : $headerUnread; ?></span><?php endif; ?></a>
                <a class="button small" href="<?php echo BASE_URL; ?>logout.php">Logout</a>
            <?php else: ?>
                <a class="button small" href="<?php echo BASE_URL; ?>login.php">Login</a>
                
            <?php endif; ?>
        </nav>
    </header>
    <main>

