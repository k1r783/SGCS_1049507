-- Requirements 1 and 2 foundation migration. Review and run once after a backup.
-- This migration is additive and preserves existing user, student, clearance and approval data.

ALTER TABLE institutes DROP FOREIGN KEY institutes_ibfk_1;
ALTER TABLE institutes MODIFY school_id INT NULL;
ALTER TABLE institutes ADD CONSTRAINT fk_institutes_school FOREIGN KEY (school_id) REFERENCES schools(school_id) ON UPDATE CASCADE ON DELETE SET NULL;

ALTER TABLE students
    ADD COLUMN gender ENUM('Male','Female','Other') NULL AFTER full_name,
    ADD COLUMN national_id_passport_no VARCHAR(30) NULL AFTER gender,
    ADD COLUMN first_name VARCHAR(60) NULL AFTER full_name,
    ADD COLUMN middle_name VARCHAR(60) NULL AFTER first_name,
    ADD COLUMN last_name VARCHAR(60) NULL AFTER middle_name,
    ADD COLUMN school_id INT NULL AFTER institute,
    ADD COLUMN institute_id INT NULL AFTER school_id,
    ADD COLUMN programme_id INT NULL AFTER institute_id,
    ADD COLUMN graduation_set_id INT NULL AFTER programme_id,
    ADD CONSTRAINT fk_students_school FOREIGN KEY (school_id) REFERENCES schools(school_id) ON UPDATE CASCADE ON DELETE SET NULL,
    ADD CONSTRAINT fk_students_institute FOREIGN KEY (institute_id) REFERENCES institutes(institute_id) ON UPDATE CASCADE ON DELETE SET NULL,
    ADD CONSTRAINT fk_students_programme FOREIGN KEY (programme_id) REFERENCES programmes(programme_id) ON UPDATE CASCADE ON DELETE SET NULL,
    ADD CONSTRAINT fk_students_graduation_set FOREIGN KEY (graduation_set_id) REFERENCES graduation_sets(graduation_set_id) ON UPDATE CASCADE ON DELETE RESTRICT,
    ADD UNIQUE KEY uq_students_phone (phone),
    ADD UNIQUE KEY uq_students_national_id_passport (national_id_passport_no),
    ADD KEY idx_students_academic_path (school_id, institute_id, programme_id),
    ADD KEY idx_students_graduation_set (graduation_set_id);

ALTER TABLE users
    ADD COLUMN school_id INT NULL AFTER linked_id,
    ADD COLUMN institute_id INT NULL AFTER school_id,
    ADD COLUMN department_id INT NULL AFTER institute_id,
    ADD COLUMN programme_id INT NULL AFTER department_id,
    ADD CONSTRAINT fk_users_school FOREIGN KEY (school_id) REFERENCES schools(school_id) ON UPDATE CASCADE ON DELETE SET NULL,
    ADD CONSTRAINT fk_users_institute FOREIGN KEY (institute_id) REFERENCES institutes(institute_id) ON UPDATE CASCADE ON DELETE SET NULL,
    ADD CONSTRAINT fk_users_department FOREIGN KEY (department_id) REFERENCES departments(dept_id) ON UPDATE CASCADE ON DELETE SET NULL,
    ADD CONSTRAINT fk_users_programme FOREIGN KEY (programme_id) REFERENCES programmes(programme_id) ON UPDATE CASCADE ON DELETE SET NULL;

ALTER TABLE clearance_requests
    ADD COLUMN graduation_set_id INT NULL AFTER student_id,
    ADD CONSTRAINT fk_clearance_requests_graduation_set FOREIGN KEY (graduation_set_id) REFERENCES graduation_sets(graduation_set_id) ON UPDATE CASCADE ON DELETE RESTRICT,
    ADD KEY idx_clearance_student_set_status (student_id, graduation_set_id, overall_status);

ALTER TABLE approval_records
    ADD COLUMN officer_institute_id INT NULL AFTER officer_id,
    ADD CONSTRAINT fk_approval_records_officer_institute FOREIGN KEY (officer_institute_id) REFERENCES institutes(institute_id) ON UPDATE CASCADE ON DELETE SET NULL;