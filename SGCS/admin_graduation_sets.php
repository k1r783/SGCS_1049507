<?php

require_once __DIR__ . '/includes/auth.php';
require_role('admin');

require_once __DIR__ . '/includes/clearance_functions.php';

$message = '';
$error = '';
$editSet = null;

$qualificationTypes = $pdo->query(
    'SELECT qualification_type_id, qualification_name FROM qualification_types WHERE is_active = 1 ORDER BY qualification_name'
)->fetchAll();


/*current page*/

$currentPage = $_SERVER['PHP_SELF'];


/*edit record*/

if (isset($_GET['edit']) && $_GET['edit'] !== '') {

    $editId = (int) $_GET['edit'];

    if ($editId > 0) {

        try {

            $stmt = $pdo->prepare(
                'SELECT *
                 FROM graduation_sets
                 WHERE graduation_set_id = ?'
            );

            $stmt->execute([$editId]);

            $editSet = $stmt->fetch();

            if (!$editSet) {
                $error = 'Graduation set not found.';
            } else {
                $stmt = $pdo->prepare('SELECT qualification_type_id FROM graduation_set_qualification_types WHERE graduation_set_id = ?');
                $stmt->execute([$editId]);
                $editSet['qualification_type_ids'] = array_map('intval', $stmt->fetchAll(PDO::FETCH_COLUMN));
            }

        } catch (Exception $e) {

            $error = $e->getMessage();

        }
    }
}


/*Handle post requests*/

