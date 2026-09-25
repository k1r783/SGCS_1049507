USE sgcs_db;

CREATE TABLE IF NOT EXISTS qualification_types (
    qualification_type_id INT AUTO_INCREMENT PRIMARY KEY,
    qualification_name VARCHAR(100) NOT NULL UNIQUE,
    is_active TINYINT(1) NOT NULL DEFAULT 1,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

INSERT IGNORE INTO qualification_types (qualification_name) VALUES
('Certificate'),
('Diploma'),
('Advanced Diploma'),
("Bachelor's Degree"),
('Postgraduate Diploma'),
("Master's Degree"),
('Doctorate'),
('Other');

ALTER TABLE programmes
    ADD COLUMN IF NOT EXISTS qualification_type_id INT NULL AFTER programme_name;

ALTER TABLE students
    ADD COLUMN IF NOT EXISTS academic_year VARCHAR(20) NULL AFTER institute,
    ADD COLUMN IF NOT EXISTS completion_status ENUM('Ongoing','Completed','Graduated') NOT NULL DEFAULT 'Ongoing' AFTER stage;

CREATE TABLE IF NOT EXISTS graduation_set_qualification_types (
    graduation_set_id INT NOT NULL,
    qualification_type_id INT NOT NULL,
    PRIMARY KEY (graduation_set_id, qualification_type_id),
    CONSTRAINT fk_gsqt_set FOREIGN KEY (graduation_set_id)
        REFERENCES graduation_sets(graduation_set_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_gsqt_qualification FOREIGN KEY (qualification_type_id)
        REFERENCES qualification_types(qualification_type_id)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- Existing programmes can be classified from the Academic Structure page.
-- Existing students default to Ongoing until the administrator marks them Completed.
