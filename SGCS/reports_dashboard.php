<?php

require_once __DIR__ . '/includes/auth.php';
require_once __DIR__ . '/includes/clearance_functions.php';

require_login();

$current = current_user();
$role = strtolower(trim((string)($current['role'] ?? '')));

/*
 * Library, Finance and University Store reports may be used by the
 * dedicated role names as well as a normal departmental officer whose
 * account is assigned to one of those departments.
 */
$assignedReportDepartment = get_assigned_department($pdo, $current);
$assignedReportDepartmentName = strtolower(trim((string)($assignedReportDepartment['dept_name'] ?? '')));

$isDirector = ($role === 'director');
$isSchoolDean = ($role === 'dean');
$isGeneralReportUser = in_array($role, ['admin', 'registrar'], true);
$isDepartmentReportUser =
    in_array($role, ['librarian', 'finance_officer', 'university_store'], true)
    || in_array($assignedReportDepartmentName, ['library', 'finance office', 'university store office'], true);

if (!$isDirector && !$isSchoolDean && !$isGeneralReportUser && !$isDepartmentReportUser) {
    http_response_code(403);
    exit('Not authorized.');
}

/* FILTERS*/

$status = clean_input($_GET['status'] ?? '');

$allowedStatuses = ['', 'Pending', 'Approved', 'Rejected'];

if (!in_array($status, $allowedStatuses, true)) {
    $status = '';
}

$assignedReportDepartment = $isDepartmentReportUser
    ? ($assignedReportDepartment ?: get_assigned_department($pdo, $current))
    : null;

$departmentId = $isGeneralReportUser
    ? (int)($_GET['department_id'] ?? 0)
    : ($isDepartmentReportUser
        ? (int)($assignedReportDepartment['dept_id'] ?? $current['department_id'] ?? 0)
        : 0);

$search = trim(clean_input($_GET['search'] ?? ''));

$schoolId = $isGeneralReportUser
    ? (int)($_GET['school_id'] ?? 0)
    : 0;

$instituteId = $isGeneralReportUser
    ? (int)($_GET['institute_id'] ?? 0)
    : 0;

$programmeId = $isGeneralReportUser
    ? (int)($_GET['programme_id'] ?? 0)
    : 0;

$graduationSetId = $isGeneralReportUser || $isDepartmentReportUser || $isSchoolDean || $isDirector
    ? (int)($_GET['graduation_set_id'] ?? 0)
    : 0;

$dateFrom = trim($_GET['date_from'] ?? '');
$dateTo = trim($_GET['date_to'] ?? '');

if ($dateFrom && !preg_match('/^\d{4}-\d{2}-\d{2}$/', $dateFrom)) {
    $dateFrom = '';
}

if ($dateTo && !preg_match('/^\d{4}-\d{2}-\d{2}$/', $dateTo)) {
    $dateTo = '';
}

/*REPORT FILTER DATA*/

$departments = get_departments($pdo);

$schools = $pdo->query(
    'SELECT school_id, school_name
     FROM schools
     ORDER BY school_name'
)->fetchAll(PDO::FETCH_ASSOC);

$institutes = $pdo->query(
    'SELECT institute_id, institute_name
     FROM institutes
     ORDER BY institute_name'
)->fetchAll(PDO::FETCH_ASSOC);

$programmes = $pdo->query(
    'SELECT programme_id, programme_name
     FROM programmes
     ORDER BY programme_name'
)->fetchAll(PDO::FETCH_ASSOC);

$graduationSets = $pdo->query(
    'SELECT graduation_set_id, set_name, graduation_year
     FROM graduation_sets
     ORDER BY graduation_year DESC, set_name ASC'
)->fetchAll(PDO::FETCH_ASSOC);

/*SUMMARY CARDS*/

$summary = get_clearance_report_summary($pdo, $current);

/* DETAILS*/

$detailsRequestId = (int)($_GET['details'] ?? 0);

$detailRows = [];

if ($detailsRequestId > 0) {
    $detailRows = get_clearance_request_latest_reviews(
        $pdo,
        $detailsRequestId,
        $current
    );
}

/* GET REPORT ROWS*/


