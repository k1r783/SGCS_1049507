-- Run once on an existing SGCS database. Resolve any duplicate existing phones before applying.
ALTER TABLE students
    ADD COLUMN gender ENUM('Male', 'Female', 'Other') NULL AFTER full_name,
    ADD COLUMN national_id_passport_no VARCHAR(30) NULL UNIQUE AFTER gender,
    MODIFY COLUMN phone VARCHAR(20) NOT NULL,
    ADD UNIQUE KEY uq_students_phone (phone);