if ($_SERVER['REQUEST_METHOD'] === 'POST') {

    try {

        $action = clean_input($_POST['action'] ?? '');

        $id = (int) ($_POST['graduation_set_id'] ?? 0);


       

        if ($action === 'create' || $action === 'update') {

            $name = clean_message(
                $_POST['set_name'] ?? '',
                100
            );

            $academicYear = clean_input(
                $_POST['academic_year'] ?? ''
            );

            $graduationYear = (int) (
                $_POST['graduation_year'] ?? 0
            );

            $start = clean_input(
                $_POST['starts_at'] ?? ''
            );

            $end = clean_input(
                $_POST['ends_at'] ?? ''
            );

            $qualificationTypeIds = array_values(array_unique(array_filter(array_map('intval', $_POST['qualification_type_ids'] ?? []))));

            foreach ($qualificationTypeIds as $qualificationTypeId) {
                $checkQualification = $pdo->prepare('SELECT 1 FROM qualification_types WHERE qualification_type_id = ? AND is_active = 1');
                $checkQualification->execute([$qualificationTypeId]);
                if (!$checkQualification->fetchColumn()) {
                    throw new Exception('An invalid qualification type was selected.');
                }
            }


            /*set name*/

            if ($name === '') {

                throw new Exception(
                    'Graduation set name is required.'
                );

            }


            
            if ($academicYear === '') {

                throw new Exception(
                    'Academic year is required.'
                );

            }


            if (!preg_match(
                '/^\d{4}-\d{4}$/',
                $academicYear
            )) {

                throw new Exception(
                    'Academic year must be in the format 2026-2027.'
                );

            }


            $academicYears = explode(
                '-',
                $academicYear
            );

            $firstYear = (int) $academicYears[0];
            $secondYear = (int) $academicYears[1];


            if ($secondYear !== $firstYear + 1) {

                throw new Exception(
                    'Academic year must use consecutive years; 2026-2027.'
                );

            }


           
            if (
                $graduationYear < 2000
                ||
                $graduationYear > 2100
            ) {

                throw new Exception(
                    'Please enter a valid graduation year.'
                );

            }


           

            if (
                $start !== ''
                &&
                $end !== ''
                &&
                $start > $end
            ) {

                throw new Exception(
                    'End date cannot be before the start date.'
                );

            }


            /*Create Graduation Set */

            if ($action === 'create') {

                $stmt = $pdo->prepare(
                    'INSERT INTO graduation_sets
                    (
                        set_name,
                        academic_year,
                        graduation_year,
                        is_active,
                        starts_at,
                        ends_at
                    )
                    VALUES (?, ?, ?, 0, ?, ?)'
                );


                $stmt->execute([
                    $name,
                    $academicYear,
                    $graduationYear,
                    $start ?: null,
                    $end ?: null
                ]);

                $newSetId = (int)$pdo->lastInsertId();
                if ($qualificationTypeIds) {
                    $map = $pdo->prepare('INSERT INTO graduation_set_qualification_types (graduation_set_id, qualification_type_id) VALUES (?, ?)');
                    foreach ($qualificationTypeIds as $qualificationTypeId) {
                        $map->execute([$newSetId, $qualificationTypeId]);
                    }
                }

                /* Optional audit log*/

                if (function_exists('log_audit')) {

                    log_audit(
                        $pdo,
                        $_SESSION['user_id'],
                        'graduation_set_created',
                        'Created graduation set: ' . $name
                    );

                }


                $message =
                    'Graduation set created successfully.';


                
                

                $editSet = null;

$qualificationTypes = $pdo->query(
    'SELECT qualification_type_id, qualification_name FROM qualification_types WHERE is_active = 1 ORDER BY qualification_name'
)->fetchAll();
            }




            elseif ($action === 'update') {

                if ($id <= 0) {

                    throw new Exception(
                        'Invalid graduation set.'
                    );

                }


                

                $check = $pdo->prepare(
                    'SELECT graduation_set_id
                     FROM graduation_sets
                     WHERE graduation_set_id = ?'
                );

                $check->execute([$id]);


                if (!$check->fetchColumn()) {

                    throw new Exception(
                        'Graduation set not found.'
                    );

                }


            

                $stmt = $pdo->prepare(
                    'UPDATE graduation_sets
                     SET
                        set_name = ?,
                        academic_year = ?,
                        graduation_year = ?,
                        starts_at = ?,
                        ends_at = ?
                     WHERE graduation_set_id = ?'
                );


                $stmt->execute([
                    $name,
                    $academicYear,
                    $graduationYear,
                    $start ?: null,
                    $end ?: null,
                    $id
                ]);

                $pdo->prepare('DELETE FROM graduation_set_qualification_types WHERE graduation_set_id = ?')->execute([$id]);
                if ($qualificationTypeIds) {
                    $map = $pdo->prepare('INSERT INTO graduation_set_qualification_types (graduation_set_id, qualification_type_id) VALUES (?, ?)');
                    foreach ($qualificationTypeIds as $qualificationTypeId) {
                        $map->execute([$id, $qualificationTypeId]);
                    }
                }

                
            

                if (function_exists('log_audit')) {

                    log_audit(
                        $pdo,
                        $_SESSION['user_id'],
                        'graduation_set_updated',
                        'Updated graduation set ID: ' . $id
                    );

                }


                $message =
                    'Graduation set updated successfully.';


                

                $editSet = null;

$qualificationTypes = $pdo->query(
    'SELECT qualification_type_id, qualification_name FROM qualification_types WHERE is_active = 1 ORDER BY qualification_name'
)->fetchAll();
            }
        }


        

        elseif ($action === 'toggle') {

            if ($id <= 0) {

                throw new Exception(
                    'Invalid graduation set.'
                );

            }


        

            $check = $pdo->prepare(
                'SELECT graduation_set_id
                 FROM graduation_sets
                 WHERE graduation_set_id = ?'
            );

            $check->execute([$id]);


            if (!$check->fetchColumn()) {

                throw new Exception(
                    'Graduation set not found.'
                );

            }


            $pdo->beginTransaction();


            
           
            $pdo->exec(
                'UPDATE graduation_sets
                 SET is_active = 0'
            );


           
            $stmt = $pdo->prepare(
                'UPDATE graduation_sets
                 SET is_active = 1
                 WHERE graduation_set_id = ?'
            );

            $stmt->execute([$id]);


            $pdo->commit();


            
            

            if (function_exists('log_audit')) {

                log_audit(
                    $pdo,
                    $_SESSION['user_id'],
                    'graduation_set_activated',
                    'Activated graduation set ID: ' . $id
                );

            }


            $message =
                'Graduation set activated successfully.';
        }


       /*invalid action*/

        else {

            throw new Exception(
                'Invalid action.'
            );

        }

    } catch (Exception $e) {

        if ($pdo->inTransaction()) {
            $pdo->rollBack();
        }

        $error = $e->getMessage();
    }
}



/* LOAD GRADUATION SET*/

