<?php

require_once __DIR__ . '/includes/auth.php';

require_role('registrar');

require_once __DIR__ . '/includes/clearance_functions.php';


$message = '';
$error = '';


/*CURRENT ACADEMIC REGISTRAR*/

$registrarId = (int) ($_SESSION['user_id'] ?? 0);

$registrarName = trim(
    $_SESSION['full_name'] ?? ''
);

if ($registrarName === '') {

    $registrarStmt = $pdo->prepare(
        'SELECT full_name
         FROM users
         WHERE user_id = ?
         LIMIT 1'
    );

    $registrarStmt->execute([
        $registrarId
    ]);

    $registrarName = (string) $registrarStmt->fetchColumn();
}


/*CLASSIFICATION FUNCTION*/

function calculate_classification($level, $averageMark)
{
    $averageMark = (float) $averageMark;


    /*BACHELOR'S DEGREE*/

    if ($level === 'Bachelor') {

        if ($averageMark >= 70) {
            return 'First Class Honours';
        }

        if ($averageMark >= 60) {
            return 'Second Class (Upper)';
        }

        if ($averageMark >= 50) {
            return 'Second Class (Lower)';
        }

        if ($averageMark >= 40) {
            return 'Pass Degree';
        }

        return 'Fail';
    }


    /*TVET / DIPLOMA*/

    if ($level === 'TVET/Diploma') {

        if ($averageMark >= 75) {
            return 'Distinction';
        }

        if ($averageMark >= 60) {
            return 'Credit';
        }

        if ($averageMark >= 40) {
            return 'Pass';
        }

        return 'Refer / Fail';
    }


    /*MASTER'S DEGREE*/

    if ($level === 'Master') {

        if ($averageMark >= 70) {
            return 'Distinction';
        }

        if ($averageMark >= 60) {
            return 'Merit';
        }

        if ($averageMark >= 50) {
            return 'Pass';
        }

        return 'Fail';
    }


    /*PHD / DOCTORATE*/

    if ($level === 'PhD/Doctorate') {

        if ($averageMark >= 50) {
            return 'Pass';
        }

        return 'Reject / Revisions';
    }


    return 'Not Classified';
}


/*HANDLE SAVE*/

if ($_SERVER['REQUEST_METHOD'] === 'POST') {

    verify_csrf();


    $studentId = (int) ($_POST['student_id'] ?? 0);


    $qualificationLevel = trim(
        $_POST['qualification_level'] ?? ''
    );


    $averageMark = trim(
        $_POST['average_mark'] ?? ''
    );


    /*VALIDATION*/

    $allowedLevels = [
        'Bachelor',
        'TVET/Diploma',
        'Master',
        'PhD/Doctorate'
    ];


    if ($studentId <= 0) {

        $error = 'Please select a student.';

    } elseif (
        !in_array(
            $qualificationLevel,
            $allowedLevels,
            true
        )
    ) {

        $error = 'Please select a valid qualification level.';

    } elseif (
        $averageMark === '' ||
        !is_numeric($averageMark)
    ) {

        $error = 'Please enter a valid average mark.';

    } else {

        $averageMark = (float) $averageMark;


        if (
            $averageMark < 0 ||
            $averageMark > 100
        ) {

            $error = 'Average mark must be between 0 and 100.';

        } else {


            /*CALCULATE CLASSIFICATION*/

            $classification = calculate_classification(
                $qualificationLevel,
                $averageMark
            );


            /* CHECK STUDENT*/

            $checkStudent = $pdo->prepare(
                'SELECT student_id
                 FROM students
                 WHERE student_id = ?
                 LIMIT 1'
            );

            $checkStudent->execute([
                $studentId
            ]);


            if (!$checkStudent->fetch()) {

                $error = 'The selected student does not exist.';

            } else {


                /*INSERT OR UPDATE CLASSIFICATION*/

                $stmt = $pdo->prepare(
                    'INSERT INTO student_classifications
                    (
                        student_id,
                        qualification_level,
                        average_mark,
                        classification,
                        entered_by
                    )
                    VALUES
                    (
                        ?,
                        ?,
                        ?,
                        ?,
                        ?
                    )

                    ON DUPLICATE KEY UPDATE

                        qualification_level =
                            VALUES(qualification_level),

                        average_mark =
                            VALUES(average_mark),

                        classification =
                            VALUES(classification),

                        entered_by =
                            VALUES(entered_by),

                        updated_at =
                            CURRENT_TIMESTAMP'
                );


                $stmt->execute([
                    $studentId,
                    $qualificationLevel,
                    $averageMark,
                    $classification,
                    $registrarId
                ]);


                /*AUDIT TRAIL*/

                log_audit(
                    $pdo,
                    $registrarId,
                    'student_classification_saved',
                    'Classification saved for student ID '
                    . $studentId
                    . ': '
                    . $classification
                    . ' ('
                    . number_format($averageMark, 2)
                    . '%)'
                    . ' by Academic Registrar: '
                    . $registrarName
                );


                /*NOTIFY STUDENT*/

                $studentUserId = get_student_user_id(
                    $pdo,
                    $studentId
                );


                if ($studentUserId) {

                    add_notification(
                        $pdo,
                        $studentUserId,
                        'classification_saved',
                        'Your academic classification has been recorded: '
                        . $classification
                        . '. Average mark: '
                        . number_format($averageMark, 2)
                        . '%.'
                    );
                }


                $message =
                    'Classification saved successfully. '
                    . 'Result: '
                    . $classification
                    . '. Recorded by Academic Registrar: '
                    . $registrarName
                    . '.';
            }
        }
    }
}


