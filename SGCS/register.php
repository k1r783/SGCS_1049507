<?php
require_once __DIR__ . '/config/database.php';
require_once __DIR__ . '/includes/auth.php';

$page_title = 'Student Accounts';
require_once __DIR__ . '/includes/header.php';
?>
<section class="login-page"><div class="login-box"><h1>Student Accounts</h1><p>Student accounts are created only by the System Administrator.</p><p class="form-links"><a href="login.php">Back to login</a></p></div></section>
<?php require_once __DIR__ . '/includes/footer.php'; ?>