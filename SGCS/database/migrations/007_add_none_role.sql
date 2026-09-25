-- Add a None role for users who should have no system access.
ALTER TABLE users
MODIFY role ENUM(
    'student',
    'officer',
    'director',
    'registrar',
    'admin',
    'librarian',
    'finance_officer',
    'dean',
    'university_store',
    'none'
) NOT NULL;