if ($isDirector) {

    $rows = get_director_clearance_report_summary_rows(
        $pdo,
        $current,
        $status
    );

} else {

    $rawRows = get_clearance_report_rows_v3(
        $pdo,
        $current,
        '',
        $departmentId
    );

    
    $grouped = [];

    foreach ($rawRows as $row) {

        $requestId = (int)($row['request_id'] ?? 0);

        if ($requestId <= 0) {
            continue;
        }

        if (!isset($grouped[$requestId])) {

            $grouped[$requestId] = [
                'request_id' => $requestId,

                'student_name' => $row['student_name'] ?? '',

                'registration_no' => $row['registration_no'] ?? '',

                'programme' => $row['programme'] ?? '',

                'graduation_set_id' => (int)($row['graduation_set_id'] ?? 0),

                'graduation_set_name' => $row['graduation_set_name'] ?? '',

                'school_id' => (int)($row['school_id'] ?? 0),

                'institute_id' => (int)($row['institute_id'] ?? 0),

                'institute_name' => $row['institute_name'] ?? '',

                'overall_status' => $row['overall_status']
                    ?? $row['approval_status']
                    ?? 'Pending',

                'approved_count' => 0,

                'total_departments' => 0,

                'last_action_at' => '',

                'departments' => []
            ];
        }

       
        $deptId = (int)($row['dept_id'] ?? 0);

        $deptName = trim((string)($row['dept_name'] ?? ''));

        if ($deptName === '') {
            $deptName = 'None';
        }

        $deptKey = $deptId > 0
            ? 'id_' . $deptId
            : 'name_' . strtolower($deptName);

        if (!isset($grouped[$requestId]['departments'][$deptKey])) {

            $approvalStatus = trim(
                (string)(
                    $row['approval_status']
                    ?? $row['status']
                    ?? 'Pending'
                )
            );

            if ($approvalStatus === '') {
                $approvalStatus = 'Pending';
            }

            $decidedAt = $row['decided_at']
                ?? $row['assigned_at']
                ?? '';

            $grouped[$requestId]['departments'][$deptKey] = [
                'dept_id' => $deptId,
                'dept_name' => $deptName,
                'status' => $approvalStatus,
                'officer_name' => $row['officer_name'] ?? '',
                'comments' => $row['comments'] ?? '',
                'decided_at' => $row['decided_at'] ?? '',
                'assigned_at' => $row['assigned_at'] ?? '',
                'action_at' => $decidedAt
            ];
        }
    }

    
    $rows = [];

    foreach ($grouped as $request) {

        $approvedCount = 0;
        $totalDepartments = 0;
        $lastAction = '';

        foreach ($request['departments'] as $dept) {

            $totalDepartments++;

            if (strcasecmp(
                trim((string)$dept['status']),
                'Approved'
            ) === 0) {
                $approvedCount++;
            }

            $actionAt = trim((string)($dept['action_at'] ?? ''));

            if ($actionAt !== '') {

                if (
                    $lastAction === '' ||
                    strcmp($actionAt, $lastAction) > 0
                ) {
                    $lastAction = $actionAt;
                }
            }
        }

        
        if ($totalDepartments === 0) {
            $totalDepartments = count($departments);
        }

        
        $overallStatus = trim(
            (string)($request['overall_status'] ?? 'Pending')
        );

        if ($isDepartmentReportUser && !empty($request['departments'])) {
            $firstDepartment = reset($request['departments']);
            $overallStatus = trim((string)($firstDepartment['status'] ?? 'Pending'));
            if ($overallStatus === '') {
                $overallStatus = 'Pending';
            }
        } elseif ($approvedCount > 0 && $totalDepartments > 0) {
            if ($approvedCount >= $totalDepartments) {
                $overallStatus = 'Approved';
            }
        }

        $rows[] = [
            'request_id' => $request['request_id'],

            'student_name' => $request['student_name'],

            'registration_no' => $request['registration_no'],

            'programme' => $request['programme'],

            'graduation_set_id' => $request['graduation_set_id'],

            'graduation_set_name' => $request['graduation_set_name'],

            'school_id' => $request['school_id'],

            'institute_id' => $request['institute_id'],

            'institute_name' => $request['institute_name'],

            'approved_count' => $approvedCount,

            'total_departments' => $totalDepartments,

            'overall_status' => $overallStatus,

            'last_action_at' => $lastAction,

            'departments' => $request['departments']
        ];
    }
}

/*COMMON EXTRA FILTERING*/

