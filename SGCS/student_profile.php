<?php

require_once __DIR__ . '/includes/auth.php';
require_role('student');

require_once __DIR__ . '/includes/clearance_functions.php';


/* Load Student*/

$student = get_student_by_user(
    $pdo,
    current_user()
);

if (!$student) {
    die('Student profile could not be found.');
}

$graduationSession = get_graduation_session_status($pdo, $student);

$message = '';
$error = '';

$step = (int) ($_GET['step'] ?? $_POST['step'] ?? 1);
if ($step < 1 || $step > 6) {
    $step = 1;
}


/* Handle Form Submissions*/

if ($_SERVER['REQUEST_METHOD'] === 'POST') {

    verify_csrf();


    /*SAVE PERSONAL PROFILE*/

    if (isset($_POST['save_profile'])) {

        $first = clean_message(
            $_POST['first_name'] ?? '',
            60
        );

        $middle = clean_message(
            $_POST['middle_name'] ?? '',
            60
        );

        $last = clean_message(
            $_POST['last_name'] ?? '',
            60
        );

        $email = clean_input(
            $_POST['email'] ?? ''
        );

        $countryCode = clean_input(
            $_POST['country_code'] ?? '+254'
        );

        $phone = normalize_phone_number(
            $countryCode,
            $_POST['phone'] ?? ''
        );


        if (!$first || !$last) {

            $error =
                'First name and last name are required.';

        } elseif (!is_valid_email($email)) {

            $error =
                'Please enter a valid email address.';

        } elseif (!$phone) {

            $error =
                'Please enter a valid phone number.';

        } elseif (
            value_exists(
                $pdo,
                'students',
                'email',
                $email,
                $student['student_id'],
                'student_id'
            )
        ) {

            $error =
                'That email address is already in use.';

        } elseif (
            value_exists(
                $pdo,
                'users',
                'email',
                $email,
                $_SESSION['user_id'],
                'user_id'
            )
        ) {

            $error =
                'That email address is already in use.';

        } elseif (
            value_exists(
                $pdo,
                'students',
                'phone',
                $phone,
                $student['student_id'],
                'student_id'
            )
        ) {

            $error =
                'That phone number is already in use.';

        } else {

            try {

                $pdo->beginTransaction();


                $fullName = trim(
                    $first . ' ' .
                    $middle . ' ' .
                    $last
                );


                /* Update Student*/

                $stmt = $pdo->prepare(
                    'UPDATE students
                     SET
                        first_name = ?,
                        middle_name = ?,
                        last_name = ?,
                        full_name = ?,
                        email = ?,
                        phone = ?
                     WHERE student_id = ?'
                );

                $stmt->execute([
                    $first,
                    $middle ?: null,
                    $last,
                    $fullName,
                    $email,
                    $phone,
                    $student['student_id']
                ]);


                /*Update Login Account*/

                $stmt = $pdo->prepare(
                    'UPDATE users
                     SET
                        full_name = ?,
                        email = ?
                     WHERE user_id = ?'
                );

                $stmt->execute([
                    $fullName,
                    $email,
                    $_SESSION['user_id']
                ]);


                $pdo->commit();


                $message =
                    'Profile updated successfully.';


            } catch (Exception $e) {

                if ($pdo->inTransaction()) {
                    $pdo->rollBack();
                }

                $error =
                    'Profile could not be updated.';
            }
        }
    }


    
    if (isset($_POST['upload_document'])) {
        $result = save_document(
            $pdo,
            $student,
            clean_input($_POST['document_type'] ?? ''),
            $_FILES['document'] ?? null
        );

        if ($result === 'Document uploaded successfully.') {
            $message = $result;
        } else {
            $error = $result;
        }
    }

    /*Confirm Application review*/

    if (isset($_POST['confirm_review'])) {
        if (!isset($_POST['review_confirmed'])) {
            $error = 'Please confirm that you have reviewed your details.';
        } else {
            $_SESSION['student_application_review_confirmed'] = (int) $student['student_id'];
            $message = 'Your details have been reviewed and confirmed.';
            $step = 6;
        }
    }

    
    if (isset($_POST['apply_graduation'])) {

        /* APPLY / RE-APPLY FOR GRADUATION*/

        $student = get_student_by_user(
            $pdo,
            current_user()
        );

        if ((int) ($_SESSION['student_application_review_confirmed'] ?? 0) !== (int) $student['student_id']) {
            $error = 'Please review and confirm your details before submitting your graduation application.';
            $step = 5;
        }

        $latestApplication = get_latest_clearance_request(
            $pdo,
            $student['student_id']
        );

        if ($graduationSession['status'] === 'not_started') {
            $error = 'Graduation application is not yet available. The current graduation session has not started.';
            $step = 6;
        } elseif ($graduationSession['status'] === 'expired') {
            $error = 'The graduation application session has expired. Please wait for the next graduation session.';
            $step = 6;
        } elseif ($graduationSession['status'] === 'unavailable') {
            $error = 'Graduation application is not currently available. Please wait for the next graduation session.';
            $step = 6;
        } elseif ($error) {
            // Keep the student on the review step until details are confirmed.
        } elseif (
            $latestApplication &&
            $latestApplication['overall_status'] === 'Final'
        ) {
            $error = 'Your clearance has already been completed. A new graduation application cannot be initiated.';
        } elseif (
            $latestApplication &&
            in_array(
                $latestApplication['overall_status'],
                ['Pending', 'In Progress', 'Approved'],
                true
            )
        ) {
            $error = 'You already have an active graduation application.';
        } else {
            $result = initiate_clearance(
                $pdo,
                $student,
                current_user()
            );

            if (!empty($result['error'])) {
                $error = $result['error'];
            } elseif ($latestApplication && $latestApplication['overall_status'] === 'Rejected') {
                unset($_SESSION['student_application_review_confirmed']);
                $message = 'Your new graduation application has been submitted successfully. Your previous rejected application has been kept in the system history.';
            } else {
                unset($_SESSION['student_application_review_confirmed']);
                $message = 'Your graduation application has been submitted successfully.';
            }
        }
    }

    

    if (isset($_POST['confirm_name'])) {

        $activeRequest =
            get_latest_clearance_request(
                $pdo,
                $student['student_id']
            );


        if (
            !empty(
                $student['certificate_name_confirmed_at']
            )
        ) {

            $error =
                'Your Final Approval name is already confirmed and locked.';

        } elseif (
            $activeRequest &&
            in_array(
                $activeRequest['overall_status'],
                [
                    'Pending',
                    'In Progress'
                ],
                true
            )
        ) {

            $error =
                'Your Final Approval name is locked while your graduation application is active.';

        } else {

            $order =
                $_POST['name_order'] ?? '';


            if (
                !in_array(
                    $order,
                    [
                        'first_middle_last',
                        'last_first_middle'
                    ],
                    true
                )
            ) {

                $error =
                    'Please select a valid name order.';

            } else {

                try {

                    $stmt = $pdo->prepare(
                        'UPDATE students
                         SET
                            certificate_name_order = ?,
                            certificate_name_confirmed_at = NOW()
                         WHERE student_id = ?'
                    );

                    $stmt->execute([
                        $order,
                        $student['student_id']
                    ]);


                    $message =
                        'Final Approval name confirmed and locked.';
                } catch (Exception $e) {

                    $error =
                        'Could not confirm Final Approval name.';
                }
            }
        }
    }
}




