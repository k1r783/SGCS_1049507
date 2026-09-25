<?php
require_once __DIR__ . '/includes/auth.php';
require_role('admin');
require_once __DIR__ . '/includes/clearance_functions.php';

$message = '';
$error = '';

$editType = clean_input($_GET['edit_type'] ?? '');
$editId = (int)($_GET['edit_id'] ?? 0);
$editRecord = null;

function admin_academic_edit_url($type, $id) {
    return 'admin_academic.php?edit_type=' . urlencode($type) . '&edit_id=' . (int)$id;
}


try {
    if ($editType && $editId > 0) {
        if ($editType === 'school') {
            $stmt = $pdo->prepare('SELECT * FROM schools WHERE school_id = ?');
            $stmt->execute([$editId]);
            $editRecord = $stmt->fetch();
        } elseif ($editType === 'institute') {
            $stmt = $pdo->prepare('SELECT * FROM institutes WHERE institute_id = ?');
            $stmt->execute([$editId]);
            $editRecord = $stmt->fetch();
        } elseif ($editType === 'programme') {
            $stmt = $pdo->prepare('SELECT * FROM programmes WHERE programme_id = ?');
            $stmt->execute([$editId]);
            $editRecord = $stmt->fetch();
        } elseif ($editType === 'department') {
            $stmt = $pdo->prepare('SELECT * FROM departments WHERE department_id = ?');
            $stmt->execute([$editId]);
            $editRecord = $stmt->fetch();
        } else {
            $editType = '';
            $editId = 0;
        }

        if (!$editRecord && $editType) {
            $error = 'The selected record could not be found.';
            $editType = '';
            $editId = 0;
        }
    }
} catch (Exception $e) {
    $error = $e->getMessage();
    $editType = '';
    $editId = 0;
}