/*GET STUDENTS*/

$students = $pdo->query(
    'SELECT
        student_id,
        registration_no,
        full_name,
        programme,
        institute

     FROM students

     ORDER BY full_name ASC'
)->fetchAll();


/*GET SAVED CLASSIFICATIONS*/

$classifications = $pdo->query(
    'SELECT

        sc.classification_id,

        sc.qualification_level,

        sc.average_mark,

        sc.classification,

        sc.entered_by,

        sc.entered_at,

        sc.updated_at,


        s.student_id,

        s.registration_no,

        s.full_name,

        s.programme,


        COALESCE(
            u.full_name,
            \'Unknown Academic Registrar\'
        ) AS registrar_name


     FROM student_classifications sc


     INNER JOIN students s
        ON s.student_id = sc.student_id


     LEFT JOIN users u
        ON u.user_id = sc.entered_by


     ORDER BY
        sc.updated_at DESC,
        sc.entered_at DESC'
)->fetchAll();


$page_title = 'Student Classifications';


require_once __DIR__ . '/includes/header.php';

?>


<section class="dashboard">


    <div class="dashboard-top">

        <div>

            <h1>
                Student Classifications
            </h1>

            <p>
                Record student average marks and automatically assign
                the appropriate academic classification.
            </p>

        </div>


        <a href="<?php echo BASE_URL; ?>dashboard.php">

            ← Back to dashboard

        </a>

    </div>



    <div class="dashboard-box">


        <?php if ($message): ?>

            <div class="success">

                <?php echo htmlspecialchars($message); ?>

            </div>

        <?php endif; ?>



        <?php if ($error): ?>

            <div class="alert">

                <?php echo htmlspecialchars($error); ?>

            </div>

        <?php endif; ?>



     

        <h2>
            Record Student Classification
        </h2>


        <!-- CURRENT ACADEMIC REGISTRAR -->

        <div class="registrar-info">

            <span>
                Academic Registrar
            </span>

            <strong>

                <?php
                echo htmlspecialchars(
                    $registrarName
                );
                ?>

            </strong>

        </div>


        <form method="post">


            <?php echo csrf_field(); ?>


            <!-- STUDENT -->

            <div class="form-group">

                <label for="student_search">
                    Student
                </label>

                <div class="student-picker">

                    <input
                        type="text"
                        id="student_search"
                        class="student-search"
                        placeholder="Type student name or registration number..."
                        autocomplete="off"
                        required
                    >

                    <input
                        type="hidden"
                        id="student_id"
                        name="student_id"
                        value=""
                    >

                    <div
                        id="student_results"
                        class="student-results"
                        role="listbox"
                        aria-label="Student search results"
                    ></div>

                </div>

                <small class="student-hint">
                    Start typing to filter the student list, then select the student.
                </small>

            </div>


            <!-- QUALIFICATION LEVEL -->

            <div class="form-group">

                <label for="qualification_level">

                    Qualification Level

                </label>


                <select
                    id="qualification_level"
                    name="qualification_level"
                    required
                >

                    <option value="">

                        Select qualification level

                    </option>


                    <option value="Bachelor">

                        Bachelor's Degree

                    </option>


                    <option value="TVET/Diploma">

                        TVET / Diploma

                    </option>


                    <option value="Master">

                        Master's Degree

                    </option>


                    <option value="PhD/Doctorate">

                        PhD / Doctorate

                    </option>

                </select>

            </div>



            <!-- AVERAGE MARK -->

            <div class="form-group">

                <label for="average_mark">

                    Student Average Mark (%)

                </label>


                <input
                    type="number"
                    id="average_mark"
                    name="average_mark"
                    min="0"
                    max="100"
                    step="0.01"
                    placeholder="Example: 68.50"
                    required
                >

            </div>



            <!-- LIVE PREVIEW -->

            <div
                id="classification-preview"
                class="classification-preview"
            >

                Select a qualification level and enter
                the average mark to preview the classification.

            </div>



            <button type="submit">

                Save Classification

            </button>


        </form>



       

        <h2 class="section-heading">

            Classification Guide

        </h2>


        <div class="classification-guide">


            <div class="classification-column">

                <h3>
                    Bachelor's Degree
                </h3>

                <p>
                    <strong>70–100%</strong>
                    First Class Honours
                </p>

                <p>
                    <strong>60–69%</strong>
                    Second Class (Upper)
                </p>

                <p>
                    <strong>50–59%</strong>
                    Second Class (Lower)
                </p>

                <p>
                    <strong>40–49%</strong>
                    Pass Degree
                </p>

                <p>
                    <strong>Below 40%</strong>
                    Fail
                </p>

            </div>



            <div class="classification-column">

                <h3>
                    TVET / Diploma
                </h3>

                <p>
                    <strong>75–100%</strong>
                    Distinction
                </p>

                <p>
                    <strong>60–74%</strong>
                    Credit
                </p>

                <p>
                    <strong>40–59%</strong>
                    Pass
                </p>

                <p>
                    <strong>Below 40%</strong>
                    Refer / Fail
                </p>

            </div>



            <div class="classification-column">

                <h3>
                    Master's Degree
                </h3>

                <p>
                    <strong>70–100%</strong>
                    Distinction
                </p>

                <p>
                    <strong>60–69%</strong>
                    Merit
                </p>

                <p>
                    <strong>50–59%</strong>
                    Pass
                </p>

                <p>
                    <strong>Below 50%</strong>
                    Fail
                </p>

            </div>



            <div class="classification-column">

                <h3>
                    PhD / Doctorate
                </h3>

                <p>

                    <strong>Pass</strong>

                    Thesis requirements completed.

                </p>

                <p>

                    <strong>Reject / Revisions</strong>

                    Further academic requirements required.

                </p>

            </div>


        </div>



        

        <h2 class="section-heading">

            Recorded Classifications

        </h2>


        <?php if ($classifications): ?>


            <div class="table-responsive">


                <table class="data-table">


                    <thead>

                        <tr>

                            <th>
                                Student
                            </th>

                            <th>
                                Registration No.
                            </th>

                            <th>
                                Programme
                            </th>

                            <th>
                                Level
                            </th>

                            <th>
                                Average
                            </th>

                            <th>
                                Classification
                            </th>

                            <th>
                                Academic Registrar
                            </th>

                            <th>
                                Date Recorded
                            </th>

                        </tr>

                    </thead>



                    <tbody>


                        <?php foreach ($classifications as $record): ?>


                            <tr>


                                <td>

                                    <?php

                                    echo htmlspecialchars(
                                        $record['full_name']
                                    );

                                    ?>

                                </td>



                                <td>

                                    <?php

                                    echo htmlspecialchars(
                                        $record['registration_no']
                                    );

                                    ?>

                                </td>



                                <td>

                                    <?php

                                    echo htmlspecialchars(
                                        $record['programme']
                                    );

                                    ?>

                                </td>



                                <td>

                                    <?php

                                    echo htmlspecialchars(
                                        $record['qualification_level']
                                    );

                                    ?>

                                </td>



                                <td>

                                    <?php

                                    echo number_format(
                                        (float) $record['average_mark'],
                                        2
                                    );

                                    ?>%

                                </td>



                                <td>

                                    <strong>

                                        <?php

                                        echo htmlspecialchars(
                                            $record['classification']
                                        );

                                        ?>

                                    </strong>

                                </td>



                                <!-- ACADEMIC REGISTRAR NAME -->

                                <td>

                                    <strong>

                                        <?php

                                        echo htmlspecialchars(
                                            $record['registrar_name']
                                        );

                                        ?>

                                    </strong>

                                </td>



                                <td>

                                    <?php

                                    echo htmlspecialchars(
                                        $record['updated_at']
                                        ?: $record['entered_at']
                                    );

                                    ?>

                                </td>


                            </tr>


                        <?php endforeach; ?>


                    </tbody>


                </table>


            </div>


        <?php else: ?>


            <p>

                No student classifications have been recorded yet.

            </p>


        <?php endif; ?>


    </div>


