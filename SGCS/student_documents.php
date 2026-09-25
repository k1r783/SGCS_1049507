<?php
require_once __DIR__ . '/includes/auth.php';
require_role('student');
require_once __DIR__ . '/includes/clearance_functions.php';

$student = get_student_by_user($pdo, current_user());
$message = ''; $error = '';
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    verify_csrf();
    $result = save_document($pdo, $student, clean_input($_POST['document_type'] ?? ''), $_FILES['document'] ?? null);
    if ($result === 'Document uploaded successfully.') { $message = $result; } else { $error = $result; }
}
$documents = get_current_documents($pdo, $student['student_id']);
$page_title = 'Student Documents';
require_once __DIR__ . '/includes/header.php';
?>
<section class="dashboard"><div class="dashboard-top"><h1>Required Documents</h1><a href="student_profile.php">Back to profile</a></div><div class="dashboard-box">
<?php if ($message): ?><div class="success"><?php echo htmlspecialchars($message); ?></div><?php endif; ?><?php if ($error): ?><div class="alert"><?php echo htmlspecialchars($error); ?></div><?php endif; ?>
<form method="post" enctype="multipart/form-data"><?php echo csrf_field(); ?><div class="form-group"><label>Document</label><select name="document_type"><option value="id_passport">National ID / Passport</option><option value="final_year_project">Final Year Project</option></select></div><div class="form-group"><label>Validated PDF, maximum 5 MB</label><input type="file" name="document" accept="application/pdf" required></div><button>Upload / replace</button></form>
<p>Replacing a pending or rejected file preserves its history. Approved files are not silently replaced.</p>
<?php foreach ($documents as $document): ?><p><?php echo htmlspecialchars(ucwords(str_replace('_', ' ', $document['document_type']))); ?>: <a href="document_download.php?id=<?php echo (int) $document['document_id']; ?>">View securely</a></p><?php endforeach; ?>
</div></section><?php require_once __DIR__ . '/includes/footer.php'; ?>

