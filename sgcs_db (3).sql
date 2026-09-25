-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Sep 10, 2026 at 12:15 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `sgcs_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `approval_records`
--

CREATE TABLE `approval_records` (
  `approval_id` int(11) NOT NULL,
  `request_id` int(11) NOT NULL,
  `dept_id` int(11) NOT NULL,
  `officer_id` int(11) DEFAULT NULL,
  `officer_institute_id` int(11) DEFAULT NULL,
  `status` enum('Pending','Approved','Rejected') NOT NULL DEFAULT 'Pending',
  `comments` text DEFAULT NULL,
  `assigned_at` datetime NOT NULL DEFAULT current_timestamp(),
  `decided_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `approval_records`
--

INSERT INTO `approval_records` (`approval_id`, `request_id`, `dept_id`, `officer_id`, `officer_institute_id`, `status`, `comments`, `assigned_at`, `decided_at`) VALUES
(1, 1, 1, 4, NULL, 'Approved', 'Director approval granted.', '2026-06-20 09:00:00', '2026-06-20 11:00:00'),
(2, 1, 2, 5, NULL, 'Approved', 'No outstanding library books.', '2026-06-20 09:00:00', '2026-06-21 10:00:00'),
(3, 1, 3, 6, NULL, 'Rejected', 'No fee structure', '2026-06-20 09:00:00', '2026-08-22 18:40:08'),
(4, 1, 4, NULL, NULL, 'Pending', NULL, '2026-06-20 09:00:00', NULL),
(5, 1, 5, NULL, NULL, 'Pending', NULL, '2026-06-20 09:00:00', NULL),
(6, 1, 6, NULL, NULL, 'Pending', NULL, '2026-06-20 09:00:00', NULL),
(7, 2, 1, 4, NULL, 'Approved', 'Director approval granted.', '2026-06-18 10:30:00', '2026-06-18 12:00:00'),
(8, 2, 2, 5, NULL, 'Rejected', 'Student has an outstanding library fine.', '2026-06-18 10:30:00', '2026-06-19 09:15:00'),
(9, 2, 3, NULL, NULL, 'Pending', NULL, '2026-06-18 10:30:00', NULL),
(10, 2, 4, NULL, NULL, 'Pending', NULL, '2026-06-18 10:30:00', NULL),
(11, 2, 5, NULL, NULL, 'Pending', NULL, '2026-06-18 10:30:00', NULL),
(12, 2, 6, NULL, NULL, 'Pending', NULL, '2026-06-18 10:30:00', NULL),
(13, 3, 1, 4, NULL, 'Approved', 'Director approval granted.', '2026-06-15 08:45:00', '2026-06-15 10:00:00'),
(14, 3, 2, 5, NULL, 'Approved', 'Library cleared.', '2026-06-15 08:45:00', '2026-06-15 12:00:00'),
(15, 3, 3, 6, NULL, 'Approved', 'Fee balance cleared.', '2026-06-15 08:45:00', '2026-06-16 09:00:00'),
(16, 3, 4, 7, NULL, 'Approved', 'Student affairs cleared.', '2026-06-15 08:45:00', '2026-06-16 13:00:00'),
(17, 3, 5, 8, NULL, 'Approved', 'No university store items pending.', '2026-06-15 08:45:00', '2026-06-17 09:30:00'),
(18, 3, 6, 9, NULL, 'Approved', 'Final registrar clearance granted.', '2026-06-15 08:45:00', '2026-06-17 14:00:00'),
(19, 4, 1, 4, NULL, 'Approved', '', '2026-08-09 18:51:03', '2026-08-09 18:52:10'),
(20, 4, 2, 5, NULL, 'Approved', '', '2026-08-09 18:52:10', '2026-08-09 18:54:41'),
(21, 4, 3, 6, NULL, 'Approved', '', '2026-08-09 18:52:10', '2026-08-09 18:58:23'),
(22, 4, 4, 7, NULL, 'Approved', 'all is uploaded.', '2026-08-09 18:52:10', '2026-08-09 18:59:55'),
(23, 4, 5, 8, NULL, 'Approved', 'Nothing was issued to this student.', '2026-08-09 18:52:10', '2026-08-09 19:01:34'),
(24, 4, 6, 9, NULL, 'Approved', 'Well Cleared.', '2026-08-09 18:52:10', '2026-08-09 19:02:36'),
(25, 5, 1, 4, NULL, 'Approved', 'all units done', '2026-08-11 10:08:42', '2026-08-11 10:14:48'),
(26, 5, 2, 5, NULL, 'Approved', '', '2026-08-11 10:14:48', '2026-08-11 10:24:03'),
(27, 5, 3, 6, NULL, 'Approved', 'Approved', '2026-08-11 10:14:48', '2026-08-11 10:25:48'),
(28, 5, 4, 7, NULL, 'Approved', 'cleared and approved', '2026-08-11 10:14:48', '2026-08-11 10:27:53'),
(29, 5, 5, 8, NULL, 'Approved', '', '2026-08-11 10:14:48', '2026-08-11 10:29:00'),
(30, 5, 6, 9, NULL, 'Rejected', 'Has not met all the requirements.', '2026-08-11 10:14:48', '2026-08-11 10:29:55'),
(32, 7, 1, 14, 10, 'Approved', 'Cleared', '2026-08-23 17:03:28', '2026-08-25 12:04:38'),
(33, 7, 2, 5, NULL, 'Approved', 'cleared', '2026-08-23 17:03:28', '2026-08-29 11:03:21'),
(34, 7, 3, 6, NULL, 'Approved', 'cleared', '2026-08-23 17:03:28', '2026-08-29 11:06:16'),
(35, 7, 4, 7, NULL, 'Approved', 'cleared', '2026-08-23 17:03:28', '2026-08-29 11:08:32'),
(36, 7, 5, 8, NULL, 'Approved', 'done', '2026-08-23 17:03:28', '2026-08-29 12:58:50'),
(37, 7, 6, 9, NULL, 'Approved', 'done', '2026-08-23 17:03:28', '2026-08-29 13:00:10'),
(38, 2, 2, 5, NULL, 'Rejected', 'no physical project submitted', '2026-08-25 12:52:46', '2026-08-29 12:48:38'),
(45, 9, 1, 20, 19, 'Approved', 'cleared.', '2026-08-29 12:46:24', '2026-08-29 12:47:20'),
(46, 9, 2, 5, NULL, 'Approved', 'All is cleared', '2026-08-29 12:46:24', '2026-08-29 12:49:02'),
(47, 9, 3, 6, NULL, 'Rejected', 'balance of 5000/= graduation fee', '2026-08-29 12:46:24', '2026-08-29 12:50:44'),
(48, 9, 4, 7, NULL, 'Approved', 'all is cleared.', '2026-08-29 12:46:24', '2026-08-29 12:58:17'),
(49, 9, 5, 8, NULL, 'Approved', 'cleared', '2026-08-29 12:46:24', '2026-08-29 12:59:01'),
(50, 9, 6, 9, NULL, 'Approved', 'Has been cleared', '2026-08-29 12:46:24', '2026-08-29 13:00:03'),
(51, 9, 3, 6, NULL, 'Approved', 'cleared the graduation fee', '2026-08-29 12:54:52', '2026-08-29 12:55:46'),
(112, 20, 1, 24, 21, 'Rejected', 'Has not completed his project', '2026-08-29 15:20:58', '2026-08-29 16:18:20'),
(113, 20, 2, 5, NULL, 'Approved', 'completed', '2026-08-29 15:20:58', '2026-08-30 13:56:04'),
(114, 20, 3, 6, NULL, 'Approved', 'cleared', '2026-08-29 15:20:58', '2026-08-30 13:57:28'),
(115, 20, 4, 22, NULL, 'Approved', 'cleared', '2026-08-29 15:20:58', '2026-08-31 23:24:10'),
(116, 20, 5, 8, NULL, 'Approved', 'cleared', '2026-08-29 15:20:58', '2026-09-03 17:06:47'),
(117, 20, 6, 9, NULL, 'Approved', 'cleared', '2026-08-29 15:20:58', '2026-09-04 22:20:19'),
(118, 21, 1, 26, 22, 'Approved', 'Cleared', '2026-08-29 16:15:43', '2026-08-29 16:17:11'),
(119, 21, 2, 5, NULL, 'Approved', 'cleared', '2026-08-29 16:15:43', '2026-08-30 13:56:19'),
(120, 21, 3, 6, NULL, 'Approved', 'done', '2026-08-29 16:15:43', '2026-08-30 13:57:33'),
(121, 21, 4, 27, NULL, 'Approved', 'done.', '2026-08-29 16:15:43', '2026-08-31 20:35:09'),
(122, 21, 5, 8, NULL, 'Approved', 'cleared', '2026-08-29 16:15:43', '2026-08-31 20:40:09'),
(123, 21, 6, 9, NULL, 'Approved', 'cleared', '2026-08-29 16:15:43', '2026-08-31 21:04:13'),
(124, 20, 1, 24, 21, 'Approved', 'Cleared', '2026-08-29 16:18:57', '2026-08-29 16:19:51'),
(125, 22, 1, 31, 23, 'Approved', 'cleared', '2026-08-30 19:00:17', '2026-08-30 19:01:30'),
(126, 22, 2, 5, NULL, 'Approved', 'Cleared', '2026-08-30 19:00:17', '2026-08-30 19:07:54'),
(127, 22, 3, 6, NULL, 'Approved', 'cleared', '2026-08-30 19:00:17', '2026-08-30 19:08:36'),
(128, 22, 4, 29, NULL, 'Rejected', 'not yet', '2026-08-30 19:00:17', '2026-08-30 19:09:47'),
(129, 22, 5, 8, NULL, 'Approved', 'returned', '2026-08-30 19:00:17', '2026-08-30 19:11:35'),
(130, 22, 6, 9, NULL, 'Approved', 'cleared and assigned second upper', '2026-08-30 19:00:17', '2026-08-30 19:13:48'),
(131, 22, 4, 29, NULL, 'Approved', 'done', '2026-08-30 19:10:34', '2026-08-30 19:11:03'),
(132, 23, 1, 26, 22, 'Approved', 'cleared.', '2026-08-31 20:21:48', '2026-08-31 20:22:45'),
(133, 23, 2, 5, NULL, 'Approved', 'cleared.', '2026-08-31 20:21:48', '2026-08-31 20:32:50'),
(134, 23, 3, 6, NULL, 'Approved', 'cleared', '2026-08-31 20:21:48', '2026-08-31 20:37:18'),
(135, 23, 4, 27, NULL, 'Approved', 'cleared', '2026-08-31 20:21:48', '2026-08-31 20:37:57'),
(136, 23, 5, 8, NULL, 'Approved', 'cleared', '2026-08-31 20:21:48', '2026-08-31 20:40:17'),
(137, 23, 6, 9, NULL, 'Approved', 'cleared', '2026-08-31 20:21:48', '2026-08-31 21:06:22'),
(138, 24, 1, 31, 23, 'Approved', 'cleared', '2026-08-31 20:30:24', '2026-08-31 20:31:16'),
(139, 24, 2, 5, NULL, 'Rejected', 'Submit project.', '2026-08-31 20:30:24', '2026-08-31 20:32:31'),
(140, 24, 3, 6, NULL, 'Approved', 'done', '2026-08-31 20:30:24', '2026-08-31 20:37:25'),
(141, 24, 4, 29, NULL, 'Approved', 'cleared', '2026-08-31 20:30:24', '2026-08-31 20:39:32'),
(142, 24, 5, 8, NULL, 'Approved', 'cleared', '2026-08-31 20:30:24', '2026-08-31 23:05:16'),
(143, 24, 6, 9, NULL, 'Approved', 'cleared with second upper', '2026-08-31 20:30:24', '2026-08-31 23:07:02'),
(144, 24, 2, 5, NULL, 'Approved', 'submitted.', '2026-08-31 20:33:52', '2026-08-31 20:34:33'),
(145, 25, 1, 37, 24, 'Approved', 'cleared', '2026-09-01 09:04:36', '2026-09-01 09:05:05'),
(146, 25, 2, 5, NULL, 'Rejected', 'no document submitted.', '2026-09-01 09:04:36', '2026-09-01 09:05:36'),
(147, 25, 3, 6, NULL, 'Approved', 'no outstanding fee', '2026-09-01 09:04:36', '2026-09-01 09:07:14'),
(148, 25, 4, 35, NULL, 'Approved', 'she\'s cleared', '2026-09-01 09:04:36', '2026-09-01 09:08:09'),
(149, 25, 5, 8, NULL, 'Approved', 'cleared', '2026-09-01 09:04:36', '2026-09-01 09:09:52'),
(150, 25, 6, 9, NULL, 'Approved', 'cleared. Has credit', '2026-09-01 09:04:36', '2026-09-01 09:12:42'),
(151, 25, 2, 5, NULL, 'Approved', 'cleared', '2026-09-01 09:06:13', '2026-09-01 09:06:44'),
(152, 26, 1, 20, 19, 'Approved', 'Cleared.', '2026-09-01 09:53:36', '2026-09-01 10:05:47'),
(153, 26, 2, 5, NULL, 'Approved', 'clear', '2026-09-01 09:53:36', '2026-09-01 10:08:32'),
(154, 26, 3, 6, NULL, 'Approved', 'Cleared', '2026-09-01 09:53:36', '2026-09-01 10:09:31'),
(155, 26, 4, 27, NULL, 'Approved', 'cleared', '2026-09-01 09:53:36', '2026-09-01 10:11:11'),
(156, 26, 5, 8, NULL, 'Approved', 'cleared', '2026-09-01 09:53:36', '2026-09-01 10:13:04'),
(157, 26, 6, 9, NULL, 'Approved', 'Cleared.', '2026-09-01 09:53:36', '2026-09-01 10:17:38'),
(158, 27, 1, 20, 19, 'Approved', 'cleared.', '2026-09-04 22:58:11', '2026-09-04 22:59:08'),
(159, 27, 2, NULL, NULL, 'Pending', NULL, '2026-09-04 22:58:11', NULL),
(160, 27, 3, NULL, NULL, 'Pending', NULL, '2026-09-04 22:58:11', NULL),
(161, 27, 4, NULL, NULL, 'Pending', NULL, '2026-09-04 22:58:11', NULL),
(162, 27, 5, NULL, NULL, 'Pending', NULL, '2026-09-04 22:58:11', NULL),
(163, 27, 6, NULL, NULL, 'Pending', NULL, '2026-09-04 22:58:11', NULL);

--
-- Triggers `approval_records`
--
DELIMITER $$
CREATE TRIGGER `trg_approval_records_immutable_decision` BEFORE UPDATE ON `approval_records` FOR EACH ROW BEGIN
  IF OLD.status IN ('Approved','Rejected') THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Approval and rejection history is immutable';
  END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `audit_logs`
--

