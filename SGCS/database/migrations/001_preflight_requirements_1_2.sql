-- Read-only preflight for migration 001. Do not apply the migration if any result is non-zero.
SELECT 'students_before' AS check_name, COUNT(*) AS result FROM students
UNION ALL SELECT 'users_before', COUNT(*) FROM users
UNION ALL SELECT 'clearance_requests_before', COUNT(*) FROM clearance_requests
UNION ALL SELECT 'approval_records_before', COUNT(*) FROM approval_records;

SELECT 'duplicate_student_registration_numbers' AS check_name, COUNT(*) AS result FROM (SELECT registration_no FROM students GROUP BY registration_no HAVING COUNT(*) > 1) duplicates
UNION ALL SELECT 'duplicate_student_emails', COUNT(*) FROM (SELECT email FROM students GROUP BY email HAVING COUNT(*) > 1) duplicates
UNION ALL SELECT 'duplicate_student_phones', COUNT(*) FROM (SELECT phone FROM students WHERE phone IS NOT NULL AND phone <> '' GROUP BY phone HAVING COUNT(*) > 1) duplicates
UNION ALL SELECT 'duplicate_usernames', COUNT(*) FROM (SELECT username FROM users GROUP BY username HAVING COUNT(*) > 1) duplicates
UNION ALL SELECT 'duplicate_user_emails', COUNT(*) FROM (SELECT email FROM users GROUP BY email HAVING COUNT(*) > 1) duplicates;

SELECT user_id, username, role, linked_id
FROM users WHERE role = 'director';

SELECT student_id, registration_no, institute, programme, graduation_year
FROM students WHERE institute IS NULL OR institute = '' OR programme IS NULL OR programme = '';