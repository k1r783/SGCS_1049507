<?php

require_once __DIR__ . '/includes/auth.php';
require_role([
    'officer',
    'librarian',
    'finance_officer',
    'university_store',
    'director',
    'registrar',
    'dean'
]);

require_once __DIR__ . '/includes/clearance_functions.php';

$user = current_user();
$department = get_assigned_department($pdo, $user);

$message = '';
$error = '';


if ($_SERVER['REQUEST_METHOD'] === 'POST') {

    verify_csrf();

    if (!$department) {

        $error = 'No department is assigned to your account.';

    } else {

        $physical = isset($_POST['physical_fyp_submitted'])
            ? $_POST['physical_fyp_submitted'] === 'yes'
            : null;

        $result = update_clearance_decision(
            $pdo,
            (int) ($_POST['request_id'] ?? 0),
            $department,
            $user,
            clean_input($_POST['decision'] ?? ''),
            clean_message($_POST['comments'] ?? '', 500),
            $physical
        );

        if (
            strpos($result, 'Decision saved') !== false ||
            strpos($result, 'Rejection recorded') !== false
        ) {
            $message = $result;
        } else {
            $error = $result;
        }
    }
}



$requests = $department
    ? get_review_queue($pdo, $department, $user)
    : [];

$counts = $department
    ? get_review_counts($pdo, $department, $user)
    : [
        'Pending' => 0,
        'Rejected' => 0,
        'Approved' => 0
    ];



$totalRequests = count($requests);

/* We use GET so Previous/Next buttons work through: officer_requests.php?page=1
  officer_requests.php?page=2
 */
$currentPage = isset($_GET['page'])
    ? (int) $_GET['page']
    : 1;


if ($currentPage < 1) {
    $currentPage = 1;
}

/*If the current page is greater than the number of remaining requests, move to the last available request.*/
if ($totalRequests > 0 && $currentPage > $totalRequests) {
    $currentPage = $totalRequests;
}

/*Get only ONE student.
 Arrays start at index 0, while pages start at 1. */
$currentRequest = null;

if ($totalRequests > 0) {
    $currentRequest = $requests[$currentPage - 1];
}



$departmentName = $department['dept_name'] ?? 'Unassigned';

$isLibrary = strtolower(trim($departmentName)) === 'library';

$isFinance = strtolower(trim($departmentName)) === 'finance office';


$page_title = $departmentName . ' Review';

require_once __DIR__ . '/includes/header.php';

?>

