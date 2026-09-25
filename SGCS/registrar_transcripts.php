<?php
require_once __DIR__ . '/includes/auth.php';
require_role('registrar');
require_once __DIR__ . '/includes/clearance_functions.php';
$message = '';
$error = '';
$students = $pdo->query('SELECT student_id, registration_no, full_name FROM students ORDER BY full_name ASC')->fetchAll();
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    verify_csrf();
    $studentId = (int) ($_POST['student_id'] ?? 0);
    $file = $_FILES['transcript_file'] ?? null;
    if ($studentId <= 0) $error = 'Please select a student.';
    elseif (!$file || $file['error'] !== UPLOAD_ERR_OK || $file['size'] > 5 * 1024 * 1024) $error = 'Upload a transcript PDF smaller than 5 MB.';
    elseif ((new finfo(FILEINFO_MIME_TYPE))->file($file['tmp_name']) !== 'application/pdf') $error = 'Only validated PDF transcripts are accepted.';
    else {
        $request = $pdo->prepare('SELECT request_id FROM clearance_requests WHERE student_id=? ORDER BY request_id DESC LIMIT 1'); $request->execute([$studentId]); $requestId = $request->fetchColumn();
        $directory = __DIR__ . '/private_uploads/transcripts';
        if (!$requestId) $error = 'The student does not have a clearance request.';
        elseif (!is_dir($directory) && !mkdir($directory, 0700, true)) $error = 'Secure transcript storage is unavailable.';
        else {
            $storedName = bin2hex(random_bytes(18)) . '.pdf';
            if (!move_uploaded_file($file['tmp_name'], $directory . '/' . $storedName)) $error = 'Upload failed. Please try again.';
            else {
                $path = 'private_uploads/transcripts/' . $storedName;
                $stmt = $pdo->prepare("INSERT INTO transcripts (student_id, request_id, uploaded_by, filename, file_path, status) VALUES (?, ?, ?, ?, ?, 'Active')");
                $stmt->execute([$studentId, $requestId, $_SESSION['user_id'], basename($file['name']), $path]);
                $studentUserId = get_student_user_id($pdo, $studentId);
                if ($studentUserId) add_notification($pdo, $studentUserId, 'transcript_uploaded', 'Your transcript has been uploaded by the Academic Registrar.');
                log_audit($pdo, $_SESSION['user_id'], 'transcript_uploaded', 'Transcript uploaded for student #' . $studentId);
                $message = 'Transcript uploaded securely.';
            }
        }
    }
}
$transcripts = $pdo->query('SELECT t.*,s.registration_no,s.full_name,u.full_name uploaded_by_name FROM transcripts t JOIN students s ON s.student_id=t.student_id JOIN users u ON u.user_id=t.uploaded_by ORDER BY t.uploaded_at DESC')->fetchAll();
$page_title = 'Transcript Upload'; require_once __DIR__ . '/includes/header.php';
?>
<section class="dashboard"><div class="dashboard-top"><h1>Transcript Upload</h1><a href="<?php echo BASE_URL; ?>dashboard.php">Back to dashboard</a></div><div class="dashboard-box">
<?php if ($message): ?><div class="success"><?php echo htmlspecialchars($message); ?></div><?php endif; ?><?php if ($error): ?><div class="alert"><?php echo htmlspecialchars($error); ?></div><?php endif; ?>
<form method="post" enctype="multipart/form-data"><?php echo csrf_field(); ?><div class="form-group"><label for="student_id">Student</label><select id="student_id" name="student_id" required><option value="">Select student</option><?php foreach ($students as $student): ?><option value="<?php echo (int)$student['student_id']; ?>"><?php echo htmlspecialchars($student['full_name'].' - '.$student['registration_no']); ?></option><?php endforeach; ?></select></div><div class="form-group"><label for="transcript_file">Transcript PDF</label><input type="file" id="transcript_file" name="transcript_file" accept="application/pdf" required></div><button type="submit">Upload Transcript</button></form>
<h2>Uploaded Transcripts</h2><?php if ($transcripts): ?><table class="data-table"><thead><tr><th>Student</th><th>Reg No.</th><th>File</th><th>Uploaded By</th><th>Uploaded At</th></tr></thead><tbody><?php foreach ($transcripts as $transcript): ?><tr><td><?php echo htmlspecialchars($transcript['full_name']); ?></td><td><?php echo htmlspecialchars($transcript['registration_no']); ?></td><td><a href="<?php echo BASE_URL; ?>transcript_download.php?id=<?php echo (int)$transcript['transcript_id']; ?>" target="_blank">View authorized file</a></td><td><?php echo htmlspecialchars($transcript['uploaded_by_name']); ?></td><td><?php echo htmlspecialchars($transcript['uploaded_at']); ?></td></tr><?php endforeach; ?></tbody></table><?php else: ?><p>No transcripts uploaded yet.</p><?php endif; ?>
</div></section><?php require_once __DIR__ . '/includes/footer.php'; ?>
