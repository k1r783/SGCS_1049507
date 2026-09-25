-- 001: Requirements 1–2 foundation migration (MariaDB 10.4+).
-- Additive/idempotent migration. Run 000_schema_migrations.sql and 001_preflight_requirements_1_2.sql first.
-- Existing free-text institute/programme/year values are copied into normalized references where derivable.

CREATE TABLE IF NOT EXISTS schools (school_id INT AUTO_INCREMENT PRIMARY KEY, school_name VARCHAR(100) NOT NULL UNIQUE) ENGINE=InnoDB;
CREATE TABLE IF NOT EXISTS institutes (institute_id INT AUTO_INCREMENT PRIMARY KEY, school_id INT NULL, institute_name VARCHAR(100) NOT NULL, UNIQUE KEY uq_institute_school_name (school_id,institute_name), CONSTRAINT fk_institutes_school FOREIGN KEY (school_id) REFERENCES schools(school_id) ON UPDATE CASCADE ON DELETE SET NULL) ENGINE=InnoDB;
CREATE TABLE IF NOT EXISTS programmes (programme_id INT AUTO_INCREMENT PRIMARY KEY, institute_id INT NOT NULL, programme_name VARCHAR(100) NOT NULL, UNIQUE KEY uq_programme_institute_name (institute_id,programme_name), CONSTRAINT fk_programmes_institute FOREIGN KEY (institute_id) REFERENCES institutes(institute_id) ON UPDATE CASCADE ON DELETE RESTRICT) ENGINE=InnoDB;
CREATE TABLE IF NOT EXISTS graduation_sets (graduation_set_id INT AUTO_INCREMENT PRIMARY KEY, set_name VARCHAR(100) NOT NULL UNIQUE, graduation_year YEAR NOT NULL, is_active TINYINT(1) NOT NULL DEFAULT 0, starts_at DATETIME NULL, ends_at DATETIME NULL, KEY idx_graduation_sets_active_window (is_active,starts_at,ends_at)) ENGINE=InnoDB;

-- Existing installations created institutes.school_id as NOT NULL; relax it before preserving legacy unassigned institutes.
ALTER TABLE institutes MODIFY COLUMN school_id INT NULL;

DELIMITER //
DROP PROCEDURE IF EXISTS sgcs_add_column_if_missing //
CREATE PROCEDURE sgcs_add_column_if_missing(IN p_table VARCHAR(64), IN p_column VARCHAR(64), IN p_definition TEXT)
BEGIN
  IF NOT EXISTS (SELECT 1 FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME=p_table AND COLUMN_NAME=p_column) THEN
    SET @sql = CONCAT('ALTER TABLE `',p_table,'` ADD COLUMN `',p_column,'` ',p_definition);
    PREPARE statement FROM @sql; EXECUTE statement; DEALLOCATE PREPARE statement;
  END IF;
END //
DROP PROCEDURE IF EXISTS sgcs_add_index_if_missing //
CREATE PROCEDURE sgcs_add_index_if_missing(IN p_table VARCHAR(64), IN p_index VARCHAR(64), IN p_definition TEXT)
BEGIN
  IF NOT EXISTS (SELECT 1 FROM information_schema.STATISTICS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME=p_table AND INDEX_NAME=p_index) THEN
    SET @sql = CONCAT('ALTER TABLE `',p_table,'` ADD ',p_definition);
    PREPARE statement FROM @sql; EXECUTE statement; DEALLOCATE PREPARE statement;
  END IF;
END //
DROP PROCEDURE IF EXISTS sgcs_fail_on_duplicates //
CREATE PROCEDURE sgcs_fail_on_duplicates()
BEGIN
  IF EXISTS (SELECT 1 FROM (SELECT registration_no FROM students GROUP BY registration_no HAVING COUNT(*)>1) x) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Duplicate student registration numbers must be resolved before migration'; END IF;
  IF EXISTS (SELECT 1 FROM (SELECT email FROM students GROUP BY email HAVING COUNT(*)>1) x) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Duplicate student emails must be resolved before migration'; END IF;
  IF EXISTS (SELECT 1 FROM (SELECT phone FROM students WHERE phone IS NOT NULL AND phone<>'' GROUP BY phone HAVING COUNT(*)>1) x) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Duplicate student phones must be resolved before migration'; END IF;
  IF EXISTS (SELECT 1 FROM (SELECT username FROM users GROUP BY username HAVING COUNT(*)>1) x) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Duplicate usernames must be resolved before migration'; END IF;
END //
DELIMITER ;