</section>



<style>


/*
|--------------------------------------------------------------------------
| ACADEMIC REGISTRAR INFORMATION
|--------------------------------------------------------------------------
*/

.registrar-info {

    display: flex;

    flex-direction: column;

    gap: 5px;

    padding: 15px 18px;

    margin-bottom: 25px;

    border: 1px solid #ddd;

    border-radius: 8px;

    background: #f8f9fa;

}


.registrar-info span {

    font-size: 13px;

    text-transform: uppercase;

    letter-spacing: 0.5px;

    opacity: 0.7;

}


.registrar-info strong {

    font-size: 17px;

}



/*
|--------------------------------------------------------------------------
| STUDENT SEARCH
|--------------------------------------------------------------------------
*/

.student-picker {
    position: relative;
}

.student-search {
    width: 100%;
    box-sizing: border-box;
}

.student-results {
    display: none;
    position: absolute;
    z-index: 1000;
    left: 0;
    right: 0;
    top: calc(100% + 4px);
    max-height: 280px;
    overflow-y: auto;
    background: #ffffff;
    border: 1px solid #d1d5db;
    border-radius: 8px;
    box-shadow: 0 8px 20px rgba(0, 0, 0, 0.12);
}

.student-results.show {
    display: block;
}

.student-result {
    display: flex;
    flex-direction: column;
    width: 100%;
    box-sizing: border-box;
    padding: 12px 14px;
    border: 0;
    border-bottom: 1px solid #e5e7eb;
    background: #ffffff;
    color: #1f2937;
    text-align: left;
    cursor: pointer;
}

