CREATE DATABASE IF NOT EXISTS sgcs_db;
USE sgcs_db;

DROP TABLE IF EXISTS final_approvals;
DROP TABLE IF EXISTS certificates;
DROP TABLE IF EXISTS supporting_documents;
DROP TABLE IF EXISTS transcripts;
DROP TABLE IF EXISTS notifications;
DROP TABLE IF EXISTS audit_logs;
DROP TABLE IF EXISTS approval_records;
DROP TABLE IF EXISTS clearance_requests;
DROP TABLE IF EXISTS departments;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS students;

CREATE TABLE students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    registration_no VARCHAR(20) NOT NULL UNIQUE,
    full_name VARCHAR(100) NOT NULL,
    gender ENUM('Male', 'Female', 'Other') NOT NULL,
    national_id_passport_no VARCHAR(30) NOT NULL UNIQUE,
    programme VARCHAR(100) NOT NULL,
    institute VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20) NOT NULL UNIQUE,
    graduation_year YEAR NOT NULL,
    account_status ENUM('Active', 'Inactive') NOT NULL DEFAULT 'Active'
);

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('student', 'officer', 'director', 'registrar', 'admin', 'librarian', 'finance_officer', 'dean', 'university_store', 'none') NOT NULL,
    linked_id INT NULL,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    account_status ENUM('Active', 'Inactive') NOT NULL DEFAULT 'Active',
    deleted_at DATETIME NULL
);