$rows = array_values(
    array_filter(
        $rows,
        function ($row) use (
            $search,
            $schoolId,
            $instituteId,
            $programmeId,
            $graduationSetId,
            $dateFrom,
            $dateTo,
            $status
        ) {

            /* Search*/
            if ($search !== '') {

                $needle = mb_strtolower($search);

                $haystack = mb_strtolower(
                    ($row['student_name'] ?? '') . ' ' .
                    ($row['registration_no'] ?? '')
                );

                if (mb_strpos($haystack, $needle) === false) {
                    return false;
                }
            }

            /*School*/
            if (
                $schoolId &&
                (int)($row['school_id'] ?? 0) !== $schoolId
            ) {
                return false;
            }

            /*Institute*/
            if (
                $instituteId &&
                (int)($row['institute_id'] ?? 0) !== $instituteId
            ) {
                return false;
            }

            
            if (
                $programmeId &&
                (int)($row['programme_id'] ?? 0) !== $programmeId
            ) {
                
                return false;
            }

            
            if (
                $graduationSetId &&
                (int)($row['graduation_set_id'] ?? 0) !== $graduationSetId
            ) {
                return false;
            }

           
            if (
                $status !== '' &&
                strcasecmp(
                    trim((string)($row['overall_status'] ?? '')),
                    $status
                ) !== 0
            ) {
                return false;
            }

           
            $actionDate = substr(
                (string)(
                    $row['last_action_at']
                    ?? $row['decided_at']
                    ?? $row['assigned_at']
                    ?? ''
                ),
                0,
                10
            );

            if (
                $dateFrom !== '' &&
                (
                    $actionDate === '' ||
                    $actionDate < $dateFrom
                )
            ) {
                return false;
            }

            if (
                $dateTo !== '' &&
                (
                    $actionDate === '' ||
                    $actionDate > $dateTo
                )
            ) {
                return false;
            }

            return true;
        }
    )
);


if ($isDepartmentReportUser || $isSchoolDean || $isDirector || $isGeneralReportUser) {

    $summary = [
        'Pending' => 0,
        'Approved' => 0,
        'Rejected' => 0
    ];

    if ($isDepartmentReportUser) {

        
        $officerDepartment = get_assigned_department(
            $pdo,
            $current
        );

        if ($officerDepartment) {
            $summary = get_review_counts(
                $pdo,
                $officerDepartment,
                $current
            );
        }

    } else {

       
         /* Director reports are already restricted to their Institute.
          Dean reports are already restricted to their School.
         */
        foreach ($rows as $reportRow) {

            $reportStatus = trim(
                (string)($reportRow['overall_status'] ?? 'Pending')
            );

            if (isset($summary[$reportStatus])) {
                $summary[$reportStatus]++;
            }
        }
    }
}

function report_query($overrides = [])
{
    $params = array_merge($_GET, $overrides);

    foreach ($params as $k => $v) {

        if (
            $v === '' ||
            $v === 0 ||
            $v === '0' ||
            $k === 'details'
        ) {
            unset($params[$k]);
        }
    }

    return http_build_query($params);
}


$page_title = 'Clearance Reports';

require_once __DIR__ . '/includes/header.php';

?>

<style>



.report-summary-table {
    width: 100%;
    min-width: 1100px;
    border-collapse: collapse;
}

.report-summary-table th {
    background: #292928;
    color: #ffffff;
    font-weight: 700;
    padding: 16px 14px;
    text-align: left;
    white-space: nowrap;
}

.report-summary-table td {
    padding: 18px 14px;
    border-bottom: 1px solid #ddd;
    vertical-align: middle;
    white-space: nowrap;
}

.report-summary-table tbody tr:hover {
    background: #fafafa;
}

/*VIEW DETAILS BUTTON*/

.report-view-details {
    display: inline-block;
    background: #d90000;
    color: #ffffff !important;
    text-decoration: none;
    padding: 12px 22px;
    border-radius: 8px;
    font-weight: 700;
    white-space: nowrap;
}

.report-view-details:hover {
    background: #b80000;
    color: #ffffff !important;
}

/*DETAILS TABLE*/

.report-details-table {
    width: 100%;
    border-collapse: collapse;
}

.report-details-table th {
    background: #292928;
    color: #ffffff;
    padding: 14px;
    text-align: left;
}

.report-details-table td {
    padding: 14px;
    border-bottom: 1px solid #ddd;
    vertical-align: top;
}

