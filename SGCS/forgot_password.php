<?php
require_once __DIR__ . '/config/database.php'; require_once __DIR__ . '/includes/auth.php'; require_once __DIR__ . '/includes/clearance_functions.php';
$error = ''; $success = '';
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    verify_csrf();
    $identity = clean_input($_POST['identity'] ?? ''); $email = clean_input($_POST['email'] ?? ''); $password = $_POST['password'] ?? ''; $confirmPassword = $_POST['confirm_password'] ?? '';
    if ($identity === '' || !is_valid_email($email) || strlen($password) < 8 || $confirmPassword === '') { $error = 'Enter your student number, registered email, and a new password of at least 8 characters.'; }
    elseif (!hash_equals($password, $confirmPassword)) { $error = 'New Password and Confirm Password must match.'; }
    else {
        $stmt = $pdo->prepare("SELECT u.user_id FROM users u INNER JOIN students s ON u.linked_id = s.student_id WHERE u.role = 'student' AND u.account_status = 'Active' AND u.deleted_at IS NULL AND s.registration_no = ? AND u.email = ? LIMIT 1");
        $stmt->execute([$identity, $email]); $user = $stmt->fetch();
        if (!$user) { $error = 'Your student number and email could not be verified.'; }
        else { $pdo->prepare('UPDATE users SET password_hash = ? WHERE user_id = ?')->execute([password_hash($password, PASSWORD_DEFAULT), $user['user_id']]); log_audit($pdo, $user['user_id'], 'password_reset', 'Student reset password after identity verification.'); $success = 'Password updated. You may now log in.'; }
    }
}
$page_title = 'Reset Password'; require_once __DIR__ . '/includes/header.php';
?><section class="login-page"><form class="login-box" method="post"><h1>Reset Password</h1><?php echo csrf_field(); ?><p>Verify your student number and registered email to set a new password.</p>
<?php if ($error): ?><div class="alert"><?php echo htmlspecialchars($error); ?></div><?php endif; ?><?php if ($success): ?><div class="success"><?php echo htmlspecialchars($success); ?></div><?php endif; ?>
<div class="form-group"><label>Student Number</label><input name="identity" required></div><div class="form-group"><label>Registered Email</label><input type="email" name="email" required></div><div class="form-group"><label>New Password</label><input type="password" name="password" minlength="8" required></div><div class="form-group"><label>Confirm Password</label><input type="password" name="confirm_password" minlength="8" required></div><button>Save New Password</button><p class="form-links"><a href="login.php">Back to login</a></p></form></section><?php require_once __DIR__ . '/includes/footer.php'; ?>