<section class="dashboard">

    <div class="dashboard-top">

        <h1>
            <?php echo htmlspecialchars($departmentName); ?>
            Review Queue
        </h1>

        <a href="dashboard.php">
            Back to dashboard
        </a>

    </div>


    <div class="dashboard-box">


        <!-- Success Message -->
        <?php if ($message): ?>

            <div class="success">
                <?php echo htmlspecialchars($message); ?>
            </div>

        <?php endif; ?>


        <!-- Error Message -->
        <?php if ($error): ?>

            <div class="alert">
                <?php echo htmlspecialchars($error); ?>
            </div>

        <?php endif; ?>


        <!-- Summary Cards -->
        <style>
            .review-status-cards {
                display: grid;
                grid-template-columns: repeat(4, 1fr);
                gap: 20px;
                margin: 20px 0 30px;
                width: 100%;
            }

            .review-status-card {
                min-height: 120px;
                height: 120px;
                padding: 26px 28px;
                border-radius: 12px;
                box-sizing: border-box;
                display: flex;
                flex-direction: column;
                justify-content: center;
            }

            .review-card-title {
                font-size: 24px;
                font-weight: 700;
                margin-bottom: 12px;
            }

            .review-card-number {
                font-size: 26px;
                font-weight: 700;
            }

            .review-pending-card {
                background: #fff6dc;
                border-left: 5px solid #b8860b;
                color: #5c4813;
            }

            .review-rejected-card {
                background: #fde8e8;
                border-left: 5px solid #b91c1c;
                color: #991b1b;
            }

            .review-approved-card {
                background: #e7f4ec;
                border-left: 5px solid #26734d;
                color: #25603f;
            }

            .review-total-card {
                background: #f1f1f1;
                border-left: 5px solid #666;
                color: #333;
            }

            @media (max-width: 800px) {
                .review-status-cards {
                    grid-template-columns: 1fr;
                }
            }
        </style>

        <div class="review-status-cards">

            <div class="review-status-card review-pending-card">
                <div class="review-card-title">Pending</div>
                <div class="review-card-number">
                    <?php echo $counts['Pending']; ?>
                </div>
            </div>

            <div class="review-status-card review-rejected-card">
                <div class="review-card-title">Rejected</div>
                <div class="review-card-number">
                    <?php echo $counts['Rejected']; ?>
                </div>
            </div>

            <div class="review-status-card review-approved-card">
                <div class="review-card-title">Approved</div>
                <div class="review-card-number">
                    <?php echo $counts['Approved']; ?>
                </div>
            </div>

        </div>


        <!-- Finance Notice -->
        <?php if ($isFinance): ?>

            <div class="alert">

                <strong>Manual finance review:</strong>

                no fee-structure integration is currently configured.
                Finance officers may approve or reject requests using
                the institution's authorized manual verification process;
                no fee status is fabricated by SGCS.

            </div>

        <?php endif; ?>


        <?php if ($currentRequest): ?>

            <?php

            /*Get documents only for the currently displayed student.*/
            $documents = get_current_documents(
                $pdo,
                $currentRequest['student_id']
            );

            ?>
            

            

            <!--CURRENT STUDENT ONLY -->

            <div class="card">


                <!-- Student Name -->

                <strong>

                    <?php
                    echo htmlspecialchars(
                        $currentRequest['full_name']
                    );
                    ?>

                    (

                    <?php
                    echo htmlspecialchars(
                        $currentRequest['registration_no']
                    );
                    ?>

                    )

                </strong>


                <!-- Programme -->

                <p>

                    <?php
                    echo htmlspecialchars(
                        academic_display_label(
                            $currentRequest['programme']
                        )
                    );
                    ?>

                </p>


                <!-- Director Details -->

                <?php if ($user['role'] === 'director'): ?>

                    <p>

                        <a
                            class="button secondary"
                            href="review_student.php?request_id=<?php echo (int) $currentRequest['request_id']; ?>"
                        >
                            View authorized student details
                        </a>

                    </p>

                <?php endif; ?>


                <!-- Library FYP PDF -->

                <?php if (
                    $isLibrary &&
                    !empty($documents['final_year_project'])
                ): ?>

                    <p>

                        FYP PDF:

                        <a
                            href="document_download.php?id=<?php echo (int) $documents['final_year_project']['document_id']; ?>"
                        >
                            View securely
                        </a>

                    </p>

                <?php endif; ?>


                <!-- 
                     REVIEW FORM
                     -->

                <form
                    method="post"
                    action="officer_requests.php?page=<?php echo $currentPage; ?>"
                >

                    <?php echo csrf_field(); ?>


                    <!-- Request ID -->

                    <input
                        type="hidden"
                        name="request_id"
                        value="<?php echo (int) $currentRequest['request_id']; ?>"
                    >


                    <!-- Review Comment -->

                    <div class="form-group">

                        <label>
                            Review Comment
                            (required for rejection)
                        </label>

                        <textarea
                            name="comments"
                            maxlength="500"
                            placeholder="State the reason clearly if rejecting."
                        ></textarea>

                    </div>


                    <!-- Library Physical FYP -->

                    <?php if ($isLibrary): ?>

                        <div class="form-group">

                            <label>
                                Physical Final Year Project Submitted
                            </label>


                            <label>

                                <input
                                    type="radio"
                                    name="physical_fyp_submitted"
                                    value="yes"
                                    required
                                >

                                Yes

                            </label>


                            <label>

                                <input
                                    type="radio"
                                    name="physical_fyp_submitted"
                                    value="no"
                                >

                                No

                            </label>

                        </div>

                    <?php endif; ?>


                    <!-- Decision Buttons -->

                    <button
                        name="decision"
                        value="Approved"
                    >
                        Approve
                    </button>


                    <button
                        class="danger"
                        name="decision"
                        value="Rejected"
                    >
                        Reject
                    </button>


                </form>


            </div>


            <!-- Bottom Navigation -->

            <?php if ($totalRequests > 1): ?>

                <div class="student-navigation bottom-navigation">


                    <?php if ($currentPage > 1): ?>

                        <a
                            href="officer_requests.php?page=<?php echo $currentPage - 1; ?>"
                            class="nav-button"
                        >
                            ← Previous Student
                        </a>

                    <?php else: ?>

                        <span class="nav-button nav-disabled">
                            ← Previous Student
                        </span>

                    <?php endif; ?>


                    <div class="student-counter">

                        Student
                        <?php echo $currentPage; ?>
                        of
                        <?php echo $totalRequests; ?>

                    </div>


                    <?php if ($currentPage < $totalRequests): ?>

                        <a
                            href="officer_requests.php?page=<?php echo $currentPage + 1; ?>"
                            class="nav-button"
                        >
                            Next Student →
                        </a>

                    <?php else: ?>

                        <span class="nav-button nav-disabled">
                            Next Student →
                        </span>

                    <?php endif; ?>


                </div>

            <?php endif; ?>


        <?php else: ?>


            <!-- No Pending Requests -->

            <p>
                No requests are currently assigned to your authorized queue.
            </p>


        <?php endif; ?>


    </div>

</section>


<style>

.student-navigation {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 15px;

    margin: 20px 0 25px;
    padding: 15px;

    border: 1px solid #ddd;
    border-radius: 8px;

    background: #f8f9fa;
}


.nav-button {
    display: inline-block;

    padding: 10px 18px;

    border-radius: 6px;

    background: #343a40;
    color: #ffffff;

    text-decoration: none;

    font-weight: 600;

    transition: opacity 0.2s ease;
}


.nav-button:hover {
    opacity: 0.85;
}


.nav-disabled {
    background: #cccccc;
    color: #777777;

    cursor: not-allowed;

    pointer-events: none;
}


.student-counter {
    font-weight: 700;
    white-space: nowrap;

    color: #333333;
}


.bottom-navigation {
    margin-top: 25px;
}



@media (max-width: 600px) {

    .student-navigation {
        flex-direction: column;
        text-align: center;
    }


    .nav-button {
        width: 100%;
        text-align: center;
        box-sizing: border-box;
    }


    .student-counter {
        order: -1;
    }

}

</style>


<?php require_once __DIR__ . '/includes/footer.php'; ?>