CREATE TABLE `audit_logs` (
  `audit_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `action` varchar(80) NOT NULL,
  `details` text DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `audit_logs`
--

INSERT INTO `audit_logs` (`audit_id`, `user_id`, `action`, `details`, `created_at`) VALUES
(1, 1, 'clearance_request_created', 'Student started clearance request #1', '2026-06-20 09:00:00'),
(2, 4, 'clearance_approved', 'Request #1 approved and moved to Library', '2026-06-20 11:00:00'),
(3, 5, 'clearance_approved', 'Request #1 approved and moved to Finance Office', '2026-06-21 10:00:00'),
(4, 5, 'clearance_rejected', 'Request #2 rejected at Library', '2026-06-19 09:15:00'),
(5, 9, 'clearance_completed', 'Request #3 received final approval.', '2026-06-17 14:00:00'),
(6, 9, 'transcript_uploaded', 'Transcript uploaded for student #3', '2026-06-17 13:30:00'),
(7, 1, 'login', 'User logged in successfully.', '2026-08-09 18:49:35'),
(8, 1, 'logout', 'User logged out.', '2026-08-09 18:49:44'),
(9, 11, 'login', 'User logged in successfully.', '2026-08-09 18:50:38'),
(10, 11, 'clearance_request_created', 'Student started clearance request #4', '2026-08-09 18:51:03'),
(11, 11, 'transcript_uploaded', 'Transcript uploaded for request #4', '2026-08-09 18:51:03'),
(12, 11, 'logout', 'User logged out.', '2026-08-09 18:51:39'),
(13, 4, 'login', 'User logged in successfully.', '2026-08-09 18:51:54'),
(14, 4, 'clearance_approved', 'Request #4 approved and moved to Library', '2026-08-09 18:52:10'),
(15, 4, 'logout', 'User logged out.', '2026-08-09 18:52:17'),
(16, 11, 'login', 'User logged in successfully.', '2026-08-09 18:52:34'),
(17, 11, 'logout', 'User logged out.', '2026-08-09 18:54:06'),
(18, 5, 'login', 'User logged in successfully.', '2026-08-09 18:54:21'),
(19, 5, 'clearance_approved', 'Request #4 approved and moved to Finance Office', '2026-08-09 18:54:41'),
(20, 5, 'logout', 'User logged out.', '2026-08-09 18:55:07'),
(21, 11, 'login', 'User logged in successfully.', '2026-08-09 18:55:22'),
(22, 11, 'logout', 'User logged out.', '2026-08-09 18:57:20'),
(23, NULL, 'failed_login', 'Failed login attempt for username: finance', '2026-08-09 18:57:42'),
(24, 6, 'login', 'User logged in successfully.', '2026-08-09 18:57:52'),
(25, 6, 'clearance_approved', 'Request #4 approved and moved to Dean of Students', '2026-08-09 18:58:23'),
(26, 6, 'clearance_rejected', 'Request #1 rejected at department #3', '2026-08-09 18:58:54'),
(27, 6, 'notifications_marked_read', 'User marked notifications as read.', '2026-08-09 18:59:03'),
(28, 6, 'logout', 'User logged out.', '2026-08-09 18:59:14'),
(29, 7, 'login', 'User logged in successfully.', '2026-08-09 18:59:35'),
(30, 7, 'clearance_approved', 'Request #4 approved and moved to University Store', '2026-08-09 18:59:55'),
(31, 7, 'logout', 'User logged out.', '2026-08-09 19:00:05'),
(32, 8, 'login', 'User logged in successfully.', '2026-08-09 19:01:06'),
(33, 8, 'clearance_approved', 'Request #4 approved and moved to Academic Registrar', '2026-08-09 19:01:34'),
(34, 8, 'logout', 'User logged out.', '2026-08-09 19:01:37'),
(35, 9, 'login', 'User logged in successfully.', '2026-08-09 19:01:53'),
(36, 9, 'clearance_completed', 'Request #4 received final approval.', '2026-08-09 19:02:36'),
(37, 9, 'logout', 'User logged out.', '2026-08-09 19:02:50'),
(38, 11, 'login', 'User logged in successfully.', '2026-08-09 19:03:04'),
(39, 10, 'login', 'User logged in successfully.', '2026-08-11 09:55:42'),
(40, 10, 'logout', 'User logged out.', '2026-08-11 09:59:00'),
(41, 11, 'login', 'User logged in successfully.', '2026-08-11 09:59:40'),
(42, 11, 'logout', 'User logged out.', '2026-08-11 10:00:51'),
(43, 1, 'login', 'User logged in successfully.', '2026-08-11 10:01:19'),
(44, 1, 'transcript_uploaded', 'Transcript uploaded for request #1', '2026-08-11 10:02:08'),
(45, 1, 'clearance_resubmitted', 'Request #1 resumed at department #3', '2026-08-11 10:02:08'),
(46, 1, 'logout', 'User logged out.', '2026-08-11 10:02:20'),
(47, 4, 'login', 'User logged in successfully.', '2026-08-11 10:02:32'),
(48, 4, 'logout', 'User logged out.', '2026-08-11 10:03:41'),
(49, 12, 'login', 'User logged in successfully.', '2026-08-11 10:08:22'),
(50, 12, 'clearance_request_created', 'Student started clearance request #5', '2026-08-11 10:08:42'),
(51, 12, 'transcript_uploaded', 'Transcript uploaded for request #5', '2026-08-11 10:08:42'),
(52, 12, 'logout', 'User logged out.', '2026-08-11 10:08:50'),
(53, NULL, 'failed_login', 'Failed login attempt for username: sci562026', '2026-08-11 10:09:13'),
(54, NULL, 'failed_login', 'Failed login attempt for username: sci562026', '2026-08-11 10:09:45'),
(55, 12, 'login', 'User logged in successfully.', '2026-08-11 10:10:34'),
(56, 12, 'logout', 'User logged out.', '2026-08-11 10:13:30'),
(57, 4, 'login', 'User logged in successfully.', '2026-08-11 10:13:40'),
(58, 4, 'clearance_approved', 'Request #5 approved and moved to Library', '2026-08-11 10:14:48'),
(59, 4, 'logout', 'User logged out.', '2026-08-11 10:14:57'),
(60, 12, 'login', 'User logged in successfully.', '2026-08-11 10:15:09'),
(61, 12, 'logout', 'User logged out.', '2026-08-11 10:19:58'),
(62, 5, 'login', 'User logged in successfully.', '2026-08-11 10:20:15'),
(63, 5, 'logout', 'User logged out.', '2026-08-11 10:21:01'),
(64, 4, 'login', 'User logged in successfully.', '2026-08-11 10:21:10'),
(65, 4, 'logout', 'User logged out.', '2026-08-11 10:23:02'),
(66, 5, 'login', 'User logged in successfully.', '2026-08-11 10:23:11'),
(67, 5, 'clearance_approved', 'Request #5 approved and moved to Finance Office', '2026-08-11 10:24:03'),
(68, 5, 'logout', 'User logged out.', '2026-08-11 10:24:11'),
(69, NULL, 'failed_login', 'Failed login attempt for username: sci562026', '2026-08-11 10:24:22'),
(70, 12, 'login', 'User logged in successfully.', '2026-08-11 10:24:35'),
(71, 12, 'logout', 'User logged out.', '2026-08-11 10:24:51'),
(72, 6, 'login', 'User logged in successfully.', '2026-08-11 10:25:00'),
(73, 6, 'clearance_approved', 'Request #5 approved and moved to Dean of Students', '2026-08-11 10:25:48'),
(74, 6, 'logout', 'User logged out.', '2026-08-11 10:25:51'),
(75, 12, 'login', 'User logged in successfully.', '2026-08-11 10:26:01'),
(76, 12, 'logout', 'User logged out.', '2026-08-11 10:27:07'),
(77, 7, 'login', 'User logged in successfully.', '2026-08-11 10:27:19'),
(78, 7, 'clearance_approved', 'Request #5 approved and moved to University Store', '2026-08-11 10:27:53'),
(79, 7, 'logout', 'User logged out.', '2026-08-11 10:27:57'),
(80, 9, 'login', 'User logged in successfully.', '2026-08-11 10:28:10'),
(81, 9, 'logout', 'User logged out.', '2026-08-11 10:28:44'),
(82, 8, 'login', 'User logged in successfully.', '2026-08-11 10:28:54'),
(83, 8, 'clearance_approved', 'Request #5 approved and moved to Academic Registrar', '2026-08-11 10:29:00'),
(84, 8, 'logout', 'User logged out.', '2026-08-11 10:29:04'),
(85, 9, 'login', 'User logged in successfully.', '2026-08-11 10:29:14'),
(86, 9, 'clearance_rejected', 'Request #5 rejected at department #6', '2026-08-11 10:29:55'),
(87, 9, 'logout', 'User logged out.', '2026-08-11 10:30:00'),
(88, 12, 'login', 'User logged in successfully.', '2026-08-11 10:30:10'),
(89, 12, 'logout', 'User logged out.', '2026-08-11 10:32:11'),
(90, 9, 'login', 'User logged in successfully.', '2026-08-11 10:32:29'),
(91, 9, 'logout', 'User logged out.', '2026-08-11 10:33:10'),
(92, 4, 'login', 'User logged in successfully.', '2026-08-11 10:33:19'),
(93, 10, 'login', 'User logged in successfully.', '2026-08-18 09:56:40'),
(94, 10, 'logout', 'User logged out.', '2026-08-18 10:00:54'),
(95, 10, 'login', 'User logged in successfully.', '2026-08-18 10:01:06'),
(96, 10, 'login', 'User logged in successfully.', '2026-08-18 10:03:20'),
(97, 10, 'user_created', 'Created student account for stacy', '2026-08-18 10:04:10'),
(98, 10, 'logout', 'User logged out.', '2026-08-18 10:04:26'),
(99, 13, 'login', 'User logged in successfully.', '2026-08-18 10:04:38'),
(100, 10, 'logout', 'User logged out.', '2026-08-18 11:04:22'),
(101, 13, 'login', 'User logged in successfully.', '2026-08-18 11:04:35'),
(102, 10, 'login', 'User logged in successfully.', '2026-08-20 18:13:16'),
(103, NULL, 'academic_structure_unmapped', 'Academic structure correction: 1049507 (student #1) requires Admin review', '2026-08-20 18:53:47'),
(104, NULL, 'academic_structure_unmapped', 'Academic structure correction: 1049508 (student #2) requires Admin review', '2026-08-20 18:53:47'),
(105, NULL, 'academic_structure_unmapped', 'Academic structure correction: sci/20/2026 (student #4) requires Admin review', '2026-08-20 18:53:47'),
(106, NULL, 'academic_structure_unmapped', 'Academic structure correction: sc/56/2026 (student #5) requires Admin review', '2026-08-20 18:53:47'),
(107, 10, 'login', 'User logged in successfully.', '2026-08-22 08:32:08'),
(108, 10, 'logout', 'User logged out.', '2026-08-22 08:50:19'),
(109, 14, 'login', 'User logged in successfully.', '2026-08-22 08:50:37'),
(110, 14, 'logout', 'User logged out.', '2026-08-22 08:50:53'),
(111, 10, 'login', 'User logged in successfully.', '2026-08-22 08:51:13'),
(112, 10, 'logout', 'User logged out.', '2026-08-22 08:56:00'),
(113, NULL, 'failed_login', 'Failed login attempt for username: sc562026', '2026-08-22 08:56:16'),
(114, 10, 'login', 'User logged in successfully.', '2026-08-22 08:56:33'),
(115, 10, 'logout', 'User logged out.', '2026-08-22 08:57:27'),
(116, NULL, 'failed_login', 'Failed login attempt for username: sci202026', '2026-08-22 08:57:40'),
(117, NULL, 'failed_login', 'Failed login attempt for username: 712345678', '2026-08-22 08:57:43'),
(118, NULL, 'failed_login', 'Failed login attempt for username: IYSdirector', '2026-08-22 08:57:51'),
(119, NULL, 'failed_login', 'Failed login attempt for username: sc562026', '2026-08-22 08:58:11'),
(120, NULL, 'failed_login', 'Failed login attempt for username: sc562026', '2026-08-22 08:58:46'),
(121, NULL, 'failed_login', 'Failed login attempt for username: 712345678', '2026-08-22 08:59:01'),
(122, NULL, 'failed_login', 'Failed login attempt for username: sc562026', '2026-08-22 09:03:24'),
(123, NULL, 'failed_login', 'Failed login attempt for username: william', '2026-08-22 09:03:47'),
(124, NULL, 'failed_login', 'Failed login attempt for username: sci202026', '2026-08-22 09:04:07'),
(125, 5, 'login', 'User logged in successfully.', '2026-08-22 09:04:48'),
(126, 5, 'logout', 'User logged out.', '2026-08-22 09:05:11'),
(127, NULL, 'failed_login', 'Failed login attempt for username: 1049508', '2026-08-22 09:05:26'),
(128, 1, 'login', 'User logged in successfully.', '2026-08-22 09:05:43'),
(129, 1, 'student_academic_assignment_updated', 'Student updated academic assignment.', '2026-08-22 09:07:10'),
(130, 1, 'document_uploaded', 'id_passport uploaded for student #1', '2026-08-22 09:07:32'),
(131, 1, 'document_uploaded', 'final_year_project uploaded for student #1', '2026-08-22 09:07:49'),
(132, 1, 'logout', 'User logged out.', '2026-08-22 09:08:37'),
(133, 10, 'login', 'User logged in successfully.', '2026-08-22 09:08:49'),
(134, 10, 'logout', 'User logged out.', '2026-08-22 09:10:20'),
(135, 1, 'login', 'User logged in successfully.', '2026-08-22 09:11:16'),
(136, 1, 'logout', 'User logged out.', '2026-08-22 09:11:47'),
(137, 4, 'login', 'User logged in successfully.', '2026-08-22 09:12:02'),
(138, 4, 'logout', 'User logged out.', '2026-08-22 09:12:19'),
(139, 10, 'login', 'User logged in successfully.', '2026-08-22 09:13:35'),
(140, 10, 'logout', 'User logged out.', '2026-08-22 09:18:30'),
(141, 1, 'login', 'User logged in successfully.', '2026-08-22 09:18:45'),
(142, 1, 'logout', 'User logged out.', '2026-08-22 09:24:30'),
(143, 4, 'login', 'User logged in successfully.', '2026-08-22 09:24:48'),
(144, 4, 'logout', 'User logged out.', '2026-08-22 09:28:11'),
(145, 10, 'login', 'User logged in successfully.', '2026-08-22 09:29:06'),
(146, 10, 'logout', 'User logged out.', '2026-08-22 09:39:07'),
(147, 4, 'login', 'User logged in successfully.', '2026-08-22 09:39:21'),
(148, 4, 'logout', 'User logged out.', '2026-08-22 09:39:44'),
(149, NULL, 'failed_login', 'Failed login attempt for username: sc562026', '2026-08-22 09:42:57'),
(150, NULL, 'failed_login', 'Failed login attempt for username: sci562026', '2026-08-22 09:43:20'),
(151, 10, 'login', 'User logged in successfully.', '2026-08-22 10:03:01'),
(152, 10, 'login', 'User logged in successfully.', '2026-08-22 15:09:25'),
(153, 10, 'logout', 'User logged out.', '2026-08-22 15:15:34'),
(154, 4, 'login', 'User logged in successfully.', '2026-08-22 15:15:45'),
(155, 4, 'logout', 'User logged out.', '2026-08-22 15:16:05'),
(156, 1, 'login', 'User logged in successfully.', '2026-08-22 15:16:13'),
(157, 1, 'logout', 'User logged out.', '2026-08-22 15:17:07'),
(158, 10, 'login', 'User logged in successfully.', '2026-08-22 15:17:15'),
(159, 10, 'logout', 'User logged out.', '2026-08-22 18:38:54'),
(160, 6, 'login', 'User logged in successfully.', '2026-08-22 18:39:06'),
(161, 6, 'clearance_rejected', 'Request #1 rejected at Finance Office', '2026-08-22 18:40:08'),
(162, 6, 'logout', 'User logged out.', '2026-08-22 18:40:22'),
(163, 1, 'login', 'User logged in successfully.', '2026-08-22 18:40:37'),
(164, 1, 'logout', 'User logged out.', '2026-08-22 18:41:39'),
(165, 2, 'login', 'User logged in successfully.', '2026-08-22 18:41:52'),
(166, 2, 'logout', 'User logged out.', '2026-08-22 18:43:33'),
(167, 3, 'login', 'User logged in successfully.', '2026-08-22 18:45:43'),
(168, 3, 'student_academic_assignment_updated', 'Student updated academic assignment.', '2026-08-22 18:47:34'),
(169, 3, 'logout', 'User logged out.', '2026-08-22 18:52:10'),
(170, 9, 'login', 'User logged in successfully.', '2026-08-22 18:52:27'),
(171, 9, 'logout', 'User logged out.', '2026-08-22 18:53:54'),
(172, 4, 'login', 'User logged in successfully.', '2026-08-22 18:54:08'),
(173, 4, 'logout', 'User logged out.', '2026-08-22 18:54:24'),
(174, 10, 'login', 'User logged in successfully.', '2026-08-22 18:54:36'),
(175, 10, 'logout', 'User logged out.', '2026-08-22 18:59:28'),
(176, NULL, 'failed_login', 'Failed login attempt for username: sc562026', '2026-08-22 18:59:43'),
(177, 10, 'login', 'User logged in successfully.', '2026-08-22 19:04:24'),
(178, 10, 'logout', 'User logged out.', '2026-08-22 19:07:05'),
(179, NULL, 'failed_login', 'Failed login attempt for username: sc562026', '2026-08-22 19:07:29'),
(180, 10, 'login', 'User logged in successfully.', '2026-08-22 19:46:21'),
(181, 10, 'login', 'User logged in successfully.', '2026-08-23 16:36:52'),
(182, 10, 'student_created', 'Created student sc/89/2026', '2026-08-23 16:51:13'),
(183, 10, 'logout', 'User logged out.', '2026-08-23 16:51:23'),
(184, 16, 'login', 'User logged in successfully.', '2026-08-23 17:01:04'),
(185, 16, 'document_uploaded', 'id_passport uploaded for student #8', '2026-08-23 17:01:41'),
(186, 16, 'document_uploaded', 'final_year_project uploaded for student #8', '2026-08-23 17:02:09'),
(187, 16, 'student_academic_assignment_updated', 'Student updated academic assignment.', '2026-08-23 17:02:21'),
(188, 16, 'clearance_request_created', 'Request #7', '2026-08-23 17:03:28'),
(189, 16, 'logout', 'User logged out.', '2026-08-23 17:03:34'),
(190, 16, 'login', 'User logged in successfully.', '2026-08-23 17:03:49'),
(191, 16, 'student_academic_assignment_updated', 'Student updated academic assignment.', '2026-08-23 17:04:20'),
(192, 16, 'document_uploaded', 'id_passport uploaded for student #8', '2026-08-23 17:07:52'),
(193, 16, 'document_uploaded', 'final_year_project uploaded for student #8', '2026-08-23 17:08:07'),
(194, 16, 'logout', 'User logged out.', '2026-08-23 17:27:12'),
(195, 4, 'login', 'User logged in successfully.', '2026-08-23 17:27:37'),
(196, 4, 'logout', 'User logged out.', '2026-08-23 17:28:13'),
(197, 10, 'login', 'User logged in successfully.', '2026-08-23 17:28:22'),
(198, 10, 'password_reset', 'Administrator reset password for user #14', '2026-08-23 17:32:51'),
(199, 10, 'logout', 'User logged out.', '2026-08-23 17:32:57'),
(200, 14, 'login', 'User logged in successfully.', '2026-08-23 17:33:33'),
(201, 14, 'logout', 'User logged out.', '2026-08-23 17:33:45'),
(202, 14, 'login', 'User logged in successfully.', '2026-08-23 17:34:06'),
(203, 14, 'logout', 'User logged out.', '2026-08-23 17:34:31'),
(204, 4, 'login', 'User logged in successfully.', '2026-08-23 17:34:59'),
(205, 4, 'logout', 'User logged out.', '2026-08-25 11:33:03'),
(206, 10, 'logout', 'User logged out.', '2026-08-25 11:37:01'),
(207, 6, 'login', 'User logged in successfully.', '2026-08-25 11:37:15'),
(208, 6, 'logout', 'User logged out.', '2026-08-25 11:38:52'),
(209, 4, 'login', 'User logged in successfully.', '2026-08-25 11:39:03'),
(210, 4, 'logout', 'User logged out.', '2026-08-25 11:39:19'),
(211, 14, 'login', 'User logged in successfully.', '2026-08-25 11:39:32'),
(212, 14, 'logout', 'User logged out.', '2026-08-25 11:39:39'),
(213, 5, 'login', 'User logged in successfully.', '2026-08-25 11:39:54'),
(214, 5, 'logout', 'User logged out.', '2026-08-25 11:40:10'),
(215, 10, 'login', 'User logged in successfully.', '2026-08-25 11:40:19'),
(216, 10, 'logout', 'User logged out.', '2026-08-25 11:40:50'),
(217, 16, 'login', 'User logged in successfully.', '2026-08-25 11:41:02'),
(218, 16, 'student_academic_assignment_updated', 'Student updated academic assignment.', '2026-08-25 11:41:21'),
(219, 16, 'logout', 'User logged out.', '2026-08-25 11:41:38'),
(220, 10, 'login', 'User logged in successfully.', '2026-08-25 11:42:00'),
(221, 10, 'logout', 'User logged out.', '2026-08-25 11:44:39'),
(222, NULL, 'failed_login', 'Failed login attempt for username: IYSDirector', '2026-08-25 11:44:41'),
(223, NULL, 'failed_login', 'Failed login attempt for username: IYSDirector', '2026-08-25 11:44:56'),
(224, NULL, 'failed_login', 'Failed login attempt for username: IYSDirector', '2026-08-25 11:45:11'),
(225, 4, 'login', 'User logged in successfully.', '2026-08-25 11:45:30'),
(226, 4, 'logout', 'User logged out.', '2026-08-25 11:45:39'),
(227, 4, 'login', 'User logged in successfully.', '2026-08-25 11:47:26'),
(228, 4, 'logout', 'User logged out.', '2026-08-25 11:48:38'),
(229, 4, 'login', 'User logged in successfully.', '2026-08-25 11:48:47'),
(230, 4, 'logout', 'User logged out.', '2026-08-25 11:49:06'),
(231, 16, 'login', 'User logged in successfully.', '2026-08-25 11:49:17'),
(232, 16, 'logout', 'User logged out.', '2026-08-25 11:49:39'),
(233, 14, 'login', 'User logged in successfully.', '2026-08-25 11:59:08'),
(234, 14, 'logout', 'User logged out.', '2026-08-25 12:00:54'),
(235, 16, 'login', 'User logged in successfully.', '2026-08-25 12:01:09'),
(236, 16, 'document_uploaded', 'id_passport uploaded for student #8', '2026-08-25 12:01:24'),
(237, 16, 'document_uploaded', 'final_year_project uploaded for student #8', '2026-08-25 12:01:37'),
(238, 16, 'logout', 'User logged out.', '2026-08-25 12:03:21'),
(239, 14, 'login', 'User logged in successfully.', '2026-08-25 12:03:33'),
(240, 14, 'clearance_approved', 'Request #7 approved at Institute Director', '2026-08-25 12:04:38'),
(241, 14, 'logout', 'User logged out.', '2026-08-25 12:08:18'),
(242, 10, 'login', 'User logged in successfully.', '2026-08-25 12:08:30'),
(243, 10, 'logout', 'User logged out.', '2026-08-25 12:18:50'),
(244, 3, 'login', 'User logged in successfully.', '2026-08-25 12:19:01'),
(245, 3, 'logout', 'User logged out.', '2026-08-25 12:19:08'),
(246, 16, 'login', 'User logged in successfully.', '2026-08-25 12:19:26'),
(247, 16, 'logout', 'User logged out.', '2026-08-25 12:21:33'),
(248, 10, 'login', 'User logged in successfully.', '2026-08-25 12:22:02'),
(249, 10, 'logout', 'User logged out.', '2026-08-25 12:28:02'),
(250, NULL, 'failed_login', 'Failed login attempt for username: IYSdirector', '2026-08-25 12:28:25'),
(251, 14, 'login', 'User logged in successfully.', '2026-08-25 12:28:37'),
(252, 14, 'logout', 'User logged out.', '2026-08-25 12:30:29'),
(253, 16, 'login', 'User logged in successfully.', '2026-08-25 12:31:30'),
(254, 16, 'logout', 'User logged out.', '2026-08-25 12:34:49'),
(255, 9, 'login', 'User logged in successfully.', '2026-08-25 12:35:52'),
(256, 9, 'logout', 'User logged out.', '2026-08-25 12:37:44'),
(257, 10, 'login', 'User logged in successfully.', '2026-08-25 12:37:53'),
(258, 10, 'logout', 'User logged out.', '2026-08-25 12:39:27'),
(259, 10, 'login', 'User logged in successfully.', '2026-08-25 12:39:37'),
(260, 10, 'logout', 'User logged out.', '2026-08-25 12:42:24'),
(261, 6, 'login', 'User logged in successfully.', '2026-08-25 12:42:40'),
(262, 6, 'logout', 'User logged out.', '2026-08-25 12:49:30'),
(263, 5, 'login', 'User logged in successfully.', '2026-08-25 12:49:40'),
(264, 5, 'logout', 'User logged out.', '2026-08-25 12:51:15'),
(265, 1, 'login', 'User logged in successfully.', '2026-08-25 12:51:24'),
(266, 1, 'logout', 'User logged out.', '2026-08-25 12:51:56'),
(267, 2, 'login', 'User logged in successfully.', '2026-08-25 12:52:09'),
(268, 2, 'clearance_resubmitted', 'Request #2 returned to department #2', '2026-08-25 12:52:46'),
(269, 2, 'logout', 'User logged out.', '2026-08-25 12:53:01'),
(270, 1, 'login', 'User logged in successfully.', '2026-08-25 12:53:16'),
(271, 1, 'logout', 'User logged out.', '2026-08-25 12:53:24'),
(272, 2, 'login', 'User logged in successfully.', '2026-08-25 12:53:33'),
(273, 2, 'logout', 'User logged out.', '2026-08-25 12:53:48'),
(274, 5, 'login', 'User logged in successfully.', '2026-08-25 12:53:58'),
(275, 14, 'login', 'User logged in successfully.', '2026-08-27 14:41:44'),
(276, 4, 'login', 'User logged in successfully.', '2026-08-27 17:47:45'),
(277, 4, 'logout', 'User logged out.', '2026-08-27 17:48:33'),
(278, NULL, 'failed_login', 'Failed login attempt for username: IYSdirector', '2026-08-27 17:48:43'),
(279, NULL, 'failed_login', 'Failed login attempt for username: IYSdirector', '2026-08-27 17:48:56'),
(280, 14, 'login', 'User logged in successfully.', '2026-08-27 17:49:13'),
(281, 14, 'logout', 'User logged out.', '2026-08-27 17:59:19'),
(282, 10, 'login', 'User logged in successfully.', '2026-08-27 17:59:36'),
(283, 10, 'logout', 'User logged out.', '2026-08-27 18:20:59'),
(284, 14, 'login', 'User logged in successfully.', '2026-08-27 18:21:25'),
(285, 14, 'logout', 'User logged out.', '2026-08-27 18:22:11'),
(286, 10, 'login', 'User logged in successfully.', '2026-08-27 18:22:20'),
(287, 10, 'logout', 'User logged out.', '2026-08-27 18:43:59'),
(288, 9, 'login', 'User logged in successfully.', '2026-08-27 18:44:07'),
(289, 9, 'logout', 'User logged out.', '2026-08-27 18:51:50'),
(290, 10, 'login', 'User logged in successfully.', '2026-08-27 18:52:11'),
(291, 10, 'student_created', 'Created student sc/98/2026', '2026-08-27 19:47:20'),
(292, 10, 'graduation_set_activated', 'Activated graduation set ID: 3', '2026-08-27 19:57:45'),
(293, 10, 'graduation_set_activated', 'Activated graduation set ID: 4', '2026-08-27 20:01:51'),
(294, 10, 'logout', 'User logged out.', '2026-08-27 20:47:37'),
(295, 1, 'login', 'User logged in successfully.', '2026-08-27 20:47:47'),
(296, 10, 'login', 'User logged in successfully.', '2026-08-28 17:23:43'),
(297, 10, 'logout', 'User logged out.', '2026-08-28 17:30:21'),
(298, 1, 'login', 'User logged in successfully.', '2026-08-28 17:31:21'),
(299, 1, 'logout', 'User logged out.', '2026-08-28 17:43:49'),
(300, 10, 'login', 'User logged in successfully.', '2026-08-28 17:44:07'),
(301, 10, 'logout', 'User logged out.', '2026-08-28 17:50:17'),
(302, 5, 'login', 'User logged in successfully.', '2026-08-28 17:50:33'),
(303, 5, 'logout', 'User logged out.', '2026-08-28 19:45:12'),
(304, 9, 'login', 'User logged in successfully.', '2026-08-28 19:45:22'),
(305, 9, 'student_classification_saved', 'Classification saved for student ID 5: Second Class (Upper) (68.50%)', '2026-08-28 19:46:10'),
(306, 9, 'student_classification_saved', 'Classification saved for student ID 4: Pass (50.44%)', '2026-08-28 19:54:16'),
(307, 9, 'student_classification_saved', 'Classification saved for student ID 1: Distinction (78.00%)', '2026-08-28 20:08:30'),
(308, 9, 'logout', 'User logged out.', '2026-08-28 20:17:18'),
(309, 10, 'login', 'User logged in successfully.', '2026-08-28 20:17:28'),
(310, 10, 'logout', 'User logged out.', '2026-08-28 20:18:38'),
(311, 9, 'login', 'User logged in successfully.', '2026-08-28 20:18:47'),
(312, 9, 'logout', 'User logged out.', '2026-08-28 20:19:13'),
(313, 10, 'login', 'User logged in successfully.', '2026-08-28 20:21:58'),
(314, 10, 'login', 'User logged in successfully.', '2026-08-29 10:32:11'),
(315, 10, 'user_soft_deleted', 'Administrator soft-deleted user #17', '2026-08-29 10:32:42'),
(316, 10, 'user_soft_deleted', 'Administrator soft-deleted user #15', '2026-08-29 10:32:52'),
(317, 10, 'logout', 'User logged out.', '2026-08-29 10:53:09'),
(318, 10, 'login', 'User logged in successfully.', '2026-08-29 10:53:41'),
(319, 10, 'logout', 'User logged out.', '2026-08-29 10:58:19'),
(320, 14, 'login', 'User logged in successfully.', '2026-08-29 10:58:37'),
(321, 14, 'logout', 'User logged out.', '2026-08-29 11:00:45'),
(322, 5, 'login', 'User logged in successfully.', '2026-08-29 11:01:01'),
(323, 5, 'clearance_approved', 'Request #7 approved at Library', '2026-08-29 11:03:21'),
(324, 5, 'logout', 'User logged out.', '2026-08-29 11:04:25'),
(325, 6, 'login', 'User logged in successfully.', '2026-08-29 11:04:40'),
(326, 6, 'clearance_approved', 'Request #7 approved at Finance Office', '2026-08-29 11:06:16'),
(327, 6, 'logout', 'User logged out.', '2026-08-29 11:08:05'),
(328, 7, 'login', 'User logged in successfully.', '2026-08-29 11:08:16'),
(329, 7, 'clearance_approved', 'Request #7 approved at Dean\'s Office', '2026-08-29 11:08:32'),
(330, 7, 'logout', 'User logged out.', '2026-08-29 11:09:29'),
(331, 9, 'login', 'User logged in successfully.', '2026-08-29 11:09:49'),
(332, 9, 'logout', 'User logged out.', '2026-08-29 11:29:24'),
(333, 10, 'login', 'User logged in successfully.', '2026-08-29 11:48:03'),
(334, 10, 'student_created', 'Created student sc/11/2025', '2026-08-29 11:49:18'),
(335, 10, 'logout', 'User logged out.', '2026-08-29 11:49:25'),
(336, 10, 'login', 'User logged in successfully.', '2026-08-29 12:07:39'),
(337, 10, 'logout', 'User logged out.', '2026-08-29 12:23:51'),
(338, 10, 'login', 'User logged in successfully.', '2026-08-29 12:23:59'),
(339, 10, 'user_created', 'Administrator created user: D. Etriga', '2026-08-29 12:29:49'),
(340, 10, 'student_created', 'Created student sc/10/2026', '2026-08-29 12:31:43'),
(341, 10, 'logout', 'User logged out.', '2026-08-29 12:31:50'),
(342, 21, 'login', 'User logged in successfully.', '2026-08-29 12:32:51'),
(343, 21, 'document_uploaded', 'id_passport uploaded for student #11', '2026-08-29 12:33:25'),
(344, 21, 'document_uploaded', 'final_year_project uploaded for student #11', '2026-08-29 12:33:41'),
(345, 21, 'logout', 'User logged out.', '2026-08-29 12:34:04'),
(346, 10, 'login', 'User logged in successfully.', '2026-08-29 12:34:13'),
(347, 10, 'logout', 'User logged out.', '2026-08-29 12:39:52'),
(348, 21, 'login', 'User logged in successfully.', '2026-08-29 12:40:02'),
(350, 21, 'clearance_request_created', 'Request #9', '2026-08-29 12:46:24'),
(351, 21, 'logout', 'User logged out.', '2026-08-29 12:46:27'),
(352, 20, 'login', 'User logged in successfully.', '2026-08-29 12:46:51'),
(353, 20, 'clearance_approved', 'Request #9 approved at Institute', '2026-08-29 12:47:20'),
(354, 20, 'logout', 'User logged out.', '2026-08-29 12:47:27'),
(355, 21, 'login', 'User logged in successfully.', '2026-08-29 12:47:38'),
(356, 21, 'logout', 'User logged out.', '2026-08-29 12:47:56'),
(357, 5, 'login', 'User logged in successfully.', '2026-08-29 12:48:09'),
(358, 5, 'clearance_rejected', 'Request #2 rejected at Library', '2026-08-29 12:48:38'),
(359, 5, 'clearance_approved', 'Request #9 approved at Library', '2026-08-29 12:49:02'),
(360, 5, 'logout', 'User logged out.', '2026-08-29 12:49:25'),
(361, 6, 'login', 'User logged in successfully.', '2026-08-29 12:49:37'),
(362, 6, 'clearance_rejected', 'Request #9 rejected at Finance Office', '2026-08-29 12:50:44'),
(363, 6, 'logout', 'User logged out.', '2026-08-29 12:50:49'),
(364, 21, 'login', 'User logged in successfully.', '2026-08-29 12:54:27'),
(365, 21, 'clearance_resubmitted', 'Request #9 returned to department #3', '2026-08-29 12:54:52'),
(366, 21, 'logout', 'User logged out.', '2026-08-29 12:54:59'),
(367, 6, 'login', 'User logged in successfully.', '2026-08-29 12:55:08'),
(368, 6, 'clearance_approved', 'Request #9 approved at Finance Office', '2026-08-29 12:55:46'),
(369, 6, 'logout', 'User logged out.', '2026-08-29 12:57:03'),
(370, 7, 'login', 'User logged in successfully.', '2026-08-29 12:57:15'),
(371, 7, 'clearance_approved', 'Request #9 approved at Dean\'s Office', '2026-08-29 12:58:17'),
(372, 7, 'logout', 'User logged out.', '2026-08-29 12:58:27'),
(373, 8, 'login', 'User logged in successfully.', '2026-08-29 12:58:40'),
(374, 8, 'clearance_approved', 'Request #7 approved at University Store Office', '2026-08-29 12:58:50'),
(375, 8, 'clearance_approved', 'Request #9 approved at University Store Office', '2026-08-29 12:59:01'),
(376, 8, 'logout', 'User logged out.', '2026-08-29 12:59:04'),
(377, 9, 'login', 'User logged in successfully.', '2026-08-29 12:59:16'),
(378, 9, 'clearance_approved', 'Request #9 approved at Registry', '2026-08-29 13:00:03'),
(379, 9, 'clearance_approved', 'Request #7 approved at Registry', '2026-08-29 13:00:10'),
(380, 9, 'student_classification_saved', 'Classification saved for student ID 11: First Class Honours (72.18%) by Academic Registrar: Academic Registrar', '2026-08-29 13:00:35'),
(381, 9, 'logout', 'User logged out.', '2026-08-29 13:01:01'),
(382, 10, 'login', 'User logged in successfully.', '2026-08-29 13:02:18'),
(383, 10, 'logout', 'User logged out.', '2026-08-29 13:07:56'),
(384, 20, 'login', 'User logged in successfully.', '2026-08-29 13:08:08'),
(385, 20, 'logout', 'User logged out.', '2026-08-29 13:20:44'),
(386, 10, 'login', 'User logged in successfully.', '2026-08-29 13:30:44'),
(387, 10, 'user_created', 'Administrator created user: Nicholas Obiero', '2026-08-29 13:57:50'),
(388, 10, 'student_created', 'Created student sc/12/2025', '2026-08-29 14:39:51'),
(389, 10, 'user_created', 'Administrator created user: Nelson Obanja', '2026-08-29 14:43:11'),
(390, 10, 'logout', 'User logged out.', '2026-08-29 14:44:06'),
(391, 23, 'login', 'User logged in successfully.', '2026-08-29 14:44:20'),
(392, 23, 'document_uploaded', 'id_passport uploaded for student #12', '2026-08-29 14:44:57'),
(393, 23, 'document_uploaded', 'final_year_project uploaded for student #12', '2026-08-29 14:45:24'),
(396, 23, 'logout', 'User logged out.', '2026-08-29 14:47:15'),
(397, NULL, 'failed_login', 'Failed login attempt for username: admin', '2026-08-29 14:47:25'),
(398, 10, 'login', 'User logged in successfully.', '2026-08-29 14:47:33'),
(399, 10, 'student_updated', 'Updated student sc/12/2025', '2026-08-29 14:47:53'),
(400, 10, 'logout', 'User logged out.', '2026-08-29 14:48:00'),
(401, 23, 'login', 'User logged in successfully.', '2026-08-29 14:48:11'),
(403, 23, 'logout', 'User logged out.', '2026-08-29 14:48:25'),
(404, 23, 'login', 'User logged in successfully.', '2026-08-29 14:53:37'),
(408, 23, 'logout', 'User logged out.', '2026-08-29 14:57:50'),
(409, 10, 'login', 'User logged in successfully.', '2026-08-29 14:57:59'),
(410, 23, 'login', 'User logged in successfully.', '2026-08-29 15:10:48'),
(415, 1, 'clearance_request_created', 'Request #20', '2026-08-29 15:20:58'),
(416, 23, 'logout', 'User logged out.', '2026-08-29 15:21:34'),
(417, 10, 'login', 'User logged in successfully.', '2026-08-29 15:58:08'),
(418, 10, 'student_created', 'Created student sc/13/2025', '2026-08-29 16:08:29'),
(419, 10, 'logout', 'User logged out.', '2026-08-29 16:08:34'),
(420, 25, 'login', 'User logged in successfully.', '2026-08-29 16:10:03'),
(421, 25, 'document_uploaded', 'id_passport uploaded for student #13', '2026-08-29 16:10:25'),
(422, 25, 'document_uploaded', 'final_year_project uploaded for student #13', '2026-08-29 16:10:33'),
(423, 25, 'logout', 'User logged out.', '2026-08-29 16:11:01'),
(424, 10, 'login', 'User logged in successfully.', '2026-08-29 16:11:12'),
(425, 10, 'user_created', 'Administrator created user: Eric Ochieng Okoth', '2026-08-29 16:15:18'),
(426, 10, 'logout', 'User logged out.', '2026-08-29 16:15:21'),
(427, 25, 'login', 'User logged in successfully.', '2026-08-29 16:15:34'),
(428, 1, 'clearance_request_created', 'Request #21', '2026-08-29 16:15:43'),
(429, 25, 'logout', 'User logged out.', '2026-08-29 16:15:56'),
(430, 26, 'login', 'User logged in successfully.', '2026-08-29 16:16:23'),
(431, 26, 'clearance_approved', 'Request #21 approved at Institute', '2026-08-29 16:17:11'),
(432, 26, 'logout', 'User logged out.', '2026-08-29 16:17:41'),
(433, 24, 'login', 'User logged in successfully.', '2026-08-29 16:17:55'),
(434, 24, 'clearance_rejected', 'Request #20 rejected at Institute', '2026-08-29 16:18:20'),
(435, 24, 'logout', 'User logged out.', '2026-08-29 16:18:32'),
(436, 23, 'login', 'User logged in successfully.', '2026-08-29 16:18:43'),
(437, 23, 'clearance_resubmitted', 'Request #20 returned to department #1', '2026-08-29 16:18:57'),
(438, 23, 'logout', 'User logged out.', '2026-08-29 16:19:00'),
(439, 23, 'login', 'User logged in successfully.', '2026-08-29 16:19:09'),
(440, 23, 'logout', 'User logged out.', '2026-08-29 16:19:18'),
(441, 24, 'login', 'User logged in successfully.', '2026-08-29 16:19:30'),
(442, 24, 'clearance_approved', 'Request #20 approved at Institute', '2026-08-29 16:19:51'),
(443, 24, 'logout', 'User logged out.', '2026-08-29 16:20:35'),
(444, 10, 'login', 'User logged in successfully.', '2026-08-29 16:20:54'),
(445, 10, 'user_created', 'Administrator created user: Cecilia Osyanju', '2026-08-29 16:22:05'),
(446, 10, 'logout', 'User logged out.', '2026-08-29 16:22:08'),
(447, 27, 'login', 'User logged in successfully.', '2026-08-29 16:22:20'),
(448, 27, 'logout', 'User logged out.', '2026-08-29 16:22:20'),
(449, 27, 'login', 'User logged in successfully.', '2026-08-29 16:22:38'),
(450, 27, 'logout', 'User logged out.', '2026-08-29 16:22:38'),
(451, 10, 'login', 'User logged in successfully.', '2026-08-29 16:23:50'),
(452, 10, 'logout', 'User logged out.', '2026-08-29 16:24:06'),
(453, 22, 'login', 'User logged in successfully.', '2026-08-29 16:24:16'),
(454, 22, 'logout', 'User logged out.', '2026-08-29 16:24:16'),
(456, 7, 'login', 'User logged in successfully.', '2026-08-29 16:37:53'),
(457, 7, 'logout', 'User logged out.', '2026-08-29 16:43:56'),
(458, 27, 'login', 'User logged in successfully.', '2026-08-29 16:56:19'),
(459, 27, 'logout', 'User logged out.', '2026-08-29 16:56:42'),
(460, 22, 'login', 'User logged in successfully.', '2026-08-29 16:58:35'),
(461, 22, 'logout', 'User logged out.', '2026-08-29 19:38:29'),
(462, 27, 'login', 'User logged in successfully.', '2026-08-30 13:41:44'),
(463, 27, 'logout', 'User logged out.', '2026-08-30 13:54:55'),
(464, 23, 'login', 'User logged in successfully.', '2026-08-30 13:55:25'),
(465, 23, 'logout', 'User logged out.', '2026-08-30 13:55:32'),
(466, 5, 'login', 'User logged in successfully.', '2026-08-30 13:55:45'),
(467, 5, 'clearance_approved', 'Request #20 approved at Library', '2026-08-30 13:56:04'),
(468, 5, 'clearance_approved', 'Request #21 approved at Library', '2026-08-30 13:56:19'),
(469, 5, 'logout', 'User logged out.', '2026-08-30 13:56:26'),
(470, 22, 'login', 'User logged in successfully.', '2026-08-30 13:56:57'),
(471, 22, 'logout', 'User logged out.', '2026-08-30 13:57:04'),
(472, 6, 'login', 'User logged in successfully.', '2026-08-30 13:57:20'),
(473, 6, 'clearance_approved', 'Request #20 approved at Finance Office', '2026-08-30 13:57:28'),
(474, 6, 'clearance_approved', 'Request #21 approved at Finance Office', '2026-08-30 13:57:34'),
(475, 6, 'logout', 'User logged out.', '2026-08-30 13:57:45'),
(476, 22, 'login', 'User logged in successfully.', '2026-08-30 13:57:56'),
(477, 22, 'logout', 'User logged out.', '2026-08-30 13:58:02'),
(478, 27, 'login', 'User logged in successfully.', '2026-08-30 13:58:41'),
(479, 27, 'logout', 'User logged out.', '2026-08-30 13:58:49'),
(480, 27, 'login', 'User logged in successfully.', '2026-08-30 13:59:28'),
(481, 27, 'logout', 'User logged out.', '2026-08-30 13:59:33'),
(482, 22, 'login', 'User logged in successfully.', '2026-08-30 14:03:28'),
(483, 22, 'logout', 'User logged out.', '2026-08-30 14:03:38'),
(484, 27, 'login', 'User logged in successfully.', '2026-08-30 14:03:50'),
(485, 27, 'logout', 'User logged out.', '2026-08-30 14:11:26'),
(486, 10, 'login', 'User logged in successfully.', '2026-08-30 14:32:19'),
(487, 10, 'notifications_marked_read', 'User marked all notifications as read.', '2026-08-30 17:39:25'),
(488, 10, 'logout', 'User logged out.', '2026-08-30 17:42:44'),
(489, 23, 'login', 'User logged in successfully.', '2026-08-30 17:43:27'),
(490, 23, 'notifications_marked_read', 'User marked all notifications as read.', '2026-08-30 17:43:42'),
(491, 23, 'logout', 'User logged out.', '2026-08-30 17:43:44'),
(492, 21, 'login', 'User logged in successfully.', '2026-08-30 17:47:17'),
(493, 21, 'logout', 'User logged out.', '2026-08-30 17:47:41'),
(494, 10, 'login', 'User logged in successfully.', '2026-08-30 17:49:02'),
(495, 10, 'student_created', 'Created student sc/14/2025', '2026-08-30 17:51:21'),
(496, 10, 'student_updated', 'Updated student sc/14/2025', '2026-08-30 17:52:47'),
(497, 10, 'student_updated', 'Updated student sc/14/2025', '2026-08-30 17:53:08'),
(498, 10, 'user_updated', 'Administrator updated user: Cecilia Osyanju', '2026-08-30 17:57:13'),
(499, 10, 'user_created', 'Administrator created user: Dr. Phoestine Naliaka', '2026-08-30 18:33:24'),
(500, 10, 'student_created', 'Created student sc/15/2026', '2026-08-30 18:51:29'),
(501, 10, 'user_created', 'Administrator created user: Peter Kiptoo', '2026-08-30 18:57:47'),
(502, 10, 'logout', 'User logged out.', '2026-08-30 18:57:53'),
(503, 30, 'login', 'User logged in successfully.', '2026-08-30 18:58:06'),
(504, 30, 'document_uploaded', 'id_passport uploaded for student #16', '2026-08-30 18:59:51'),
(505, 30, 'document_uploaded', 'final_year_project uploaded for student #16', '2026-08-30 19:00:02'),
(506, 1, 'clearance_request_created', 'Request #22', '2026-08-30 19:00:17'),
(507, 30, 'logout', 'User logged out.', '2026-08-30 19:00:28'),
(508, 31, 'login', 'User logged in successfully.', '2026-08-30 19:00:43'),
(509, 31, 'clearance_approved', 'Request #22 approved at Institute', '2026-08-30 19:01:30'),
(510, 31, 'notifications_marked_read', 'User marked all notifications as read.', '2026-08-30 19:01:39'),
(511, 31, 'logout', 'User logged out.', '2026-08-30 19:07:25'),
(512, 5, 'login', 'User logged in successfully.', '2026-08-30 19:07:38'),
(513, 5, 'clearance_approved', 'Request #22 approved at Library', '2026-08-30 19:07:54'),
(514, 5, 'notifications_marked_read', 'User marked all notifications as read.', '2026-08-30 19:07:59'),
(515, 5, 'logout', 'User logged out.', '2026-08-30 19:08:10'),
(516, 6, 'login', 'User logged in successfully.', '2026-08-30 19:08:22'),
(517, 6, 'clearance_approved', 'Request #22 approved at Finance Office', '2026-08-30 19:08:36'),
(518, 6, 'notifications_marked_read', 'User marked all notifications as read.', '2026-08-30 19:08:44'),
(519, 6, 'logout', 'User logged out.', '2026-08-30 19:08:48'),
(520, 29, 'login', 'User logged in successfully.', '2026-08-30 19:09:14'),
(521, 29, 'clearance_rejected', 'Request #22 rejected at Dean\'s Office', '2026-08-30 19:09:47'),
(522, 29, 'notifications_marked_read', 'User marked all notifications as read.', '2026-08-30 19:09:54'),
(523, 29, 'logout', 'User logged out.', '2026-08-30 19:09:58'),
(524, 30, 'login', 'User logged in successfully.', '2026-08-30 19:10:12'),
(525, 30, 'notifications_marked_read', 'User marked all notifications as read.', '2026-08-30 19:10:23'),
(526, 30, 'clearance_resubmitted', 'Request #22 returned to department #4', '2026-08-30 19:10:34'),
(527, 30, 'notifications_marked_read', 'User marked all notifications as read.', '2026-08-30 19:10:39'),
(528, 30, 'logout', 'User logged out.', '2026-08-30 19:10:41'),
(529, 29, 'login', 'User logged in successfully.', '2026-08-30 19:10:53'),
(530, 29, 'clearance_approved', 'Request #22 approved at Dean\'s Office', '2026-08-30 19:11:03'),
(531, 29, 'logout', 'User logged out.', '2026-08-30 19:11:07'),
(532, 8, 'login', 'User logged in successfully.', '2026-08-30 19:11:17'),
(533, 8, 'clearance_approved', 'Request #22 approved at University Store Office', '2026-08-30 19:11:35'),
(534, 8, 'notifications_marked_read', 'User marked all notifications as read.', '2026-08-30 19:11:41'),
(535, 8, 'logout', 'User logged out.', '2026-08-30 19:11:43'),
(536, 9, 'login', 'User logged in successfully.', '2026-08-30 19:11:57'),
(537, 9, 'student_classification_saved', 'Classification saved for student ID 16: Second Class (Upper) (66.87%) by Academic Registrar: Academic Registrar', '2026-08-30 19:12:29'),
(538, 9, 'notifications_marked_read', 'User marked all notifications as read.', '2026-08-30 19:13:23'),
(539, 9, 'clearance_approved', 'Request #22 approved at Registry', '2026-08-30 19:13:48'),
(540, 9, 'logout', 'User logged out.', '2026-08-30 19:22:31'),
(541, 30, 'login', 'User logged in successfully.', '2026-08-30 19:22:41'),
(542, 30, 'notifications_marked_read', 'User marked all notifications as read.', '2026-08-30 19:24:07'),
(543, 30, 'logout', 'User logged out.', '2026-08-30 19:30:11'),
(544, 5, 'login', 'User logged in successfully.', '2026-08-30 19:30:21'),
(545, 5, 'logout', 'User logged out.', '2026-08-30 19:32:15'),
(546, 27, 'login', 'User logged in successfully.', '2026-08-30 19:32:27'),
(547, 27, 'logout', 'User logged out.', '2026-08-30 19:34:57'),
(548, 23, 'login', 'User logged in successfully.', '2026-08-30 19:35:09'),
(549, 23, 'logout', 'User logged out.', '2026-08-30 19:36:35'),
(550, 9, 'login', 'User logged in successfully.', '2026-08-30 19:59:17'),
(551, 9, 'logout', 'User logged out.', '2026-08-31 12:47:33'),
(552, 10, 'login', 'User logged in successfully.', '2026-08-31 12:47:50'),
(553, 10, 'logout', 'User logged out.', '2026-08-31 13:02:38'),
(554, 27, 'login', 'User logged in successfully.', '2026-08-31 13:02:51'),
(555, 27, 'logout', 'User logged out.', '2026-08-31 13:09:57'),
(556, 4, 'login', 'User logged in successfully.', '2026-08-31 13:10:10'),
(557, 4, 'logout', 'User logged out.', '2026-08-31 13:10:23'),
(558, 20, 'login', 'User logged in successfully.', '2026-08-31 13:10:34'),
(559, 20, 'notifications_marked_read', 'User marked all notifications as read.', '2026-08-31 13:11:06'),
(560, 20, 'logout', 'User logged out.', '2026-08-31 13:11:12'),
(561, 10, 'login', 'User logged in successfully.', '2026-08-31 13:11:24'),
(562, 10, 'logout', 'User logged out.', '2026-08-31 13:11:44'),
(563, 9, 'login', 'User logged in successfully.', '2026-08-31 13:11:55'),
(564, 9, 'logout', 'User logged out.', '2026-08-31 13:13:20'),
(565, 23, 'login', 'User logged in successfully.', '2026-08-31 13:13:31'),
(566, 23, 'logout', 'User logged out.', '2026-08-31 13:17:26'),
(567, 22, 'login', 'User logged in successfully.', '2026-08-31 13:17:38'),
(568, 22, 'logout', 'User logged out.', '2026-08-31 13:21:06'),
(569, 20, 'login', 'User logged in successfully.', '2026-08-31 13:21:17'),
(570, 20, 'logout', 'User logged out.', '2026-08-31 13:25:03'),
(571, 9, 'login', 'User logged in successfully.', '2026-08-31 13:25:14'),
(572, 9, 'logout', 'User logged out.', '2026-08-31 13:41:09'),
(573, 10, 'login', 'User logged in successfully.', '2026-08-31 13:41:21'),
(574, 10, 'logout', 'User logged out.', '2026-08-31 13:41:39'),
(575, 27, 'login', 'User logged in successfully.', '2026-08-31 13:42:21'),
(576, 27, 'logout', 'User logged out.', '2026-08-31 13:42:45'),
(577, 10, 'login', 'User logged in successfully.', '2026-08-31 13:42:57'),
(578, 10, 'user_updated', 'Administrator updated user: Catherine Ogutu', '2026-08-31 13:44:26'),
(579, 10, 'logout', 'User logged out.', '2026-08-31 13:44:45'),
(580, 10, 'login', 'User logged in successfully.', '2026-08-31 13:45:15'),
(581, 10, 'logout', 'User logged out.', '2026-08-31 13:49:16'),
(582, 10, 'login', 'User logged in successfully.', '2026-08-31 13:55:49'),
(583, 10, 'user_updated', 'Administrator updated user: Catherine Ogutu', '2026-08-31 13:56:10'),
(584, 10, 'logout', 'User logged out.', '2026-08-31 13:56:13'),
(585, 10, 'login', 'User logged in successfully.', '2026-08-31 14:16:21'),
(586, 10, 'user_updated', 'Administrator updated Librarian: Catherine Ogutu', '2026-08-31 14:16:43'),
(587, 10, 'logout', 'User logged out.', '2026-08-31 14:16:49'),
(588, 10, 'login', 'User logged in successfully.', '2026-08-31 14:31:26'),
(589, 10, 'user_updated', 'Administrator updated Librarian: Catherine Ogutu', '2026-08-31 14:31:48'),
(590, 10, 'logout', 'User logged out.', '2026-08-31 14:31:56'),
(591, 5, 'login', 'User logged in successfully.', '2026-08-31 14:37:05'),
(592, 5, 'logout', 'User logged out.', '2026-08-31 14:37:05'),
(593, 5, 'login', 'User logged in successfully.', '2026-08-31 14:37:17'),
(594, 5, 'logout', 'User logged out.', '2026-08-31 14:37:17'),
(595, 5, 'login', 'User logged in successfully.', '2026-08-31 14:37:31'),
(596, 5, 'logout', 'User logged out.', '2026-08-31 14:37:31'),
(597, 5, 'login', 'User logged in successfully.', '2026-08-31 15:18:16'),
(598, 5, 'logout', 'User logged out.', '2026-08-31 15:18:16'),
(599, 10, 'login', 'User logged in successfully.', '2026-08-31 15:18:31'),
(600, 10, 'logout', 'User logged out.', '2026-08-31 15:34:02'),
(601, 5, 'login', 'User logged in successfully.', '2026-08-31 15:34:14'),
(602, 5, 'logout', 'User logged out.', '2026-08-31 15:34:14'),
(603, 5, 'login', 'User logged in successfully.', '2026-08-31 15:44:09'),
(604, 5, 'logout', 'User logged out.', '2026-08-31 15:44:09'),
(605, 23, 'login', 'User logged in successfully.', '2026-08-31 15:44:21'),
(606, 23, 'logout', 'User logged out.', '2026-08-31 15:49:00'),
(607, 5, 'login', 'User logged in successfully.', '2026-08-31 15:49:10'),
(608, 5, 'logout', 'User logged out.', '2026-08-31 15:52:23'),
(609, 5, 'login', 'User logged in successfully.', '2026-08-31 15:52:33'),
(610, 5, 'logout', 'User logged out.', '2026-08-31 15:54:06'),
(611, 6, 'login', 'User logged in successfully.', '2026-08-31 15:54:16'),
(612, 6, 'logout', 'User logged out.', '2026-08-31 15:54:20'),
(613, 5, 'login', 'User logged in successfully.', '2026-08-31 15:57:26'),
(614, 5, 'logout', 'User logged out.', '2026-08-31 15:57:26'),
(615, 6, 'login', 'User logged in successfully.', '2026-08-31 15:57:44'),
(616, 6, 'logout', 'User logged out.', '2026-08-31 15:57:47'),
(617, 5, 'login', 'User logged in successfully.', '2026-08-31 15:59:58'),
(618, 5, 'logout', 'User logged out.', '2026-08-31 15:59:58'),
(619, 5, 'login', 'User logged in successfully.', '2026-08-31 18:32:03'),
(620, 5, 'logout', 'User logged out.', '2026-08-31 18:32:03'),
(621, 5, 'login', 'User logged in successfully.', '2026-08-31 18:32:57'),
(622, 5, 'logout', 'User logged out.', '2026-08-31 18:32:57'),
(623, 5, 'login', 'User logged in successfully.', '2026-08-31 18:40:04'),
(624, 5, 'logout', 'User logged out.', '2026-08-31 18:40:04'),
(625, 5, 'login', 'User logged in successfully.', '2026-08-31 20:07:24'),
(626, 5, 'logout', 'User logged out.', '2026-08-31 20:16:57'),
(627, 10, 'login', 'User logged in successfully.', '2026-08-31 20:17:11'),
(628, 10, 'student_created', 'Created student sc/16/2026', '2026-08-31 20:19:39'),
(629, 10, 'logout', 'User logged out.', '2026-08-31 20:19:56'),
(630, 32, 'login', 'User logged in successfully.', '2026-08-31 20:20:15'),
(631, 32, 'document_uploaded', 'final_year_project uploaded for student #17', '2026-08-31 20:21:09'),
(632, 32, 'document_uploaded', 'id_passport uploaded for student #17', '2026-08-31 20:21:29'),
(633, 1, 'clearance_request_created', 'Request #23', '2026-08-31 20:21:48'),
(634, 32, 'logout', 'User logged out.', '2026-08-31 20:21:57'),
(635, 26, 'login', 'User logged in successfully.', '2026-08-31 20:22:08'),
(636, 26, 'notifications_marked_read', 'User marked all notifications as read.', '2026-08-31 20:22:20'),
(637, 26, 'clearance_approved', 'Request #23 approved at Institute', '2026-08-31 20:22:45'),
(638, 26, 'logout', 'User logged out.', '2026-08-31 20:23:13'),
(639, 5, 'login', 'User logged in successfully.', '2026-08-31 20:24:11'),
(640, 5, 'notifications_marked_read', 'User marked all notifications as read.', '2026-08-31 20:24:19'),
(641, 5, 'logout', 'User logged out.', '2026-08-31 20:24:21'),
(642, 10, 'login', 'User logged in successfully.', '2026-08-31 20:24:37'),
(643, 10, 'student_created', 'Created student sc/17/2026', '2026-08-31 20:26:18'),
(644, 10, 'graduation_set_created', 'Created graduation set: grad27', '2026-08-31 20:28:48'),
(645, 10, 'graduation_set_activated', 'Activated graduation set ID: 5', '2026-08-31 20:28:53'),
(646, 10, 'graduation_set_activated', 'Activated graduation set ID: 4', '2026-08-31 20:28:59'),
(647, 10, 'logout', 'User logged out.', '2026-08-31 20:29:13'),
(648, 33, 'login', 'User logged in successfully.', '2026-08-31 20:29:28'),
(649, 33, 'document_uploaded', 'id_passport uploaded for student #18', '2026-08-31 20:29:58'),
(650, 33, 'document_uploaded', 'final_year_project uploaded for student #18', '2026-08-31 20:30:07'),
(651, 1, 'clearance_request_created', 'Request #24', '2026-08-31 20:30:24'),
(652, 33, 'logout', 'User logged out.', '2026-08-31 20:30:45'),
(653, 31, 'login', 'User logged in successfully.', '2026-08-31 20:31:00'),
(654, 31, 'clearance_approved', 'Request #24 approved at Institute', '2026-08-31 20:31:16'),
(655, 31, 'notifications_marked_read', 'User marked all notifications as read.', '2026-08-31 20:31:20'),
(656, 31, 'logout', 'User logged out.', '2026-08-31 20:31:38'),
(657, 5, 'login', 'User logged in successfully.', '2026-08-31 20:31:59'),
(658, 5, 'clearance_rejected', 'Request #24 rejected at Library', '2026-08-31 20:32:31'),
(659, 5, 'clearance_approved', 'Request #23 approved at Library', '2026-08-31 20:32:50'),
(660, 5, 'notifications_marked_read', 'User marked all notifications as read.', '2026-08-31 20:32:56'),
(661, 5, 'logout', 'User logged out.', '2026-08-31 20:33:02'),
(662, 33, 'login', 'User logged in successfully.', '2026-08-31 20:33:30'),
(663, 33, 'notifications_marked_read', 'User marked all notifications as read.', '2026-08-31 20:33:41'),
(664, 33, 'clearance_resubmitted', 'Request #24 returned to department #2', '2026-08-31 20:33:52'),
(665, 33, 'notifications_marked_read', 'User marked all notifications as read.', '2026-08-31 20:34:00'),
(666, 33, 'logout', 'User logged out.', '2026-08-31 20:34:05'),
(667, 5, 'login', 'User logged in successfully.', '2026-08-31 20:34:15'),
(668, 5, 'clearance_approved', 'Request #24 approved at Library', '2026-08-31 20:34:33'),
(669, 5, 'notifications_marked_read', 'User marked all notifications as read.', '2026-08-31 20:34:39'),
(670, 5, 'logout', 'User logged out.', '2026-08-31 20:34:44'),
(671, 27, 'login', 'User logged in successfully.', '2026-08-31 20:34:57'),
(672, 27, 'clearance_approved', 'Request #21 approved at Dean\'s Office', '2026-08-31 20:35:09');
INSERT INTO `audit_logs` (`audit_id`, `user_id`, `action`, `details`, `created_at`) VALUES
(673, 27, 'logout', 'User logged out.', '2026-08-31 20:35:57'),
(674, 27, 'login', 'User logged in successfully.', '2026-08-31 20:36:11'),
(675, 27, 'logout', 'User logged out.', '2026-08-31 20:36:31'),
(676, 29, 'login', 'User logged in successfully.', '2026-08-31 20:36:44'),
(677, 29, 'logout', 'User logged out.', '2026-08-31 20:36:56'),
(678, 6, 'login', 'User logged in successfully.', '2026-08-31 20:37:08'),
(679, 6, 'clearance_approved', 'Request #23 approved at Finance Office', '2026-08-31 20:37:18'),
(680, 6, 'clearance_approved', 'Request #24 approved at Finance Office', '2026-08-31 20:37:25'),
(681, 6, 'notifications_marked_read', 'User marked all notifications as read.', '2026-08-31 20:37:30'),
(682, 6, 'notifications_marked_read', 'User marked all notifications as read.', '2026-08-31 20:37:33'),
(683, 6, 'logout', 'User logged out.', '2026-08-31 20:37:37'),
(684, 27, 'login', 'User logged in successfully.', '2026-08-31 20:37:47'),
(685, 27, 'clearance_approved', 'Request #23 approved at Dean\'s Office', '2026-08-31 20:37:57'),
(686, 27, 'logout', 'User logged out.', '2026-08-31 20:39:10'),
(687, 29, 'login', 'User logged in successfully.', '2026-08-31 20:39:21'),
(688, 29, 'clearance_approved', 'Request #24 approved at Dean\'s Office', '2026-08-31 20:39:32'),
(689, 29, 'notifications_marked_read', 'User marked all notifications as read.', '2026-08-31 20:39:37'),
(690, 29, 'logout', 'User logged out.', '2026-08-31 20:39:41'),
(691, 8, 'login', 'User logged in successfully.', '2026-08-31 20:39:57'),
(692, 8, 'clearance_approved', 'Request #21 approved at University Store Office', '2026-08-31 20:40:09'),
(693, 8, 'clearance_approved', 'Request #23 approved at University Store Office', '2026-08-31 20:40:17'),
(694, 8, 'notifications_marked_read', 'User marked all notifications as read.', '2026-08-31 20:40:22'),
(695, 8, 'logout', 'User logged out.', '2026-08-31 20:40:35'),
(696, 9, 'login', 'User logged in successfully.', '2026-08-31 20:40:53'),
(697, 9, 'notifications_marked_read', 'User marked all notifications as read.', '2026-08-31 21:03:13'),
(698, 9, 'student_classification_saved', 'Classification saved for student ID 13: Credit (69.00%) by Academic Registrar: Academic Registrar', '2026-08-31 21:03:50'),
(699, 9, 'clearance_approved', 'Request #21 approved at Registry', '2026-08-31 21:04:13'),
(700, 9, 'student_classification_saved', 'Classification saved for student ID 17: Distinction (76.00%) by Academic Registrar: Academic Registrar', '2026-08-31 21:04:56'),
(701, 9, 'clearance_approved', 'Request #23 approved at Registry', '2026-08-31 21:06:22'),
(702, 9, 'logout', 'User logged out.', '2026-08-31 21:06:27'),
(703, 33, 'login', 'User logged in successfully.', '2026-08-31 21:06:39'),
(704, 33, 'logout', 'User logged out.', '2026-08-31 23:04:56'),
(705, 8, 'login', 'User logged in successfully.', '2026-08-31 23:05:07'),
(706, 8, 'clearance_approved', 'Request #24 approved at University Store Office', '2026-08-31 23:05:16'),
(707, 8, 'logout', 'User logged out.', '2026-08-31 23:05:18'),
(708, 9, 'login', 'User logged in successfully.', '2026-08-31 23:05:28'),
(709, 9, 'student_classification_saved', 'Classification saved for student ID 18: Second Class (Upper) (69.77%) by Academic Registrar: Academic Registrar', '2026-08-31 23:06:09'),
(710, 9, 'logout', 'User logged out.', '2026-08-31 23:06:16'),
(711, 33, 'login', 'User logged in successfully.', '2026-08-31 23:06:27'),
(712, 33, 'logout', 'User logged out.', '2026-08-31 23:06:33'),
(713, 9, 'login', 'User logged in successfully.', '2026-08-31 23:06:45'),
(714, 9, 'clearance_approved', 'Request #24 approved at Registry', '2026-08-31 23:07:02'),
(715, 9, 'notifications_marked_read', 'User marked all notifications as read.', '2026-08-31 23:07:27'),
(716, 9, 'logout', 'User logged out.', '2026-08-31 23:07:32'),
(717, 5, 'login', 'User logged in successfully.', '2026-08-31 23:07:43'),
(718, 5, 'logout', 'User logged out.', '2026-08-31 23:07:51'),
(719, 10, 'login', 'User logged in successfully.', '2026-08-31 23:08:12'),
(720, 10, 'student_created', 'Created student sc/18/2026', '2026-08-31 23:10:36'),
(721, 10, 'user_created', 'Administrator created Dean of School: Lillian Muli', '2026-08-31 23:15:21'),
(722, 10, 'logout', 'User logged out.', '2026-08-31 23:17:48'),
(723, 27, 'login', 'User logged in successfully.', '2026-08-31 23:23:13'),
(724, 27, 'logout', 'User logged out.', '2026-08-31 23:23:31'),
(725, 22, 'login', 'User logged in successfully.', '2026-08-31 23:23:42'),
(726, 22, 'clearance_approved', 'Request #20 approved at Dean\'s Office', '2026-08-31 23:24:10'),
(727, 22, 'logout', 'User logged out.', '2026-08-31 23:24:24'),
(728, 24, 'login', 'User logged in successfully.', '2026-08-31 23:24:35'),
(729, 24, 'notifications_marked_read', 'User marked all notifications as read.', '2026-08-31 23:24:51'),
(730, 24, 'logout', 'User logged out.', '2026-08-31 23:24:54'),
(731, 6, 'login', 'User logged in successfully.', '2026-08-31 23:25:07'),
(732, 6, 'logout', 'User logged out.', '2026-08-31 23:25:15'),
(733, 10, 'login', 'User logged in successfully.', '2026-09-01 08:49:25'),
(734, 10, 'logout', 'User logged out.', '2026-09-01 08:51:09'),
(735, 25, 'login', 'User logged in successfully.', '2026-09-01 08:51:24'),
(736, 25, 'notifications_marked_read', 'User marked all notifications as read.', '2026-09-01 08:51:43'),
(737, 25, 'logout', 'User logged out.', '2026-09-01 08:52:49'),
(738, 33, 'login', 'User logged in successfully.', '2026-09-01 08:53:01'),
(739, 33, 'notifications_marked_read', 'User marked all notifications as read.', '2026-09-01 08:53:12'),
(740, 33, 'logout', 'User logged out.', '2026-09-01 08:53:16'),
(741, 10, 'login', 'User logged in successfully.', '2026-09-01 08:53:47'),
(742, 10, 'logout', 'User logged out.', '2026-09-01 08:55:56'),
(743, 10, 'login', 'User logged in successfully.', '2026-09-01 08:56:10'),
(744, 10, 'student_created', 'Created student sc/19/2025', '2026-09-01 09:01:13'),
(745, 10, 'logout', 'User logged out.', '2026-09-01 09:01:29'),
(746, 36, 'login', 'User logged in successfully.', '2026-09-01 09:01:42'),
(747, 36, 'document_uploaded', 'id_passport uploaded for student #20', '2026-09-01 09:02:02'),
(748, 36, 'document_uploaded', 'final_year_project uploaded for student #20', '2026-09-01 09:02:15'),
(749, 36, 'logout', 'User logged out.', '2026-09-01 09:02:39'),
(750, 10, 'login', 'User logged in successfully.', '2026-09-01 09:02:53'),
(751, 10, 'user_created', 'Administrator created Director: Clinton Maina', '2026-09-01 09:03:50'),
(752, 10, 'logout', 'User logged out.', '2026-09-01 09:03:57'),
(753, 37, 'login', 'User logged in successfully.', '2026-09-01 09:04:09'),
(754, 37, 'logout', 'User logged out.', '2026-09-01 09:04:17'),
(755, 36, 'login', 'User logged in successfully.', '2026-09-01 09:04:31'),
(756, 36, 'clearance_request_created', 'Request #25', '2026-09-01 09:04:36'),
(757, 36, 'notifications_marked_read', 'User marked all notifications as read.', '2026-09-01 09:04:42'),
(758, 36, 'logout', 'User logged out.', '2026-09-01 09:04:44'),
(759, 37, 'login', 'User logged in successfully.', '2026-09-01 09:04:54'),
(760, 37, 'clearance_approved', 'Request #25 approved at Institute', '2026-09-01 09:05:05'),
(761, 37, 'logout', 'User logged out.', '2026-09-01 09:05:09'),
(762, 5, 'login', 'User logged in successfully.', '2026-09-01 09:05:21'),
(763, 5, 'clearance_rejected', 'Request #25 rejected at Library', '2026-09-01 09:05:36'),
(764, 5, 'logout', 'User logged out.', '2026-09-01 09:05:43'),
(765, 36, 'login', 'User logged in successfully.', '2026-09-01 09:05:54'),
(766, 36, 'clearance_resubmitted', 'Request #25 returned to department #2', '2026-09-01 09:06:13'),
(767, 36, 'logout', 'User logged out.', '2026-09-01 09:06:16'),
(768, 5, 'login', 'User logged in successfully.', '2026-09-01 09:06:26'),
(769, 5, 'clearance_approved', 'Request #25 approved at Library', '2026-09-01 09:06:44'),
(770, 5, 'logout', 'User logged out.', '2026-09-01 09:06:49'),
(771, 6, 'login', 'User logged in successfully.', '2026-09-01 09:07:01'),
(772, 6, 'clearance_approved', 'Request #25 approved at Finance Office', '2026-09-01 09:07:14'),
(773, 6, 'notifications_marked_read', 'User marked all notifications as read.', '2026-09-01 09:07:23'),
(774, 6, 'logout', 'User logged out.', '2026-09-01 09:07:24'),
(775, 35, 'login', 'User logged in successfully.', '2026-09-01 09:07:57'),
(776, 35, 'clearance_approved', 'Request #25 approved at Dean\'s Office', '2026-09-01 09:08:09'),
(777, 35, 'notifications_marked_read', 'User marked all notifications as read.', '2026-09-01 09:08:22'),
(778, 35, 'logout', 'User logged out.', '2026-09-01 09:08:48'),
(779, 37, 'login', 'User logged in successfully.', '2026-09-01 09:08:58'),
(780, 37, 'logout', 'User logged out.', '2026-09-01 09:09:19'),
(781, 8, 'login', 'User logged in successfully.', '2026-09-01 09:09:35'),
(782, 8, 'clearance_approved', 'Request #25 approved at University Store Office', '2026-09-01 09:09:52'),
(783, 8, 'logout', 'User logged out.', '2026-09-01 09:10:02'),
(784, 9, 'login', 'User logged in successfully.', '2026-09-01 09:10:12'),
(785, 9, 'student_classification_saved', 'Classification saved for student ID 20: Credit (74.80%) by Academic Registrar: Academic Registrar', '2026-09-01 09:10:59'),
(786, 9, 'logout', 'User logged out.', '2026-09-01 09:12:10'),
(787, 9, 'login', 'User logged in successfully.', '2026-09-01 09:12:22'),
(788, 9, 'clearance_approved', 'Request #25 approved at Registry', '2026-09-01 09:12:42'),
(789, 9, 'logout', 'User logged out.', '2026-09-01 09:12:51'),
(790, 36, 'login', 'User logged in successfully.', '2026-09-01 09:13:04'),
(791, 36, 'logout', 'User logged out.', '2026-09-01 09:32:05'),
(792, 10, 'login', 'User logged in successfully.', '2026-09-01 09:32:20'),
(793, 10, 'graduation_set_updated', 'Updated graduation set ID: 4', '2026-09-01 09:35:12'),
(794, 10, 'student_created', 'Created student 719', '2026-09-01 09:40:40'),
(795, 10, 'logout', 'User logged out.', '2026-09-01 09:40:52'),
(796, 38, 'login', 'User logged in successfully.', '2026-09-01 09:41:01'),
(797, 38, 'logout', 'User logged out.', '2026-09-01 09:41:45'),
(798, 10, 'login', 'User logged in successfully.', '2026-09-01 09:42:33'),
(799, 10, 'graduation_set_updated', 'Updated graduation set ID: 4', '2026-09-01 09:43:12'),
(800, 10, 'logout', 'User logged out.', '2026-09-01 09:43:17'),
(801, 38, 'login', 'User logged in successfully.', '2026-09-01 09:43:30'),
(802, 38, 'logout', 'User logged out.', '2026-09-01 09:50:45'),
(803, 10, 'login', 'User logged in successfully.', '2026-09-01 09:50:58'),
(804, 10, 'graduation_set_updated', 'Updated graduation set ID: 4', '2026-09-01 09:51:21'),
(805, 10, 'logout', 'User logged out.', '2026-09-01 09:51:25'),
(806, 38, 'login', 'User logged in successfully.', '2026-09-01 09:51:35'),
(807, 38, 'document_uploaded', 'id_passport uploaded for student #21', '2026-09-01 09:52:09'),
(808, 38, 'document_uploaded', 'final_year_project uploaded for student #21', '2026-09-01 09:52:17'),
(809, 38, 'logout', 'User logged out.', '2026-09-01 09:52:50'),
(810, 10, 'login', 'User logged in successfully.', '2026-09-01 09:52:59'),
(811, 10, 'graduation_set_updated', 'Updated graduation set ID: 4', '2026-09-01 09:53:14'),
(812, 10, 'logout', 'User logged out.', '2026-09-01 09:53:17'),
(813, 38, 'login', 'User logged in successfully.', '2026-09-01 09:53:24'),
(814, 1, 'clearance_request_created', 'Request #26', '2026-09-01 09:53:36'),
(815, 38, 'logout', 'User logged out.', '2026-09-01 10:04:03'),
(816, 20, 'login', 'User logged in successfully.', '2026-09-01 10:05:17'),
(817, 20, 'clearance_approved', 'Request #26 approved at Institute', '2026-09-01 10:05:47'),
(818, 20, 'logout', 'User logged out.', '2026-09-01 10:06:58'),
(819, 24, 'login', 'User logged in successfully.', '2026-09-01 10:07:08'),
(820, 24, 'logout', 'User logged out.', '2026-09-01 10:07:17'),
(821, 38, 'login', 'User logged in successfully.', '2026-09-01 10:07:31'),
(822, 38, 'logout', 'User logged out.', '2026-09-01 10:07:46'),
(823, 5, 'login', 'User logged in successfully.', '2026-09-01 10:07:56'),
(824, 5, 'clearance_approved', 'Request #26 approved at Library', '2026-09-01 10:08:32'),
(825, 5, 'logout', 'User logged out.', '2026-09-01 10:08:39'),
(826, 5, 'login', 'User logged in successfully.', '2026-09-01 10:08:52'),
(827, 5, 'logout', 'User logged out.', '2026-09-01 10:09:05'),
(828, 6, 'login', 'User logged in successfully.', '2026-09-01 10:09:14'),
(829, 6, 'clearance_approved', 'Request #26 approved at Finance Office', '2026-09-01 10:09:31'),
(830, 6, 'logout', 'User logged out.', '2026-09-01 10:10:35'),
(831, 27, 'login', 'User logged in successfully.', '2026-09-01 10:10:58'),
(832, 27, 'clearance_approved', 'Request #26 approved at Dean\'s Office', '2026-09-01 10:11:11'),
(833, 27, 'logout', 'User logged out.', '2026-09-01 10:12:25'),
(834, 8, 'login', 'User logged in successfully.', '2026-09-01 10:12:34'),
(835, 8, 'clearance_approved', 'Request #26 approved at University Store Office', '2026-09-01 10:13:04'),
(836, 8, 'logout', 'User logged out.', '2026-09-01 10:13:16'),
(837, 9, 'login', 'User logged in successfully.', '2026-09-01 10:13:30'),
(838, 9, 'student_classification_saved', 'Classification saved for student ID 21: Second Class (Upper) (68.00%) by Academic Registrar: Academic Registrar', '2026-09-01 10:16:56'),
(839, 9, 'clearance_approved', 'Request #26 approved at Registry', '2026-09-01 10:17:38'),
(840, 9, 'logout', 'User logged out.', '2026-09-01 10:18:48'),
(841, 38, 'login', 'User logged in successfully.', '2026-09-01 10:18:57'),
(842, 38, 'logout', 'User logged out.', '2026-09-01 10:22:27'),
(843, 10, 'login', 'User logged in successfully.', '2026-09-01 10:22:43'),
(844, 10, 'logout', 'User logged out.', '2026-09-01 10:29:26'),
(845, 38, 'login', 'User logged in successfully.', '2026-09-01 17:55:07'),
(846, 38, 'logout', 'User logged out.', '2026-09-01 17:59:13'),
(847, 5, 'login', 'User logged in successfully.', '2026-09-01 17:59:28'),
(848, 5, 'logout', 'User logged out.', '2026-09-01 17:59:45'),
(849, 10, 'login', 'User logged in successfully.', '2026-09-01 17:59:57'),
(850, 10, 'logout', 'User logged out.', '2026-09-01 18:00:07'),
(851, 38, 'login', 'User logged in successfully.', '2026-09-01 18:00:21'),
(852, 38, 'logout', 'User logged out.', '2026-09-01 18:10:47'),
(853, 5, 'login', 'User logged in successfully.', '2026-09-01 18:11:26'),
(854, 5, 'logout', 'User logged out.', '2026-09-01 18:18:28'),
(855, 38, 'login', 'User logged in successfully.', '2026-09-01 18:18:47'),
(856, 38, 'notifications_marked_read', 'User marked all notifications as read.', '2026-09-01 18:26:48'),
(857, 38, 'logout', 'User logged out.', '2026-09-01 19:50:41'),
(858, 5, 'login', 'User logged in successfully.', '2026-09-01 19:50:51'),
(859, 5, 'logout', 'User logged out.', '2026-09-01 19:51:07'),
(860, 9, 'login', 'User logged in successfully.', '2026-09-01 19:51:22'),
(861, 9, 'logout', 'User logged out.', '2026-09-01 19:51:34'),
(862, 38, 'login', 'User logged in successfully.', '2026-09-01 19:51:49'),
(863, 38, 'logout', 'User logged out.', '2026-09-01 19:53:12'),
(864, 5, 'login', 'User logged in successfully.', '2026-09-01 19:53:27'),
(865, 5, 'logout', 'User logged out.', '2026-09-01 19:56:24'),
(866, 38, 'login', 'User logged in successfully.', '2026-09-01 19:56:40'),
(867, 38, 'logout', 'User logged out.', '2026-09-01 19:58:45'),
(868, 9, 'login', 'User logged in successfully.', '2026-09-01 19:59:00'),
(869, 9, 'logout', 'User logged out.', '2026-09-01 20:01:21'),
(870, 38, 'login', 'User logged in successfully.', '2026-09-01 20:01:33'),
(871, 38, 'logout', 'User logged out.', '2026-09-01 20:02:23'),
(872, 38, 'login', 'User logged in successfully.', '2026-09-01 20:02:43'),
(873, 38, 'logout', 'User logged out.', '2026-09-01 20:03:07'),
(874, 5, 'login', 'User logged in successfully.', '2026-09-01 20:03:22'),
(875, 5, 'logout', 'User logged out.', '2026-09-01 20:15:26'),
(876, 6, 'login', 'User logged in successfully.', '2026-09-01 20:15:36'),
(877, 6, 'notifications_marked_read', 'User marked all notifications as read.', '2026-09-01 20:16:15'),
(878, 6, 'logout', 'User logged out.', '2026-09-01 20:16:17'),
(879, 5, 'login', 'User logged in successfully.', '2026-09-01 20:16:27'),
(880, 5, 'logout', 'User logged out.', '2026-09-01 20:18:30'),
(881, 8, 'login', 'User logged in successfully.', '2026-09-01 20:18:41'),
(882, 8, 'logout', 'User logged out.', '2026-09-01 20:25:00'),
(883, 6, 'login', 'User logged in successfully.', '2026-09-01 20:25:09'),
(884, 6, 'logout', 'User logged out.', '2026-09-01 20:35:43'),
(885, 6, 'login', 'User logged in successfully.', '2026-09-01 20:35:55'),
(886, 6, 'logout', 'User logged out.', '2026-09-01 20:35:58'),
(887, 6, 'login', 'User logged in successfully.', '2026-09-01 20:37:48'),
(888, 6, 'login', 'User logged in successfully.', '2026-09-02 07:30:46'),
(889, 6, 'logout', 'User logged out.', '2026-09-02 07:30:54'),
(890, 5, 'login', 'User logged in successfully.', '2026-09-02 07:31:11'),
(891, 5, 'logout', 'User logged out.', '2026-09-02 07:35:52'),
(892, 6, 'login', 'User logged in successfully.', '2026-09-02 07:36:14'),
(893, 6, 'logout', 'User logged out.', '2026-09-02 07:36:47'),
(894, 8, 'login', 'User logged in successfully.', '2026-09-02 07:36:57'),
(895, 8, 'logout', 'User logged out.', '2026-09-02 07:46:07'),
(896, 6, 'login', 'User logged in successfully.', '2026-09-02 07:46:17'),
(897, 6, 'logout', 'User logged out.', '2026-09-02 07:46:40'),
(898, 27, 'login', 'User logged in successfully.', '2026-09-02 07:46:59'),
(899, 27, 'logout', 'User logged out.', '2026-09-02 07:54:47'),
(900, 29, 'login', 'User logged in successfully.', '2026-09-02 07:54:58'),
(901, 29, 'logout', 'User logged out.', '2026-09-02 07:55:07'),
(902, 20, 'login', 'User logged in successfully.', '2026-09-02 07:55:43'),
(903, 20, 'logout', 'User logged out.', '2026-09-02 08:12:12'),
(904, 31, 'login', 'User logged in successfully.', '2026-09-02 08:12:25'),
(905, 31, 'logout', 'User logged out.', '2026-09-02 08:12:32'),
(906, 20, 'login', 'User logged in successfully.', '2026-09-02 08:12:42'),
(907, 20, 'logout', 'User logged out.', '2026-09-02 08:12:54'),
(908, 37, 'login', 'User logged in successfully.', '2026-09-02 08:13:14'),
(909, 37, 'notifications_marked_read', 'User marked all notifications as read.', '2026-09-02 08:13:42'),
(910, 37, 'logout', 'User logged out.', '2026-09-02 08:13:45'),
(911, 10, 'login', 'User logged in successfully.', '2026-09-02 08:14:00'),
(912, 10, 'student_created', 'Created student sc/76/2025', '2026-09-02 08:27:16'),
(913, 38, 'login', 'User logged in successfully.', '2026-09-03 15:09:24'),
(914, 38, 'logout', 'User logged out.', '2026-09-03 15:09:29'),
(915, 5, 'login', 'User logged in successfully.', '2026-09-03 15:09:41'),
(916, 5, 'logout', 'User logged out.', '2026-09-03 16:15:24'),
(917, 6, 'login', 'User logged in successfully.', '2026-09-03 16:15:35'),
(918, 6, 'logout', 'User logged out.', '2026-09-03 16:15:49'),
(919, 27, 'login', 'User logged in successfully.', '2026-09-03 16:16:02'),
(920, 27, 'logout', 'User logged out.', '2026-09-03 16:16:23'),
(921, 24, 'login', 'User logged in successfully.', '2026-09-03 16:16:41'),
(922, 24, 'logout', 'User logged out.', '2026-09-03 16:17:00'),
(923, 8, 'login', 'User logged in successfully.', '2026-09-03 16:17:21'),
(924, 8, 'notifications_marked_read', 'User marked all notifications as read.', '2026-09-03 16:17:44'),
(925, 8, 'logout', 'User logged out.', '2026-09-03 16:17:48'),
(926, 9, 'login', 'User logged in successfully.', '2026-09-03 16:18:04'),
(927, 9, 'logout', 'User logged out.', '2026-09-03 16:18:32'),
(928, 9, 'login', 'User logged in successfully.', '2026-09-03 16:18:45'),
(929, 9, 'logout', 'User logged out.', '2026-09-03 16:52:39'),
(930, 8, 'login', 'User logged in successfully.', '2026-09-03 16:53:16'),
(931, 8, 'logout', 'User logged out.', '2026-09-03 16:59:46'),
(932, 9, 'login', 'User logged in successfully.', '2026-09-03 16:59:59'),
(933, 9, 'logout', 'User logged out.', '2026-09-03 17:02:16'),
(934, 9, 'login', 'User logged in successfully.', '2026-09-03 17:02:30'),
(935, 9, 'logout', 'User logged out.', '2026-09-03 17:06:15'),
(936, 8, 'login', 'User logged in successfully.', '2026-09-03 17:06:26'),
(937, 8, 'clearance_approved', 'Request #20 approved at University Store Office', '2026-09-03 17:06:47'),
(938, 8, 'logout', 'User logged out.', '2026-09-03 17:07:10'),
(939, 9, 'login', 'User logged in successfully.', '2026-09-03 17:07:31'),
(940, 9, 'clearance_approved', 'Request #20 approved at Registry', '2026-09-04 22:20:19'),
(941, 9, 'student_classification_saved', 'Classification saved for student ID 12: Second Class (Upper) (67.00%)', '2026-09-04 22:20:19'),
(942, 9, 'logout', 'User logged out.', '2026-09-04 22:22:56'),
(943, 10, 'login', 'User logged in successfully.', '2026-09-04 22:23:11'),
(944, 10, 'student_created', 'Created student 123', '2026-09-04 22:25:06'),
(945, 10, 'logout', 'User logged out.', '2026-09-04 22:25:12'),
(946, 9, 'login', 'User logged in successfully.', '2026-09-04 22:32:03'),
(947, 9, 'logout', 'User logged out.', '2026-09-04 22:32:28'),
(948, 8, 'login', 'User logged in successfully.', '2026-09-04 22:32:37'),
(949, 8, 'logout', 'User logged out.', '2026-09-04 22:37:39'),
(950, 5, 'login', 'User logged in successfully.', '2026-09-04 22:37:49'),
(951, 5, 'logout', 'User logged out.', '2026-09-04 22:38:01'),
(952, 8, 'login', 'User logged in successfully.', '2026-09-04 22:38:10'),
(953, 8, 'logout', 'User logged out.', '2026-09-04 22:38:17'),
(954, 9, 'login', 'User logged in successfully.', '2026-09-04 22:38:28'),
(955, 9, 'logout', 'User logged out.', '2026-09-04 22:38:40'),
(956, 40, 'login', 'User logged in successfully.', '2026-09-04 22:38:51'),
(957, 40, 'document_uploaded', 'id_passport uploaded for student #23', '2026-09-04 22:39:21'),
(958, 40, 'document_uploaded', 'final_year_project uploaded for student #23', '2026-09-04 22:39:33'),
(959, 40, 'document_uploaded', 'final_year_project uploaded for student #23', '2026-09-04 22:41:56'),
(960, 40, 'document_uploaded', 'id_passport uploaded for student #23', '2026-09-04 22:42:06'),
(961, 40, 'logout', 'User logged out.', '2026-09-04 22:47:27'),
(962, 10, 'login', 'User logged in successfully.', '2026-09-04 22:47:40'),
(963, 10, 'logout', 'User logged out.', '2026-09-04 22:55:25'),
(964, 10, 'login', 'User logged in successfully.', '2026-09-04 22:55:38'),
(965, 10, 'graduation_set_updated', 'Updated graduation set ID: 4', '2026-09-04 22:56:17'),
(966, 10, 'logout', 'User logged out.', '2026-09-04 22:56:19'),
(967, 40, 'login', 'User logged in successfully.', '2026-09-04 22:56:37'),
(968, 40, 'logout', 'User logged out.', '2026-09-04 22:57:18'),
(969, 10, 'login', 'User logged in successfully.', '2026-09-04 22:57:30'),
(970, 10, 'graduation_set_updated', 'Updated graduation set ID: 4', '2026-09-04 22:57:53'),
(971, 10, 'logout', 'User logged out.', '2026-09-04 22:57:55'),
(972, 40, 'login', 'User logged in successfully.', '2026-09-04 22:58:04'),
(973, 40, 'clearance_request_created', 'Request #27', '2026-09-04 22:58:11'),
(974, 40, 'logout', 'User logged out.', '2026-09-04 22:58:15'),
(975, 20, 'login', 'User logged in successfully.', '2026-09-04 22:58:26'),
(976, 20, 'clearance_approved', 'Request #27 approved at Institute', '2026-09-04 22:59:08'),
(977, 20, 'notifications_marked_read', 'User marked all notifications as read.', '2026-09-04 23:00:04'),
(978, 20, 'logout', 'User logged out.', '2026-09-04 23:00:05'),
(979, 38, 'login', 'User logged in successfully.', '2026-09-10 12:32:52'),
(980, 38, 'logout', 'User logged out.', '2026-09-10 12:33:21'),
(981, 10, 'login', 'User logged in successfully.', '2026-09-10 12:33:32'),
(982, 10, 'user_updated', 'Administrator updated Director: Clinton Maina', '2026-09-10 12:44:19'),
(983, 10, 'logout', 'User logged out.', '2026-09-10 12:44:32'),
(984, 40, 'login', 'User logged in successfully.', '2026-09-10 12:44:44'),
(985, 40, 'logout', 'User logged out.', '2026-09-10 12:45:09'),
(986, 5, 'login', 'User logged in successfully.', '2026-09-10 12:45:20'),
(987, 5, 'logout', 'User logged out.', '2026-09-10 12:56:14'),
(988, 5, 'login', 'User logged in successfully.', '2026-09-10 12:56:24'),
(989, 5, 'logout', 'User logged out.', '2026-09-10 12:56:51'),
(990, 20, 'login', 'User logged in successfully.', '2026-09-10 12:57:02'),
(991, 20, 'logout', 'User logged out.', '2026-09-10 12:57:16'),
(992, 27, 'login', 'User logged in successfully.', '2026-09-10 12:57:26'),
(993, 27, 'logout', 'User logged out.', '2026-09-10 12:57:41'),
(994, 10, 'login', 'User logged in successfully.', '2026-09-10 12:57:53'),
(995, 10, 'logout', 'User logged out.', '2026-09-10 12:58:15'),
(996, 9, 'login', 'User logged in successfully.', '2026-09-10 12:58:27'),
(997, 9, 'logout', 'User logged out.', '2026-09-10 12:58:45');

-- --------------------------------------------------------

--
-- Table structure for table `clearance_requests`
--

CREATE TABLE `clearance_requests` (
  `request_id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `graduation_set_id` int(11) DEFAULT NULL,
  `submitted_at` datetime NOT NULL DEFAULT current_timestamp(),
  `overall_status` enum('Pending','Approved','In Progress','Rejected','Final') NOT NULL DEFAULT 'Pending',
  `current_dept_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `clearance_requests`
--

INSERT INTO `clearance_requests` (`request_id`, `student_id`, `graduation_set_id`, `submitted_at`, `overall_status`, `current_dept_id`) VALUES
(1, 1, 1, '2026-06-20 09:00:00', 'Rejected', 3),
(2, 2, 1, '2026-06-18 10:30:00', 'Rejected', 2),
(3, 3, 1, '2026-06-15 08:45:00', 'Final', NULL),
(4, 4, 1, '2026-08-09 18:51:03', 'Final', NULL),
(5, 5, 1, '2026-08-11 10:08:42', 'Rejected', 6),
(7, 8, 2, '2026-08-23 17:03:28', 'Final', NULL),
(9, 11, 4, '2026-08-29 12:46:24', 'Final', NULL),
(20, 12, 4, '2026-08-29 15:20:58', 'Final', NULL),
(21, 13, 4, '2026-08-29 16:15:43', 'Final', NULL),
(22, 16, 4, '2026-08-30 19:00:17', 'Final', NULL),
(23, 17, 4, '2026-08-31 20:21:48', 'Final', NULL),
(24, 18, 4, '2026-08-31 20:30:24', 'Final', NULL),
(25, 20, 4, '2026-09-01 09:04:36', 'Final', NULL),
(26, 21, 4, '2026-09-01 09:53:36', 'Final', NULL),
(27, 23, 4, '2026-09-04 22:58:11', 'In Progress', 2);

--
-- Triggers `clearance_requests`
--
DELIMITER $$
CREATE TRIGGER `trg_clearance_no_duplicate_active_insert` BEFORE INSERT ON `clearance_requests` FOR EACH ROW BEGIN
  IF NEW.graduation_set_id IS NULL THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Clearance request requires a graduation set'; END IF;
  IF NEW.overall_status IN ('Pending','In Progress','Rejected') AND EXISTS (SELECT 1 FROM clearance_requests WHERE student_id=NEW.student_id AND graduation_set_id=NEW.graduation_set_id AND overall_status IN ('Pending','In Progress','Rejected')) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Only one active clearance request per student and graduation set is allowed'; END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `departments`
--

CREATE TABLE `departments` (
  `dept_id` int(11) NOT NULL,
  `dept_name` varchar(100) NOT NULL,
  `sequence_no` int(11) NOT NULL,
  `officer_user_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `departments`
--

INSERT INTO `departments` (`dept_id`, `dept_name`, `sequence_no`, `officer_user_id`) VALUES
(1, 'Institute', 1, 4),
(2, 'Library', 2, 5),
(3, 'Finance Office', 3, 6),
(4, 'Dean\'s Office', 4, 7),
(5, 'University Store Office', 5, 8),
(6, 'Registry', 6, 9);

-- --------------------------------------------------------

--
-- Table structure for table `department_review_checks`
--

CREATE TABLE `department_review_checks` (
  `review_check_id` int(11) NOT NULL,
  `request_id` int(11) NOT NULL,
  `dept_id` int(11) NOT NULL,
  `physical_fyp_submitted` tinyint(1) DEFAULT NULL,
  `checked_by` int(11) DEFAULT NULL,
  `checked_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `department_review_checks`
--

INSERT INTO `department_review_checks` (`review_check_id`, `request_id`, `dept_id`, `physical_fyp_submitted`, `checked_by`, `checked_at`) VALUES
(1, 7, 2, 1, 5, '2026-08-29 11:03:21'),
(2, 2, 2, 0, 5, '2026-08-29 12:48:38'),
(3, 9, 2, 1, 5, '2026-08-29 12:49:02'),
(4, 20, 2, 1, 5, '2026-08-30 13:56:04'),
(5, 21, 2, 1, 5, '2026-08-30 13:56:19'),
(6, 22, 2, 1, 5, '2026-08-30 19:07:54'),
(7, 24, 2, 1, 5, '2026-08-31 20:34:33'),
(8, 23, 2, 1, 5, '2026-08-31 20:32:50'),
(10, 25, 2, 1, 5, '2026-09-01 09:06:44'),
(12, 26, 2, 1, 5, '2026-09-01 10:08:32');

-- --------------------------------------------------------

--
-- Table structure for table `final_approvals`
--

CREATE TABLE `final_approvals` (
  `approval_number` int(11) NOT NULL,
  `request_id` int(11) NOT NULL,
  `generated_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `final_approvals`
--

INSERT INTO `final_approvals` (`approval_number`, `request_id`, `generated_at`) VALUES
(1, 3, '2026-06-17 14:05:00'),
(2, 4, '2026-08-09 19:02:36'),
(3, 9, '2026-08-29 13:00:03'),
(4, 7, '2026-08-29 13:00:10'),
(5, 22, '2026-08-30 19:13:48'),
(6, 21, '2026-08-31 21:04:13'),
(7, 23, '2026-08-31 21:06:22'),
(8, 24, '2026-08-31 23:07:02'),
(9, 25, '2026-09-01 09:12:42'),
(10, 26, '2026-09-01 10:17:38'),
(11, 20, '2026-09-04 22:20:19');

-- --------------------------------------------------------

--
-- Table structure for table `graduation_applications`
--

CREATE TABLE `graduation_applications` (
  `graduation_application_id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `graduation_set_id` int(11) NOT NULL,
  `application_status` enum('Submitted','Approved','Rejected') NOT NULL DEFAULT 'Submitted',
  `applied_at` datetime NOT NULL DEFAULT current_timestamp(),
  `reviewed_at` datetime DEFAULT NULL,
  `reviewed_by` int(11) DEFAULT NULL,
  `remarks` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `graduation_sets`
--

CREATE TABLE `graduation_sets` (
  `graduation_set_id` int(11) NOT NULL,
  `set_name` varchar(100) NOT NULL,
  `graduation_year` year(4) NOT NULL,
  `academic_year` varchar(9) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 0,
  `starts_at` datetime DEFAULT NULL,
  `ends_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `graduation_sets`
--

INSERT INTO `graduation_sets` (`graduation_set_id`, `set_name`, `graduation_year`, `academic_year`, `is_active`, `starts_at`, `ends_at`) VALUES
(1, 'Legacy 2026 Graduation', '2026', NULL, 0, NULL, NULL),
(2, 'Graduation 2026', '2026', NULL, 0, '2026-08-20 18:14:00', '2026-09-20 18:14:00'),
(3, '2026 Graduation', '2026', NULL, 0, '2026-08-25 12:10:00', '2026-09-25 12:10:00'),
(4, 'Grad26', '2026', '2025-2026', 1, '2026-08-13 07:15:00', '2026-10-23 19:15:00'),
(5, 'grad27', '2027', '2026-2027', 0, '2026-01-07 20:28:00', '2027-02-28 20:28:00');

-- --------------------------------------------------------

--
-- Table structure for table `graduation_set_qualification_types`
--

CREATE TABLE `graduation_set_qualification_types` (
  `graduation_set_id` int(11) NOT NULL,
  `qualification_type_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `institutes`
--

CREATE TABLE `institutes` (
  `institute_id` int(11) NOT NULL,
  `school_id` int(11) DEFAULT NULL,
  `institute_name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `institutes`
--

INSERT INTO `institutes` (`institute_id`, `school_id`, `institute_name`) VALUES
(11, NULL, 'Centre for Leadership Management (CLM)'),
(9, NULL, 'Institute for Interreligious Dialogue and Islamic Studies (IRDIS)'),
(3, NULL, 'Institute for Social Transformation (IST)'),
(12, NULL, 'Institute of Communication, Journalism and Media Studies (ICJMS)'),
(10, NULL, 'Institute of Youth Studies (IYS)'),
(14, NULL, 'Tangaza Centre for Ethical Leadership & Safeguarding (TCELS)'),
(13, NULL, 'Tangaza English as a Foreign Language Program (TEFLAP)'),
(4, NULL, 'Unmapped - needs Admin review'),
(21, 1, 'Institute of Theology'),
(19, 2, 'Institute of Philosophy'),
(22, 2, 'Institute of Social Transformation'),
(17, 2, 'Institute of Youth Studies (IYS)'),
(23, 3, 'None'),
(24, 5, 'None');

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `notif_id` int(11) NOT NULL,
  `recipient_user_id` int(11) NOT NULL,
  `notif_type` varchar(50) NOT NULL,
  `message` text NOT NULL,
  `sent_at` datetime NOT NULL DEFAULT current_timestamp(),
  `is_read` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`notif_id`, `recipient_user_id`, `notif_type`, `message`, `sent_at`, `is_read`) VALUES
(1, 1, 'clearance_updated', 'Your clearance has moved to Finance Office.', '2026-06-21 10:00:00', 0),
(2, 2, 'clearance_rejected', 'Your clearance request was rejected. Please check the tracking page for comments.', '2026-06-19 09:15:00', 0),
(3, 3, 'final_approval_generated', 'Your Final Approval has been generated.', '2026-06-17 14:00:00', 0),
(4, 6, 'pending_clearance_request', 'A clearance request is waiting for Finance Office review.', '2026-06-21 10:00:00', 1),
(5, 9, 'transcript_request', 'Abigael K. Kirimi (1049507) has requested transcript support for graduation clearance.', '2026-06-21 11:00:00', 1),
(6, 10, 'student_registered', 'William Muruiki registered as sci/20/2026.', '2026-08-09 18:50:22', 1),
(7, 4, 'pending_clearance_request', 'A final transcript is ready for Institute Director review.', '2026-08-09 18:51:03', 0),
(8, 11, 'clearance_started', 'Your clearance request was submitted to the Institute Director.', '2026-08-09 18:51:03', 0),
(9, 11, 'clearance_updated', 'Your clearance has moved to Library.', '2026-08-09 18:52:10', 0),
(10, 5, 'pending_clearance_request', 'A clearance request is waiting for your department review.', '2026-08-09 18:52:10', 1),
(11, 11, 'clearance_updated', 'Your clearance has moved to Finance Office.', '2026-08-09 18:54:41', 0),
(12, 6, 'pending_clearance_request', 'A clearance request is waiting for your department review.', '2026-08-09 18:54:41', 1),
(13, 11, 'clearance_updated', 'Your clearance has moved to Dean of Students.', '2026-08-09 18:58:23', 0),
(14, 7, 'pending_clearance_request', 'A clearance request is waiting for your department review.', '2026-08-09 18:58:23', 0),
(15, 1, 'clearance_rejected', 'Your clearance request was rejected. Please check the tracking page for comments.', '2026-08-09 18:58:54', 0),
(16, 11, 'clearance_updated', 'Your clearance has moved to University Store.', '2026-08-09 18:59:55', 0),
(17, 8, 'pending_clearance_request', 'A clearance request is waiting for your department review.', '2026-08-09 18:59:55', 1),
(18, 11, 'clearance_updated', 'Your clearance has moved to Academic Registrar.', '2026-08-09 19:01:34', 0),
(19, 9, 'pending_clearance_request', 'A clearance request is waiting for your department review.', '2026-08-09 19:01:34', 1),
(20, 11, 'final_approval_generated', 'Your Final Approval has been generated.', '2026-08-09 19:02:36', 0),
(21, 4, 'transcript_uploaded', 'A final transcript is ready for Institute Director review.', '2026-08-11 10:02:08', 0),
(22, 1, 'transcript_uploaded', 'Your transcript was uploaded successfully.', '2026-08-11 10:02:08', 0),
(23, 6, 'resubmitted_request', 'A corrected clearance request has been resubmitted for review.', '2026-08-11 10:02:08', 1),
(24, 1, 'clearance_resubmitted', 'Your clearance request was resubmitted to the department that rejected it.', '2026-08-11 10:02:08', 0),
(25, 10, 'student_registered', 'Abby Kirimi registered as sc/56/2026.', '2026-08-11 10:06:05', 1),
(26, 4, 'pending_clearance_request', 'A final transcript is ready for Institute Director review.', '2026-08-11 10:08:42', 0),
(27, 12, 'clearance_started', 'Your clearance request was submitted to the Institute Director.', '2026-08-11 10:08:42', 0),
(28, 12, 'clearance_updated', 'Your clearance has moved to Library.', '2026-08-11 10:14:48', 0),
(29, 5, 'pending_clearance_request', 'A clearance request is waiting for your department review.', '2026-08-11 10:14:48', 1),
(30, 12, 'clearance_updated', 'Your clearance has moved to Finance Office.', '2026-08-11 10:24:03', 0),
(31, 6, 'pending_clearance_request', 'A clearance request is waiting for your department review.', '2026-08-11 10:24:03', 1),
(32, 12, 'clearance_updated', 'Your clearance has moved to Dean of Students.', '2026-08-11 10:25:48', 0),
(33, 7, 'pending_clearance_request', 'A clearance request is waiting for your department review.', '2026-08-11 10:25:48', 0),
(34, 12, 'clearance_updated', 'Your clearance has moved to University Store.', '2026-08-11 10:27:53', 0),
(35, 8, 'pending_clearance_request', 'A clearance request is waiting for your department review.', '2026-08-11 10:27:53', 1),
(36, 12, 'clearance_updated', 'Your clearance has moved to Academic Registrar.', '2026-08-11 10:29:00', 0),
(37, 9, 'pending_clearance_request', 'A clearance request is waiting for your department review.', '2026-08-11 10:29:00', 1),
(38, 12, 'clearance_rejected', 'Your clearance request was rejected. Please check the tracking page for comments.', '2026-08-11 10:29:55', 0),
(39, 1, 'clearance_rejected', 'Your clearance was rejected: No fee structure', '2026-08-22 18:40:08', 0),
(40, 4, 'pending_clearance_request', 'A clearance request awaits Institute Director review.', '2026-08-23 17:03:28', 0),
(41, 16, 'clearance_started', 'Your clearance request was initiated.', '2026-08-23 17:03:28', 0),
(42, 16, 'clearance_updated', 'Your clearance has moved to Library.', '2026-08-25 12:04:38', 0),
(43, 5, 'pending_clearance_request', 'A clearance request awaits review.', '2026-08-25 12:04:38', 1),
(44, 5, 'resubmitted_request', 'A corrected clearance request awaits re-review.', '2026-08-25 12:52:46', 1),
(45, 2, 'clearance_resubmitted', 'Your request has returned to the department that rejected it.', '2026-08-25 12:52:46', 0),
(46, 12, 'classification_saved', 'Your academic classification has been recorded: Second Class (Upper)', '2026-08-28 19:46:10', 0),
(47, 11, 'classification_saved', 'Your academic classification has been recorded: Pass', '2026-08-28 19:54:16', 0),
(48, 1, 'classification_saved', 'Your academic classification has been recorded: Distinction', '2026-08-28 20:08:30', 0),
(49, 16, 'clearance_updated', 'Your clearance has moved to Finance Office.', '2026-08-29 11:03:21', 0),
(50, 6, 'pending_clearance_request', 'A clearance request awaits review.', '2026-08-29 11:03:21', 1),
(51, 16, 'clearance_updated', 'Your clearance has moved to Dean\'s Office.', '2026-08-29 11:06:16', 0),
(52, 7, 'pending_clearance_request', 'A clearance request awaits review.', '2026-08-29 11:06:16', 0),
(53, 16, 'clearance_updated', 'Your clearance has moved to University Store Office.', '2026-08-29 11:08:32', 0),
(54, 8, 'pending_clearance_request', 'A clearance request awaits review.', '2026-08-29 11:08:32', 1),
(57, 20, 'pending_clearance_request', 'A clearance request from your institute awaits Institute Director review.', '2026-08-29 12:46:24', 1),
(58, 21, 'clearance_started', 'Your clearance request was initiated.', '2026-08-29 12:46:24', 0),
(59, 21, 'clearance_updated', 'Your clearance has moved to Library.', '2026-08-29 12:47:20', 0),
(60, 5, 'pending_clearance_request', 'A clearance request awaits review.', '2026-08-29 12:47:20', 1),
(61, 2, 'clearance_rejected', 'Your clearance was rejected: no physical project submitted', '2026-08-29 12:48:38', 0),
(62, 21, 'clearance_updated', 'Your clearance has moved to Finance Office.', '2026-08-29 12:49:02', 0),
(63, 6, 'pending_clearance_request', 'A clearance request awaits review.', '2026-08-29 12:49:02', 1),
(64, 21, 'clearance_rejected', 'Your clearance was rejected: balance of 5000/= graduation fee', '2026-08-29 12:50:44', 0),
(65, 6, 'resubmitted_request', 'A corrected clearance request awaits re-review.', '2026-08-29 12:54:52', 1),
(66, 21, 'clearance_resubmitted', 'Your request has returned to the department that rejected it.', '2026-08-29 12:54:52', 0),
(67, 21, 'clearance_updated', 'Your clearance has moved to Dean\'s Office.', '2026-08-29 12:55:46', 0),
(68, 7, 'pending_clearance_request', 'A clearance request awaits review.', '2026-08-29 12:55:46', 0),
(69, 21, 'clearance_updated', 'Your clearance has moved to University Store Office.', '2026-08-29 12:58:17', 0),
(70, 8, 'pending_clearance_request', 'A clearance request awaits review.', '2026-08-29 12:58:17', 1),
(71, 16, 'clearance_updated', 'Your clearance has moved to Registry.', '2026-08-29 12:58:50', 0),
(72, 9, 'pending_clearance_request', 'A clearance request awaits review.', '2026-08-29 12:58:50', 1),
(73, 21, 'clearance_updated', 'Your clearance has moved to Registry.', '2026-08-29 12:59:01', 0),
(74, 9, 'pending_clearance_request', 'A clearance request awaits review.', '2026-08-29 12:59:01', 1),
(75, 21, 'final_approval_generated', 'Your Final Approval has been granted by the Academic Registrar.', '2026-08-29 13:00:03', 0),
(76, 16, 'final_approval_generated', 'Your Final Approval has been granted by the Academic Registrar.', '2026-08-29 13:00:10', 0),
(77, 21, 'classification_saved', 'Your academic classification has been recorded: First Class Honours. Average mark: 72.18%.', '2026-08-29 13:00:35', 0),
(98, 24, 'pending_clearance_request', 'A clearance request from your institute awaits Institute Director review.', '2026-08-29 15:20:58', 1),
(99, 1, 'clearance_started', 'Your clearance request was initiated.', '2026-08-29 15:20:58', 0),
(100, 26, 'pending_clearance_request', 'A clearance request from your institute awaits Institute Director review.', '2026-08-29 16:15:43', 1),
(101, 1, 'clearance_started', 'Your clearance request was initiated.', '2026-08-29 16:15:43', 0),
(102, 25, 'clearance_updated', 'Your clearance has moved to Library.', '2026-08-29 16:17:11', 1),
(103, 5, 'pending_clearance_request', 'A clearance request awaits review.', '2026-08-29 16:17:11', 1),
(104, 23, 'clearance_rejected', 'Your clearance was rejected by Institute: Has not completed his project', '2026-08-29 16:18:20', 1),
(105, 24, 'resubmitted_request', 'A corrected clearance request awaits re-review.', '2026-08-29 16:18:57', 1),
(106, 23, 'clearance_resubmitted', 'Your request has returned to the department that rejected it.', '2026-08-29 16:18:57', 1),
(107, 23, 'clearance_updated', 'Your clearance has moved to Library.', '2026-08-29 16:19:51', 1),
(108, 5, 'pending_clearance_request', 'A clearance request awaits review.', '2026-08-29 16:19:51', 1),
(109, 23, 'clearance_updated', 'Your clearance has moved to Finance Office.', '2026-08-30 13:56:04', 1),
(110, 6, 'pending_clearance_request', 'A clearance request awaits review.', '2026-08-30 13:56:04', 1),
(111, 25, 'clearance_updated', 'Your clearance has moved to Finance Office.', '2026-08-30 13:56:19', 1),
(112, 6, 'pending_clearance_request', 'A clearance request awaits review.', '2026-08-30 13:56:19', 1),
(113, 23, 'clearance_updated', 'Your clearance has moved to Dean\'s Office.', '2026-08-30 13:57:28', 1),
(114, 7, 'pending_clearance_request', 'A clearance request awaits review.', '2026-08-30 13:57:28', 0),
(115, 25, 'clearance_updated', 'Your clearance has moved to Dean\'s Office.', '2026-08-30 13:57:34', 1),
(116, 7, 'pending_clearance_request', 'A clearance request awaits review.', '2026-08-30 13:57:34', 0),
(117, 31, 'pending_clearance_request', 'A clearance request from your institute awaits Institute Director review.', '2026-08-30 19:00:17', 1),
(118, 1, 'clearance_started', 'Your clearance request was initiated.', '2026-08-30 19:00:17', 0),
(119, 30, 'clearance_updated', 'Your clearance has moved to Library.', '2026-08-30 19:01:30', 1),
(120, 5, 'pending_clearance_request', 'A clearance request is awaiting your review.', '2026-08-30 19:01:30', 1),
(121, 30, 'clearance_updated', 'Your clearance has moved to Finance Office.', '2026-08-30 19:07:54', 1),
(122, 6, 'pending_clearance_request', 'A clearance request is awaiting your review.', '2026-08-30 19:07:54', 1),
(123, 30, 'clearance_updated', 'Your clearance has moved to Dean\'s Office.', '2026-08-30 19:08:36', 1),
(124, 29, 'pending_clearance_request', 'A clearance request is awaiting your review.', '2026-08-30 19:08:36', 1),
(125, 30, 'clearance_rejected', 'Your clearance was rejected by Dean\'s Office: not yet', '2026-08-30 19:09:47', 1),
(126, 7, 'resubmitted_request', 'A corrected clearance request awaits re-review.', '2026-08-30 19:10:34', 0),
(127, 30, 'clearance_resubmitted', 'Your request has returned to the department that rejected it.', '2026-08-30 19:10:34', 1),
(128, 30, 'clearance_updated', 'Your clearance has moved to University Store Office.', '2026-08-30 19:11:03', 1),
(129, 8, 'pending_clearance_request', 'A clearance request is awaiting your review.', '2026-08-30 19:11:03', 1),
(130, 30, 'clearance_updated', 'Your clearance has moved to Registry.', '2026-08-30 19:11:35', 1),
(131, 9, 'pending_clearance_request', 'A clearance request is awaiting your review.', '2026-08-30 19:11:35', 1),
(132, 30, 'classification_saved', 'Your academic classification has been recorded: Second Class (Upper). Average mark: 66.87%.', '2026-08-30 19:12:29', 1),
(133, 30, 'final_approval_generated', 'Your Final Approval has been granted by the Academic Registrar.', '2026-08-30 19:13:48', 1),
(134, 26, 'pending_clearance_request', 'A clearance request from your institute awaits Institute Director review.', '2026-08-31 20:21:48', 1),
(135, 1, 'clearance_started', 'Your clearance request was initiated.', '2026-08-31 20:21:48', 0),
(136, 32, 'clearance_updated', 'Your clearance has moved to Library.', '2026-08-31 20:22:45', 0),
(137, 5, 'pending_clearance_request', 'A clearance request is awaiting your review.', '2026-08-31 20:22:45', 1),
(138, 31, 'pending_clearance_request', 'A clearance request from your institute awaits Institute Director review.', '2026-08-31 20:30:24', 1),
(139, 1, 'clearance_started', 'Your clearance request was initiated.', '2026-08-31 20:30:24', 0),
(140, 33, 'clearance_updated', 'Your clearance has moved to Library.', '2026-08-31 20:31:16', 1),
(141, 5, 'pending_clearance_request', 'A clearance request is awaiting your review.', '2026-08-31 20:31:16', 1),
(142, 33, 'clearance_rejected', 'Your clearance was rejected by Library: Submit project.', '2026-08-31 20:32:31', 1),
(143, 32, 'clearance_updated', 'Your clearance has moved to Finance Office.', '2026-08-31 20:32:50', 0),
(144, 6, 'pending_clearance_request', 'A clearance request is awaiting your review.', '2026-08-31 20:32:50', 1),
(145, 5, 'resubmitted_request', 'A corrected clearance request awaits re-review.', '2026-08-31 20:33:52', 1),
(146, 33, 'clearance_resubmitted', 'Your request has returned to the department that rejected it.', '2026-08-31 20:33:52', 1),
(147, 33, 'clearance_updated', 'Your clearance has moved to Finance Office.', '2026-08-31 20:34:33', 1),
(148, 6, 'pending_clearance_request', 'A clearance request is awaiting your review.', '2026-08-31 20:34:33', 1),
(149, 25, 'clearance_updated', 'Your clearance has moved to University Store Office.', '2026-08-31 20:35:09', 1),
(150, 8, 'pending_clearance_request', 'A clearance request is awaiting your review.', '2026-08-31 20:35:09', 1),
(151, 32, 'clearance_updated', 'Your clearance has moved to Dean\'s Office.', '2026-08-31 20:37:18', 0),
(152, 27, 'pending_clearance_request', 'A clearance request is awaiting your review.', '2026-08-31 20:37:18', 0),
(153, 33, 'clearance_updated', 'Your clearance has moved to Dean\'s Office.', '2026-08-31 20:37:25', 1),
(154, 29, 'pending_clearance_request', 'A clearance request is awaiting your review.', '2026-08-31 20:37:25', 1),
(155, 32, 'clearance_updated', 'Your clearance has moved to University Store Office.', '2026-08-31 20:37:57', 0),
(156, 8, 'pending_clearance_request', 'A clearance request is awaiting your review.', '2026-08-31 20:37:57', 1),
(157, 33, 'clearance_updated', 'Your clearance has moved to University Store Office.', '2026-08-31 20:39:32', 1),
(158, 8, 'pending_clearance_request', 'A clearance request is awaiting your review.', '2026-08-31 20:39:32', 1),
(159, 25, 'clearance_updated', 'Your clearance has moved to Registry.', '2026-08-31 20:40:09', 1),
(160, 9, 'pending_clearance_request', 'A clearance request is awaiting your review.', '2026-08-31 20:40:09', 1),
(161, 32, 'clearance_updated', 'Your clearance has moved to Registry.', '2026-08-31 20:40:17', 0),
(162, 9, 'pending_clearance_request', 'A clearance request is awaiting your review.', '2026-08-31 20:40:17', 1),
(163, 25, 'classification_saved', 'Your academic classification has been recorded: Credit. Average mark: 69.00%.', '2026-08-31 21:03:50', 1),
(164, 25, 'final_approval_generated', 'Your Final Approval has been granted by the Academic Registrar.', '2026-08-31 21:04:13', 1),
(165, 32, 'classification_saved', 'Your academic classification has been recorded: Distinction. Average mark: 76.00%.', '2026-08-31 21:04:56', 0),
(166, 32, 'final_approval_generated', 'Your Final Approval has been granted by the Academic Registrar.', '2026-08-31 21:06:22', 0),
(167, 33, 'clearance_updated', 'Your clearance has moved to Registry.', '2026-08-31 23:05:16', 1),
(168, 9, 'pending_clearance_request', 'A clearance request is awaiting your review.', '2026-08-31 23:05:16', 1),
(169, 33, 'classification_saved', 'Your academic classification has been recorded: Second Class (Upper). Average mark: 69.77%.', '2026-08-31 23:06:09', 1),
(170, 33, 'final_approval_generated', 'Your Final Approval has been granted by the Academic Registrar.', '2026-08-31 23:07:02', 1),
(171, 23, 'clearance_updated', 'Your clearance has moved to University Store Office.', '2026-08-31 23:24:10', 0),
(172, 8, 'pending_clearance_request', 'A clearance request is awaiting your review.', '2026-08-31 23:24:10', 1),
(173, 37, 'pending_clearance_request', 'A clearance request from your institute awaits Institute Director review.', '2026-09-01 09:04:36', 1),
(174, 36, 'clearance_started', 'Your clearance request was initiated.', '2026-09-01 09:04:36', 1),
(175, 36, 'clearance_updated', 'Your clearance has moved to Library.', '2026-09-01 09:05:05', 0),
(176, 5, 'pending_clearance_request', 'A clearance request is awaiting your review.', '2026-09-01 09:05:05', 0),
(177, 36, 'clearance_rejected', 'Your clearance was rejected by Library: no document submitted.', '2026-09-01 09:05:36', 0),
(178, 5, 'resubmitted_request', 'A corrected clearance request awaits re-review.', '2026-09-01 09:06:13', 0),
(179, 36, 'clearance_resubmitted', 'Your request has returned to the department that rejected it.', '2026-09-01 09:06:13', 0),
(180, 36, 'clearance_updated', 'Your clearance has moved to Finance Office.', '2026-09-01 09:06:44', 0),
(181, 6, 'pending_clearance_request', 'A clearance request is awaiting your review.', '2026-09-01 09:06:44', 1),
(182, 36, 'clearance_updated', 'Your clearance has moved to Dean\'s Office.', '2026-09-01 09:07:14', 0),
(183, 35, 'pending_clearance_request', 'A clearance request is awaiting your review.', '2026-09-01 09:07:14', 1),
(184, 36, 'clearance_updated', 'Your clearance has moved to University Store Office.', '2026-09-01 09:08:09', 0),
(185, 8, 'pending_clearance_request', 'A clearance request is awaiting your review.', '2026-09-01 09:08:09', 1),
(186, 36, 'clearance_updated', 'Your clearance has moved to Registry.', '2026-09-01 09:09:52', 0),
(187, 9, 'pending_clearance_request', 'A clearance request is awaiting your review.', '2026-09-01 09:09:52', 0),
(188, 36, 'classification_saved', 'Your academic classification has been recorded: Credit. Average mark: 74.80%.', '2026-09-01 09:10:59', 0),
(189, 36, 'final_approval_generated', 'Your Final Approval has been granted by the Academic Registrar.', '2026-09-01 09:12:42', 0),
(190, 20, 'pending_clearance_request', 'A clearance request from your institute awaits Institute Director review.', '2026-09-01 09:53:36', 1),
(191, 1, 'clearance_started', 'Your clearance request was initiated.', '2026-09-01 09:53:36', 0),
(192, 38, 'clearance_updated', 'Your clearance has moved to Library.', '2026-09-01 10:05:47', 1),
(193, 5, 'pending_clearance_request', 'A clearance request is awaiting your review.', '2026-09-01 10:05:47', 0),
(194, 38, 'clearance_updated', 'Your clearance has moved to Finance Office.', '2026-09-01 10:08:32', 1),
(195, 6, 'pending_clearance_request', 'A clearance request is awaiting your review.', '2026-09-01 10:08:32', 1),
(196, 38, 'clearance_updated', 'Your clearance has moved to Dean\'s Office.', '2026-09-01 10:09:31', 1),
(197, 27, 'pending_clearance_request', 'A clearance request is awaiting your review.', '2026-09-01 10:09:31', 0),
(198, 38, 'clearance_updated', 'Your clearance has moved to University Store Office.', '2026-09-01 10:11:11', 1),
(199, 8, 'pending_clearance_request', 'A clearance request is awaiting your review.', '2026-09-01 10:11:11', 1),
(200, 38, 'clearance_updated', 'Your clearance has moved to Registry.', '2026-09-01 10:13:04', 1),
(201, 9, 'pending_clearance_request', 'A clearance request is awaiting your review.', '2026-09-01 10:13:04', 0),
(202, 38, 'classification_saved', 'Your academic classification has been recorded: Second Class (Upper). Average mark: 68.00%.', '2026-09-01 10:16:56', 1),
(203, 38, 'final_approval_generated', 'Your Final Approval has been granted by the Academic Registrar.', '2026-09-01 10:17:38', 1),
(204, 23, 'clearance_updated', 'Your clearance has moved to Registry.', '2026-09-03 17:06:47', 0),
(205, 9, 'pending_clearance_request', 'A clearance request is awaiting your review.', '2026-09-03 17:06:47', 0),
(206, 23, 'final_approval_generated', 'Your Final Approval has been granted by the Academic Registrar.', '2026-09-04 22:20:19', 0),
(207, 23, 'classification_saved', 'Your academic classification has been recorded: Second Class (Upper). Average mark: 67.00%.', '2026-09-04 22:20:19', 0),
(208, 20, 'pending_clearance_request', 'A clearance request from your institute awaits Institute Director review.', '2026-09-04 22:58:11', 1),
(209, 40, 'clearance_started', 'Your clearance request was initiated.', '2026-09-04 22:58:11', 0),
(210, 40, 'clearance_updated', 'Your clearance has moved to Library.', '2026-09-04 22:59:08', 0),
(211, 5, 'pending_clearance_request', 'A clearance request is awaiting your review.', '2026-09-04 22:59:08', 0);

-- --------------------------------------------------------

--
-- Table structure for table `programmes`
--

CREATE TABLE `programmes` (
  `programme_id` int(11) NOT NULL,
  `institute_id` int(11) NOT NULL,
  `programme_name` varchar(100) NOT NULL,
  `qualification_type_id` int(11) DEFAULT NULL,
  `specialisation` varchar(150) DEFAULT NULL,
  `level` enum('Postgraduate','Undergraduate','Diploma','Certificate') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `programmes`
--

INSERT INTO `programmes` (`programme_id`, `institute_id`, `programme_name`, `qualification_type_id`, `specialisation`, `level`) VALUES
(2, 4, 'Bachelor of Science in Computer Science', NULL, NULL, NULL),
(8, 4, '[Unmapped - needs Admin review] Sample Programme - replace via Admin', NULL, NULL, NULL),
(12, 10, 'Bachelor of Arts in Counselling Psychology', NULL, NULL, NULL),
(14, 17, 'Diploma in Counselling Psychology', NULL, NULL, NULL),
(16, 19, 'Bachelor of Arts in Philosophy', 4, 'none', NULL),
(18, 21, 'Baccalaureate in Sacred Theology', 4, 'none', NULL),
(19, 22, 'Diploma in Social Ministry', 2, 'none', NULL),
(20, 23, 'Bachelor of Education', 4, 'Science', NULL),
(21, 23, 'Diploma in Education', 2, 'Arts and Sciences', NULL),
(23, 24, 'Diploma in Computer Science', 2, 'none', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `programme_specialisations`
--

CREATE TABLE `programme_specialisations` (
  `specialisation_id` int(11) NOT NULL,
  `programme_id` int(11) NOT NULL,
  `specialisation_name` varchar(150) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `programme_specialisations`
--

INSERT INTO `programme_specialisations` (`specialisation_id`, `programme_id`, `specialisation_name`, `created_at`) VALUES
(1, 20, 'Mathematics', '2026-08-30 15:30:52'),
(2, 20, 'English', '2026-08-30 15:30:52'),
(3, 20, 'Geography', '2026-08-30 15:30:52'),
(4, 20, 'History', '2026-08-30 15:30:52');

-- --------------------------------------------------------

--
-- Table structure for table `qualification_types`
--

CREATE TABLE `qualification_types` (
  `qualification_type_id` int(11) NOT NULL,
  `qualification_name` varchar(100) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `qualification_types`
--

INSERT INTO `qualification_types` (`qualification_type_id`, `qualification_name`, `is_active`, `created_at`) VALUES
(1, 'Certificate', 1, '2026-08-29 12:06:49'),
(2, 'Diploma', 1, '2026-08-29 12:06:49'),
(3, 'Advanced Diploma', 1, '2026-08-29 12:06:49'),
(4, 'Bachelor\'s Degree', 1, '2026-08-29 12:06:49'),
(5, 'Postgraduate Diploma', 1, '2026-08-29 12:06:49'),
(6, 'Master\'s Degree', 1, '2026-08-29 12:06:49'),
(7, 'Doctorate', 1, '2026-08-29 12:06:49'),
(8, 'Other', 1, '2026-08-29 12:06:49');

-- --------------------------------------------------------

--
-- Table structure for table `schema_migrations`
--

CREATE TABLE `schema_migrations` (
  `migration_id` varchar(100) NOT NULL,
  `applied_at` datetime NOT NULL DEFAULT current_timestamp(),
  `checksum` varchar(64) DEFAULT NULL,
  `notes` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `schema_migrations`
--

INSERT INTO `schema_migrations` (`migration_id`, `applied_at`, `checksum`, `notes`) VALUES
('001_requirements_1_2_foundation', '2026-08-20 18:00:57', NULL, 'Requirements 1-2 foundation'),
('002_part_3_4_profile_workflow_safeguards', '2026-08-20 17:54:14', NULL, 'Document metadata and active-clearance trigger'),
('003_part_5_6_review_security', '2026-08-20 17:58:08', NULL, 'Immutable decisions and Library physical FYP checks'),
('004_academic_structure_correction', '2026-08-20 18:53:47', NULL, 'Official academic references; corrected programmes; explicit unmapped reconciliation'),
('005_programme_levels_and_profile_status', '2026-08-22 09:55:54', NULL, 'Nullable programme levels; existing rows require Admin classification'),
('006_add_student_stage_and_graduation_application', '2026-08-28 13:22:14', NULL, 'Added student stage and graduation applications');

-- --------------------------------------------------------

--
-- Table structure for table `schools`
--

CREATE TABLE `schools` (
  `school_id` int(11) NOT NULL,
  `school_name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `schools`
--

INSERT INTO `schools` (`school_id`, `school_name`) VALUES
(4, 'School of Applied Science & Technology'),
(2, 'School of Arts and Social Sciences'),
(3, 'School of Education'),
(1, 'School of Theology'),
(5, 'TU TVET Institute');

-- --------------------------------------------------------

--
-- Table structure for table `students`
--

CREATE TABLE `students` (
  `student_id` int(11) NOT NULL,
  `registration_no` varchar(20) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `first_name` varchar(60) DEFAULT NULL,
  `middle_name` varchar(60) DEFAULT NULL,
  `last_name` varchar(60) DEFAULT NULL,
  `gender` enum('Male','Female','Other') DEFAULT NULL,
  `national_id_passport_no` varchar(30) DEFAULT NULL,
  `programme` varchar(100) NOT NULL,
  `institute` varchar(100) NOT NULL,
  `school_id` int(11) DEFAULT NULL,
  `institute_id` int(11) DEFAULT NULL,
  `programme_id` int(11) DEFAULT NULL,
  `specialisation_id` int(11) DEFAULT NULL,
  `stage` varchar(10) DEFAULT NULL,
  `completion_status` enum('Ongoing','Completed','Graduated') NOT NULL DEFAULT 'Ongoing',
  `graduation_set_id` int(11) DEFAULT NULL,
  `email` varchar(100) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `graduation_year` year(4) NOT NULL,
  `account_status` enum('Active','Inactive') NOT NULL DEFAULT 'Active',
  `certificate_name_order` enum('first_middle_last','last_first_middle') DEFAULT NULL,
  `certificate_name_confirmed_at` datetime DEFAULT NULL,
  `academic_year` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `students`
--

INSERT INTO `students` (`student_id`, `registration_no`, `full_name`, `first_name`, `middle_name`, `last_name`, `gender`, `national_id_passport_no`, `programme`, `institute`, `school_id`, `institute_id`, `programme_id`, `specialisation_id`, `stage`, `completion_status`, `graduation_set_id`, `email`, `phone`, `graduation_year`, `account_status`, `certificate_name_order`, `certificate_name_confirmed_at`, `academic_year`) VALUES
(1, '1049507', 'Abigael Kinanu Kirimi', 'Abigael', 'Kinanu', 'Kirimi', NULL, NULL, 'Bachelor of Arts in Social Ministry', 'Institute of Youth Studies (IYS)', 2, 10, 9, NULL, NULL, 'Ongoing', 1, 'abigael.kirimi@student.tangaza.ac.ke', '+254710248422', '2026', 'Active', 'first_middle_last', NULL, NULL),
(2, '1049508', 'Brian Mutwiri Otieno', 'Brian', 'Mutwiri', 'Otieno', NULL, NULL, 'Bachelor of Education', 'Institute of Education', NULL, 4, 8, NULL, NULL, 'Ongoing', 1, 'brian.otieno@student.tangaza.ac.ke', '+254711111111', '2026', 'Active', 'first_middle_last', NULL, NULL),
(3, '1049509', 'Mary Muthoni Wanjiku', 'Mary', 'Muthoni', 'Wanjiku', NULL, NULL, 'Bachelor of Arts in Social Ministry', 'Institute for Social Transformation (IST)', 2, 3, 3, NULL, NULL, 'Ongoing', 1, 'mary.wanjiku@student.tangaza.ac.ke', '+254722222222', '2026', 'Active', 'first_middle_last', NULL, NULL),
(4, 'sci/20/2026', 'William Muruiki', 'William', NULL, 'Muruiki', NULL, NULL, 'Institute of social communication', 'Not assigned', NULL, 4, 8, NULL, NULL, 'Ongoing', 1, 'william@gmail.com', '0756879387', '2026', 'Active', 'first_middle_last', NULL, NULL),
(5, 'sc/56/2026', 'Abby Kirimi', 'Abby', NULL, 'Kirimi', NULL, NULL, 'Institute of theology', 'Not assigned', NULL, 4, 8, NULL, NULL, 'Ongoing', 1, 'abby@gmail.com', '72', '2026', 'Inactive', 'first_middle_last', NULL, NULL),
(8, 'sc/89/2026', 'Brandy Kawira Gitonga', 'Brandy', 'Kawira', 'Gitonga', 'Female', '24356789', 'Diploma in Counselling Psychology', 'Institute of Youth Studies (IYS)', 2, 10, 14, NULL, NULL, 'Ongoing', 2, 'brandy@gmail.com', '+254789876789', '2026', 'Active', 'last_first_middle', '2026-08-23 17:02:35', NULL),
(9, 'sc/98/2026', 'Nelly Makena Mutwiri', 'Nelly', 'Makena', 'Mutwiri', 'Female', '24', 'Diploma in Counselling Psychology', 'Institute of Youth Studies (IYS)', 2, 17, 14, NULL, NULL, 'Ongoing', 4, 'nelly@gmail.com', '+254727889398', '2026', 'Active', NULL, NULL, NULL),
(10, 'sc/11/2025', 'Myles Muthomi Mwenda', 'Myles', 'Muthomi', 'Mwenda', 'Female', '2345678', 'Diploma in Counselling Psychology', 'Institute of Youth Studies (IYS)', 2, 17, 14, NULL, '4.2', 'Ongoing', NULL, 'myles@gmail.com', '+254712345678', '0000', 'Active', NULL, NULL, '2025-2026'),
(11, 'sc/10/2026', 'Elsy Mwende Mariga', 'Elsy', 'Mwende', 'Mariga', 'Female', '24567837', 'Bachelor of Arts in Philosophy', 'Institute of Philosophy', 2, 19, 16, NULL, '4.2', 'Completed', NULL, 'elsym@gmail.com', '+254745678903', '0000', 'Active', 'last_first_middle', '2026-08-29 12:33:52', '2025-2026'),
(12, 'sc/12/2025', 'Frank Mwenda Muriuki', 'Frank', 'Mwenda', 'Muriuki', 'Male', '345678', 'Baccalaureate in Sacred Theology', 'Institute of Theology', 1, 21, 18, NULL, '4.2', 'Completed', NULL, 'frank@gmail.com', '+254767890987', '0000', 'Active', 'first_middle_last', '2026-08-29 14:45:32', '2025-2026'),
(13, 'sc/13/2025', 'Lucy Kendi Mutwiri', 'Lucy', 'Kendi', 'Mutwiri', 'Female', '2343456', 'Diploma in Social Ministry', 'Institute of Social Transformation', 2, 22, 19, NULL, '2.2', 'Completed', NULL, 'lucy@gmail.com', '+254768499848', '0000', 'Active', 'last_first_middle', '2026-08-29 16:10:47', '2025-2026'),
(14, 'sc/14/2025', 'Sheila Chebet Rono', 'Sheila', 'Chebet', 'Rono', 'Female', '34567828', 'Bachelor of Arts in Philosophy', 'Institute of Philosophy', 2, 19, 16, NULL, '4.2', 'Completed', NULL, 'chebet@gmail.com', '+254789387478', '0000', 'Active', NULL, NULL, '2025-2026'),
(16, 'sc/15/2026', 'Allan Kuria Mutwiri', 'Allan', 'Kuria', 'Mutwiri', 'Male', '8987890', 'Bachelor of Education', 'None', 3, 23, 20, 2, '2.2', 'Completed', NULL, 'allan@gmail.com', '+254789098767', '0000', 'Active', 'last_first_middle', '2026-08-30 19:00:13', '2025-2026'),
(17, 'sc/16/2026', 'Betty Kyalo Mwende', 'Betty', 'Kyalo', 'Mwende', 'Female', '23567867', 'Diploma in Social Ministry', 'Institute of Social Transformation', 2, 22, 19, NULL, NULL, 'Completed', NULL, 'betty@gmail.com', '+25475645678', '0000', 'Active', 'first_middle_last', '2026-08-31 20:21:44', '2025-2026'),
(18, 'sc/17/2026', 'Lucas Akoth Mawera', 'Lucas', 'Akoth', 'Mawera', 'Male', '4568798', 'Bachelor of Education', 'None', 3, 23, 20, 1, NULL, 'Completed', NULL, 'mawera@gmail.com', '+254764534565', '0000', 'Active', 'last_first_middle', '2026-08-31 20:30:20', '2025-2026'),
(19, 'sc/18/2026', 'Nick Mutuma Mawera', 'Nick', 'Mutuma', 'Mawera', 'Male', '36748938', 'Bachelor of Education', 'None', 3, 23, 20, 1, NULL, 'Completed', NULL, 'nick@gmail.com', '+254762635783', '0000', 'Active', NULL, NULL, '2025-2026'),
(20, 'sc/19/2025', 'Sharon Wairimu Wanja', 'Sharon', 'Wairimu', 'Wanja', 'Female', '3464567', 'Diploma in Computer Science', 'None', 5, 24, 23, NULL, NULL, 'Completed', NULL, 'wairimu@gmail.com', '+254787678767', '0000', 'Active', 'last_first_middle', '2026-09-01 09:02:25', '2025-2026'),
(21, '719', 'John Joy Wekesa', 'John', 'Joy', 'Wekesa', 'Male', '784647837', 'Bachelor of Arts in Philosophy', 'Institute of Philosophy', 2, 19, 16, NULL, NULL, 'Completed', NULL, 'john@gmail.com', '+254734567354', '0000', 'Active', 'first_middle_last', '2026-09-01 09:52:31', '2025-2026'),
(22, 'sc/76/2025', 'Wilson Marega Joy', 'Wilson', 'Marega', 'Joy', 'Male', '8983638', 'Diploma in Social Ministry', 'Institute of Social Transformation', 2, 22, 19, NULL, NULL, 'Ongoing', NULL, 'wilson@gmail.com', '+254741232939', '0000', 'Active', NULL, NULL, NULL),
(23, '123', 'Grace Jojo Wekesa', 'Grace', 'Jojo', 'Wekesa', 'Female', '23456789', 'Bachelor of Arts in Philosophy', 'Institute of Philosophy', 2, 19, 16, NULL, NULL, 'Ongoing', NULL, 'wekesa@gmail.com', '+254789685784', '0000', 'Active', 'first_middle_last', '2026-09-04 22:39:53', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `student_classifications`
--

CREATE TABLE `student_classifications` (
  `classification_id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `qualification_level` enum('Bachelor','TVET/Diploma','Master','PhD/Doctorate') NOT NULL,
  `average_mark` decimal(5,2) DEFAULT NULL,
  `classification` varchar(100) NOT NULL,
  `entered_by` int(11) NOT NULL,
  `entered_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `student_classifications`
--

INSERT INTO `student_classifications` (`classification_id`, `student_id`, `qualification_level`, `average_mark`, `classification`, `entered_by`, `entered_at`, `updated_at`) VALUES
(1, 5, 'Bachelor', 68.50, 'Second Class (Upper)', 9, '2026-08-28 19:46:10', NULL),
(2, 4, 'TVET/Diploma', 50.44, 'Pass', 9, '2026-08-28 19:54:16', NULL),
(3, 1, 'Master', 78.00, 'Distinction', 9, '2026-08-28 20:08:30', NULL),
(4, 11, 'Bachelor', 72.18, 'First Class Honours', 9, '2026-08-29 13:00:35', NULL),
(5, 16, 'Bachelor', 66.87, 'Second Class (Upper)', 9, '2026-08-30 19:12:29', NULL),
(6, 13, 'TVET/Diploma', 69.00, 'Credit', 9, '2026-08-31 21:03:50', NULL),
(7, 17, 'TVET/Diploma', 76.00, 'Distinction', 9, '2026-08-31 21:04:56', NULL),
(8, 18, 'Bachelor', 69.77, 'Second Class (Upper)', 9, '2026-08-31 23:06:09', NULL),
(9, 20, 'TVET/Diploma', 74.80, 'Credit', 9, '2026-09-01 09:10:59', NULL),
(10, 21, 'Bachelor', 68.00, 'Second Class (Upper)', 9, '2026-09-01 10:16:56', NULL),
(11, 12, 'Bachelor', 67.00, 'Second Class (Upper)', 9, '2026-09-04 22:20:19', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `supporting_documents`
--

CREATE TABLE `supporting_documents` (
  `document_id` int(11) NOT NULL,
  `request_id` int(11) DEFAULT NULL,
  `student_id` int(11) NOT NULL,
  `document_type` enum('id_passport','final_year_project','fee_statement') NOT NULL,
  `filename` varchar(255) NOT NULL,
  `file_path` varchar(255) NOT NULL,
  `uploaded_at` datetime NOT NULL DEFAULT current_timestamp(),
  `stored_name` varchar(255) NOT NULL DEFAULT '',
  `mime_type` varchar(100) NOT NULL DEFAULT 'application/pdf',
  `status` enum('Pending','Approved','Rejected','Replaced') NOT NULL DEFAULT 'Pending',
  `replaced_at` datetime DEFAULT NULL,
  `document_reviewed_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `supporting_documents`
--

INSERT INTO `supporting_documents` (`document_id`, `request_id`, `student_id`, `document_type`, `filename`, `file_path`, `uploaded_at`, `stored_name`, `mime_type`, `status`, `replaced_at`, `document_reviewed_at`) VALUES
(1, 4, 4, 'final_year_project', 'final_year_project_4_1786290801.pdf', 'uploads/documents/final_year_project_4_1786290801.pdf', '2026-08-09 18:53:21', '', 'application/pdf', 'Pending', NULL, NULL),
(2, 4, 4, 'fee_statement', 'fee_statement_4_1786291030.pdf', 'uploads/documents/fee_statement_4_1786291030.pdf', '2026-08-09 18:57:10', '', 'application/pdf', 'Pending', NULL, NULL),
(3, 5, 5, 'final_year_project', 'final_year_project_5_1786432663.pdf', 'uploads/documents/final_year_project_5_1786432663.pdf', '2026-08-11 10:17:43', '', 'application/pdf', 'Pending', NULL, NULL),
(4, 5, 5, 'fee_statement', 'fee_statement_5_1786432794.pdf', 'uploads/documents/fee_statement_5_1786432794.pdf', '2026-08-11 10:19:54', '', 'application/pdf', 'Pending', NULL, NULL),
(5, 1, 1, 'id_passport', 'ID card.pdf', 'private_uploads/documents/09b6b361156e9c87c3785e911512b2610a0d.pdf', '2026-08-22 09:07:32', '09b6b361156e9c87c3785e911512b2610a0d.pdf', 'application/pdf', 'Pending', NULL, NULL),
(6, 1, 1, 'final_year_project', 'Students\' Clearance Graduation System -1049507 - Kirimi Abigael K..pdf', 'private_uploads/documents/d5a257ff0735ba12930e7f13a11efaa727db.pdf', '2026-08-22 09:07:49', 'd5a257ff0735ba12930e7f13a11efaa727db.pdf', 'application/pdf', 'Pending', NULL, NULL),
(7, NULL, 8, 'id_passport', 'ID card.pdf', 'private_uploads/documents/9dce8855871fad9e6ec42d3e96469d38380e.pdf', '2026-08-23 17:01:41', '9dce8855871fad9e6ec42d3e96469d38380e.pdf', 'application/pdf', 'Replaced', '2026-08-23 17:07:52', NULL),
(8, NULL, 8, 'final_year_project', 'Internship letter - Abigael K..pdf', 'private_uploads/documents/6d657983ce67401e343194863e0af84ab4d3.pdf', '2026-08-23 17:02:09', '6d657983ce67401e343194863e0af84ab4d3.pdf', 'application/pdf', 'Replaced', '2026-08-23 17:08:07', NULL),
(9, 7, 8, 'id_passport', '_OceanofPDF.com_Discipline_-_Ryan_holiday.pdf', 'private_uploads/documents/43d0c2756ec71b603b6d7c6abb931d6aee27.pdf', '2026-08-23 17:07:52', '43d0c2756ec71b603b6d7c6abb931d6aee27.pdf', 'application/pdf', 'Replaced', '2026-08-25 12:01:24', NULL),
(10, 7, 8, 'final_year_project', 'Abigael\'s ID.pdf', 'private_uploads/documents/42b28ae0ff1a43c042df7a74e0b18cb56450.pdf', '2026-08-23 17:08:07', '42b28ae0ff1a43c042df7a74e0b18cb56450.pdf', 'application/pdf', 'Replaced', '2026-08-25 12:01:37', NULL),
(11, 7, 8, 'id_passport', 'ID card.pdf', 'private_uploads/documents/e48668ddca2e2cb824111151e228051aaef2.pdf', '2026-08-25 12:01:24', 'e48668ddca2e2cb824111151e228051aaef2.pdf', 'application/pdf', 'Pending', NULL, NULL),
(12, 7, 8, 'final_year_project', 'Students\' Clearance Graduation System -1049507 - Kirimi Abigael K..pdf', 'private_uploads/documents/53220737f842963fddb5f557fff28fc272ba.pdf', '2026-08-25 12:01:37', '53220737f842963fddb5f557fff28fc272ba.pdf', 'application/pdf', 'Pending', NULL, NULL),
(13, NULL, 11, 'id_passport', 'ID card.pdf', 'private_uploads/documents/5d5302b457dad65f6a55064a414431383676.pdf', '2026-08-29 12:33:25', '5d5302b457dad65f6a55064a414431383676.pdf', 'application/pdf', 'Pending', NULL, NULL),
(14, NULL, 11, 'final_year_project', 'Students\' Clearance Graduation System -1049507 - Kirimi Abigael K..pdf', 'private_uploads/documents/e45490985483b7cb05318113f6d00826c2a6.pdf', '2026-08-29 12:33:41', 'e45490985483b7cb05318113f6d00826c2a6.pdf', 'application/pdf', 'Pending', NULL, NULL),
(15, NULL, 12, 'id_passport', 'ID card.pdf', 'private_uploads/documents/5cb1ed591327b5d191aa4c1459f973106fc4.pdf', '2026-08-29 14:44:57', '5cb1ed591327b5d191aa4c1459f973106fc4.pdf', 'application/pdf', 'Pending', NULL, NULL),
(16, NULL, 12, 'final_year_project', 'Students\' Clearance Graduation System -1049507 - Kirimi Abigael K..pdf', 'private_uploads/documents/2ca9c1d750455c4e04a32df152b2fc2ee5ba.pdf', '2026-08-29 14:45:24', '2ca9c1d750455c4e04a32df152b2fc2ee5ba.pdf', 'application/pdf', 'Pending', NULL, NULL),
(17, NULL, 13, 'id_passport', 'Abigael_Kirimi_CV.pdf', 'private_uploads/documents/75ae2dfbccf0eb3add6f663924d5f1242674.pdf', '2026-08-29 16:10:25', '75ae2dfbccf0eb3add6f663924d5f1242674.pdf', 'application/pdf', 'Pending', NULL, NULL),
(18, NULL, 13, 'final_year_project', 'Mary transcript.pdf', 'private_uploads/documents/69c314a98932f4077c74639926b87cc4aedb.pdf', '2026-08-29 16:10:33', '69c314a98932f4077c74639926b87cc4aedb.pdf', 'application/pdf', 'Pending', NULL, NULL),
(19, NULL, 16, 'id_passport', 'ID card.pdf', 'private_uploads/documents/0ad1a71fa1c356681fb7553cf2f3506fb71a.pdf', '2026-08-30 18:59:51', '0ad1a71fa1c356681fb7553cf2f3506fb71a.pdf', 'application/pdf', 'Pending', NULL, NULL),
(20, NULL, 16, 'final_year_project', '_OceanofPDF.com_Discipline_-_Ryan_holiday.pdf', 'private_uploads/documents/b34ee4f9730330152f0c7d1f4fef786d8968.pdf', '2026-08-30 19:00:02', 'b34ee4f9730330152f0c7d1f4fef786d8968.pdf', 'application/pdf', 'Pending', NULL, NULL),
(21, NULL, 17, 'final_year_project', 'How To Win Friends and Influence People ( PDFDrive ).pdf', 'private_uploads/documents/afa6a03ecb91c3847f4b12d8f508da2d7d2f.pdf', '2026-08-31 20:21:09', 'afa6a03ecb91c3847f4b12d8f508da2d7d2f.pdf', 'application/pdf', 'Pending', NULL, NULL),
(22, NULL, 17, 'id_passport', 'How To Win Friends and Influence People ( PDFDrive ).pdf', 'private_uploads/documents/a32e52288bee3412c04ebec1fef8db39520f.pdf', '2026-08-31 20:21:29', 'a32e52288bee3412c04ebec1fef8db39520f.pdf', 'application/pdf', 'Pending', NULL, NULL),
(23, NULL, 18, 'id_passport', 'ID card.pdf', 'private_uploads/documents/1e4dea085eb0c69897fe3edb939195244041.pdf', '2026-08-31 20:29:58', '1e4dea085eb0c69897fe3edb939195244041.pdf', 'application/pdf', 'Pending', NULL, NULL),
(24, NULL, 18, 'final_year_project', 'Kirimi_Abigael_CV.pdf', 'private_uploads/documents/70d98048436f1c52975ad6fca93a158169c1.pdf', '2026-08-31 20:30:07', '70d98048436f1c52975ad6fca93a158169c1.pdf', 'application/pdf', 'Pending', NULL, NULL),
(25, NULL, 20, 'id_passport', 'ID card.pdf', 'private_uploads/documents/645bca4727783d842fcfd44e4d0f89530653.pdf', '2026-09-01 09:02:02', '645bca4727783d842fcfd44e4d0f89530653.pdf', 'application/pdf', 'Pending', NULL, NULL),
(26, NULL, 20, 'final_year_project', 'I.T Officer.pdf', 'private_uploads/documents/1aa5ac1391014f36649ab5de31fa2f57c7b0.pdf', '2026-09-01 09:02:15', '1aa5ac1391014f36649ab5de31fa2f57c7b0.pdf', 'application/pdf', 'Pending', NULL, NULL),
(27, NULL, 21, 'id_passport', 'ID card.pdf', 'private_uploads/documents/b01f23348ca596bc0286898059f3bf0ccbb3.pdf', '2026-09-01 09:52:09', 'b01f23348ca596bc0286898059f3bf0ccbb3.pdf', 'application/pdf', 'Pending', NULL, NULL),
(28, NULL, 21, 'final_year_project', '_OceanofPDF.com_Discipline_-_Ryan_holiday.pdf', 'private_uploads/documents/bd715cfbeb943e33755fb1586976104c6756.pdf', '2026-09-01 09:52:17', 'bd715cfbeb943e33755fb1586976104c6756.pdf', 'application/pdf', 'Pending', NULL, NULL),
(29, NULL, 23, 'id_passport', 'Abigael\'s ID.pdf', 'private_uploads/documents/f11c0af954839af5e79b16c4bab3b2386793.pdf', '2026-09-04 22:39:21', 'f11c0af954839af5e79b16c4bab3b2386793.pdf', 'application/pdf', 'Replaced', '2026-09-04 22:42:06', NULL),
(30, NULL, 23, 'final_year_project', '_OceanofPDF.com_Discipline_-_Ryan_holiday.pdf', 'private_uploads/documents/d0ea7b78116d37fe7315e48c6a7807936bf5.pdf', '2026-09-04 22:39:33', 'd0ea7b78116d37fe7315e48c6a7807936bf5.pdf', 'application/pdf', 'Replaced', '2026-09-04 22:41:56', NULL),
(31, NULL, 23, 'final_year_project', 'How To Win Friends and Influence People ( PDFDrive ).pdf', 'private_uploads/documents/454a6d26f94799d60e3b0dc80120d9048d48.pdf', '2026-09-04 22:41:56', '454a6d26f94799d60e3b0dc80120d9048d48.pdf', 'application/pdf', 'Pending', NULL, NULL),
(32, NULL, 23, 'id_passport', 'ID card.pdf', 'private_uploads/documents/984fe78018df3a45db2a8840e56a3af3453a.pdf', '2026-09-04 22:42:06', '984fe78018df3a45db2a8840e56a3af3453a.pdf', 'application/pdf', 'Pending', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `transcripts`
--

CREATE TABLE `transcripts` (
  `transcript_id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `request_id` int(11) NOT NULL,
  `uploaded_by` int(11) NOT NULL,
  `uploaded_at` datetime NOT NULL DEFAULT current_timestamp(),
  `filename` varchar(255) NOT NULL,
  `file_path` varchar(255) NOT NULL,
  `status` enum('Active','Replaced') NOT NULL DEFAULT 'Active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `transcripts`
--

INSERT INTO `transcripts` (`transcript_id`, `student_id`, `request_id`, `uploaded_by`, `uploaded_at`, `filename`, `file_path`, `status`) VALUES
(1, 3, 3, 9, '2026-06-17 13:30:00', 'sample-transcript-mary.pdf', 'uploads/transcripts/sample-transcript-mary.pdf', 'Active'),
(2, 4, 4, 11, '2026-08-09 18:51:03', 'transcript_4_1786290663.pdf', 'uploads/transcripts/transcript_4_1786290663.pdf', 'Active'),
(3, 1, 1, 1, '2026-08-11 10:02:08', 'transcript_1_1786431728.pdf', 'uploads/transcripts/transcript_1_1786431728.pdf', 'Active'),
(4, 5, 5, 12, '2026-08-11 10:08:42', 'transcript_5_1786432122.pdf', 'uploads/transcripts/transcript_5_1786432122.pdf', 'Active');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role` enum('student','officer','director','librarian','finance_officer','dean','university_store','registrar','admin') NOT NULL,
  `linked_id` int(11) DEFAULT NULL,
  `school_id` int(11) DEFAULT NULL,
  `institute_id` int(11) DEFAULT NULL,
  `department_id` int(11) DEFAULT NULL,
  `programme_id` int(11) DEFAULT NULL,
  `full_name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `account_status` enum('Active','Inactive') NOT NULL DEFAULT 'Active',
  `deleted_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role`, `linked_id`, `school_id`, `institute_id`, `department_id`, `programme_id`, `full_name`, `email`, `created_at`, `account_status`, `deleted_at`) VALUES
(1, 'student1', '$2y$10$CW38hPxbW7lvxr8Dj1bSYuj4VDAf3WcMkk5VYhDBhBlOB.Q0aORuq', 'student', 1, 2, 10, NULL, 9, 'Abigael Kinanu Kirimi', 'abigael.kirimi@student.tangaza.ac.ke', '2026-08-09 18:46:52', 'Inactive', NULL),
(2, 'student2', '$2y$10$CW38hPxbW7lvxr8Dj1bSYuj4VDAf3WcMkk5VYhDBhBlOB.Q0aORuq', 'student', 2, NULL, 4, NULL, 8, 'Brian Mutwiri Otieno', 'brian.otieno@student.tangaza.ac.ke', '2026-08-09 18:46:52', 'Inactive', NULL),
(3, 'student3', '$2y$10$CW38hPxbW7lvxr8Dj1bSYuj4VDAf3WcMkk5VYhDBhBlOB.Q0aORuq', 'student', 3, 2, 3, NULL, 3, 'Mary Muthoni Wanjiku', 'mary.wanjiku@student.tangaza.ac.ke', '2026-08-09 18:46:52', 'Inactive', NULL),
(4, 'director', '$2y$10$CW38hPxbW7lvxr8Dj1bSYuj4VDAf3WcMkk5VYhDBhBlOB.Q0aORuq', 'director', 1, NULL, NULL, NULL, NULL, 'Director Office', 'director@tangaza.ac.ke', '2026-08-09 18:46:52', 'Active', NULL),
(5, 'library', '$2y$10$CW38hPxbW7lvxr8Dj1bSYuj4VDAf3WcMkk5VYhDBhBlOB.Q0aORuq', 'librarian', 2, NULL, NULL, 2, NULL, 'Catherine Ogutu', 'library@tangaza.ac.ke', '2026-08-09 18:46:52', 'Active', NULL),
(6, 'finance', '$2y$10$CW38hPxbW7lvxr8Dj1bSYuj4VDAf3WcMkk5VYhDBhBlOB.Q0aORuq', 'officer', 3, NULL, NULL, NULL, NULL, 'Finance Officer', 'finance@tangaza.ac.ke', '2026-08-09 18:46:52', 'Active', NULL),
(7, 'dean', '$2y$10$CW38hPxbW7lvxr8Dj1bSYuj4VDAf3WcMkk5VYhDBhBlOB.Q0aORuq', 'dean', 4, NULL, NULL, NULL, NULL, 'Dean of Students Officer', 'dean@tangaza.ac.ke', '2026-08-09 18:46:52', 'Active', NULL),
(8, 'store', '$2y$10$CW38hPxbW7lvxr8Dj1bSYuj4VDAf3WcMkk5VYhDBhBlOB.Q0aORuq', 'officer', 5, NULL, NULL, NULL, NULL, 'University Store Officer', 'store@tangaza.ac.ke', '2026-08-09 18:46:52', 'Active', NULL),
(9, 'registrar', '$2y$10$CW38hPxbW7lvxr8Dj1bSYuj4VDAf3WcMkk5VYhDBhBlOB.Q0aORuq', 'registrar', 6, NULL, NULL, NULL, NULL, 'Academic Registrar', 'registrar@tangaza.ac.ke', '2026-08-09 18:46:52', 'Active', NULL),
(10, 'admin', '$2y$10$CW38hPxbW7lvxr8Dj1bSYuj4VDAf3WcMkk5VYhDBhBlOB.Q0aORuq', 'admin', NULL, NULL, NULL, NULL, NULL, 'System Administrator', 'admin@tangaza.ac.ke', '2026-08-09 18:46:52', 'Active', NULL),
(11, 'sci202026', '$2y$10$zogPBpEqnOJNCp96sqtCB.ZfGq8lGQmvfIVqFwl.KrYDohFZOJdrW', 'student', 4, NULL, 4, NULL, 8, 'William Muruiki', 'william@gmail.com', '2026-08-09 18:50:22', 'Inactive', '2026-08-22 08:47:08'),
(12, 'sc562026', '$2y$10$7CPBQyc7tuVCG8oJ9dXMTu.iYDmfjpmWKcoTkMIFtb/ca7tJOkXoa', 'student', 5, NULL, 4, NULL, 8, 'Abby Kirimi', 'abby@gmail.com', '2026-08-11 10:06:05', 'Inactive', '2026-08-22 08:47:01'),
(13, 'stacy', '$2y$10$ccAayURvdbu7JE264iuBMO7cvAsWNSkH2sOI3W5dpFb55pI1TTyhu', '', NULL, NULL, NULL, NULL, NULL, 'Makena', 'stacy@gmail.com', '2026-08-18 10:04:10', 'Inactive', NULL),
(14, 'IYSdirector', '$2y$10$reOdRK1DiNEptPOq/GZ9vO9U6CiISHcGGCcGeCG5G4yVYqSWsLzJa', 'director', NULL, 3, 10, 1, NULL, 'Michael Murithi', 'michael@gmail.com', '2026-08-22 08:44:11', 'Active', NULL),
(15, '123456', '$2y$10$OS2373HL7ksnkGFqSfQmWuWcMavPAHI4fG37GcWWYwM9mB1LgIyaK', '', NULL, 2, 10, 1, NULL, 'Alma Weru', 'Alma@gmail.com', '2026-08-22 09:32:14', 'Inactive', '2026-08-29 10:32:52'),
(16, 'sc892026', '$2y$10$AMfmVCHJLsQLHlLnntPQdO9m5UuUq1A/dYDolj3sJptYHk5YtNNVy', 'student', 8, 2, 10, NULL, 14, 'Brandy Kawira Gitonga', 'brandy@gmail.com', '2026-08-23 16:51:13', 'Active', NULL),
(17, 'PhilosophyDirector', '$2y$10$ZpsLFp0NlgSdEh2LoIthfuZOhNy1actMVs0zdiS.V.jeSSgV0De9S', 'director', NULL, NULL, NULL, 6, NULL, 'Mike Liam', 'mike@gmail.com', '2026-08-25 12:27:32', 'Inactive', '2026-08-29 10:32:42'),
(18, 'sc982026', '$2y$10$T8Rc7Ydd/27L2ik5Sc6U9OzQmUDm9..HZ0FU.PIYiMoy5TTtBgseC', 'student', 9, 2, 17, NULL, 14, 'Nelly Makena Mutwiri', 'nelly@gmail.com', '2026-08-27 19:47:20', 'Active', NULL),
(19, 'sc/11/2025', '$2y$10$MjPfhjLkPCQ8I6BTb5CX5OrGbbEI8GfgXB03.GBjZNqempZgkwaE.', 'student', 10, 2, 17, NULL, 14, 'Myles Muthomi Mwenda', 'myles@gmail.com', '2026-08-29 11:49:18', 'Active', NULL),
(20, 'IOPdirector', '$2y$10$BkMhxJkpjkpCe7OfXRgiNOTGUAMrDmsgAG0Lc/QjQ7dK0bElJYLPa', 'director', NULL, 2, 19, 1, NULL, 'D. Etriga', 'etriga@gmail.com', '2026-08-29 12:29:49', 'Active', NULL),
(21, 'sc/10/2026', '$2y$10$dwOgpiGEKiwjOVFUY7rq5eUbJPeSnQUivg1ySisMdc/6pvIs48raS', 'student', 11, 2, 19, NULL, 16, 'Elsy Mwende Mariga', 'elsym@gmail.com', '2026-08-29 12:31:43', 'Active', NULL),
(22, 'SOTdean', '$2y$10$FG2qQ3hOtrpHRlRTeBP1qu8IMmvlZA6vjhZV74XQp9eN2EqC2hi5q', 'dean', NULL, 1, NULL, 4, NULL, 'Nicholas Obiero', 'nicholas@gmail.com', '2026-08-29 13:57:50', 'Active', NULL),
(23, 'sc/12/2025', '$2y$10$J.s7DqzlScUt/7LQV7nG7uCQQPHpV/.Z1LmJgsifMwQ6PkszUandm', 'student', 12, 1, 21, NULL, 18, 'Frank Mwenda Muriuki', 'frank@gmail.com', '2026-08-29 14:39:51', 'Active', NULL),
(24, 'IOTdirector', '$2y$10$p/pAz9baZEFB2TKC7Zi6o.Zuw3Z7OB8jQQGGpw0.AA7nPoyEcO19u', 'director', NULL, 1, 21, 1, NULL, 'Nelson Obanja', 'nelson@gmail.com', '2026-08-29 14:43:11', 'Active', NULL),
(25, 'sc/13/2025', '$2y$10$4iIRIO9bdRDLqX7Ibt6w8uQEshSaBrlfdIZ5prC1.pec6mMngUDs2', 'student', 13, 2, 22, NULL, 19, 'Lucy Kendi Mutwiri', 'lucy@gmail.com', '2026-08-29 16:08:29', 'Active', NULL),
(26, 'ISTdirector', '$2y$10$nC2MrLTpNalwNDZTFUWqbux2Lx9oLfbHlKERcTVIs2ZmgVF1bsa1K', 'director', NULL, 2, 22, 1, NULL, 'Eric Ochieng Okoth', 'okoth@gmail.com', '2026-08-29 16:15:18', 'Active', NULL),
(27, 'SASSdean', '$2y$10$.lcIO.u7ekdkkScfG.TsauSIzQQBGqXSl6nNC5FURLhS.phHoAxFq', 'dean', NULL, 2, NULL, 4, NULL, 'Cecilia Osyanju', 'cecilia@gmail.com', '2026-08-29 16:22:05', 'Active', NULL),
(28, 'sc/14/2025', '$2y$10$nsbkpuLjJZRRDOwyGqDyw.xxsXqVWHXRstvXJvm4oq5FJr80UFk12', 'student', 14, 2, 19, NULL, 16, 'Sheila Chebet Rono', 'chebet@gmail.com', '2026-08-30 17:51:21', 'Active', NULL),
(29, 'SOEdean', '$2y$10$GU3bI31Dvqsck8LFPHi7XuPtFIhKK.kHcojvueQrGZDQcqcJuFssK', 'dean', NULL, 3, NULL, 4, NULL, 'Dr. Phoestine Naliaka', 'naliaka@gmail.com', '2026-08-30 18:33:24', 'Active', NULL),
(30, 'sc/15/2026', '$2y$10$7Ddig8B2j1wZePcTO8ih7.fbcW7O/4y6NQGroW2fmHDaP0.GHUzze', 'student', 16, 3, 23, NULL, 20, 'Allan Kuria Mutwiri', 'allan@gmail.com', '2026-08-30 18:51:29', 'Active', NULL),
(31, 'IOEdirector', '$2y$10$T6BRrVCwtIcd3a7fde4IDeL4Sj40lTFGAwua5cs2CGy8utx4TO.fi', 'director', NULL, 3, 23, 1, NULL, 'Peter Kiptoo', 'kip@gmail.com', '2026-08-30 18:57:47', 'Active', NULL),
(32, 'sc/16/2026', '$2y$10$/rrfp.Dgx.HgAmvCJDFLOu20y/K5v9eFDK5UyweWIay2FpZYx4zcO', 'student', 17, 2, 22, NULL, 19, 'Betty Kyalo Mwende', 'betty@gmail.com', '2026-08-31 20:19:39', 'Active', NULL),
(33, 'sc/17/2026', '$2y$10$oroiomM1zzXuz0ej.ZL.OORxZAIW9gwHVRyIWtBSDTuqmKYyNO5J6', 'student', 18, 3, 23, NULL, 20, 'Lucas Akoth Mawera', 'mawera@gmail.com', '2026-08-31 20:26:18', 'Active', NULL),
(34, 'sc/18/2026', '$2y$10$4aY4rg7wNq1JKUwoP7WfKOhfFGdA.n1VmXItb3LNDfL5p5Pp./fWq', 'student', 19, 3, 23, NULL, 20, 'Nick Mutuma Mawera', 'nick@gmail.com', '2026-08-31 23:10:36', 'Active', NULL),
(35, 'TVETdean', '$2y$10$JFWmOcbdUR6Sdo7urbyXReYM2VtxGQdp5MxitzczoWspeKxAAGHKe', 'dean', NULL, 5, NULL, 4, NULL, 'Lillian Muli', 'muli@gmail.com', '2026-08-31 23:15:21', 'Active', NULL),
(36, 'sc/19/2025', '$2y$10$pCbUAk./jx5Xuhw6oijWDuk3AKbNsD6q5DEAbESYJPq/QDSdZzgJa', 'student', 20, 5, 24, NULL, 23, 'Sharon Wairimu Wanja', 'wairimu@gmail.com', '2026-09-01 09:01:13', 'Active', NULL),
(37, 'TVETdirector', '$2y$10$VuFt9GeAjHiqsG/GEOnQzO48S7RKt3cccLG53ikzqmqnVGApLn0G6', 'director', NULL, NULL, 24, 1, NULL, 'Clinton Maina', 'clinton@gmail.com', '2026-09-01 09:03:50', 'Active', NULL),
(38, '719', '$2y$10$RJJqVwlEANUbNnDr2f6jb.WmwovzKBb.9pVJlcWlccPFIdHyBY/u2', 'student', 21, 2, 19, NULL, 16, 'John Joy Wekesa', 'john@gmail.com', '2026-09-01 09:40:40', 'Active', NULL),
(39, 'sc/76/2025', '$2y$10$UCyfEmmQQ6sJ5.5ghBoJ4.n4lHszmR8IlEYqwfJAxTF5Hh4JzL94e', 'student', 22, 2, 22, NULL, 19, 'Wilson Marega Joy', 'wilson@gmail.com', '2026-09-02 08:27:16', 'Active', NULL),
(40, '123', '$2y$10$.OF3TEE6s/Ybf20xanmEH.tEhqpU0HvpsghQS5wpJg5OW3ZbqokAu', 'student', 23, 2, 19, NULL, 16, 'Grace Jojo Wekesa', 'wekesa@gmail.com', '2026-09-04 22:25:06', 'Active', NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `approval_records`
--
ALTER TABLE `approval_records`
  ADD PRIMARY KEY (`approval_id`),
  ADD KEY `request_id` (`request_id`),
  ADD KEY `dept_id` (`dept_id`),
  ADD KEY `officer_id` (`officer_id`);

--
-- Indexes for table `audit_logs`
--
ALTER TABLE `audit_logs`
  ADD PRIMARY KEY (`audit_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `clearance_requests`
--
ALTER TABLE `clearance_requests`
  ADD PRIMARY KEY (`request_id`),
  ADD KEY `student_id` (`student_id`),
  ADD KEY `current_dept_id` (`current_dept_id`),
  ADD KEY `idx_clearance_student_set_status` (`student_id`,`graduation_set_id`,`overall_status`);

--
-- Indexes for table `departments`
--
ALTER TABLE `departments`
  ADD PRIMARY KEY (`dept_id`),
  ADD UNIQUE KEY `sequence_no` (`sequence_no`),
  ADD KEY `officer_user_id` (`officer_user_id`);

--
-- Indexes for table `department_review_checks`
--
ALTER TABLE `department_review_checks`
  ADD PRIMARY KEY (`review_check_id`),
  ADD UNIQUE KEY `uq_review_check_request_dept` (`request_id`,`dept_id`),
  ADD KEY `fk_review_check_department` (`dept_id`),
  ADD KEY `fk_review_check_user` (`checked_by`);

--
-- Indexes for table `final_approvals`
--
ALTER TABLE `final_approvals`
  ADD PRIMARY KEY (`approval_number`),
  ADD UNIQUE KEY `request_id` (`request_id`);

--
-- Indexes for table `graduation_applications`
--
ALTER TABLE `graduation_applications`
  ADD PRIMARY KEY (`graduation_application_id`),
  ADD UNIQUE KEY `unique_student_graduation_set` (`student_id`,`graduation_set_id`),
  ADD KEY `fk_graduation_application_set` (`graduation_set_id`),
  ADD KEY `fk_graduation_application_reviewer` (`reviewed_by`);

--
-- Indexes for table `graduation_sets`
--
ALTER TABLE `graduation_sets`
  ADD PRIMARY KEY (`graduation_set_id`),
  ADD UNIQUE KEY `set_name` (`set_name`);

--
-- Indexes for table `graduation_set_qualification_types`
--
ALTER TABLE `graduation_set_qualification_types`
  ADD PRIMARY KEY (`graduation_set_id`,`qualification_type_id`),
  ADD KEY `fk_gsqt_qualification` (`qualification_type_id`);

--
-- Indexes for table `institutes`
--
ALTER TABLE `institutes`
  ADD PRIMARY KEY (`institute_id`),
  ADD UNIQUE KEY `uq_institute_school_name` (`school_id`,`institute_name`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`notif_id`),
  ADD KEY `recipient_user_id` (`recipient_user_id`);

--
-- Indexes for table `programmes`
--
ALTER TABLE `programmes`
  ADD PRIMARY KEY (`programme_id`),
  ADD UNIQUE KEY `uq_programme_institute_name` (`institute_id`,`programme_name`);

--
-- Indexes for table `programme_specialisations`
--
ALTER TABLE `programme_specialisations`
  ADD PRIMARY KEY (`specialisation_id`),
  ADD UNIQUE KEY `unique_programme_specialisation` (`programme_id`,`specialisation_name`);

--
-- Indexes for table `qualification_types`
--
ALTER TABLE `qualification_types`
  ADD PRIMARY KEY (`qualification_type_id`),
  ADD UNIQUE KEY `qualification_name` (`qualification_name`);

--
-- Indexes for table `schema_migrations`
--
ALTER TABLE `schema_migrations`
  ADD PRIMARY KEY (`migration_id`);

--
-- Indexes for table `schools`
--
ALTER TABLE `schools`
  ADD PRIMARY KEY (`school_id`),
  ADD UNIQUE KEY `school_name` (`school_name`);

--
-- Indexes for table `students`
--
ALTER TABLE `students`
  ADD PRIMARY KEY (`student_id`),
  ADD UNIQUE KEY `registration_no` (`registration_no`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `uq_students_phone` (`phone`),
  ADD UNIQUE KEY `uq_students_national_id_passport` (`national_id_passport_no`),
  ADD KEY `idx_students_academic_path` (`school_id`,`institute_id`,`programme_id`),
  ADD KEY `idx_students_graduation_set` (`graduation_set_id`),
  ADD KEY `fk_student_specialisation` (`specialisation_id`);

--
-- Indexes for table `student_classifications`
--
ALTER TABLE `student_classifications`
  ADD PRIMARY KEY (`classification_id`),
  ADD UNIQUE KEY `unique_student_classification` (`student_id`,`qualification_level`),
  ADD KEY `fk_classification_registrar` (`entered_by`);

--
-- Indexes for table `supporting_documents`
--
ALTER TABLE `supporting_documents`
  ADD PRIMARY KEY (`document_id`),
  ADD KEY `request_id` (`request_id`),
  ADD KEY `student_id` (`student_id`);

--
-- Indexes for table `transcripts`
--
ALTER TABLE `transcripts`
  ADD PRIMARY KEY (`transcript_id`),
  ADD KEY `student_id` (`student_id`),
  ADD KEY `uploaded_by` (`uploaded_by`),
  ADD KEY `request_id` (`request_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `approval_records`
--
ALTER TABLE `approval_records`
  MODIFY `approval_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=164;

--
-- AUTO_INCREMENT for table `audit_logs`
--
ALTER TABLE `audit_logs`
  MODIFY `audit_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=998;

--
-- AUTO_INCREMENT for table `clearance_requests`
--
ALTER TABLE `clearance_requests`
  MODIFY `request_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT for table `departments`
--
ALTER TABLE `departments`
  MODIFY `dept_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `department_review_checks`
--
ALTER TABLE `department_review_checks`
  MODIFY `review_check_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `final_approvals`
--
ALTER TABLE `final_approvals`
  MODIFY `approval_number` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `graduation_applications`
--
ALTER TABLE `graduation_applications`
  MODIFY `graduation_application_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `graduation_sets`
--
ALTER TABLE `graduation_sets`
  MODIFY `graduation_set_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `institutes`
--
ALTER TABLE `institutes`
  MODIFY `institute_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `notif_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=212;

--
-- AUTO_INCREMENT for table `programmes`
--
ALTER TABLE `programmes`
  MODIFY `programme_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT for table `programme_specialisations`
--
ALTER TABLE `programme_specialisations`
  MODIFY `specialisation_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `qualification_types`
--
ALTER TABLE `qualification_types`
  MODIFY `qualification_type_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `schools`
--
ALTER TABLE `schools`
  MODIFY `school_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `students`
--
ALTER TABLE `students`
  MODIFY `student_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT for table `student_classifications`
--
ALTER TABLE `student_classifications`
  MODIFY `classification_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `supporting_documents`
--
ALTER TABLE `supporting_documents`
  MODIFY `document_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT for table `transcripts`
--
ALTER TABLE `transcripts`
  MODIFY `transcript_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `approval_records`
--
ALTER TABLE `approval_records`
  ADD CONSTRAINT `approval_records_ibfk_1` FOREIGN KEY (`request_id`) REFERENCES `clearance_requests` (`request_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `approval_records_ibfk_2` FOREIGN KEY (`dept_id`) REFERENCES `departments` (`dept_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `approval_records_ibfk_3` FOREIGN KEY (`officer_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `audit_logs`
--
ALTER TABLE `audit_logs`
  ADD CONSTRAINT `audit_logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `clearance_requests`
--
ALTER TABLE `clearance_requests`
  ADD CONSTRAINT `clearance_requests_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `clearance_requests_ibfk_2` FOREIGN KEY (`current_dept_id`) REFERENCES `departments` (`dept_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `departments`
--
ALTER TABLE `departments`
  ADD CONSTRAINT `departments_ibfk_1` FOREIGN KEY (`officer_user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `department_review_checks`
--
ALTER TABLE `department_review_checks`
  ADD CONSTRAINT `fk_review_check_department` FOREIGN KEY (`dept_id`) REFERENCES `departments` (`dept_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_review_check_request` FOREIGN KEY (`request_id`) REFERENCES `clearance_requests` (`request_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_review_check_user` FOREIGN KEY (`checked_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `final_approvals`
--
ALTER TABLE `final_approvals`
  ADD CONSTRAINT `final_approvals_ibfk_1` FOREIGN KEY (`request_id`) REFERENCES `clearance_requests` (`request_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `graduation_applications`
--
ALTER TABLE `graduation_applications`
  ADD CONSTRAINT `fk_graduation_application_reviewer` FOREIGN KEY (`reviewed_by`) REFERENCES `users` (`user_id`),
  ADD CONSTRAINT `fk_graduation_application_set` FOREIGN KEY (`graduation_set_id`) REFERENCES `graduation_sets` (`graduation_set_id`),
  ADD CONSTRAINT `fk_graduation_application_student` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`);

--
-- Constraints for table `graduation_set_qualification_types`
--
ALTER TABLE `graduation_set_qualification_types`
  ADD CONSTRAINT `fk_gsqt_qualification` FOREIGN KEY (`qualification_type_id`) REFERENCES `qualification_types` (`qualification_type_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_gsqt_set` FOREIGN KEY (`graduation_set_id`) REFERENCES `graduation_sets` (`graduation_set_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `institutes`
--
ALTER TABLE `institutes`
  ADD CONSTRAINT `institutes_ibfk_1` FOREIGN KEY (`school_id`) REFERENCES `schools` (`school_id`);

--
-- Constraints for table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`recipient_user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `programmes`
--
ALTER TABLE `programmes`
  ADD CONSTRAINT `programmes_ibfk_1` FOREIGN KEY (`institute_id`) REFERENCES `institutes` (`institute_id`);

--
-- Constraints for table `programme_specialisations`
--
ALTER TABLE `programme_specialisations`
  ADD CONSTRAINT `fk_specialisation_programme` FOREIGN KEY (`programme_id`) REFERENCES `programmes` (`programme_id`) ON DELETE CASCADE;

--
-- Constraints for table `students`
--
ALTER TABLE `students`
  ADD CONSTRAINT `fk_student_specialisation` FOREIGN KEY (`specialisation_id`) REFERENCES `programme_specialisations` (`specialisation_id`) ON DELETE SET NULL;

--
-- Constraints for table `student_classifications`
--
ALTER TABLE `student_classifications`
  ADD CONSTRAINT `fk_classification_registrar` FOREIGN KEY (`entered_by`) REFERENCES `users` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_classification_student` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `supporting_documents`
--
ALTER TABLE `supporting_documents`
  ADD CONSTRAINT `supporting_documents_ibfk_1` FOREIGN KEY (`request_id`) REFERENCES `clearance_requests` (`request_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `supporting_documents_ibfk_2` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `transcripts`
--
ALTER TABLE `transcripts`
  ADD CONSTRAINT `transcripts_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `transcripts_ibfk_2` FOREIGN KEY (`uploaded_by`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `transcripts_ibfk_3` FOREIGN KEY (`request_id`) REFERENCES `clearance_requests` (`request_id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
