-- 005: Academic year and flexible student stage support
-- Safe to run once on MariaDB 10.4+.
USE sgcs_db;

ALTER TABLE graduation_sets
    ADD COLUMN IF NOT EXISTS academic_year VARCHAR(20) NULL AFTER graduation_year;

ALTER TABLE students
    ADD COLUMN IF NOT EXISTS stage VARCHAR(50) NULL,
    ADD COLUMN IF NOT EXISTS academic_year VARCHAR(20) NULL;

INSERT IGNORE INTO schema_migrations (migration_id, checksum, notes)
VALUES ('005_add_academic_year_to_graduation_sets', NULL, 'Adds academic year to graduation sets and flexible stage/academic year fields for students');