.report-details-table td:nth-child(4) {
    white-space: normal;
    min-width: 250px;
}

/*HORIZONTAL SCROLLING*/

.report-table-scroll {
    width: 100%;
    overflow-x: auto;
    overflow-y: hidden;
    -webkit-overflow-scrolling: touch;
}


/* Report cards */
.report-status-cards {
    grid-template-columns: repeat(4, 1fr);
}

/* Departmental report cards: keep the four summary cards on one row. */
.department-report-status-cards {
    grid-template-columns: repeat(4, 1fr);
}

.report-status-card.total-card {
    background: #f1f1f1;
    border-left: 5px solid #666;
}

@media (max-width: 800px) {
    .department-report-status-cards {
        grid-template-columns: 1fr;
    }
}

</style>

<section class="dashboard">

    <!-- HEADER -->

    <div class="dashboard-top">

        <div>

            <?php
            $reportTitle = 'Clearance Reports';
            if ($isDepartmentReportUser) {
                if ($role === 'librarian' || $assignedReportDepartmentName === 'library') {
                    $reportTitle = 'Library Reports';
                } elseif ($role === 'finance_officer' || $assignedReportDepartmentName === 'finance office') {
                    $reportTitle = 'Finance Reports';
                } else {
                    $reportTitle = 'University Store Reports';
                }
            }
            ?>
            <h1><?php echo htmlspecialchars($reportTitle); ?></h1>

            <p>
                Filter clearance records within your authorized scope.
            </p>

        </div>

        <a href="<?php echo BASE_URL; ?>dashboard.php">
            ← Back to dashboard
        </a>

    </div>


    <!-- STATUS CARDS -->

    <div class="report-status-cards">

        <div class="report-status-card pending-card">

            <div class="report-card-title">
                Pending
            </div>

            <div class="report-card-number">
                <?php echo (int)($summary['Pending'] ?? 0); ?>
            </div>

        </div>


        <div class="report-status-card rejected-card">

            <div class="report-card-title">
                Rejected
            </div>

            <div class="report-card-number">
                <?php echo (int)($summary['Rejected'] ?? 0); ?>
            </div>

        </div>


        <div class="report-status-card approved-card">

            <div class="report-card-title">
                Approved
            </div>

            <div class="report-card-number">
                <?php echo (int)($summary['Approved'] ?? 0); ?>
            </div>

        </div>

        <div class="report-status-card total-card">

                <div class="report-card-title">
                    Total Results
                </div>

                <div class="report-card-number">
                    <?php echo count($rows); ?>
                </div>

        </div>

    </div>


    <!-- FILTERS -->

    <div class="dashboard-box report-filter-box">

        <h2>Filter Report</h2>

        <form class="filter-form" method="get">

            <div class="form-group">

                <label>Search</label>

                <input
                    type="text"
                    name="search"
                    value="<?php echo htmlspecialchars($search); ?>"
                    placeholder="Student name or registration number"
                >

            </div>


            <div class="form-group">

                <label>Status</label>

                <select name="status">

                    <option value="">
                        All Statuses
                    </option>

                    <?php foreach (
                        ['Pending', 'Approved', 'Rejected']
                        as $o
                    ): ?>

                        <option
                            value="<?php echo htmlspecialchars($o); ?>"
                            <?php echo $status === $o ? 'selected' : ''; ?>
                        >
                            <?php echo htmlspecialchars($o); ?>
                        </option>

                    <?php endforeach; ?>

                </select>

            </div>


            <?php if ($isGeneralReportUser): ?>

                <div class="form-group">

                    <label>School</label>

                    <select name="school_id">

                        <option value="0">
                            All Schools
                        </option>

                        <?php foreach ($schools as $x): ?>

                            <option
                                value="<?php echo (int)$x['school_id']; ?>"
                                <?php
                                echo $schoolId === (int)$x['school_id']
                                    ? 'selected'
                                    : '';
                                ?>
                            >
                                <?php
                                echo htmlspecialchars(
                                    $x['school_name']
                                );
                                ?>
                            </option>

                        <?php endforeach; ?>

                    </select>

                </div>


                <div class="form-group">

                    <label>Institute</label>

                    <select name="institute_id">

                        <option value="0">
                            All Institutes
                        </option>

                        <?php foreach ($institutes as $x): ?>

                            <option
                                value="<?php echo (int)$x['institute_id']; ?>"
                                <?php
                                echo $instituteId === (int)$x['institute_id']
                                    ? 'selected'
                                    : '';
                                ?>
                            >
                                <?php
                                echo htmlspecialchars(
                                    $x['institute_name']
                                );
                                ?>
                            </option>

                        <?php endforeach; ?>

                    </select>

                </div>


                <div class="form-group">

                    <label>Programme</label>

                    <select name="programme_id">

                        <option value="0">
                            All Programmes
                        </option>

                        <?php foreach ($programmes as $x): ?>

                            <option
                                value="<?php echo (int)$x['programme_id']; ?>"
                                <?php
                                echo $programmeId === (int)$x['programme_id']
                                    ? 'selected'
                                    : '';
                                ?>
                            >
                                <?php
                                echo htmlspecialchars(
                                    $x['programme_name']
                                );
                                ?>
                            </option>

                        <?php endforeach; ?>

                    </select>

                </div>


                <div class="form-group">

                    <label>Department</label>

                    <select name="department_id">

                        <option value="0">
                            All Departments
                        </option>

                        <?php foreach ($departments as $x): ?>

                            <option
                                value="<?php echo (int)$x['dept_id']; ?>"
                                <?php
                                echo $departmentId === (int)$x['dept_id']
                                    ? 'selected'
                                    : '';
                                ?>
                            >
                                <?php
                                echo htmlspecialchars(
                                    $x['dept_name']
                                );
                                ?>
                            </option>

                        <?php endforeach; ?>

                    </select>

                </div>

            <?php endif; ?>


            <?php if ($isGeneralReportUser || $isDepartmentReportUser || $isSchoolDean || $isDirector): ?>

                <div class="form-group">

                    <label>Graduation Set</label>

                    <select name="graduation_set_id">

                        <option value="0">
                            All Graduation Sets
                        </option>

                        <?php foreach ($graduationSets as $x): ?>

                            <option
                                value="<?php echo (int)$x['graduation_set_id']; ?>"
                                <?php echo $graduationSetId === (int)$x['graduation_set_id'] ? 'selected' : ''; ?>
                            >
                                <?php echo htmlspecialchars($x['set_name'] . ' (' . $x['graduation_year'] . ')'); ?>
                            </option>

                        <?php endforeach; ?>

                    </select>

                </div>

            <?php endif; ?>


            <div class="form-group">

                <label>From</label>

                <input
                    type="date"
                    name="date_from"
                    value="<?php echo htmlspecialchars($dateFrom); ?>"
                >

            </div>


            <div class="form-group">

                <label>To</label>

                <input
                    type="date"
                    name="date_to"
                    value="<?php echo htmlspecialchars($dateTo); ?>"
                >

            </div>


            <button type="submit">
                Apply Filters
            </button>

            <a
                class="button secondary"
                href="<?php echo BASE_URL; ?>reports_dashboard.php"
            >
                Reset
            </a>

        </form>

    </div>


    <!-- DETAILS -->

    <?php if ($detailsRequestId > 0): ?>

        <div class="dashboard-box">

            <div class="dashboard-top">

                <div>

                    <h2>
                        Department Clearance Details
                    </h2>

                    <p>
                        Latest decision for each department.
                    </p>

                </div>


                <a
                    href="<?php
                    echo BASE_URL;
                    ?>reports_dashboard.php?<?php
                    echo htmlspecialchars(report_query());
                    ?>"
                >
                    ← Back to Summary
                </a>

            </div>


            <?php if ($detailRows): ?>

                <div class="report-table-scroll">

                    <table class="report-details-table">

                        <thead>

                            <tr>

                                <th>
                                    Department
                                </th>

                                <th>
                                    Status
                                </th>

                                <th>
                                    Officer
                                </th>

                                <th>
                                    Comment
                                </th>

                                <th>
                                    Date
                                </th>

                            </tr>

                        </thead>


                        <tbody>

                            <?php foreach ($detailRows as $d): ?>

                                <tr>

                                    <td>

                                        <?php
                                        $detailDepartment =
                                            trim(
                                                (string)(
                                                    $d['dept_name']
                                                    ?? ''
                                                )
                                            );

                                        echo htmlspecialchars(
                                            $detailDepartment !== ''
                                                ? $detailDepartment
                                                : 'None'
                                        );
                                        ?>

                                    </td>


                                    <td>

                                        <?php
                                        echo htmlspecialchars(
                                            $d['status']
                                            ?? 'Pending'
                                        );
                                        ?>

                                    </td>


                                    <td>

                                        <?php

                                        $officerName =
                                            trim(
                                                (string)(
                                                    $d['officer_name']
                                                    ?? ''
                                                )
                                            );

                                        echo htmlspecialchars(
                                            $officerName !== ''
                                                ? $officerName
                                                : 'Not yet assigned'
                                        );

                                        ?>

                                    </td>


                                    <td>

                                        <?php

                                        $comment =
                                            trim(
                                                (string)(
                                                    $d['comments']
                                                    ?? ''
                                                )
                                            );

                                        echo htmlspecialchars(
                                            $comment !== ''
                                                ? $comment
                                                : '—'
                                        );

                                        ?>

                                    </td>


                                    <td>

                                        <?php

                                        $detailDate =
                                            $d['decided_at']
                                            ?? $d['assigned_at']
                                            ?? '';

                                        echo htmlspecialchars(
                                            $detailDate !== ''
                                                ? $detailDate
                                                : '—'
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
                    This request is not available in your authorized scope.
                </p>

            <?php endif; ?>

        </div>

    <?php endif; ?>


    <!-- SUMMARY REPORT -->

    <div class="dashboard-box">

        <h2>
            Clearance Progress Summary
        </h2>

        <p>
            <strong>
                <?php echo count($rows); ?>
            </strong>
            record(s) match the selected filters.
        </p>


        <?php if ($rows): ?>

            <div class="report-table-scroll">

                <table class="report-summary-table">

                    <thead>

                        <tr>

                            <th>
                                #
                            </th>

                            <th>
                                Student
                            </th>

                            <th>
                                Registration
                            </th>

                            <th>
                                Programme
                            </th>

                            <th>
                                Progress
                            </th>

                            <th>
                                Status
                            </th>

                            <th>
                                Last Action
                            </th>

                            <th>
                                Action
                            </th>

                        </tr>

                    </thead>


                    <tbody>

                        <?php foreach ($rows as $i => $r): ?>

                            <tr>

                                <td>
                                    <?php echo $i + 1; ?>
                                </td>


                                <td>
                                    <?php
                                    echo htmlspecialchars(
                                        $r['student_name'] ?? ''
                                    );
                                    ?>
                                </td>


                                <td>
                                    <?php
                                    echo htmlspecialchars(
                                        $r['registration_no'] ?? ''
                                    );
                                    ?>
                                </td>


                                <td>
                                    <?php

                                    $programme =
                                        trim(
                                            (string)(
                                                $r['programme']
                                                ?? ''
                                            )
                                        );

                                    echo htmlspecialchars(
                                        $programme !== ''
                                            ? $programme
                                            : 'None'
                                    );

                                    ?>
                                </td>


                                <td>

                                    <?php

                                    $approved =
                                        (int)(
                                            $r['approved_count']
                                            ?? 0
                                        );

                                    $total =
                                        (int)(
                                            $r['total_departments']
                                            ?? 0
                                        );

                                    echo $approved . '/' . $total;
                                    ?>

                                    Approved

                                </td>


                                <td>

                                    <?php

                                    echo htmlspecialchars(
                                        $r['overall_status']
                                        ?? 'Pending'
                                    );

                                    ?>

                                </td>


                                <td>

                                    <?php

                                    $lastAction =
                                        trim(
                                            (string)(
                                                $r['last_action_at']
                                                ?? ''
                                            )
                                        );

                                    echo htmlspecialchars(
                                        $lastAction !== ''
                                            ? $lastAction
                                            : '—'
                                    );

                                    ?>

                                </td>


                                <td>

                                    <a
                                        class="report-view-details"
                                        href="<?php
                                        echo htmlspecialchars(
                                            BASE_URL .
                                            'reports_dashboard.php?details=' .
                                            (int)$r['request_id'] .
                                            '&' .
                                            report_query()
                                        );
                                        ?>"
                                    >
                                        View Details
                                    </a>

                                </td>

                            </tr>

                        <?php endforeach; ?>

                    </tbody>

                </table>

            </div>

        <?php else: ?>

            <p>
                No clearance records match the selected filters.
            </p>

        <?php endif; ?>

    </div>

</section>


<?php

require_once __DIR__ . '/includes/footer.php';

?>