try {

    $sets = $pdo->query(<<<SQL
SELECT
    gs.*,
    COUNT(cr.request_id) AS requests,
    (
        SELECT GROUP_CONCAT(
            qt.qualification_name
            ORDER BY qt.qualification_name
            SEPARATOR ', '
        )
        FROM graduation_set_qualification_types gsqt
        JOIN qualification_types qt
            ON qt.qualification_type_id = gsqt.qualification_type_id
        WHERE gsqt.graduation_set_id = gs.graduation_set_id
    ) AS eligible_qualifications
FROM graduation_sets gs
LEFT JOIN clearance_requests cr
    ON cr.graduation_set_id = gs.graduation_set_id
GROUP BY gs.graduation_set_id
ORDER BY
    gs.academic_year DESC,
    gs.graduation_year DESC,
    gs.set_name ASC
SQL
    )->fetchAll();

} catch (Exception $e) {

    $sets = [];

    if ($error === '') {
        $error = $e->getMessage();
    }
}


$page_title = 'Graduation Setup';

require_once __DIR__ . '/includes/header.php';

?>


<style>
/* Graduation set form layout */
.graduation-set-form {
    display: grid;
    grid-template-columns: repeat(3, minmax(220px, 1fr));
    gap: 18px;
    align-items: end;
    margin-bottom: 28px;
}
.graduation-set-form .form-group {
    margin-bottom: 0;
}
.graduation-set-form .qualifications-group {
    grid-column: 1 / -1;
}
.qualification-options {
    display: grid;
    grid-template-columns: repeat(3, minmax(180px, 1fr));
    gap: 12px 18px;
    padding: 14px 16px;
    border: 1px solid rgba(45,45,43,.16);
    border-radius: 8px;
    background: #fbfaf8;
}
.qualification-option,
.active-option {
    display: flex !important;
    align-items: center;
    gap: 10px;
    margin: 0 !important;
    font-weight: 600;
}
.qualification-option input,
.active-option input {
    width: auto;
    margin: 0;
}
.qualification-help {
    display: block;
    margin-top: 8px;
    color: var(--gray);
}
.graduation-set-form .form-actions {
    grid-column: 1 / -1;
    display: flex;
    align-items: center;
    justify-content: flex-end;
    gap: 12px;
    padding-top: 4px;
}
.graduation-set-form .form-actions button,
.graduation-set-form .form-actions .secondary-button {
    width: auto;
    min-width: 220px;
    text-align: center;
}
@media (max-width: 900px) {
    .graduation-set-form { grid-template-columns: repeat(2, minmax(0, 1fr)); }
    .qualification-options { grid-template-columns: repeat(2, minmax(0, 1fr)); }
}
@media (max-width: 600px) {
    .graduation-set-form { grid-template-columns: 1fr; }
    .qualification-options { grid-template-columns: 1fr; }
    .graduation-set-form .form-actions { align-items: stretch; flex-direction: column; }
    .graduation-set-form .form-actions button,
    .graduation-set-form .form-actions .secondary-button { width: 100%; }
}
</style>