$student = get_student_by_user(
    $pdo,
    current_user()
);




$academicStmt = $pdo->prepare(
    'SELECT
        s.*,
        sc.school_name,
        i.institute_name,
        p.programme_name,
        ps.specialisation_name,
        gs.set_name

     FROM students s

     LEFT JOIN schools sc
        ON sc.school_id = s.school_id

     LEFT JOIN institutes i
        ON i.institute_id = s.institute_id

     LEFT JOIN programmes p
        ON p.programme_id = s.programme_id

     LEFT JOIN programme_specialisations ps
        ON ps.specialisation_id = s.specialisation_id

     LEFT JOIN graduation_sets gs
        ON gs.graduation_set_id = s.graduation_set_id

     WHERE s.student_id = ?'
);

$academicStmt->execute([
    $student['student_id']
]);

$academic = $academicStmt->fetch();


$currentGraduationSet = get_active_compatible_graduation_set($pdo, $student);




$documents = get_current_documents(
    $pdo,
    $student['student_id']
);



$missing =
    profile_completion_missing(
        $pdo,
        $student
    );




$latestApplication =
    get_latest_clearance_request(
        $pdo,
        $student['student_id']
);


/*Can Apply?*/

$canApply = false;

if (
    $graduationSession['status'] === 'available'
    && !$latestApplication
) {

    $canApply = true;

} elseif (
    $graduationSession['status'] === 'available'
    && $latestApplication['overall_status'] === 'Rejected'
) {

    $canApply = true;
}


