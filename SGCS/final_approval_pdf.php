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
if (!$student || !$approval) {
    http_response_code(404);
    exit('Final approval is not available.');
}

function pdf_text($text) {
    $text = trim((string)$text);
    $text = iconv('UTF-8', 'Windows-1252//TRANSLIT//IGNORE', $text);
    $text = str_replace('\\', '\\\\', $text);
    $text = str_replace('(', '\\(', $text);
    $text = str_replace(')', '\\)', $text);
    return $text;
}
function pdf_wrap($text, $maxChars = 92) {
    $words = preg_split('/\s+/', trim((string)$text));
    $lines = [];
    $line = '';
    foreach ($words as $word) {
        if ($line === '') { $line = $word; continue; }
        if (strlen($line . ' ' . $word) <= $maxChars) { $line .= ' ' . $word; }
        else { $lines[] = $line; $line = $word; }
    }
    if ($line !== '') $lines[] = $line;
    return $lines ?: [''];
}

$name = profile_display_name($student);
$programme = academic_display_label($student['programme']);
$approvalNo = $approval['approval_number'];
$regNo = $student['registration_no'];
$issueDate = $approval['generated_at'];

$lines = [];
$addCentered = function($text, $size = 12, $bold = false, $gap = 18) use (&$lines) {
    $lines[] = ['text' => $text, 'size' => $size, 'bold' => $bold, 'gap' => $gap];
};
$addCentered('Congratulations!', 11, true, 14);
foreach (pdf_wrap('Tangaza University is pleased to inform you that you have successfully completed all the required graduation clearance procedures.', 48) as $i => $line) {
    $addCentered($line, 7.2, false, 9);
}
$lines[] = ['spacer' => true, 'gap' => 3];
foreach (pdf_wrap('You may now proceed with gown selection and make the necessary arrangements for the upcoming graduation ceremony. We commend you on this important academic achievement and wish you every success as you prepare to celebrate this milestone.', 48) as $line) {
    $addCentered($line, 7.2, false, 9);
}
$lines[] = ['spacer' => true, 'gap' => 3];
$addCentered('Tangaza University', 13, true, 13);
$addCentered('Students Graduation Clearance System', 7.5, false, 12);
$addCentered('FINAL APPROVAL', 10.5, true, 13);
$addCentered('Approval Number: ' . $approvalNo, 7.5, true, 10);
$addCentered('Student Name: ' . $name, 7.5, true, 10);
$addCentered('Registration Number: ' . $regNo, 7.5, true, 10);
$addCentered('Programme: ' . $programme, 7.5, true, 10);
$addCentered('Issue Date: ' . $issueDate, 7.5, true, 10);
$addCentered('Approved By: Academic Registrar', 7.5, true, 13);
$addCentered('Academic Registrar', 8, true, 10);
$addCentered('Final Approval Authority', 7.5, false, 0);

$pageW = 297.64; $pageH = 419.53;
$commands = [];
$y = 398;
foreach ($lines as $item) {
    $gap = $item['gap'] ?? 14;
    if (!empty($item['spacer'])) { $y -= $gap; continue; }
    $text = pdf_text($item['text']);
    $size = $item['size'];
    $font = $item['bold'] ? 'F2' : 'F1';
    $approxWidth = strlen($text) * $size * 0.48;
    $x = max(18, ($pageW - $approxWidth) / 2);
    $commands[] = sprintf('BT /%s %.1f Tf 0 g %.2f %.2f Td (%s) Tj ET', $font, $size, $x, $y, $text);
    $y -= $gap;
}

// A clean gold top rule and subtle border around the certificate/card only.
$commands[] = '0.78 0.63 0.15 RG 1.2 w 18 401 m 280 401 l S';
$commands[] = '0.82 0.82 0.82 RG 0.5 w 18 18 262 383 re S';
$stream = implode("\n", $commands);

$objects = [];
$objects[] = '<< /Type /Catalog /Pages 2 0 R >>';
$objects[] = '<< /Type /Pages /Kids [3 0 R] /Count 1 >>';
$objects[] = '<< /Type /Page /Parent 2 0 R /MediaBox [0 0 297.64 419.53] /Resources << /Font << /F1 5 0 R /F2 6 0 R >> >> /Contents 4 0 R >>';
$objects[] = '<< /Length ' . strlen($stream) . " >>\nstream\n" . $stream . "\nendstream";
$objects[] = '<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica /Encoding /WinAnsiEncoding >>';
$objects[] = '<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica-Bold /Encoding /WinAnsiEncoding >>';

$pdf = "%PDF-1.4\n%\xE2\xE3\xCF\xD3\n";
$offsets = [0];
foreach ($objects as $i => $obj) {
    $offsets[$i + 1] = strlen($pdf);
    $pdf .= ($i + 1) . " 0 obj\n" . $obj . "\nendobj\n";
}
$xref = strlen($pdf);
$pdf .= "xref\n0 " . (count($objects) + 1) . "\n0000000000 65535 f \n";
for ($i = 1; $i <= count($objects); $i++) $pdf .= sprintf("%010d 00000 n \n", $offsets[$i]);
$pdf .= "trailer\n<< /Size " . (count($objects) + 1) . " /Root 1 0 R >>\nstartxref\n" . $xref . "\n%%EOF";

header('Content-Type: application/pdf');
header('Content-Disposition: attachment; filename="final-approval-' . preg_replace('/[^A-Za-z0-9_-]/', '-', $regNo) . '.pdf"');
header('Content-Length: ' . strlen($pdf));
echo $pdf;
