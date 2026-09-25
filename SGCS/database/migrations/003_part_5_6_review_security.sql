-- 003: Part 5–6 review and security safeguards. Run after 001 and 002.
CREATE TABLE IF NOT EXISTS department_review_checks (
  review_check_id INT AUTO_INCREMENT PRIMARY KEY,
  request_id INT NOT NULL,
  dept_id INT NOT NULL,
  physical_fyp_submitted TINYINT(1) NULL,
  checked_by INT NULL,
  checked_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uq_review_check_request_dept (request_id,dept_id),
  CONSTRAINT fk_review_check_request FOREIGN KEY (request_id) REFERENCES clearance_requests(request_id) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_review_check_department FOREIGN KEY (dept_id) REFERENCES departments(dept_id) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_review_check_user FOREIGN KEY (checked_by) REFERENCES users(user_id) ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB;

DROP TRIGGER IF EXISTS trg_approval_records_immutable_decision;
DELIMITER //
CREATE TRIGGER trg_approval_records_immutable_decision BEFORE UPDATE ON approval_records FOR EACH ROW
BEGIN
  IF OLD.status IN ('Approved','Rejected') THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Approval and rejection history is immutable';
  END IF;
END //
DELIMITER ;
INSERT IGNORE INTO schema_migrations(migration_id,checksum,notes) VALUES('003_part_5_6_review_security',NULL,'Immutable decisions and Library physical FYP checks');