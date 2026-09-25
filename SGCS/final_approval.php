<?php
require_once __DIR__ . '/includes/auth.php';
require_role('student');
require_once __DIR__ . '/includes/clearance_functions.php';

$student = get_student_by_user($pdo, current_user());
$request = $student ? get_latest_clearance_request($pdo, $student['student_id']) : null;
$approval = null;
if ($request && $request['overall_status'] === 'Final') {
    $stmt = $pdo->prepare('SELECT * FROM final_approvals WHERE request_id = ? LIMIT 1');
    $stmt->execute([$request['request_id']]);
    $approval = $stmt->fetch();
}
$page_title = 'Final Approval';
require_once __DIR__ . '/includes/header.php';
?>
<section class="dashboard">
    <div class="dashboard-top approval-toolbar">
        <h1>View Final Approval</h1>
        <a class="back-link" href="<?php echo BASE_URL; ?>dashboard.php">Back to dashboard</a>
    </div>

    <div class="dashboard-box final-approval-preview">
    <?php if (!$approval): ?>
        <p>Your Final Approval will be available after Academic Registrar approval.</p>
    <?php else: ?>
        <div class="approval-document">
            <div class="approval-message approval-message-top">
                <p><strong>Congratulations!</strong></p>
                <p>Tangaza University is pleased to inform you that you have successfully completed all the required graduation clearance procedures.</p>
                <p>You may now proceed with gown selection and make the necessary arrangements for the upcoming graduation ceremony. We commend you on this important academic achievement and wish you every success as you prepare to celebrate this milestone.</p>
            </div>

            <div class="approval-header">
                <h2>Tangaza University</h2>
                <p>Students Graduation Clearance System</p>
                <h3>FINAL APPROVAL</h3>
            </div>

            <div class="approval-details">
                <p><strong>Approval Number:</strong> <?php echo htmlspecialchars($approval['approval_number']); ?></p>
                <p><strong>Student Name:</strong> <?php echo htmlspecialchars(profile_display_name($student)); ?></p>
                <p><strong>Registration Number:</strong> <?php echo htmlspecialchars($student['registration_no']); ?></p>
                <p><strong>Programme:</strong> <?php echo htmlspecialchars(academic_display_label($student['programme'])); ?></p>
                <p><strong>Issue Date:</strong> <?php echo htmlspecialchars($approval['generated_at']); ?></p>
                <p><strong>Approved By:</strong> Academic Registrar</p>
            </div>

            <div class="approval-signoff">
                <p><strong>Academic Registrar</strong></p>
                <p>Final Approval Authority</p>
            </div>
        </div>
    <?php endif; ?>
    </div>

    <?php if ($approval): ?>
        <div class="approval-actions approval-actions-bottom">
            <a class="button approval-small-button" href="<?php echo BASE_URL; ?>final_approval_pdf.php">Save as PDF</a>
        </div>
    <?php endif; ?>
</section>
<?php require_once __DIR__ . '/includes/footer.php'; ?>
