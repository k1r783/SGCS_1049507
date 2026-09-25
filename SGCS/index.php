<?php
$page_title = 'Home';
require_once __DIR__ . '/includes/header.php';
?>

<section class="hero">
    <div>
        <h1>Students Graduation Clearance System</h1>
        <p>
            A simple online system for Tangaza University students to start graduation
            clearance, follow departmental approval progress, and receive final registrar clearance.
        </p>
        <?php if (is_logged_in()): ?>
            <a class="button" href="<?php echo BASE_URL; ?>dashboard.php">Go to Dashboard</a>
        <?php else: ?>
            <a class="button" href="<?php echo BASE_URL; ?>login.php">Login to Continue</a>
        <?php endif; ?>
    </div>
    <div class="hero-panel">
        <h2>Clearance Workflow</h2>
        <ol class="workflow-list">
            <li>Institute Director</li>
            <li>Library</li>
            <li>Finance Office</li>
            <li>Dean</li>
            <li>University Store</li>
            <li>Academic Registrar</li>
        </ol>
    </div>
</section>

<section class="page-section">
    <div class="cards">
        <article class="card">
            <h3>Students</h3>
            <p>Initiate clearance online and monitor the status of each department.</p>
        </article>
        <article class="card">
            <h3>Officers</h3>
            <p>Review assigned clearance requests and record approval or rejection comments.</p>
        </article>
        <article class="card">
            <h3>Registrar</h3>
            <p>Track institution-wide progress and confirm students who are fully cleared.</p>
        </article>
    </div>
</section>

<?php require_once __DIR__ . '/includes/footer.php'; ?>