CALL sgcs_fail_on_duplicates();
CALL sgcs_add_column_if_missing('students','gender',"ENUM('Male','Female','Other') NULL AFTER full_name");
CALL sgcs_add_column_if_missing('students','national_id_passport_no','VARCHAR(30) NULL AFTER gender');
CALL sgcs_add_column_if_missing('students','first_name','VARCHAR(60) NULL AFTER full_name');
CALL sgcs_add_column_if_missing('students','middle_name','VARCHAR(60) NULL AFTER first_name');
CALL sgcs_add_column_if_missing('students','last_name','VARCHAR(60) NULL AFTER middle_name');
CALL sgcs_add_column_if_missing('students','school_id','INT NULL AFTER institute');
CALL sgcs_add_column_if_missing('students','institute_id','INT NULL AFTER school_id');
CALL sgcs_add_column_if_missing('students','programme_id','INT NULL AFTER institute_id');
CALL sgcs_add_column_if_missing('students','graduation_set_id','INT NULL AFTER programme_id');
CALL sgcs_add_column_if_missing('students','certificate_name_order',"ENUM('first_middle_last','last_first_middle') NULL");
CALL sgcs_add_column_if_missing('students','certificate_name_confirmed_at','DATETIME NULL');
CALL sgcs_add_column_if_missing('users','school_id','INT NULL AFTER linked_id');
CALL sgcs_add_column_if_missing('users','institute_id','INT NULL AFTER school_id');
CALL sgcs_add_column_if_missing('users','department_id','INT NULL AFTER institute_id');
CALL sgcs_add_column_if_missing('users','programme_id','INT NULL AFTER department_id');
CALL sgcs_add_column_if_missing('clearance_requests','graduation_set_id','INT NULL AFTER student_id');
CALL sgcs_add_column_if_missing('approval_records','officer_institute_id','INT NULL AFTER officer_id');

-- Normalize only values derivable from existing data. Unmapped school and Director assignments stay NULL for Admin review.
INSERT INTO institutes (school_id,institute_name)
SELECT NULL, TRIM(s.institute) FROM students s
WHERE TRIM(COALESCE(s.institute,''))<>''
  AND NOT EXISTS (SELECT 1 FROM institutes i WHERE i.institute_name=TRIM(s.institute))
GROUP BY TRIM(s.institute);
INSERT INTO programmes (institute_id,programme_name)
SELECT i.institute_id, TRIM(s.programme) FROM students s JOIN institutes i ON i.institute_name=TRIM(s.institute)
WHERE TRIM(COALESCE(s.programme,''))<>''
  AND NOT EXISTS (SELECT 1 FROM programmes p WHERE p.institute_id=i.institute_id AND p.programme_name=TRIM(s.programme))
GROUP BY i.institute_id,TRIM(s.programme);
INSERT INTO graduation_sets (set_name,graduation_year,is_active)
SELECT CONCAT('Legacy ',graduation_year,' Graduation'),graduation_year,0 FROM students
WHERE NOT EXISTS (SELECT 1 FROM graduation_sets g WHERE g.graduation_year=students.graduation_year)
GROUP BY graduation_year;
UPDATE students s LEFT JOIN institutes i ON i.institute_name=TRIM(s.institute) LEFT JOIN programmes p ON p.institute_id=i.institute_id AND p.programme_name=TRIM(s.programme) LEFT JOIN graduation_sets g ON g.graduation_year=s.graduation_year
SET s.institute_id=COALESCE(s.institute_id,i.institute_id), s.programme_id=COALESCE(s.programme_id,p.programme_id), s.graduation_set_id=COALESCE(s.graduation_set_id,g.graduation_set_id), s.first_name=COALESCE(s.first_name,SUBSTRING_INDEX(s.full_name,' ',1)), s.last_name=COALESCE(s.last_name,TRIM(SUBSTRING_INDEX(s.full_name,' ',-1))), s.certificate_name_order=COALESCE(s.certificate_name_order,'first_middle_last');
UPDATE clearance_requests cr JOIN students s ON s.student_id=cr.student_id SET cr.graduation_set_id=COALESCE(cr.graduation_set_id,s.graduation_set_id);

CALL sgcs_add_index_if_missing('students','uq_students_phone','UNIQUE KEY `uq_students_phone` (`phone`)');
CALL sgcs_add_index_if_missing('students','uq_students_national_id_passport','UNIQUE KEY `uq_students_national_id_passport` (`national_id_passport_no`)');
CALL sgcs_add_index_if_missing('students','idx_students_academic_path','KEY `idx_students_academic_path` (`school_id`,`institute_id`,`programme_id`)');
CALL sgcs_add_index_if_missing('students','idx_students_graduation_set','KEY `idx_students_graduation_set` (`graduation_set_id`)');
CALL sgcs_add_index_if_missing('clearance_requests','idx_clearance_student_set_status','KEY `idx_clearance_student_set_status` (`student_id`,`graduation_set_id`,`overall_status`)');

-- Foreign keys are deliberately added in the next verified migration after Admin maps legacy schools/directors.
-- They are not added here because unresolved legacy values must remain reviewable rather than be fabricated.
DROP PROCEDURE IF EXISTS sgcs_add_column_if_missing;
DROP PROCEDURE IF EXISTS sgcs_add_index_if_missing;
DROP PROCEDURE IF EXISTS sgcs_fail_on_duplicates;