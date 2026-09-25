<?php
require_once __DIR__ . '/includes/auth.php';
require_login();
require_once __DIR__ . '/includes/clearance_functions.php';
$id = (int) ($_GET['id'] ?? 0);
$stmt = $pdo->prepare("SELECT t.*,s.institute_id FROM transcripts t JOIN students s ON s.student_id=t.student_id WHERE t.transcript_id=? AND t.status='Active' LIMIT 1");
$stmt->execute([$id]); $transcript = $stmt->fetch();
if (!$transcript) { http_response_code(404); exit('Transcript not found.'); }
$user = current_user(); $allowed = false;
if ($user['role'] === 'student') $allowed = (int)$user['linked_id'] === (int)$transcript['student_id'];
elseif (in_array($user['role'], ['admin','registrar'], true)) $allowed = true;
elseif ($user['role'] === 'director') $allowed = (int)get_user_institute_id($pdo,$user['user_id']) === (int)$transcript['institute_id'];
if (!$allowed) { http_response_code(403); exit('Not authorized.'); }
$path = __DIR__ . '/' . ltrim($transcript['file_path'], '/\\');
if (!is_file($path)) { http_response_code(404); exit('Transcript file unavailable.'); }
header('Content-Type: application/pdf'); header('Content-Length: ' . filesize($path)); header('Content-Disposition: inline; filename="transcript.pdf"'); header('X-Content-Type-Options: nosniff'); readfile($path); exit;
