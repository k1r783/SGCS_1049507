-- MariaDB dump 10.19  Distrib 10.4.32-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: sgcs_db
-- ------------------------------------------------------
-- Server version	10.4.32-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `approval_records`
--

DROP TABLE IF EXISTS `approval_records`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `approval_records` (
  `approval_id` int(11) NOT NULL AUTO_INCREMENT,
  `request_id` int(11) NOT NULL,
  `dept_id` int(11) NOT NULL,
  `officer_id` int(11) DEFAULT NULL,
  `officer_institute_id` int(11) DEFAULT NULL,
  `status` enum('Pending','Approved','Rejected') NOT NULL DEFAULT 'Pending',
  `comments` text DEFAULT NULL,
  `assigned_at` datetime NOT NULL DEFAULT current_timestamp(),
  `decided_at` datetime DEFAULT NULL,
  PRIMARY KEY (`approval_id`),
  KEY `request_id` (`request_id`),
  KEY `dept_id` (`dept_id`),
  KEY `officer_id` (`officer_id`),
  CONSTRAINT `approval_records_ibfk_1` FOREIGN KEY (`request_id`) REFERENCES `clearance_requests` (`request_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `approval_records_ibfk_2` FOREIGN KEY (`dept_id`) REFERENCES `departments` (`dept_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `approval_records_ibfk_3` FOREIGN KEY (`officer_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `approval_records`
--

LOCK TABLES `approval_records` WRITE;
/*!40000 ALTER TABLE `approval_records` DISABLE KEYS */;
INSERT INTO `approval_records` VALUES (1,1,1,4,NULL,'Approved','Director approval granted.','2026-06-20 09:00:00','2026-06-20 11:00:00'),(2,1,2,5,NULL,'Approved','No outstanding library books.','2026-06-20 09:00:00','2026-06-21 10:00:00'),(3,1,3,NULL,NULL,'Pending','Upload the fee structure','2026-06-20 09:00:00',NULL),(4,1,4,NULL,NULL,'Pending',NULL,'2026-06-20 09:00:00',NULL),(5,1,5,NULL,NULL,'Pending',NULL,'2026-06-20 09:00:00',NULL),(6,1,6,NULL,NULL,'Pending',NULL,'2026-06-20 09:00:00',NULL),(7,2,1,4,NULL,'Approved','Director approval granted.','2026-06-18 10:30:00','2026-06-18 12:00:00'),(8,2,2,5,NULL,'Rejected','Student has an outstanding library fine.','2026-06-18 10:30:00','2026-06-19 09:15:00'),(9,2,3,NULL,NULL,'Pending',NULL,'2026-06-18 10:30:00',NULL),(10,2,4,NULL,NULL,'Pending',NULL,'2026-06-18 10:30:00',NULL),(11,2,5,NULL,NULL,'Pending',NULL,'2026-06-18 10:30:00',NULL),(12,2,6,NULL,NULL,'Pending',NULL,'2026-06-18 10:30:00',NULL),(13,3,1,4,NULL,'Approved','Director approval granted.','2026-06-15 08:45:00','2026-06-15 10:00:00'),(14,3,2,5,NULL,'Approved','Library cleared.','2026-06-15 08:45:00','2026-06-15 12:00:00'),(15,3,3,6,NULL,'Approved','Fee balance cleared.','2026-06-15 08:45:00','2026-06-16 09:00:00'),(16,3,4,7,NULL,'Approved','Student affairs cleared.','2026-06-15 08:45:00','2026-06-16 13:00:00'),(17,3,5,8,NULL,'Approved','No university store items pending.','2026-06-15 08:45:00','2026-06-17 09:30:00'),(18,3,6,9,NULL,'Approved','Final registrar clearance granted.','2026-06-15 08:45:00','2026-06-17 14:00:00'),(19,4,1,4,NULL,'Approved','','2026-08-09 18:51:03','2026-08-09 18:52:10'),(20,4,2,5,NULL,'Approved','','2026-08-09 18:52:10','2026-08-09 18:54:41'),(21,4,3,6,NULL,'Approved','','2026-08-09 18:52:10','2026-08-09 18:58:23'),(22,4,4,7,NULL,'Approved','all is uploaded.','2026-08-09 18:52:10','2026-08-09 18:59:55'),(23,4,5,8,NULL,'Approved','Nothing was issued to this student.','2026-08-09 18:52:10','2026-08-09 19:01:34'),(24,4,6,9,NULL,'Approved','Well Cleared.','2026-08-09 18:52:10','2026-08-09 19:02:36'),(25,5,1,4,NULL,'Approved','all units done','2026-08-11 10:08:42','2026-08-11 10:14:48'),(26,5,2,5,NULL,'Approved','','2026-08-11 10:14:48','2026-08-11 10:24:03'),(27,5,3,6,NULL,'Approved','Approved','2026-08-11 10:14:48','2026-08-11 10:25:48'),(28,5,4,7,NULL,'Approved','cleared and approved','2026-08-11 10:14:48','2026-08-11 10:27:53'),(29,5,5,8,NULL,'Approved','','2026-08-11 10:14:48','2026-08-11 10:29:00'),(30,5,6,9,NULL,'Rejected','Has not met all the requirements.','2026-08-11 10:14:48','2026-08-11 10:29:55');
/*!40000 ALTER TABLE `approval_records` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER trg_approval_records_immutable_decision BEFORE UPDATE ON approval_records FOR EACH ROW
BEGIN
  IF OLD.status IN ('Approved','Rejected') THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Approval and rejection history is immutable';
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `audit_logs`
--

DROP TABLE IF EXISTS `audit_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `audit_logs` (
  `audit_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `action` varchar(80) NOT NULL,
  `details` text DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`audit_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `audit_logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=103 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `audit_logs`
--

LOCK TABLES `audit_logs` WRITE;
/*!40000 ALTER TABLE `audit_logs` DISABLE KEYS */;
INSERT INTO `audit_logs` VALUES (1,1,'clearance_request_created','Student started clearance request #1','2026-06-20 09:00:00'),(2,4,'clearance_approved','Request #1 approved and moved to Library','2026-06-20 11:00:00'),(3,5,'clearance_approved','Request #1 approved and moved to Finance Office','2026-06-21 10:00:00'),(4,5,'clearance_rejected','Request #2 rejected at Library','2026-06-19 09:15:00'),(5,9,'clearance_completed','Request #3 received final approval.','2026-06-17 14:00:00'),(6,9,'transcript_uploaded','Transcript uploaded for student #3','2026-06-17 13:30:00'),(7,1,'login','User logged in successfully.','2026-08-09 18:49:35'),(8,1,'logout','User logged out.','2026-08-09 18:49:44'),(9,11,'login','User logged in successfully.','2026-08-09 18:50:38'),(10,11,'clearance_request_created','Student started clearance request #4','2026-08-09 18:51:03'),(11,11,'transcript_uploaded','Transcript uploaded for request #4','2026-08-09 18:51:03'),(12,11,'logout','User logged out.','2026-08-09 18:51:39'),(13,4,'login','User logged in successfully.','2026-08-09 18:51:54'),(14,4,'clearance_approved','Request #4 approved and moved to Library','2026-08-09 18:52:10'),(15,4,'logout','User logged out.','2026-08-09 18:52:17'),(16,11,'login','User logged in successfully.','2026-08-09 18:52:34'),(17,11,'logout','User logged out.','2026-08-09 18:54:06'),(18,5,'login','User logged in successfully.','2026-08-09 18:54:21'),(19,5,'clearance_approved','Request #4 approved and moved to Finance Office','2026-08-09 18:54:41'),(20,5,'logout','User logged out.','2026-08-09 18:55:07'),(21,11,'login','User logged in successfully.','2026-08-09 18:55:22'),(22,11,'logout','User logged out.','2026-08-09 18:57:20'),(23,NULL,'failed_login','Failed login attempt for username: finance','2026-08-09 18:57:42'),(24,6,'login','User logged in successfully.','2026-08-09 18:57:52'),(25,6,'clearance_approved','Request #4 approved and moved to Dean of Students','2026-08-09 18:58:23'),(26,6,'clearance_rejected','Request #1 rejected at department #3','2026-08-09 18:58:54'),(27,6,'notifications_marked_read','User marked notifications as read.','2026-08-09 18:59:03'),(28,6,'logout','User logged out.','2026-08-09 18:59:14'),(29,7,'login','User logged in successfully.','2026-08-09 18:59:35'),(30,7,'clearance_approved','Request #4 approved and moved to University Store','2026-08-09 18:59:55'),(31,7,'logout','User logged out.','2026-08-09 19:00:05'),(32,8,'login','User logged in successfully.','2026-08-09 19:01:06'),(33,8,'clearance_approved','Request #4 approved and moved to Academic Registrar','2026-08-09 19:01:34'),(34,8,'logout','User logged out.','2026-08-09 19:01:37'),(35,9,'login','User logged in successfully.','2026-08-09 19:01:53'),(36,9,'clearance_completed','Request #4 received final approval.','2026-08-09 19:02:36'),(37,9,'logout','User logged out.','2026-08-09 19:02:50'),(38,11,'login','User logged in successfully.','2026-08-09 19:03:04'),(39,10,'login','User logged in successfully.','2026-08-11 09:55:42'),(40,10,'logout','User logged out.','2026-08-11 09:59:00'),(41,11,'login','User logged in successfully.','2026-08-11 09:59:40'),(42,11,'logout','User logged out.','2026-08-11 10:00:51'),(43,1,'login','User logged in successfully.','2026-08-11 10:01:19'),(44,1,'transcript_uploaded','Transcript uploaded for request #1','2026-08-11 10:02:08'),(45,1,'clearance_resubmitted','Request #1 resumed at department #3','2026-08-11 10:02:08'),(46,1,'logout','User logged out.','2026-08-11 10:02:20'),(47,4,'login','User logged in successfully.','2026-08-11 10:02:32'),(48,4,'logout','User logged out.','2026-08-11 10:03:41'),(49,12,'login','User logged in successfully.','2026-08-11 10:08:22'),(50,12,'clearance_request_created','Student started clearance request #5','2026-08-11 10:08:42'),(51,12,'transcript_uploaded','Transcript uploaded for request #5','2026-08-11 10:08:42'),(52,12,'logout','User logged out.','2026-08-11 10:08:50'),(53,NULL,'failed_login','Failed login attempt for username: sci562026','2026-08-11 10:09:13'),(54,NULL,'failed_login','Failed login attempt for username: sci562026','2026-08-11 10:09:45'),(55,12,'login','User logged in successfully.','2026-08-11 10:10:34'),(56,12,'logout','User logged out.','2026-08-11 10:13:30'),(57,4,'login','User logged in successfully.','2026-08-11 10:13:40'),(58,4,'clearance_approved','Request #5 approved and moved to Library','2026-08-11 10:14:48'),(59,4,'logout','User logged out.','2026-08-11 10:14:57'),(60,12,'login','User logged in successfully.','2026-08-11 10:15:09'),(61,12,'logout','User logged out.','2026-08-11 10:19:58'),(62,5,'login','User logged in successfully.','2026-08-11 10:20:15'),(63,5,'logout','User logged out.','2026-08-11 10:21:01'),(64,4,'login','User logged in successfully.','2026-08-11 10:21:10'),(65,4,'logout','User logged out.','2026-08-11 10:23:02'),(66,5,'login','User logged in successfully.','2026-08-11 10:23:11'),(67,5,'clearance_approved','Request #5 approved and moved to Finance Office','2026-08-11 10:24:03'),(68,5,'logout','User logged out.','2026-08-11 10:24:11'),(69,NULL,'failed_login','Failed login attempt for username: sci562026','2026-08-11 10:24:22'),(70,12,'login','User logged in successfully.','2026-08-11 10:24:35'),(71,12,'logout','User logged out.','2026-08-11 10:24:51'),(72,6,'login','User logged in successfully.','2026-08-11 10:25:00'),(73,6,'clearance_approved','Request #5 approved and moved to Dean of Students','2026-08-11 10:25:48'),(74,6,'logout','User logged out.','2026-08-11 10:25:51'),(75,12,'login','User logged in successfully.','2026-08-11 10:26:01'),(76,12,'logout','User logged out.','2026-08-11 10:27:07'),(77,7,'login','User logged in successfully.','2026-08-11 10:27:19'),(78,7,'clearance_approved','Request #5 approved and moved to University Store','2026-08-11 10:27:53'),(79,7,'logout','User logged out.','2026-08-11 10:27:57'),(80,9,'login','User logged in successfully.','2026-08-11 10:28:10'),(81,9,'logout','User logged out.','2026-08-11 10:28:44'),(82,8,'login','User logged in successfully.','2026-08-11 10:28:54'),(83,8,'clearance_approved','Request #5 approved and moved to Academic Registrar','2026-08-11 10:29:00'),(84,8,'logout','User logged out.','2026-08-11 10:29:04'),(85,9,'login','User logged in successfully.','2026-08-11 10:29:14'),(86,9,'clearance_rejected','Request #5 rejected at department #6','2026-08-11 10:29:55'),(87,9,'logout','User logged out.','2026-08-11 10:30:00'),(88,12,'login','User logged in successfully.','2026-08-11 10:30:10'),(89,12,'logout','User logged out.','2026-08-11 10:32:11'),(90,9,'login','User logged in successfully.','2026-08-11 10:32:29'),(91,9,'logout','User logged out.','2026-08-11 10:33:10'),(92,4,'login','User logged in successfully.','2026-08-11 10:33:19'),(93,10,'login','User logged in successfully.','2026-08-18 09:56:40'),(94,10,'logout','User logged out.','2026-08-18 10:00:54'),(95,10,'login','User logged in successfully.','2026-08-18 10:01:06'),(96,10,'login','User logged in successfully.','2026-08-18 10:03:20'),(97,10,'user_created','Created student account for stacy','2026-08-18 10:04:10'),(98,10,'logout','User logged out.','2026-08-18 10:04:26'),(99,13,'login','User logged in successfully.','2026-08-18 10:04:38'),(100,10,'logout','User logged out.','2026-08-18 11:04:22'),(101,13,'login','User logged in successfully.','2026-08-18 11:04:35'),(102,10,'login','User logged in successfully.','2026-08-20 18:13:16');
/*!40000 ALTER TABLE `audit_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clearance_requests`
--

DROP TABLE IF EXISTS `clearance_requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `clearance_requests` (
  `request_id` int(11) NOT NULL AUTO_INCREMENT,
  `student_id` int(11) NOT NULL,
  `graduation_set_id` int(11) DEFAULT NULL,
  `submitted_at` datetime NOT NULL DEFAULT current_timestamp(),
  `overall_status` enum('Pending','Approved','In Progress','Rejected','Final') NOT NULL DEFAULT 'Pending',
  `current_dept_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`request_id`),
  KEY `student_id` (`student_id`),
  KEY `current_dept_id` (`current_dept_id`),
  KEY `idx_clearance_student_set_status` (`student_id`,`graduation_set_id`,`overall_status`),
  CONSTRAINT `clearance_requests_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `clearance_requests_ibfk_2` FOREIGN KEY (`current_dept_id`) REFERENCES `departments` (`dept_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clearance_requests`
--

LOCK TABLES `clearance_requests` WRITE;
/*!40000 ALTER TABLE `clearance_requests` DISABLE KEYS */;
INSERT INTO `clearance_requests` VALUES (1,1,1,'2026-06-20 09:00:00','In Progress',3),(2,2,1,'2026-06-18 10:30:00','Rejected',2),(3,3,1,'2026-06-15 08:45:00','Final',NULL),(4,4,1,'2026-08-09 18:51:03','Final',NULL),(5,5,1,'2026-08-11 10:08:42','Rejected',6);
/*!40000 ALTER TABLE `clearance_requests` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER trg_clearance_no_duplicate_active_insert BEFORE INSERT ON clearance_requests FOR EACH ROW
BEGIN
  IF NEW.graduation_set_id IS NULL THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Clearance request requires a graduation set'; END IF;
  IF NEW.overall_status IN ('Pending','In Progress','Rejected') AND EXISTS (SELECT 1 FROM clearance_requests WHERE student_id=NEW.student_id AND graduation_set_id=NEW.graduation_set_id AND overall_status IN ('Pending','In Progress','Rejected')) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Only one active clearance request per student and graduation set is allowed'; END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `department_review_checks`
--

DROP TABLE IF EXISTS `department_review_checks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `department_review_checks` (
  `review_check_id` int(11) NOT NULL AUTO_INCREMENT,
  `request_id` int(11) NOT NULL,
  `dept_id` int(11) NOT NULL,
  `physical_fyp_submitted` tinyint(1) DEFAULT NULL,
  `checked_by` int(11) DEFAULT NULL,
  `checked_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`review_check_id`),
  UNIQUE KEY `uq_review_check_request_dept` (`request_id`,`dept_id`),
  KEY `fk_review_check_department` (`dept_id`),
  KEY `fk_review_check_user` (`checked_by`),
  CONSTRAINT `fk_review_check_department` FOREIGN KEY (`dept_id`) REFERENCES `departments` (`dept_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_review_check_request` FOREIGN KEY (`request_id`) REFERENCES `clearance_requests` (`request_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_review_check_user` FOREIGN KEY (`checked_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `department_review_checks`
--

LOCK TABLES `department_review_checks` WRITE;
/*!40000 ALTER TABLE `department_review_checks` DISABLE KEYS */;
/*!40000 ALTER TABLE `department_review_checks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `departments`
--

DROP TABLE IF EXISTS `departments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `departments` (
  `dept_id` int(11) NOT NULL AUTO_INCREMENT,
  `dept_name` varchar(100) NOT NULL,
  `sequence_no` int(11) NOT NULL,
  `officer_user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`dept_id`),
  UNIQUE KEY `sequence_no` (`sequence_no`),
  KEY `officer_user_id` (`officer_user_id`),
  CONSTRAINT `departments_ibfk_1` FOREIGN KEY (`officer_user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `departments`
--

LOCK TABLES `departments` WRITE;
/*!40000 ALTER TABLE `departments` DISABLE KEYS */;
INSERT INTO `departments` VALUES (1,'Institute Director',1,4),(2,'Library',2,5),(3,'Finance Office',3,6),(4,'Dean of Students',4,7),(5,'University Store',5,8),(6,'Academic Registrar',6,9);
/*!40000 ALTER TABLE `departments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `final_approvals`
--

DROP TABLE IF EXISTS `final_approvals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `final_approvals` (
  `approval_number` int(11) NOT NULL AUTO_INCREMENT,
  `request_id` int(11) NOT NULL,
  `generated_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`approval_number`),
  UNIQUE KEY `request_id` (`request_id`),
  CONSTRAINT `final_approvals_ibfk_1` FOREIGN KEY (`request_id`) REFERENCES `clearance_requests` (`request_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `final_approvals`
--

LOCK TABLES `final_approvals` WRITE;
/*!40000 ALTER TABLE `final_approvals` DISABLE KEYS */;
INSERT INTO `final_approvals` VALUES (1,3,'2026-06-17 14:05:00'),(2,4,'2026-08-09 19:02:36');
/*!40000 ALTER TABLE `final_approvals` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `graduation_sets`
--

DROP TABLE IF EXISTS `graduation_sets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `graduation_sets` (
  `graduation_set_id` int(11) NOT NULL AUTO_INCREMENT,
  `set_name` varchar(100) NOT NULL,
  `graduation_year` year(4) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 0,
  `starts_at` datetime DEFAULT NULL,
  `ends_at` datetime DEFAULT NULL,
  PRIMARY KEY (`graduation_set_id`),
  UNIQUE KEY `set_name` (`set_name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `graduation_sets`
--

LOCK TABLES `graduation_sets` WRITE;
/*!40000 ALTER TABLE `graduation_sets` DISABLE KEYS */;
INSERT INTO `graduation_sets` VALUES (1,'Legacy 2026 Graduation',2026,1,NULL,NULL),(2,'Graduation 2026',2026,0,'2026-08-20 18:14:00','2026-09-20 18:14:00');
/*!40000 ALTER TABLE `graduation_sets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `institutes`
--

DROP TABLE IF EXISTS `institutes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `institutes` (
  `institute_id` int(11) NOT NULL AUTO_INCREMENT,
  `school_id` int(11) DEFAULT NULL,
  `institute_name` varchar(100) NOT NULL,
  PRIMARY KEY (`institute_id`),
  UNIQUE KEY `uq_institute_school_name` (`school_id`,`institute_name`),
  CONSTRAINT `institutes_ibfk_1` FOREIGN KEY (`school_id`) REFERENCES `schools` (`school_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `institutes`
--

LOCK TABLES `institutes` WRITE;
/*!40000 ALTER TABLE `institutes` DISABLE KEYS */;
INSERT INTO `institutes` VALUES (1,NULL,'Institute of Education'),(2,NULL,'Institute of Science and Technology'),(3,NULL,'Institute of Social Transformation'),(4,NULL,'Not assigned');
/*!40000 ALTER TABLE `institutes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notifications` (
  `notif_id` int(11) NOT NULL AUTO_INCREMENT,
  `recipient_user_id` int(11) NOT NULL,
  `notif_type` varchar(50) NOT NULL,
  `message` text NOT NULL,
  `sent_at` datetime NOT NULL DEFAULT current_timestamp(),
  `is_read` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`notif_id`),
  KEY `recipient_user_id` (`recipient_user_id`),
  CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`recipient_user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notifications`
--

LOCK TABLES `notifications` WRITE;
/*!40000 ALTER TABLE `notifications` DISABLE KEYS */;
INSERT INTO `notifications` VALUES (1,1,'clearance_updated','Your clearance has moved to Finance Office.','2026-06-21 10:00:00',0),(2,2,'clearance_rejected','Your clearance request was rejected. Please check the tracking page for comments.','2026-06-19 09:15:00',0),(3,3,'final_approval_generated','Your Final Approval has been generated.','2026-06-17 14:00:00',0),(4,6,'pending_clearance_request','A clearance request is waiting for Finance Office review.','2026-06-21 10:00:00',1),(5,9,'transcript_request','Abigael K. Kirimi (1049507) has requested transcript support for graduation clearance.','2026-06-21 11:00:00',0),(6,10,'student_registered','William Muruiki registered as sci/20/2026.','2026-08-09 18:50:22',0),(7,4,'pending_clearance_request','A final transcript is ready for Institute Director review.','2026-08-09 18:51:03',0),(8,11,'clearance_started','Your clearance request was submitted to the Institute Director.','2026-08-09 18:51:03',0),(9,11,'clearance_updated','Your clearance has moved to Library.','2026-08-09 18:52:10',0),(10,5,'pending_clearance_request','A clearance request is waiting for your department review.','2026-08-09 18:52:10',0),(11,11,'clearance_updated','Your clearance has moved to Finance Office.','2026-08-09 18:54:41',0),(12,6,'pending_clearance_request','A clearance request is waiting for your department review.','2026-08-09 18:54:41',1),(13,11,'clearance_updated','Your clearance has moved to Dean of Students.','2026-08-09 18:58:23',0),(14,7,'pending_clearance_request','A clearance request is waiting for your department review.','2026-08-09 18:58:23',0),(15,1,'clearance_rejected','Your clearance request was rejected. Please check the tracking page for comments.','2026-08-09 18:58:54',0),(16,11,'clearance_updated','Your clearance has moved to University Store.','2026-08-09 18:59:55',0),(17,8,'pending_clearance_request','A clearance request is waiting for your department review.','2026-08-09 18:59:55',0),(18,11,'clearance_updated','Your clearance has moved to Academic Registrar.','2026-08-09 19:01:34',0),(19,9,'pending_clearance_request','A clearance request is waiting for your department review.','2026-08-09 19:01:34',0),(20,11,'final_approval_generated','Your Final Approval has been generated.','2026-08-09 19:02:36',0),(21,4,'transcript_uploaded','A final transcript is ready for Institute Director review.','2026-08-11 10:02:08',0),(22,1,'transcript_uploaded','Your transcript was uploaded successfully.','2026-08-11 10:02:08',0),(23,6,'resubmitted_request','A corrected clearance request has been resubmitted for review.','2026-08-11 10:02:08',0),(24,1,'clearance_resubmitted','Your clearance request was resubmitted to the department that rejected it.','2026-08-11 10:02:08',0),(25,10,'student_registered','Abby Kirimi registered as sc/56/2026.','2026-08-11 10:06:05',0),(26,4,'pending_clearance_request','A final transcript is ready for Institute Director review.','2026-08-11 10:08:42',0),(27,12,'clearance_started','Your clearance request was submitted to the Institute Director.','2026-08-11 10:08:42',0),(28,12,'clearance_updated','Your clearance has moved to Library.','2026-08-11 10:14:48',0),(29,5,'pending_clearance_request','A clearance request is waiting for your department review.','2026-08-11 10:14:48',0),(30,12,'clearance_updated','Your clearance has moved to Finance Office.','2026-08-11 10:24:03',0),(31,6,'pending_clearance_request','A clearance request is waiting for your department review.','2026-08-11 10:24:03',0),(32,12,'clearance_updated','Your clearance has moved to Dean of Students.','2026-08-11 10:25:48',0),(33,7,'pending_clearance_request','A clearance request is waiting for your department review.','2026-08-11 10:25:48',0),(34,12,'clearance_updated','Your clearance has moved to University Store.','2026-08-11 10:27:53',0),(35,8,'pending_clearance_request','A clearance request is waiting for your department review.','2026-08-11 10:27:53',0),(36,12,'clearance_updated','Your clearance has moved to Academic Registrar.','2026-08-11 10:29:00',0),(37,9,'pending_clearance_request','A clearance request is waiting for your department review.','2026-08-11 10:29:00',0),(38,12,'clearance_rejected','Your clearance request was rejected. Please check the tracking page for comments.','2026-08-11 10:29:55',0);
/*!40000 ALTER TABLE `notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `programmes`
--

DROP TABLE IF EXISTS `programmes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `programmes` (
  `programme_id` int(11) NOT NULL AUTO_INCREMENT,
  `institute_id` int(11) NOT NULL,
  `programme_name` varchar(100) NOT NULL,
  PRIMARY KEY (`programme_id`),
  UNIQUE KEY `uq_programme_institute_name` (`institute_id`,`programme_name`),
  CONSTRAINT `programmes_ibfk_1` FOREIGN KEY (`institute_id`) REFERENCES `institutes` (`institute_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `programmes`
--

LOCK TABLES `programmes` WRITE;
/*!40000 ALTER TABLE `programmes` DISABLE KEYS */;
INSERT INTO `programmes` VALUES (1,1,'Bachelor of Education'),(2,2,'Bachelor of Science in Computer Science'),(3,3,'Bachelor of Arts in Social Ministry'),(4,4,'Institute of social communication'),(5,4,'Institute of theology');
/*!40000 ALTER TABLE `programmes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schema_migrations`
--

DROP TABLE IF EXISTS `schema_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schema_migrations` (
  `migration_id` varchar(100) NOT NULL,
  `applied_at` datetime NOT NULL DEFAULT current_timestamp(),
  `checksum` varchar(64) DEFAULT NULL,
  `notes` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`migration_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schema_migrations`
--

LOCK TABLES `schema_migrations` WRITE;
/*!40000 ALTER TABLE `schema_migrations` DISABLE KEYS */;
INSERT INTO `schema_migrations` VALUES ('001_requirements_1_2_foundation','2026-08-20 18:00:57',NULL,'Requirements 1-2 foundation'),('002_part_3_4_profile_workflow_safeguards','2026-08-20 17:54:14',NULL,'Document metadata and active-clearance trigger'),('003_part_5_6_review_security','2026-08-20 17:58:08',NULL,'Immutable decisions and Library physical FYP checks');
/*!40000 ALTER TABLE `schema_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schools`
--

DROP TABLE IF EXISTS `schools`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schools` (
  `school_id` int(11) NOT NULL AUTO_INCREMENT,
  `school_name` varchar(100) NOT NULL,
  PRIMARY KEY (`school_id`),
  UNIQUE KEY `school_name` (`school_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schools`
--

LOCK TABLES `schools` WRITE;
/*!40000 ALTER TABLE `schools` DISABLE KEYS */;
/*!40000 ALTER TABLE `schools` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `students`
--

DROP TABLE IF EXISTS `students`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `students` (
  `student_id` int(11) NOT NULL AUTO_INCREMENT,
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
  `graduation_set_id` int(11) DEFAULT NULL,
  `email` varchar(100) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `graduation_year` year(4) NOT NULL,
  `account_status` enum('Active','Inactive') NOT NULL DEFAULT 'Active',
  `certificate_name_order` enum('first_middle_last','last_first_middle') DEFAULT NULL,
  `certificate_name_confirmed_at` datetime DEFAULT NULL,
  PRIMARY KEY (`student_id`),
  UNIQUE KEY `registration_no` (`registration_no`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `uq_students_phone` (`phone`),
  UNIQUE KEY `uq_students_national_id_passport` (`national_id_passport_no`),
  KEY `idx_students_academic_path` (`school_id`,`institute_id`,`programme_id`),
  KEY `idx_students_graduation_set` (`graduation_set_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `students`
--

LOCK TABLES `students` WRITE;
/*!40000 ALTER TABLE `students` DISABLE KEYS */;
INSERT INTO `students` VALUES (1,'1049507','Abigael K. Kirimi','Abigael',NULL,'Kirimi',NULL,NULL,'Bachelor of Science in Computer Science','Institute of Science and Technology',NULL,2,2,1,'abigael.kirimi@student.tangaza.ac.ke','0700000000',2026,'Active','first_middle_last',NULL),(2,'1049508','Brian Otieno','Brian',NULL,'Otieno',NULL,NULL,'Bachelor of Education','Institute of Education',NULL,1,1,1,'brian.otieno@student.tangaza.ac.ke','0711111111',2026,'Active','first_middle_last',NULL),(3,'1049509','Mary Wanjiku','Mary',NULL,'Wanjiku',NULL,NULL,'Bachelor of Arts in Social Ministry','Institute of Social Transformation',NULL,3,3,1,'mary.wanjiku@student.tangaza.ac.ke','0722222222',2026,'Active','first_middle_last',NULL),(4,'sci/20/2026','William Muruiki','William',NULL,'Muruiki',NULL,NULL,'Institute of social communication','Not assigned',NULL,4,4,1,'william@gmail.com','0756879387',2026,'Active','first_middle_last',NULL),(5,'sc/56/2026','Abby Kirimi','Abby',NULL,'Kirimi',NULL,NULL,'Institute of theology','Not assigned',NULL,4,5,1,'abby@gmail.com','72',2026,'Active','first_middle_last',NULL);
/*!40000 ALTER TABLE `students` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `supporting_documents`
--

DROP TABLE IF EXISTS `supporting_documents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `supporting_documents` (
  `document_id` int(11) NOT NULL AUTO_INCREMENT,
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
  `document_reviewed_at` datetime DEFAULT NULL,
  PRIMARY KEY (`document_id`),
  KEY `request_id` (`request_id`),
  KEY `student_id` (`student_id`),
  CONSTRAINT `supporting_documents_ibfk_1` FOREIGN KEY (`request_id`) REFERENCES `clearance_requests` (`request_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `supporting_documents_ibfk_2` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `supporting_documents`
--

LOCK TABLES `supporting_documents` WRITE;
/*!40000 ALTER TABLE `supporting_documents` DISABLE KEYS */;
INSERT INTO `supporting_documents` VALUES (1,4,4,'final_year_project','final_year_project_4_1786290801.pdf','uploads/documents/final_year_project_4_1786290801.pdf','2026-08-09 18:53:21','','application/pdf','Pending',NULL,NULL),(2,4,4,'fee_statement','fee_statement_4_1786291030.pdf','uploads/documents/fee_statement_4_1786291030.pdf','2026-08-09 18:57:10','','application/pdf','Pending',NULL,NULL),(3,5,5,'final_year_project','final_year_project_5_1786432663.pdf','uploads/documents/final_year_project_5_1786432663.pdf','2026-08-11 10:17:43','','application/pdf','Pending',NULL,NULL),(4,5,5,'fee_statement','fee_statement_5_1786432794.pdf','uploads/documents/fee_statement_5_1786432794.pdf','2026-08-11 10:19:54','','application/pdf','Pending',NULL,NULL);
/*!40000 ALTER TABLE `supporting_documents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transcripts`
--

DROP TABLE IF EXISTS `transcripts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `transcripts` (
  `transcript_id` int(11) NOT NULL AUTO_INCREMENT,
  `student_id` int(11) NOT NULL,
  `request_id` int(11) NOT NULL,
  `uploaded_by` int(11) NOT NULL,
  `uploaded_at` datetime NOT NULL DEFAULT current_timestamp(),
  `filename` varchar(255) NOT NULL,
  `file_path` varchar(255) NOT NULL,
  `status` enum('Active','Replaced') NOT NULL DEFAULT 'Active',
  PRIMARY KEY (`transcript_id`),
  KEY `student_id` (`student_id`),
  KEY `uploaded_by` (`uploaded_by`),
  KEY `request_id` (`request_id`),
  CONSTRAINT `transcripts_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `transcripts_ibfk_2` FOREIGN KEY (`uploaded_by`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `transcripts_ibfk_3` FOREIGN KEY (`request_id`) REFERENCES `clearance_requests` (`request_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transcripts`
--

LOCK TABLES `transcripts` WRITE;
/*!40000 ALTER TABLE `transcripts` DISABLE KEYS */;
INSERT INTO `transcripts` VALUES (1,3,3,9,'2026-06-17 13:30:00','sample-transcript-mary.pdf','uploads/transcripts/sample-transcript-mary.pdf','Active'),(2,4,4,11,'2026-08-09 18:51:03','transcript_4_1786290663.pdf','uploads/transcripts/transcript_4_1786290663.pdf','Active'),(3,1,1,1,'2026-08-11 10:02:08','transcript_1_1786431728.pdf','uploads/transcripts/transcript_1_1786431728.pdf','Active'),(4,5,5,12,'2026-08-11 10:08:42','transcript_5_1786432122.pdf','uploads/transcripts/transcript_5_1786432122.pdf','Active');
/*!40000 ALTER TABLE `transcripts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role` enum('student','officer','director','registrar','admin') NOT NULL,
  `linked_id` int(11) DEFAULT NULL,
  `school_id` int(11) DEFAULT NULL,
  `institute_id` int(11) DEFAULT NULL,
  `department_id` int(11) DEFAULT NULL,
  `programme_id` int(11) DEFAULT NULL,
  `full_name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `account_status` enum('Active','Inactive') NOT NULL DEFAULT 'Active',
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'student1','$2y$10$CW38hPxbW7lvxr8Dj1bSYuj4VDAf3WcMkk5VYhDBhBlOB.Q0aORuq','student',1,NULL,NULL,NULL,NULL,'Abigael K. Kirimi','abigael.kirimi@student.tangaza.ac.ke','2026-08-09 18:46:52','Active',NULL),(2,'student2','$2y$10$CW38hPxbW7lvxr8Dj1bSYuj4VDAf3WcMkk5VYhDBhBlOB.Q0aORuq','student',2,NULL,NULL,NULL,NULL,'Brian Otieno','brian.otieno@student.tangaza.ac.ke','2026-08-09 18:46:52','Active',NULL),(3,'student3','$2y$10$CW38hPxbW7lvxr8Dj1bSYuj4VDAf3WcMkk5VYhDBhBlOB.Q0aORuq','student',3,NULL,NULL,NULL,NULL,'Mary Wanjiku','mary.wanjiku@student.tangaza.ac.ke','2026-08-09 18:46:52','Active',NULL),(4,'director','$2y$10$CW38hPxbW7lvxr8Dj1bSYuj4VDAf3WcMkk5VYhDBhBlOB.Q0aORuq','director',1,NULL,NULL,NULL,NULL,'Director Office','director@tangaza.ac.ke','2026-08-09 18:46:52','Active',NULL),(5,'library','$2y$10$CW38hPxbW7lvxr8Dj1bSYuj4VDAf3WcMkk5VYhDBhBlOB.Q0aORuq','officer',2,NULL,NULL,NULL,NULL,'Library Officer','library@tangaza.ac.ke','2026-08-09 18:46:52','Active',NULL),(6,'finance','$2y$10$CW38hPxbW7lvxr8Dj1bSYuj4VDAf3WcMkk5VYhDBhBlOB.Q0aORuq','officer',3,NULL,NULL,NULL,NULL,'Finance Officer','finance@tangaza.ac.ke','2026-08-09 18:46:52','Active',NULL),(7,'dean','$2y$10$CW38hPxbW7lvxr8Dj1bSYuj4VDAf3WcMkk5VYhDBhBlOB.Q0aORuq','officer',4,NULL,NULL,NULL,NULL,'Dean of Students Officer','dean@tangaza.ac.ke','2026-08-09 18:46:52','Active',NULL),(8,'store','$2y$10$CW38hPxbW7lvxr8Dj1bSYuj4VDAf3WcMkk5VYhDBhBlOB.Q0aORuq','officer',5,NULL,NULL,NULL,NULL,'University Store Officer','store@tangaza.ac.ke','2026-08-09 18:46:52','Active',NULL),(9,'registrar','$2y$10$CW38hPxbW7lvxr8Dj1bSYuj4VDAf3WcMkk5VYhDBhBlOB.Q0aORuq','registrar',6,NULL,NULL,NULL,NULL,'Academic Registrar','registrar@tangaza.ac.ke','2026-08-09 18:46:52','Active',NULL),(10,'admin','$2y$10$CW38hPxbW7lvxr8Dj1bSYuj4VDAf3WcMkk5VYhDBhBlOB.Q0aORuq','admin',NULL,NULL,NULL,NULL,NULL,'System Administrator','admin@tangaza.ac.ke','2026-08-09 18:46:52','Active',NULL),(11,'sci202026','$2y$10$zogPBpEqnOJNCp96sqtCB.ZfGq8lGQmvfIVqFwl.KrYDohFZOJdrW','student',4,NULL,NULL,NULL,NULL,'William Muruiki','william@gmail.com','2026-08-09 18:50:22','Active',NULL),(12,'sc562026','$2y$10$7CPBQyc7tuVCG8oJ9dXMTu.iYDmfjpmWKcoTkMIFtb/ca7tJOkXoa','student',5,NULL,NULL,NULL,NULL,'Abby Kirimi','abby@gmail.com','2026-08-11 10:06:05','Active',NULL),(13,'stacy','$2y$10$ccAayURvdbu7JE264iuBMO7cvAsWNSkH2sOI3W5dpFb55pI1TTyhu','student',NULL,NULL,NULL,NULL,NULL,'Makena','stacy@gmail.com','2026-08-18 10:04:10','Active',NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'sgcs_db'
--
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sgcs_002_add_column` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sgcs_002_add_column`(IN p_table VARCHAR(64), IN p_column VARCHAR(64), IN p_definition TEXT)
BEGIN
  IF NOT EXISTS (SELECT 1 FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME=p_table AND COLUMN_NAME=p_column) THEN
    SET @sql=CONCAT('ALTER TABLE `',p_table,'` ADD COLUMN `',p_column,'` ',p_definition);
    PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
  END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sgcs_002_fail_active_duplicates` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sgcs_002_fail_active_duplicates`()
BEGIN
  IF EXISTS (SELECT 1 FROM (SELECT student_id,graduation_set_id FROM clearance_requests WHERE overall_status IN ('Pending','In Progress','Rejected') GROUP BY student_id,graduation_set_id HAVING COUNT(*)>1) x) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Resolve multiple active clearance requests before adding workflow guard'; END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-08-20 18:47:21