.student-result:hover,
.student-result:focus {
    background: #f3f4f6;
    color: #111827;
}

.student-result strong {
    color: #111827;
    font-size: 15px;
}

.student-result span {
    margin-top: 3px;
    color: #4b5563;
    font-size: 13px;
    opacity: 1;
}

.student-result-empty {
    padding: 14px;
    color: #4b5563;
}

.student-hint {
    display: block;
    margin-top: 6px;
    color: #4b5563;
    font-size: 12px;
    opacity: 1;
}


/*
|--------------------------------------------------------------------------
| CLASSIFICATION PREVIEW
|--------------------------------------------------------------------------
*/


|--------------------------------------------------------------------------
*/

.classification-preview {

    margin-top: 20px;

    margin-bottom: 20px;

    padding: 18px;

    border: 1px solid #ddd;

    border-radius: 8px;

    font-size: 17px;

    font-weight: 600;

    background: #f8f9fa;

}



/*
|--------------------------------------------------------------------------
| CLASSIFICATION GUIDE
|--------------------------------------------------------------------------
*/

.classification-guide {

    display: grid;

    grid-template-columns:
        repeat(
            auto-fit,
            minmax(220px, 1fr)
        );

    gap: 20px;

    margin-bottom: 35px;

}


.classification-column {

    border: 1px solid #ddd;

    border-radius: 8px;

    padding: 20px;

    background: #fff;

}


.classification-column h3 {

    margin-top: 0;

}


.classification-column p {

    padding-bottom: 10px;

    border-bottom: 1px solid #eee;

}



/*
|--------------------------------------------------------------------------
| SECTION HEADINGS
|--------------------------------------------------------------------------
*/

.section-heading {

    margin-top: 40px;

}



/*
|--------------------------------------------------------------------------
| TABLE
|--------------------------------------------------------------------------
*/

.table-responsive {

    overflow-x: auto;

}


</style>



<script>


const studentSearch = document.getElementById('student_search');
const studentId = document.getElementById('student_id');
const studentResults = document.getElementById('student_results');

