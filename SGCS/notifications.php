<?php

require_once __DIR__ . '/includes/auth.php';

require_login();

require_once __DIR__ . '/includes/clearance_functions.php';


/*CURRENT USER*/

$userId = (int) ($_SESSION['user_id'] ?? 0);


/*MARK ALL NOTIFICATIONS AS READ*/

if (isset($_GET['mark_read']) && $userId > 0) {

    try {

        $stmt = $pdo->prepare(
            'UPDATE notifications
             SET is_read = 1
             WHERE recipient_user_id = ?
             AND is_read = 0'
        );

        $stmt->execute([
            $userId
        ]);

        log_audit(
            $pdo,
            $userId,
            'notifications_marked_read',
            'User marked all notifications as read.'
        );

    } catch (PDOException $e) {

        error_log(
            'Notification mark read error: '
            . $e->getMessage()
        );

    }

    header(
        'Location: '
        . BASE_URL
        . 'notifications.php'
    );

    exit;
}


/*GET NOTIFICATIONS*/

$notifications = [];

try {

    /*Get the newest notifications first.*/

    $stmt = $pdo->prepare(
        'SELECT
            notif_id,
            recipient_user_id,
            notif_type,
            message,
            is_read,
            sent_at
         FROM notifications
         WHERE recipient_user_id = ?
         ORDER BY notif_id DESC
         LIMIT 50'
    );

    $stmt->execute([
        $userId
    ]);

    $notifications = $stmt->fetchAll(
        PDO::FETCH_ASSOC
    );

} catch (PDOException $e) {

    error_log(
        'Notification retrieval error: '
        . $e->getMessage()
    );

}


/* PAGE TITLE*/

$page_title = 'Notifications';


require_once __DIR__ . '/includes/header.php';

?>


<section class="dashboard">


    <!-- PAGE HEADER -->

    <div class="dashboard-top">

        <div>

            <h1>Notifications</h1>

            <p>
                View your latest system notifications.
            </p>

        </div>


        <a href="<?php echo BASE_URL; ?>dashboard.php">

            Back to dashboard

        </a>

    </div>



    <div class="dashboard-box">


        <!-- ACTIONS-->

        <?php if ($notifications): ?>

            <div class="action-row">

                <a
                    class="button small"
                    href="<?php echo BASE_URL; ?>notifications.php?mark_read=1"
                >

                    Mark all as read

                </a>

            </div>

        <?php endif; ?>



        <!-- NOTIFICATION LIST -->

        <?php if ($notifications): ?>


            <ul class="notification-list">


                <?php foreach ($notifications as $notification): ?>


                    <li
                        class="<?php
                            echo ((int) $notification['is_read'] === 0)
                                ? 'notification-unread'
                                : 'notification-read';
                        ?>"
                    >


                        <!-- Notification Type -->

                        <strong>

                            <?php

                            echo htmlspecialchars(
                                ucwords(
                                    str_replace(
                                        '_',
                                        ' ',
                                        $notification['notif_type']
                                    )
                                )
                            );

                            ?>

                        </strong>



                        <!-- Notification Message -->

                        <span class="notification-message">

                            <?php

                            echo htmlspecialchars(
                                $notification['message']
                            );

                            ?>

                        </span>



                        <!-- Notification Date -->

                        <small>

                            <?php

                            echo htmlspecialchars(
                                $notification['sent_at']
                            );

                            ?>

                            -

                            <?php

                            echo ((int) $notification['is_read'] === 1)
                                ? 'Read'
                                : 'New';

                            ?>

                        </small>


                    </li>


                <?php endforeach; ?>


            </ul>


        <?php else: ?>


            <!-- No Notifications -->

            <div class="empty-state">

                <p>
                    No notifications yet.
                </p>

            </div>


        <?php endif; ?>


    </div>


</section>



<style>

/*
|--------------------------------------------------------------------------
| NOTIFICATION LIST
|--------------------------------------------------------------------------
*/

.notification-list {

    list-style: none;

    padding: 0;

    margin: 20px 0;

}


.notification-list li {

    display: flex;

    flex-direction: column;

    gap: 8px;

    padding: 18px;

    margin-bottom: 12px;

    border: 1px solid #ddd;

    border-radius: 8px;

    background: #fff;

}


/*
|--------------------------------------------------------------------------
| UNREAD NOTIFICATIONS
|--------------------------------------------------------------------------
*/

.notification-unread {

    border-left: 5px solid #333;

    font-weight: 500;

}


.notification-unread strong {

    font-weight: 700;

}


/*
|--------------------------------------------------------------------------
| READ NOTIFICATIONS
|--------------------------------------------------------------------------
*/

.notification-read {

    opacity: 0.75;

}


/*
|--------------------------------------------------------------------------
| MESSAGE
|--------------------------------------------------------------------------
*/

.notification-message {

    display: block;

    line-height: 1.5;

}


/*
|--------------------------------------------------------------------------
| DATE
|--------------------------------------------------------------------------
*/

.notification-list small {

    color: #666;

}


/*
|--------------------------------------------------------------------------
| EMPTY STATE
|--------------------------------------------------------------------------
*/

.empty-state {

    padding: 30px;

    text-align: center;

    border: 1px dashed #ccc;

    border-radius: 8px;

}


/*
|--------------------------------------------------------------------------
| MOBILE
|--------------------------------------------------------------------------
*/

@media (max-width: 600px) {

    .notification-list li {

        padding: 15px;

    }

}

</style>


<?php

require_once __DIR__ . '/includes/footer.php';

?>