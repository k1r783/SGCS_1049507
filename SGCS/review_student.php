<?php
require_once __DIR__ . '/includes/auth.php'; require_role([
    'officer',
    'librarian',
    'finance_officer',
    'university_store',
    'director',
    'registrar',
    'dean'
]);require_once __DIR__ . '/includes/clearance_functions.php';
$user=current_user(); $dept=get_assigned_department($pdo,$user); $request=$dept ? authorized_review_request($pdo,(int)($_GET['request_id']??0),$dept,$user) : null;
if(!$request){http_response_code(403);exit('Not authorized to view this student.');}
$q=$pdo->prepare('SELECT s.*,sc.school_name,i.institute_name,p.programme_name FROM students s LEFT JOIN schools sc ON sc.school_id=s.school_id LEFT JOIN institutes i ON i.institute_id=s.institute_id LEFT JOIN programmes p ON p.programme_id=s.programme_id WHERE s.student_id=?');$q->execute([$request['student_id']]);$student=$q->fetch();$documents=get_current_documents($pdo,$student['student_id']);$q=$pdo->prepare("SELECT transcript_id FROM transcripts WHERE student_id=? AND status='Active' ORDER BY uploaded_at DESC LIMIT 1");$q->execute([$student['student_id']]);$transcriptId=$q->fetchColumn();$page_title='Authorized Student Review';require_once __DIR__.'/includes/header.php';
?><section class="dashboard"><div class="dashboard-top"><h1>Authorized Student Review</h1><a href="officer_requests.php">Back to queue</a></div><div class="dashboard-box"><h2><?php echo htmlspecialchars($student['full_name']); ?></h2><p><strong>Registration number:</strong> <?php echo htmlspecialchars($student['registration_no']); ?></p><p><strong>School / Institute / Programme:</strong> <?php echo htmlspecialchars(($student['school_name']??'Not assigned').' / '.($student['institute_name']??'Not assigned').' / '.($student['programme_name']??$student['programme'])); ?></p><h2>Authorized records</h2><ul><?php foreach($documents as $document): if($user['role']==='officer' && strtolower(trim($dept['dept_name']))!=='library') continue; ?><li><?php echo htmlspecialchars(ucwords(str_replace('_',' ',$document['document_type']))); ?>: <a href="document_download.php?id=<?php echo (int)$document['document_id']; ?>">View securely</a></li><?php endforeach; ?><?php if($transcriptId && in_array($user['role'],['director','registrar'],true)): ?><li><a href="transcript_download.php?id=<?php echo (int)$transcriptId; ?>">View transcript securely</a></li><?php endif; ?></ul></div></section><?php require_once __DIR__.'/includes/footer.php'; ?>