const students = <?php echo json_encode(
    array_map(
        static function ($student) {
            return [
                'student_id' => (int) $student['student_id'],
                'full_name' => (string) $student['full_name'],
                'registration_no' => (string) $student['registration_no'],
                'programme' => (string) $student['programme'],
            ];
        },
        $students
    ),
    JSON_HEX_TAG | JSON_HEX_AMP | JSON_HEX_APOS | JSON_HEX_QUOT
); ?>;

function renderStudentResults(query = '') {
    const term = query.trim().toLowerCase();

    const matches = students.filter(student => {
        return !term ||
            student.full_name.toLowerCase().includes(term) ||
            student.registration_no.toLowerCase().includes(term);
    }).slice(0, 20);

    studentResults.innerHTML = '';

    if (!matches.length) {
        const empty = document.createElement('div');
        empty.className = 'student-result-empty';
        empty.textContent = 'No matching student found.';
        studentResults.appendChild(empty);
        studentResults.classList.add('show');
        return;
    }

    matches.forEach(student => {
        const item = document.createElement('button');
        item.type = 'button';
        item.className = 'student-result';
        item.setAttribute('role', 'option');

        const name = document.createElement('strong');
        name.textContent = student.full_name;

        const details = document.createElement('span');
        details.textContent =
            student.registration_no +
            (student.programme ? ' • ' + student.programme : '');

        item.appendChild(name);
        item.appendChild(details);

        item.addEventListener('click', () => {
            studentSearch.value = student.full_name +
                ' - ' + student.registration_no +
                (student.programme ? ' (' + student.programme + ')' : '');

            studentId.value = student.student_id;
            studentResults.classList.remove('show');
        });

        studentResults.appendChild(item);
    });

    studentResults.classList.add('show');
}

studentSearch.addEventListener('focus', () => {
    renderStudentResults(studentSearch.value);
});

studentSearch.addEventListener('input', () => {
    studentId.value = '';
    renderStudentResults(studentSearch.value);
});

document.addEventListener('click', event => {
    if (!event.target.closest('.student-picker')) {
        studentResults.classList.remove('show');
    }
});

studentSearch.form.addEventListener('submit', event => {
    if (!studentId.value) {
        event.preventDefault();
        studentSearch.focus();
        renderStudentResults(studentSearch.value);
        alert('Please select a student from the filtered results.');
    }
});


const qualificationLevel =
    document.getElementById(
        'qualification_level'
    );


const averageMark =
    document.getElementById(
        'average_mark'
    );


const preview =
    document.getElementById(
        'classification-preview'
    );


function calculatePreviewClassification()
{

    const level =
        qualificationLevel.value;


    const mark =
        parseFloat(
            averageMark.value
        );


    if (
        !level ||
        isNaN(mark)
    ) {

        preview.textContent =
            'Select a qualification level and enter the average mark to preview the classification.';

        return;
    }


    let result = '';


    if (level === 'Bachelor') {

        if (mark >= 70) {

            result = 'First Class Honours';

        } else if (mark >= 60) {

            result = 'Second Class (Upper)';

        } else if (mark >= 50) {

            result = 'Second Class (Lower)';

        } else if (mark >= 40) {

            result = 'Pass Degree';

        } else {

            result = 'Fail';
        }

    }


    else if (level === 'TVET/Diploma') {

        if (mark >= 75) {

            result = 'Distinction';

        } else if (mark >= 60) {

            result = 'Credit';

        } else if (mark >= 40) {

            result = 'Pass';

        } else {

            result = 'Refer / Fail';
        }

    }


    else if (level === 'Master') {

        if (mark >= 70) {

            result = 'Distinction';

        } else if (mark >= 60) {

            result = 'Merit';

        } else if (mark >= 50) {

            result = 'Pass';

        } else {

            result = 'Fail';
        }

    }


    else if (level === 'PhD/Doctorate') {

        if (mark >= 50) {

            result = 'Pass';

        } else {

            result = 'Reject / Revisions';
        }

    }


    preview.innerHTML =
        'Classification Preview: <strong>'
        + result
        + '</strong>';

}


qualificationLevel.addEventListener(
    'change',
    calculatePreviewClassification
);


averageMark.addEventListener(
    'input',
    calculatePreviewClassification
);


</script>


<?php require_once __DIR__ . '/includes/footer.php'; ?>