/* CREATE / UPDATE*/
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $action = clean_input($_POST['action'] ?? '');

    try {
        /* SCHOOL */
        if ($action === 'school') {
            $name = clean_message($_POST['school_name'] ?? '', 100);
            if (!$name) throw new Exception('School name is required.');
            $pdo->prepare('INSERT INTO schools (school_name) VALUES (?)')->execute([$name]);
            $message = 'School created.';
        }
        elseif ($action === 'update_school') {
            $id = (int)($_POST['school_id'] ?? 0);
            $name = clean_message($_POST['school_name'] ?? '', 100);
            if (!$id || !$name) throw new Exception('School name is required.');
            $pdo->prepare('UPDATE schools SET school_name = ? WHERE school_id = ?')->execute([$name, $id]);
            $message = 'School updated successfully.';
            $editType = ''; $editId = 0; $editRecord = null;
        }

        /* INSTITUTE / CENTRE */
        elseif ($action === 'institute') {
            $name = clean_message($_POST['institute_name'] ?? '', 100);
            $schoolId = ($_POST['school_id'] ?? '') !== '' ? (int)$_POST['school_id'] : null;
            if (!$name) throw new Exception('Institute/Centre name is required.');
            $pdo->prepare('INSERT INTO institutes (school_id, institute_name) VALUES (?, ?)')->execute([$schoolId, $name]);
            $message = 'Institute/Centre created.';
        }
        elseif ($action === 'update_institute') {
            $id = (int)($_POST['institute_id'] ?? 0);
            $name = clean_message($_POST['institute_name'] ?? '', 100);
            $schoolId = ($_POST['school_id'] ?? '') !== '' ? (int)$_POST['school_id'] : null;
            if (!$id || !$name) throw new Exception('Institute/Centre name is required.');
            $pdo->prepare('UPDATE institutes SET school_id = ?, institute_name = ? WHERE institute_id = ?')->execute([$schoolId, $name, $id]);
            $message = 'Institute/Centre updated successfully.';
            $editType = ''; $editId = 0; $editRecord = null;
        }

        /* PROGRAMME */
        elseif ($action === 'programme') {
            $name = clean_message($_POST['programme_name'] ?? '', 100);
            $specialisation = clean_message($_POST['specialisation'] ?? '', 150);
            $qualificationTypeId = (int)($_POST['qualification_type_id'] ?? 0);
            $instituteId = (int)($_POST['institute_id'] ?? 0);
            if (!$name || !$instituteId || !$qualificationTypeId) throw new Exception('Programme name, qualification type and institute are required.');
            $check = $pdo->prepare('SELECT qualification_type_id FROM qualification_types WHERE qualification_type_id = ? AND is_active = 1');
            $check->execute([$qualificationTypeId]);
            if (!$check->fetchColumn()) throw new Exception('Please select a valid qualification type.');
            $pdo->prepare('INSERT INTO programmes (institute_id, programme_name, qualification_type_id, specialisation) VALUES (?, ?, ?, ?)')
                ->execute([$instituteId, $name, $qualificationTypeId, $specialisation ?: null]);
            $message = 'Programme created.';
        }
        elseif ($action === 'update_programme') {
            $id = (int)($_POST['programme_id'] ?? 0);
            $name = clean_message($_POST['programme_name'] ?? '', 100);
            $specialisation = clean_message($_POST['specialisation'] ?? '', 150);
            $qualificationTypeId = (int)($_POST['qualification_type_id'] ?? 0);
            $instituteId = (int)($_POST['institute_id'] ?? 0);
            if (!$id || !$name || !$instituteId || !$qualificationTypeId) throw new Exception('Programme name, qualification type and institute are required.');
            $check = $pdo->prepare('SELECT qualification_type_id FROM qualification_types WHERE qualification_type_id = ? AND is_active = 1');
            $check->execute([$qualificationTypeId]);
            if (!$check->fetchColumn()) throw new Exception('Please select a valid qualification type.');
            $pdo->prepare('UPDATE programmes SET institute_id = ?, programme_name = ?, qualification_type_id = ?, specialisation = ? WHERE programme_id = ?')
                ->execute([$instituteId, $name, $qualificationTypeId, $specialisation ?: null, $id]);
            $message = 'Programme updated successfully.';
            $editType = ''; $editId = 0; $editRecord = null;
        }

        /* DEPARTMENT */
        elseif ($action === 'department') {
            $name = clean_message($_POST['dept_name'] ?? '', 100);
            $sequence = (int)($_POST['sequence_no'] ?? 0);
            if (!$name || $sequence < 1) throw new Exception('Department and positive workflow sequence are required.');
            $pdo->prepare('INSERT INTO departments (dept_name, sequence_no) VALUES (?, ?)')->execute([$name, $sequence]);
            $message = 'Department created.';
        }
        elseif ($action === 'update_department') {
            $id = (int)($_POST['department_id'] ?? 0);
            $name = clean_message($_POST['dept_name'] ?? '', 100);
            $sequence = (int)($_POST['sequence_no'] ?? 0);
            if (!$id || !$name || $sequence < 1) throw new Exception('Department and positive workflow sequence are required.');
            $pdo->prepare('UPDATE departments SET dept_name = ?, sequence_no = ? WHERE department_id = ?')->execute([$name, $sequence, $id]);
            $message = 'Department updated successfully.';
            $editType = ''; $editId = 0; $editRecord = null;
        }

        /* DELETE */
        elseif ($action === 'delete_school') {
            $id = (int)($_POST['school_id'] ?? 0);
            if (!$id) throw new Exception('Invalid school selected.');
            $pdo->prepare('DELETE FROM schools WHERE school_id = ?')->execute([$id]);
            $message = 'School deleted successfully.';
        }
        elseif ($action === 'delete_institute') {
            $id = (int)($_POST['institute_id'] ?? 0);
            if (!$id) throw new Exception('Invalid institute/centre selected.');
            $pdo->prepare('DELETE FROM institutes WHERE institute_id = ?')->execute([$id]);
            $message = 'Institute/Centre deleted successfully.';
        }
        elseif ($action === 'delete_programme') {
            $id = (int)($_POST['programme_id'] ?? 0);
            if (!$id) throw new Exception('Invalid programme selected.');
            $pdo->prepare('DELETE FROM programmes WHERE programme_id = ?')->execute([$id]);
            $message = 'Programme deleted successfully.';
        }
        elseif ($action === 'delete_department') {
            $id = (int)($_POST['department_id'] ?? 0);
            if (!$id) throw new Exception('Invalid department selected.');
            $pdo->prepare('DELETE FROM departments WHERE department_id = ?')->execute([$id]);
            $message = 'Department deleted successfully.';
        }
    } catch (Exception $e) {
        $error = $e->getMessage();
    }
}

/* load data */
$schools = $pdo->query('SELECT * FROM schools ORDER BY school_name')->fetchAll();
$institutes = $pdo->query('SELECT i.*, s.school_name FROM institutes i LEFT JOIN schools s ON s.school_id = i.school_id ORDER BY institute_name')->fetchAll();
$qualificationTypes = $pdo->query('SELECT * FROM qualification_types WHERE is_active = 1 ORDER BY qualification_name')->fetchAll();
$programmes = $pdo->query('SELECT p.*, i.institute_name, qt.qualification_name FROM programmes p JOIN institutes i ON i.institute_id = p.institute_id LEFT JOIN qualification_types qt ON qt.qualification_type_id = p.qualification_type_id ORDER BY programme_name')->fetchAll();
$departments = $pdo->query('SELECT * FROM departments ORDER BY sequence_no')->fetchAll();

