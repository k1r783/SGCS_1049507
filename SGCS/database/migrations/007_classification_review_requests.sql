USE sgcs_db;

CREATE TABLE IF NOT EXISTS classification_review_requests (
    classification_request_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    qualification_level VARCHAR(50) NOT NULL,
    average_mark DECIMAL(5,2) NOT NULL,
    classification VARCHAR(100) NOT NULL,
    entered_by INT NOT NULL,
    status ENUM('Pending', 'Approved', 'Rejected') NOT NULL DEFAULT 'Pending',
    comments TEXT NULL,
    decided_by INT NULL,
    submitted_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    decided_at DATETIME NULL,
    FOREIGN KEY (student_id) REFERENCES students(student_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (entered_by) REFERENCES users(user_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (decided_by) REFERENCES users(user_id)
        ON UPDATE CASCADE ON DELETE SET NULL
);
