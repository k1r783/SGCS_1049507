<?php

require_once __DIR__ . '/../includes/auth.php';

require_role('registrar');

require_once __DIR__ . '/../includes/clearance_functions.php';


$department = get_assigned_department(
    $pdo,
    current_user()
);

$summary = get_clearance_summary($pdo);

$notifications = get_notifications(
    $pdo,
    $_SESSION['user_id'],
    4
);

$page_title = 'Registrar Dashboard';

require_once __DIR__ . '/../includes/header.php';

?>

<section class="dashboard">

    <div class="dashboard-top">

        <div>

            <h1>Mark Barasa Wamalwa</h1>

            <p>
                Welcome, Mark Barasa Wamalwa.
            </p>

        </div>

        <span class="badge">

            <?php
            echo role_label($_SESSION['role']);
            ?>

        </span>

    </div>


    <div class="dashboard-box">


        <h2>Final Clearance and Reports</h2>

        <p>
            The Registrar is the final approval stage and issues
            Final Approval after all prior departments approve.
        </p>


        <div class="action-row">


            <!-- Pending Requests -->

            <a
                class="button"
                href="<?php echo BASE_URL; ?>officer_requests.php"
            >
                Pending Requests
            </a>


            <!-- Approval History -->

            <a
                class="button secondary"
                href="<?php echo BASE_URL; ?>officer_history.php"
            >
                Approval History
            </a>


            <!-- Transcript Upload -->

            <a
                class="button secondary"
                href="<?php echo BASE_URL; ?>registrar_transcripts.php"
            >
                Transcript Upload
            </a>


            <!-- Student Classifications -->

            <a
                class="button secondary"
                href="<?php echo BASE_URL; ?>registrar_classifications.php"
            >
                Student Classifications
            </a>


            <!-- Reports -->

            <a
                class="button secondary"
                href="<?php echo BASE_URL; ?>reports_dashboard.php"
            >
                Reports
            </a>


            <!-- Notifications -->

            <a
                class="button secondary"
                href="<?php echo BASE_URL; ?>notifications.php"
            >
                Notifications
            </a>


            <!-- Audit Trail -->

            <a
                class="button secondary"
                href="<?php echo BASE_URL; ?>audit_trail.php"
            >
                Audit Trail
            </a>


        </div>



        <!--  CLEARANCE SUMMARY-->

        <h2>Clearance Summary</h2>


        <div class="summary-row">

            <?php foreach ($summary as $item): ?>

                <div>

                    <strong>

                        <?php
                        echo htmlspecialchars(
                            $item['overall_status']
                        );
                        ?>

                    </strong>


                    <span>

                        <?php
                        echo htmlspecialchars(
                            $item['total']
                        );
                        ?>

                    </span>

                </div>

            <?php endforeach; ?>

        </div>



       

        <h2>Recent Notifications</h2>


        <?php if ($notifications): ?>


            <ul class="simple-list">

                <?php foreach ($notifications as $notification): ?>

                    <li>

                        <?php
                        echo htmlspecialchars(
                            $notification['message']
                        );
                        ?>

                    </li>

                <?php endforeach; ?>

            </ul>


        <?php else: ?>


            <p>
                No notifications yet.
            </p>


        <?php endif; ?>


    </div>

</section>


<?php require_once __DIR__ . '/../includes/footer.php'; ?>