$page_title = 'Academic Structure';
require_once __DIR__ . '/includes/header.php';
?>
<section class="dashboard">
<div class="dashboard-top"><h1>Academic Structure</h1><a href="dashboard.php">Back to dashboard</a></div>
<div class="dashboard-box">
<?php if($message): ?><div class="success"><?= htmlspecialchars($message) ?></div><?php endif; ?>
<?php if($error): ?><div class="alert"><?= htmlspecialchars($error) ?></div><?php endif; ?>

<h2><?= $editType === 'school' ? 'Edit School' : 'Schools' ?></h2>
<form class="filter-form" method="post">
<input type="hidden" name="action" value="<?= $editType === 'school' ? 'update_school' : 'school' ?>">
<?php if($editType === 'school'): ?><input type="hidden" name="school_id" value="<?= (int)$editRecord['school_id'] ?>"><?php endif; ?>
<div class="form-group"><label>School Name</label><input name="school_name" required value="<?= $editType === 'school' ? htmlspecialchars($editRecord['school_name']) : '' ?>"></div>
<button><?= $editType === 'school' ? 'Save Changes' : 'Add School' ?></button>
<?php if($editType === 'school'): ?><a class="button" href="admin_academic.php">Cancel Editing</a><?php endif; ?>
</form>
<ul class="simple-list">
<?php foreach($schools as $x): ?><li><?= htmlspecialchars(academic_display_label($x['school_name'])) ?> <a class="button" href="<?= htmlspecialchars(admin_academic_edit_url('school', $x['school_id'])) ?>">Edit</a> <form method="post" style="display:inline" onsubmit="return confirm('Delete this school? This cannot be undone.');"><input type="hidden" name="action" value="delete_school"><input type="hidden" name="school_id" value="<?= (int)$x['school_id'] ?>"><button type="submit" class="button">Delete</button></form></li><?php endforeach; ?>
</ul>

<h2><?= $editType === 'institute' ? 'Edit Institute / Centre' : 'Institutes / Centres' ?></h2>
<form class="filter-form" method="post">
<input type="hidden" name="action" value="<?= $editType === 'institute' ? 'update_institute' : 'institute' ?>">
<?php if($editType === 'institute'): ?><input type="hidden" name="institute_id" value="<?= (int)$editRecord['institute_id'] ?>"><?php endif; ?>
<div class="form-group"><label>Name</label><input name="institute_name" required value="<?= $editType === 'institute' ? htmlspecialchars($editRecord['institute_name']) : '' ?>"></div>
<div class="form-group"><label>School (optional)</label><select name="school_id"><option value="">No school</option><?php foreach($schools as $x): ?><option value="<?= $x['school_id'] ?>" <?= $editType === 'institute' && (int)$editRecord['school_id'] === (int)$x['school_id'] ? 'selected' : '' ?>><?= htmlspecialchars(academic_display_label($x['school_name'])) ?></option><?php endforeach; ?></select></div>
<button><?= $editType === 'institute' ? 'Save Changes' : 'Add Institute/Centre' ?></button>
<?php if($editType === 'institute'): ?><a class="button" href="admin_academic.php">Cancel Editing</a><?php endif; ?>
</form>
<ul class="simple-list">
<?php foreach($institutes as $x): ?><li><?= htmlspecialchars(academic_display_label($x['institute_name']) . ' — ' . academic_display_label($x['school_name'] ?? 'None')) ?> <a class="button" href="<?= htmlspecialchars(admin_academic_edit_url('institute', $x['institute_id'])) ?>">Edit</a> <form method="post" style="display:inline" onsubmit="return confirm('Delete this institute/centre? This cannot be undone.');"><input type="hidden" name="action" value="delete_institute"><input type="hidden" name="institute_id" value="<?= (int)$x['institute_id'] ?>"><button type="submit" class="button">Delete</button></form></li><?php endforeach; ?>
</ul>