<section class="dashboard">

    <div class="dashboard-top">

        <h1>Graduation Setup</h1>

        <a href="dashboard.php">
            Back to dashboard
        </a>

    </div>


    <div class="dashboard-box">


        <!-- SUCCESS MESSAGE -->

        <?php if ($message): ?>

            <div class="success">
                <?= htmlspecialchars($message) ?>
            </div>

        <?php endif; ?>


        <!-- ERROR MESSAGE -->

        <?php if ($error): ?>

            <div class="alert">
                <?= htmlspecialchars($error) ?>
            </div>

        <?php endif; ?>


        <!--CREATE FORM -->

        <?php if (!$editSet): ?>

            <h2>Create Graduation Set</h2>


            <form
                class="graduation-set-form"
                method="post"
                action="<?= htmlspecialchars($currentPage) ?>"
            >

                <input
                    type="hidden"
                    name="action"
                    value="create"
                >


                <!-- SET NAME -->

                <div class="form-group">

                    <label>Set Name</label>

                    <input
                        type="text"
                        name="set_name"
                        placeholder="Graduation"
                        required
                    >

                </div>


                <!-- ACADEMIC YEAR -->

                <div class="form-group">

                    <label>Academic Year</label>

                    <input
                        type="text"
                        name="academic_year"
                        placeholder="2026-2027"
                        pattern="\d{4}-\d{4}"
                        required
                    >

                </div>


                <!-- GRADUATION YEAR -->

                <div class="form-group">

                    <label>Graduation Year</label>

                    <input
                        type="number"
                        name="graduation_year"
                        min="2000"
                        max="2100"
                        placeholder="2027"
                        required
                    >

                </div>


                <!-- START DATE -->

                <div class="form-group">

                    <label>Clearance Start Date</label>

                    <input
                        type="datetime-local"
                        name="starts_at"
                    >

                </div>


                <!-- END DATE -->

                <div class="form-group">

                    <label>Clearance End Date</label>

                    <input
                        type="datetime-local"
                        name="ends_at"
                    >

                </div>

                <!-- ELIGIBLE QUALIFICATIONS -->
                <div class="form-group qualifications-group">
                    <label>Eligible Qualifications</label>
                    <div class="qualification-options">
                        <?php foreach ($qualificationTypes as $q): ?>
                            <label class="qualification-option">
                                <input type="checkbox" name="qualification_type_ids[]" value="<?= $q['qualification_type_id'] ?>">
                                <span><?= htmlspecialchars($q['qualification_name']) ?></span>
                            </label>
                        <?php endforeach; ?>
                    </div>
                    <small class="qualification-help">Leave all unchecked to allow every qualification type.</small>
                </div>

                <div class="form-group">
                    <label class="active-option">
                        <input type="checkbox" name="is_active" value="1">
                        <span>Set as active</span>
                    </label>
                </div>

                <div class="form-actions">
                    <button type="submit">Create Graduation Set</button>
                </div>

            </form>

        <?php endif; ?>


        <!--EDIT FORM -->

        <?php if ($editSet): ?>

            <div class="dashboard-top">

                <h2>Edit Graduation Set</h2>


                <a
                    href="<?= htmlspecialchars($currentPage) ?>"
                >
                    Cancel Editing
                </a>

            </div>


            <form
                class="graduation-set-form"
                method="post"
                action="<?= htmlspecialchars($currentPage) ?>"
            >

                <input
                    type="hidden"
                    name="action"
                    value="update"
                >


                <input
                    type="hidden"
                    name="graduation_set_id"
                    value="<?= $editSet['graduation_set_id'] ?>"
                >


                <!-- SET NAME -->

                <div class="form-group">

                    <label>Set Name</label>

                    <input
                        type="text"
                        name="set_name"
                        value="<?= htmlspecialchars($editSet['set_name']) ?>"
                        required
                    >

                </div>


                <!-- ACADEMIC YEAR -->

                <div class="form-group">

                    <label>Academic Year</label>

                    <input
                        type="text"
                        name="academic_year"
                        value="<?= htmlspecialchars($editSet['academic_year'] ?? '') ?>"
                        placeholder="2026-2027"
                        pattern="\d{4}-\d{4}"
                        required
                    >

                </div>


                <!-- GRADUATION YEAR -->

                <div class="form-group">

                    <label>Graduation Year</label>

                    <input
                        type="number"
                        name="graduation_year"
                        min="2000"
                        max="2100"
                        value="<?= htmlspecialchars($editSet['graduation_year']) ?>"
                        required
                    >

                </div>


                <!-- ELIGIBLE QUALIFICATIONS -->
                <div class="form-group qualifications-group">
                    <label>Eligible Qualifications</label>
                    <div class="qualification-options">
                        <?php foreach ($qualificationTypes as $q): ?>
                            <label class="qualification-option">
                                <input type="checkbox" name="qualification_type_ids[]" value="<?= $q['qualification_type_id'] ?>" <?= in_array((int)$q['qualification_type_id'], $editSet['qualification_type_ids'] ?? [], true) ? 'checked' : '' ?>>
                                <span><?= htmlspecialchars($q['qualification_name']) ?></span>
                            </label>
                        <?php endforeach; ?>
                    </div>
                    <small class="qualification-help">Leave all unchecked to allow every qualification type.</small>
                </div>

