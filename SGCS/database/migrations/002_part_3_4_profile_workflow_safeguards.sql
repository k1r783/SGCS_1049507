-- 002: Part 3–4 profile/document/workflow safeguards. Run after 001.
-- Additive migration; do not apply before the 001 foundation migration and its post-migration mapping review.

DELIMITER //
DROP PROCEDURE IF EXISTS sgcs_002_add_column //
CREATE PROCEDURE sgcs_002_add_column(IN p_table VARCHAR(64), IN p_column VARCHAR(64), IN p_definition TEXT)
BEGIN
  IF NOT EXISTS (SELECT 1 FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME=p_table AND COLUMN_NAME=p_column) THEN
    SET @sql=CONCAT('ALTER TABLE `',p_table,'` ADD COLUMN `',p_column,'` ',p_definition);
    PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
  END IF;
END //
DROP PROCEDURE IF EXISTS sgcs_002_fail_active_duplicates //
CREATE PROCEDURE sgcs_002_fail_active_duplicates()
BEGIN
  IF EXISTS (SELECT 1 FROM (SELECT student_id,graduation_set_id FROM clearance_requests WHERE overall_status IN ('Pending','In Progress','Rejected') GROUP BY student_id,graduation_set_id HAVING COUNT(*)>1) x) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Resolve multiple active clearance requests before adding workflow guard'; END IF;
END //
DELIMITER ;

CALL sgcs_002_fail_active_duplicates();
ALTER TABLE supporting_documents MODIFY request_id INT NULL;
ALTER TABLE supporting_documents MODIFY document_type ENUM('id_passport','final_year_project','fee_statement') NOT NULL;
CALL sgcs_002_add_column('supporting_documents','stored_name',"VARCHAR(255) NOT NULL DEFAULT ''");
CALL sgcs_002_add_column('supporting_documents','mime_type',"VARCHAR(100) NOT NULL DEFAULT 'application/pdf'");
CALL sgcs_002_add_column('supporting_documents','status',"ENUM('Pending','Approved','Rejected','Replaced') NOT NULL DEFAULT 'Pending'");
CALL sgcs_002_add_column('supporting_documents','replaced_at','DATETIME NULL');
CALL sgcs_002_add_column('supporting_documents','document_reviewed_at','DATETIME NULL');

-- Enforce one active request per student per graduation set at database level.
DROP TRIGGER IF EXISTS trg_clearance_no_duplicate_active_insert;
DELIMITER //
CREATE TRIGGER trg_clearance_no_duplicate_active_insert BEFORE INSERT ON clearance_requests FOR EACH ROW
BEGIN
  IF NEW.graduation_set_id IS NULL THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Clearance request requires a graduation set'; END IF;
  IF NEW.overall_status IN ('Pending','In Progress','Rejected') AND EXISTS (SELECT 1 FROM clearance_requests WHERE student_id=NEW.student_id AND graduation_set_id=NEW.graduation_set_id AND overall_status IN ('Pending','In Progress','Rejected')) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Only one active clearance request per student and graduation set is allowed'; END IF;
END //
DELIMITER ;

INSERT IGNORE INTO schema_migrations(migration_id,checksum,notes) VALUES('002_part_3_4_profile_workflow_safeguards',NULL,'Document metadata and active-clearance trigger');
DROP PROCEDURE IF EXISTS sgcs_002_add_column;
DROP PROCEDURE IF EXISTS sgcs_002_fail_active_duplicates;