<h2><?= $editType === 'programme' ? 'Edit Programme' : 'Programmes' ?></h2>
<form class="filter-form" method="post">
<input type="hidden" name="action" value="<?= $editType === 'programme' ? 'update_programme' : 'programme' ?>">
<?php if($editType === 'programme'): ?><input type="hidden" name="programme_id" value="<?= (int)$editRecord['programme_id'] ?>"><?php endif; ?>
<div class="form-group"><label>Programme Name</label><input name="programme_name" required value="<?= $editType === 'programme' ? htmlspecialchars($editRecord['programme_name']) : '' ?>"></div>
<div class="form-group"><label>Qualification / Certification</label><select name="qualification_type_id" required><option value="">Select</option><?php foreach($qualificationTypes as $q): ?><option value="<?= $q['qualification_type_id'] ?>" <?= $editType === 'programme' && (int)$editRecord['qualification_type_id'] === (int)$q['qualification_type_id'] ? 'selected' : '' ?>><?= htmlspecialchars($q['qualification_name']) ?></option><?php endforeach; ?></select></div>
<div class="form-group"><label>Specialisation</label><input name="specialisation" placeholder="Counselling Psychology" value="<?= $editType === 'programme' ? htmlspecialchars($editRecord['specialisation'] ?? '') : '' ?>"></div>
<div class="form-group"><label>Institute/Centre</label><select name="institute_id" required><option value="">Select</option><?php foreach($institutes as $x): ?><option value="<?= $x['institute_id'] ?>" <?= $editType === 'programme' && (int)$editRecord['institute_id'] === (int)$x['institute_id'] ? 'selected' : '' ?>><?= htmlspecialchars(academic_display_label($x['institute_name'])) ?></option><?php endforeach; ?></select></div>
<button><?= $editType === 'programme' ? 'Save Changes' : 'Add Programme' ?></button>
<?php if($editType === 'programme'): ?><a class="button" href="admin_academic.php">Cancel Editing</a><?php endif; ?>
</form>
<ul class="simple-list">
<?php foreach($programmes as $x): ?><li><?= htmlspecialchars(academic_display_label($x['programme_name'])) ?> — <?= htmlspecialchars(academic_display_label($x['qualification_name'] ?? 'Not set')) ?><?php if(!empty($x['specialisation'])): ?> — <?= htmlspecialchars(academic_display_label($x['specialisation'])) ?><?php endif; ?> — <?= htmlspecialchars(academic_display_label($x['institute_name'] ?? 'None')) ?> <a class="button" href="<?= htmlspecialchars(admin_academic_edit_url('programme', $x['programme_id'])) ?>">Edit</a> <form method="post" style="display:inline" onsubmit="return confirm('Delete this programme? This cannot be undone.');"><input type="hidden" name="action" value="delete_programme"><input type="hidden" name="programme_id" value="<?= (int)$x['programme_id'] ?>"><button type="submit" class="button">Delete</button></form></li><?php endforeach; ?>
</ul>

<h2><?= $editType === 'department'
    ? 'Edit Administrative Department / Workflow Order'
    : 'Administrative Departments / Workflow Order' ?></h2>

<form class="filter-form" method="post">

    <input
        type="hidden"
        name="action"
        value="<?= $editType === 'department' ? 'update_department' : 'department' ?>"
    >

    <?php if ($editType === 'department'): ?>
        <input
            type="hidden"
            name="dept_id"
            value="<?= (int)$editRecord['dept_id'] ?>"
        >
    <?php endif; ?>

    <div class="form-group">
        <label>Department Name</label>

        <input
            name="dept_name"
            required
            value="<?= $editType === 'department'
                ? htmlspecialchars($editRecord['dept_name'])
                : '' ?>"
        >
    </div>

    <div class="form-group">
        <label>Sequence</label>

        <input
            type="number"
            min="1"
            name="sequence_no"
            required
            value="<?= $editType === 'department'
                ? (int)$editRecord['sequence_no']
                : '' ?>"
        >
    </div>

    <button type="submit">
        <?= $editType === 'department' ? 'Save Changes' : 'Add Department' ?>
    </button>

    <?php if ($editType === 'department'): ?>
        <a class="button" href="admin_academic.php">Cancel Editing</a>
    <?php endif; ?>

</form>

<ul class="simple-list">

<?php foreach ($departments as $x): ?>

    <li>

        <?= htmlspecialchars(
            $x['sequence_no'] . '. ' . $x['dept_name']
        ) ?>

        <a
            class="button"
            href="<?= htmlspecialchars(
                admin_academic_edit_url('department', $x['dept_id'])
            ) ?>"
        >
            Edit
        </a>

        <form
            method="post"
            style="display:inline"
            onsubmit="return confirm('Delete this department? This cannot be undone.');"
        >

            <input
                type="hidden"
                name="action"
                value="delete_department"
            >

            <input
                type="hidden"
                name="dept_id"
                value="<?= (int)$x['dept_id'] ?>"
            >

            <button type="submit" class="button">
                Delete
            </button>

        </form>

    </li>

<?php endforeach; ?>

</ul>

</div>
</section>

<?php require_once __DIR__ . '/includes/footer.php'; ?>