CREATE TABLE departments (
    dept_id INT AUTO_INCREMENT PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL,
    sequence_no INT NOT NULL UNIQUE,
    officer_user_id INT NULL,
    FOREIGN KEY (officer_user_id) REFERENCES users(user_id)
        ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE TABLE clearance_requests (
    request_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    submitted_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    overall_status ENUM('Pending', 'Approved', 'In Progress', 'Rejected', 'Final') NOT NULL DEFAULT 'Pending',
    current_dept_id INT NULL,
    FOREIGN KEY (student_id) REFERENCES students(student_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (current_dept_id) REFERENCES departments(dept_id)
        ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE TABLE approval_records (
    approval_id INT AUTO_INCREMENT PRIMARY KEY,
    request_id INT NOT NULL,
    dept_id INT NOT NULL,
    officer_id INT NULL,
    status ENUM('Pending', 'Approved', 'Rejected') NOT NULL DEFAULT 'Pending',
    comments TEXT,
    assigned_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    decided_at DATETIME NULL,
    FOREIGN KEY (request_id) REFERENCES clearance_requests(request_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (officer_id) REFERENCES users(user_id)
        ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE TABLE notifications (
    notif_id INT AUTO_INCREMENT PRIMARY KEY,
    recipient_user_id INT NOT NULL,
    notif_type VARCHAR(50) NOT NULL,
    message TEXT NOT NULL,
    sent_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    is_read TINYINT(1) NOT NULL DEFAULT 0,
    FOREIGN KEY (recipient_user_id) REFERENCES users(user_id)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE audit_logs (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NULL,
    action VARCHAR(80) NOT NULL,
    details TEXT,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
        ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE TABLE final_approvals (
    approval_number INT AUTO_INCREMENT PRIMARY KEY,
    request_id INT NOT NULL UNIQUE,
    generated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (request_id) REFERENCES clearance_requests(request_id)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE transcripts (
    transcript_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    request_id INT NOT NULL,
    uploaded_by INT NOT NULL,
    uploaded_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    filename VARCHAR(255) NOT NULL,
    file_path VARCHAR(255) NOT NULL,
    status ENUM('Active', 'Replaced') NOT NULL DEFAULT 'Active',
    FOREIGN KEY (student_id) REFERENCES students(student_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (uploaded_by) REFERENCES users(user_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (request_id) REFERENCES clearance_requests(request_id)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE supporting_documents (
    document_id INT AUTO_INCREMENT PRIMARY KEY,
    request_id INT NOT NULL,
    student_id INT NOT NULL,
    document_type ENUM('final_year_project', 'fee_statement') NOT NULL,
    filename VARCHAR(255) NOT NULL,
    file_path VARCHAR(255) NOT NULL,
    uploaded_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (request_id) REFERENCES clearance_requests(request_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON UPDATE CASCADE ON DELETE CASCADE
);

INSERT INTO students (registration_no, full_name, gender, national_id_passport_no, programme, institute, email, phone, graduation_year) VALUES
('1049507', 'Abigael K. Kirimi', 'Female', '12345678', 'Bachelor of Science in Computer Science', 'Institute of Science and Technology', 'abigael.kirimi@student.tangaza.ac.ke', '+254700000000', 2026),
('1049508', 'Brian Otieno', 'Male', '23456789', 'Bachelor of Education', 'Institute of Education', 'brian.otieno@student.tangaza.ac.ke', '+254711111111', 2026),
('1049509', 'Mary Wanjiku', 'Female', '34567890', 'Bachelor of Arts in Social Ministry', 'Institute of Social Transformation', 'mary.wanjiku@student.tangaza.ac.ke', '+254722222222', 2026);

-- Password for all demo users is: password
INSERT INTO users (username, password_hash, role, linked_id, full_name, email) VALUES
('student1', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llCwWQpWlH..eFqAuMyG', 'student', 1, 'Abigael K. Kirimi', 'abigael.kirimi@student.tangaza.ac.ke'),
('student2', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llCwWQpWlH..eFqAuMyG', 'student', 2, 'Brian Otieno', 'brian.otieno@student.tangaza.ac.ke'),
('student3', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llCwWQpWlH..eFqAuMyG', 'student', 3, 'Mary Wanjiku', 'mary.wanjiku@student.tangaza.ac.ke'),
('director', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llCwWQpWlH..eFqAuMyG', 'director', 1, 'Director Office', 'director@tangaza.ac.ke'),
('library', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llCwWQpWlH..eFqAuMyG', 'officer', 2, 'Library Officer', 'library@tangaza.ac.ke'),
('finance', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llCwWQpWlH..eFqAuMyG', 'officer', 3, 'Finance Officer', 'finance@tangaza.ac.ke'),
('dean', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llCwWQpWlH..eFqAuMyG', 'officer', 4, 'Dean of Students Officer', 'dean@tangaza.ac.ke'),
('store', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llCwWQpWlH..eFqAuMyG', 'officer', 5, 'University Store Officer', 'store@tangaza.ac.ke'),
('registrar', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llCwWQpWlH..eFqAuMyG', 'registrar', 6, 'Academic Registrar', 'registrar@tangaza.ac.ke'),
('admin', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llCwWQpWlH..eFqAuMyG', 'admin', NULL, 'System Administrator', 'admin@tangaza.ac.ke');

INSERT INTO departments (dept_name, sequence_no, officer_user_id) VALUES
('Institute Director', 1, 4),
('Library', 2, 5),
('Finance Office', 3, 6),
('Dean of Students', 4, 7),
('University Store', 5, 8),
('Academic Registrar', 6, 9);

INSERT INTO clearance_requests (student_id, submitted_at, overall_status, current_dept_id) VALUES
(1, '2026-06-20 09:00:00', 'In Progress', 3),
(2, '2026-06-18 10:30:00', 'Rejected', 2),
(3, '2026-06-15 08:45:00', 'Final', NULL);

INSERT INTO approval_records (request_id, dept_id, officer_id, status, comments, assigned_at, decided_at) VALUES
(1, 1, 4, 'Approved', 'Director approval granted.', '2026-06-20 09:00:00', '2026-06-20 11:00:00'),
(1, 2, 5, 'Approved', 'No outstanding library books.', '2026-06-20 09:00:00', '2026-06-21 10:00:00'),
(1, 3, NULL, 'Pending', NULL, '2026-06-20 09:00:00', NULL),
(1, 4, NULL, 'Pending', NULL, '2026-06-20 09:00:00', NULL),
(1, 5, NULL, 'Pending', NULL, '2026-06-20 09:00:00', NULL),
(1, 6, NULL, 'Pending', NULL, '2026-06-20 09:00:00', NULL),
(2, 1, 4, 'Approved', 'Director approval granted.', '2026-06-18 10:30:00', '2026-06-18 12:00:00'),
(2, 2, 5, 'Rejected', 'Student has an outstanding library fine.', '2026-06-18 10:30:00', '2026-06-19 09:15:00'),
(2, 3, NULL, 'Pending', NULL, '2026-06-18 10:30:00', NULL),
(2, 4, NULL, 'Pending', NULL, '2026-06-18 10:30:00', NULL),
(2, 5, NULL, 'Pending', NULL, '2026-06-18 10:30:00', NULL),
(2, 6, NULL, 'Pending', NULL, '2026-06-18 10:30:00', NULL),
(3, 1, 4, 'Approved', 'Director approval granted.', '2026-06-15 08:45:00', '2026-06-15 10:00:00'),
(3, 2, 5, 'Approved', 'Library cleared.', '2026-06-15 08:45:00', '2026-06-15 12:00:00'),
(3, 3, 6, 'Approved', 'Fee balance cleared.', '2026-06-15 08:45:00', '2026-06-16 09:00:00'),
(3, 4, 7, 'Approved', 'Student affairs cleared.', '2026-06-15 08:45:00', '2026-06-16 13:00:00'),
(3, 5, 8, 'Approved', 'No university store items pending.', '2026-06-15 08:45:00', '2026-06-17 09:30:00'),
(3, 6, 9, 'Approved', 'Final registrar clearance granted.', '2026-06-15 08:45:00', '2026-06-17 14:00:00');

INSERT INTO notifications (recipient_user_id, notif_type, message, sent_at, is_read) VALUES
(1, 'clearance_updated', 'Your clearance has moved to Finance Office.', '2026-06-21 10:00:00', 0),
(2, 'clearance_rejected', 'Your clearance request was rejected. Please check the tracking page for comments.', '2026-06-19 09:15:00', 0),
(3, 'final_approval_generated', 'Your Final Approval has been generated.', '2026-06-17 14:00:00', 0),
(6, 'pending_clearance_request', 'A clearance request is waiting for Finance Office review.', '2026-06-21 10:00:00', 0),
(9, 'transcript_request', 'Abigael K. Kirimi (1049507) has requested transcript support for graduation clearance.', '2026-06-21 11:00:00', 0);

INSERT INTO final_approvals (request_id, generated_at) VALUES
(3, '2026-06-17 14:05:00');

INSERT INTO transcripts (student_id, request_id, uploaded_by, uploaded_at, filename, file_path, status) VALUES
(3, 3, 9, '2026-06-17 13:30:00', 'sample-transcript-mary.pdf', 'uploads/transcripts/sample-transcript-mary.pdf', 'Active');

INSERT INTO audit_logs (user_id, action, details, created_at) VALUES
(1, 'clearance_request_created', 'Student started clearance request #1', '2026-06-20 09:00:00'),
(4, 'clearance_approved', 'Request #1 approved and moved to Library', '2026-06-20 11:00:00'),
(5, 'clearance_approved', 'Request #1 approved and moved to Finance Office', '2026-06-21 10:00:00'),
(5, 'clearance_rejected', 'Request #2 rejected at Library', '2026-06-19 09:15:00'),
(9, 'clearance_completed', 'Request #3 received final approval.', '2026-06-17 14:00:00'),
(9, 'transcript_uploaded', 'Transcript uploaded for student #3', '2026-06-17 13:30:00');