/*Phone Formatting*/

$countryCode = '+254';

$localPhone =
    $student['phone'] ?? '';


if (
    preg_match(
        '/^(\+254|\+255|\+256|\+250|\+44|\+1)(\d+)$/',
        $localPhone,
        $matches
    )
) {

    $countryCode =
        $matches[1];

    $localPhone =
        $matches[2];
}


/*Page*/

$page_title = 'Student Profile';

require_once __DIR__ . '/includes/header.php';

?>


<style>
.readonly-field {
    background: #e9ecef !important;
    color: #6c757d !important;
    cursor: not-allowed;
}
.readonly-note {
    margin-top: 5px;
    display: block;
    color: #6c757d;
    font-size: 13px;
}
.profile-steps {
    display: flex;
    flex-wrap: wrap;
    gap: 8px;
    margin: 0 0 24px;
}
.profile-step {
    padding: 8px 12px;
    border: 1px solid #d7dce1;
    border-radius: 6px;
    background: #f5f6f7;
    color: #5f666d;
    font-size: 13px;
}
.profile-step.active {
    background: #ffffff;
    color: #222;
    border-color: #8b949e;
    font-weight: 600;
}
.profile-navigation {
    display: flex;
    justify-content: space-between;
    gap: 12px;
    margin-top: 24px;
}
.profile-navigation .right {
    margin-left: auto;
}
.preview-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
    gap: 12px;
}
.preview-item {
    padding: 12px;
    border: 1px solid #e1e5e8;
    border-radius: 6px;
    background: #fafafa;
}
.preview-item strong {
    display: block;
    margin-bottom: 4px;
}
</style>