<!-- START DATE -->

                <div class="form-group">

                    <label>Clearance Start Date</label>

                    <input
                        type="datetime-local"
                        name="starts_at"
                        value="<?=
                            !empty($editSet['starts_at'])
                            ? date(
                                'Y-m-d\TH:i',
                                strtotime($editSet['starts_at'])
                            )
                            : ''
                        ?>"
                    >

                </div>


                <!-- END DATE -->

                <div class="form-group">

                    <label>Clearance End Date</label>

                    <input
                        type="datetime-local"
                        name="ends_at"
                        value="<?=
                            !empty($editSet['ends_at'])
                            ? date(
                                'Y-m-d\TH:i',
                                strtotime($editSet['ends_at'])
                            )
                            : ''
                        ?>"
                    >

                </div>


                <div class="form-actions">
                    <a href="<?= htmlspecialchars($currentPage) ?>" class="secondary-button">Cancel</a>
                    <button type="submit" class="secondary">Save Changes</button>
                </div>

            </form>

        <?php endif; ?>


        <!-- GRADUATION SETS TABLE -->

        <h2>
            Graduation Sets
        </h2>


        <table class="data-table">

            <thead>

                <tr>

                    <th>Set</th>

                    <th>Academic Year</th>

                    <th>Graduation Year</th>

                    <th>Window</th>

                    <th>Eligible Qualifications</th>

                    <th>Status</th>

                    <th>Clearance Records</th>

                    <th>Actions</th>

                </tr>

            </thead>


            <tbody>


                <?php foreach ($sets as $s): ?>

                    <tr>


                        <!-- SET -->

                        <td>

                            <?= htmlspecialchars(
                                $s['set_name']
                            ) ?>

                        </td>


                        <!-- ACADEMIC YEAR -->

                        <td>

                            <?= htmlspecialchars(
                                $s['academic_year'] ?? '—'
                            ) ?>

                        </td>


                        <!-- GRADUATION YEAR -->

                        <td>

                            <?= htmlspecialchars(
                                $s['graduation_year']
                            ) ?>

                        </td>


                        <!-- WINDOW -->

                        <td>

                            <?= htmlspecialchars(
                                !empty($s['starts_at'])
                                ? $s['starts_at']
                                : 'No start date'
                            ) ?>

                            <br>

                            <?= htmlspecialchars(
                                !empty($s['ends_at'])
                                ? $s['ends_at']
                                : 'No end date'
                            ) ?>

                        </td>


                        <!-- STATUS -->

                        <td>

                            <?= $s['is_active']
                                ? 'Active'
                                : 'Inactive'
                            ?>

                        </td>


                        <!-- CLEARANCE RECORDS -->

                        <td>

                            <?= (int) $s['requests'] ?>

                        </td>


                        <!-- ACTIONS -->

                        <td>


                            <!-- EDIT BUTTON -->

                            <form
                                method="get"
                                action="<?= htmlspecialchars($currentPage) ?>"
                                class="inline-form"
                            >

                                <input
                                    type="hidden"
                                    name="edit"
                                    value="<?= $s['graduation_set_id'] ?>"
                                >

                                <button
                                    type="submit"
                                    class="secondary"
                                >
                                    Edit
                                </button>

                            </form>


                            <!-- ACTIVATE BUTTON -->

                            <?php if (!$s['is_active']): ?>

                                <form
                                    method="post"
                                    action="<?= htmlspecialchars($currentPage) ?>"
                                    class="inline-form"
                                >

                                    <input
                                        type="hidden"
                                        name="action"
                                        value="toggle"
                                    >

                                    <input
                                        type="hidden"
                                        name="graduation_set_id"
                                        value="<?= $s['graduation_set_id'] ?>"
                                    >

                                    <button type="submit">
                                        Activate
                                    </button>

                                </form>


                            <?php else: ?>

                                <span class="status-active">
                                    Currently Active
                                </span>

                            <?php endif; ?>


                        </td>

                    </tr>

                <?php endforeach; ?>


                <!-- NO RECORDS -->

                <?php if (empty($sets)): ?>

                    <tr>

                        <td
                            colspan="7"
                            style="text-align:center;"
                        >
                            No graduation sets have been created yet.
                        </td>

                    </tr>

                <?php endif; ?>


            </tbody>

        </table>


    </div>

</section>


<?php
require_once __DIR__ . '/includes/footer.php';
?>