<section class="dashboard">
    <div class="dashboard-top">
        <h1>Student Profile</h1>
        <a href="dashboard.php">Back to dashboard</a>
    </div>

    <div class="dashboard-box">
        <?php if ($message): ?><div class="success"><?= htmlspecialchars($message) ?></div><?php endif; ?>
        <?php if ($error): ?><div class="alert"><?= htmlspecialchars($error) ?></div><?php endif; ?>

        <div class="profile-steps">
            <?php
            $stepLabels = [
                1 => 'Personal / Biodata',
                2 => 'Academic Information',
                3 => 'Required Documents',
                4 => 'Final Approval Name',
                5 => 'Preview & Confirmation',
                6 => 'Graduation Application'
            ];
            foreach ($stepLabels as $number => $label):
            ?>
                <span class="profile-step <?= $step === $number ? 'active' : '' ?>">
                    <?= $number ?>. <?= htmlspecialchars($label) ?>
                </span>
            <?php endforeach; ?>
        </div>

        <?php if ($step === 1): ?>
            <h2>Personal / Biodata</h2>
            <form method="post">
                <?= csrf_field() ?>
                <input type="hidden" name="save_profile" value="1">
                <input type="hidden" name="step" value="1">

                <div class="summary-row">
                    <div class="form-group"><label>First Name</label><input name="first_name" value="<?= htmlspecialchars($student['first_name'] ?? '') ?>" required></div>
                    <div class="form-group"><label>Middle Name</label><input name="middle_name" value="<?= htmlspecialchars($student['middle_name'] ?? '') ?>"></div>
                    <div class="form-group"><label>Last Name</label><input name="last_name" value="<?= htmlspecialchars($student['last_name'] ?? '') ?>" required></div>
                </div>

                <div class="form-group"><label>Registration Number</label><input value="<?= htmlspecialchars($student['registration_no']) ?>" readonly class="readonly-field"></div>
                <div class="form-group"><label>Email</label><input type="email" name="email" value="<?= htmlspecialchars($student['email']) ?>" required></div>

                <div class="summary-row">
                    <div class="form-group">
                        <label>Country Code</label>
                        <select name="country_code">
                            <?php foreach ([
                                '+254' => 'Kenya (+254)', '+255' => 'Tanzania (+255)', '+256' => 'Uganda (+256)',
                                '+250' => 'Rwanda (+250)', '+1' => 'United States/Canada (+1)', '+44' => 'United Kingdom (+44)'
                            ] as $code => $label): ?>
                                <option value="<?= $code ?>" <?= $countryCode === $code ? 'selected' : '' ?>><?= htmlspecialchars($label) ?></option>
                            <?php endforeach; ?>
                        </select>
                    </div>
                    <div class="form-group"><label>Phone</label><input name="phone" value="<?= htmlspecialchars($localPhone) ?>" required></div>
                </div>
                <button type="submit">Save Personal Information</button>
            </form>
            <div class="profile-navigation"><span></span><a class="button right" href="student_profile.php?step=2">Next →</a></div>

        <?php elseif ($step === 2): ?>
            <h2>Academic Information</h2>
            <p class="readonly-note">Your academic information is assigned and managed by the administrator.</p>
            <div class="summary-row">
                <div class="form-group"><label>School</label><input value="<?= htmlspecialchars($academic['school_name'] ?? 'Not assigned') ?>" readonly class="readonly-field"></div>
                <div class="form-group"><label>Institute / Centre</label><input value="<?= htmlspecialchars($academic['institute_name'] ?? 'Not assigned') ?>" readonly class="readonly-field"></div>
            </div>
            <div class="summary-row">
                <div class="form-group"><label>Programme</label><input value="<?= htmlspecialchars($academic['programme_name'] ?? 'Not assigned') ?>" readonly class="readonly-field"></div>
                <div class="form-group"><label>Specialisation</label><input value="<?= htmlspecialchars($academic['specialisation_name'] ?? 'None') ?>" readonly class="readonly-field"></div>
            </div>
            <div class="profile-navigation"><a class="button secondary" href="student_profile.php?step=1">← Previous</a><a class="button right" href="student_profile.php?step=3">Next →</a></div>

        <?php elseif ($step === 3): ?>
            <h2>Required Documents</h2>
            <table class="data-table">
                <thead><tr><th>Document</th><th>Status</th><th>Access</th></tr></thead>
                <tbody>
                <?php $requiredDocuments = ['id_passport' => 'National ID / Passport', 'final_year_project' => 'Final Year Project']; ?>
                <?php foreach ($requiredDocuments as $type => $label): $document = $documents[$type] ?? null; ?>
                    <tr>
                        <td><?= htmlspecialchars($label) ?></td>
                        <td class="<?= $document ? 'status-approved' : 'status-pending' ?>"><?= $document ? htmlspecialchars($document['status']) : 'Missing' ?></td>
                        <td><?php if ($document): ?><a href="document_download.php?id=<?= (int) $document['document_id'] ?>">View PDF</a><?php else: ?>—<?php endif; ?></td>
                    </tr>
                <?php endforeach; ?>
                </tbody>
            </table>

            <form method="post" enctype="multipart/form-data">
                <?= csrf_field() ?>
                <input type="hidden" name="step" value="3">
                <input type="hidden" name="upload_document" value="1">
                <div class="form-group"><label>Document</label><select name="document_type"><option value="id_passport">National ID / Passport</option><option value="final_year_project">Final Year Project</option></select></div>
                <div class="form-group"><label>Validated PDF, maximum 5 MB</label><input type="file" name="document" accept="application/pdf" required></div>
                <button type="submit">Upload / Replace</button>
            </form>
            <p class="readonly-note">Replacing a pending or rejected file preserves its history. Approved files are not silently replaced.</p>
            <div class="profile-navigation"><a class="button secondary" href="student_profile.php?step=2">← Previous</a><a class="button right" href="student_profile.php?step=4">Next →</a></div>

        <?php elseif ($step === 4): ?>
            <h2>Final Approval / Certificate Name</h2>
            <?php if (!empty($student['certificate_name_confirmed_at'])): ?>
                <p><strong>Confirmed Name:</strong> <?= htmlspecialchars(profile_display_name($student)) ?></p>
                <p><strong>Confirmed On:</strong> <?= htmlspecialchars($student['certificate_name_confirmed_at']) ?></p>
            <?php else: ?>
                <form method="post">
                    <?= csrf_field() ?>
                    <input type="hidden" name="step" value="4">
                    <h3>Final Approval Name Preview</h3>
                    <p>Review how your name will appear before confirming it.</p>
                    <label><input type="radio" name="name_order" value="first_middle_last" checked> <?= htmlspecialchars(profile_display_name($student, 'first_middle_last')) ?></label><br>
                    <label><input type="radio" name="name_order" value="last_first_middle"> <?= htmlspecialchars(profile_display_name($student, 'last_first_middle')) ?></label>
                    <p>Once confirmed, this name will be locked.</p>
                    <button type="submit" name="confirm_name" value="1">Confirm Final Approval Name</button>
                </form>
            <?php endif; ?>
            <div class="profile-navigation"><a class="button secondary" href="student_profile.php?step=3">← Previous</a><a class="button right" href="student_profile.php?step=5">Next →</a></div>

        <?php elseif ($step === 5): ?>
            <h2>Preview & Confirmation</h2>
            <p>Review the information below before proceeding to your graduation application.</p>

            <h3>Personal / Biodata</h3>
            <div class="preview-grid">
                <div class="preview-item"><strong>Name</strong><?= htmlspecialchars(trim(($student['first_name'] ?? '') . ' ' . ($student['middle_name'] ?? '') . ' ' . ($student['last_name'] ?? ''))) ?></div>
                <div class="preview-item"><strong>Registration Number</strong><?= htmlspecialchars($student['registration_no'] ?? '') ?></div>
                <div class="preview-item"><strong>Email</strong><?= htmlspecialchars($student['email'] ?? '') ?></div>
                <div class="preview-item"><strong>Phone</strong><?= htmlspecialchars($student['phone'] ?? '') ?></div>
            </div>

            <h3>Academic Information</h3>
            <div class="preview-grid">
                <div class="preview-item"><strong>School</strong><?= htmlspecialchars($academic['school_name'] ?? 'Not assigned') ?></div>
                <div class="preview-item"><strong>Institute / Centre</strong><?= htmlspecialchars($academic['institute_name'] ?? 'Not assigned') ?></div>
                <div class="preview-item"><strong>Programme</strong><?= htmlspecialchars($academic['programme_name'] ?? 'Not assigned') ?></div>
                <div class="preview-item"><strong>Specialisation</strong><?= htmlspecialchars($academic['specialisation_name'] ?? 'None') ?></div>
            </div>

            <h3>Required Documents</h3>
            <div class="preview-grid">
                <?php foreach (['id_passport' => 'National ID / Passport', 'final_year_project' => 'Final Year Project'] as $type => $label): $document = $documents[$type] ?? null; ?>
                    <div class="preview-item"><strong><?= htmlspecialchars($label) ?></strong><?= $document ? htmlspecialchars($document['status']) : 'Missing' ?></div>
                <?php endforeach; ?>
            </div>

            <h3>Final Approval / Certificate Name</h3>
            <div class="preview-item">
                <?= !empty($student['certificate_name_confirmed_at']) ? htmlspecialchars(profile_display_name($student)) : 'Not yet confirmed' ?>
            </div>

            <form method="post" style="margin-top:20px;">
                <?= csrf_field() ?>
                <input type="hidden" name="step" value="5">
                <label style="display:inline-flex; align-items:center; gap:8px; width:auto; white-space:nowrap; margin-bottom:6px;"><input type="checkbox" name="review_confirmed" value="1" required style="width:auto; margin:0;"> I confirm that I have reviewed the details and documents shown above.</label>
                <p><button type="submit" name="confirm_review" value="1">Confirm & Continue</button></p>
            </form>
            <div class="profile-navigation"><a class="button secondary" href="student_profile.php?step=4">← Previous</a></div>

        <?php elseif ($step === 6): ?>
            <h2>Graduation Application</h2>
            <p>This is the final step before the clearance process is initiated.</p>

            <?php if ($graduationSession['status'] === 'not_started'): ?>
                <div class="alert">Graduation application is not yet available. The current graduation session has not started.</div>
            <?php elseif ($graduationSession['status'] === 'expired'): ?>
                <div class="alert">The graduation application session has expired. Please wait for the next graduation session.</div>
            <?php elseif ($graduationSession['status'] === 'unavailable'): ?>
                <div class="alert">Graduation application is not currently available. Please wait for the next graduation session.</div>
            <?php endif; ?>

            <?php if ($latestApplication): ?>
                <p><strong>Latest Application Status:</strong> <span class="<?= $latestApplication['overall_status'] === 'Approved' ? 'status-approved' : 'status-pending' ?>"><?= htmlspecialchars($latestApplication['overall_status']) ?></span></p>
            <?php endif; ?>

            <?php if ($latestApplication && $latestApplication['overall_status'] === 'Rejected'): ?>
                <div class="alert">Your previous graduation application was rejected. You may correct any issues identified by the reviewing departments and submit a new application.</div>
            <?php endif; ?>

            <?php if ($canApply): ?>
                <?php if (!empty($missing)): ?>
                    <div class="alert">You must complete your profile and required documents before applying for graduation.</div>
                <?php endif; ?>

                <?php if ((int) ($_SESSION['student_application_review_confirmed'] ?? 0) !== (int) $student['student_id']): ?>
                    <div class="alert">Please complete the Preview & Confirmation step before submitting your graduation application.</div>
                    <p><a class="button secondary" href="student_profile.php?step=5">Review Details</a></p>
                <?php else: ?>
                    <form method="post">
                        <?= csrf_field() ?>
                        <input type="hidden" name="step" value="6">
                        <button type="submit" name="apply_graduation" value="1" <?= !empty($missing) ? 'disabled' : '' ?>><?= $latestApplication ? 'Re-Apply for Graduation' : 'Apply for Graduation' ?></button>
                    </form>
                <?php endif; ?>
            <?php elseif ($latestApplication && in_array($latestApplication['overall_status'], ['Pending', 'In Progress'], true)): ?>
                <p class="status-pending">You already have an active graduation application. Please wait for the clearance process to be completed.</p>
            <?php elseif ($latestApplication && $latestApplication['overall_status'] === 'Approved'): ?>
                <p class="status-approved">Your graduation application has already been approved.</p>
            <?php endif; ?>

            <div class="profile-navigation"><a class="button secondary" href="student_profile.php?step=5">← Previous</a></div>
        <?php endif; ?>
    </div>
</section>

<?php

require_once __DIR__ . '/includes/footer.php';

?>