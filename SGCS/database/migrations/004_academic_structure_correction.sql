-- 004: Academic structure correction. Run after 001, 002 and 003.
-- Corrective and idempotent; preserves legacy free-text fields as a recovery reference.

START TRANSACTION;

INSERT IGNORE INTO schools (school_name) VALUES
 ('School of Theology'),
 ('School of Arts and Social Sciences'),
 ('School of Education'),
 ('School of Applied Science & Technology'),
 ('TU TVET Institute');

-- Tangaza publishes Schools and Institutes/Centres as parallel groups. Do not infer links.
UPDATE institutes SET school_id = NULL;

-- Preserve the existing placeholder primary key so existing references can be reconciled safely.
UPDATE institutes
SET institute_name = 'Unmapped - needs Admin review', school_id = NULL
WHERE LOWER(TRIM(institute_name)) = 'not assigned';

-- This is the only legacy institute with an exact official counterpart.
UPDATE institutes
SET institute_name = 'Institute for Social Transformation (IST)', school_id = NULL
WHERE LOWER(TRIM(institute_name)) = 'institute of social transformation';

INSERT INTO institutes (school_id,institute_name)
SELECT NULL, x.institute_name FROM (
 SELECT 'Institute of Philosophy (IOP)' institute_name UNION ALL
 SELECT 'Institute for Interreligious Dialogue and Islamic Studies (IRDIS)' UNION ALL
 SELECT 'Institute of Youth Studies (IYS)' UNION ALL
 SELECT 'Centre for Leadership Management (CLM)' UNION ALL
 SELECT 'Institute of Communication, Journalism and Media Studies (ICJMS)' UNION ALL
 SELECT 'Tangaza English as a Foreign Language Program (TEFLAP)' UNION ALL
 SELECT 'Tangaza Centre for Ethical Leadership & Safeguarding (TCELS)'
) x WHERE NOT EXISTS (SELECT 1 FROM institutes i WHERE i.institute_name=x.institute_name);

-- Create a visible temporary target for records that cannot be matched without guessing.
INSERT INTO institutes (school_id,institute_name)
SELECT NULL, 'Unmapped - needs Admin review'
WHERE NOT EXISTS (SELECT 1 FROM institutes WHERE institute_name='Unmapped - needs Admin review');
SET @unmapped_institute := (SELECT institute_id FROM institutes WHERE institute_name='Unmapped - needs Admin review' ORDER BY institute_id LIMIT 1);

INSERT INTO programmes (institute_id,programme_name)
SELECT @unmapped_institute, '[Unmapped - needs Admin review] Sample Programme - replace via Admin'
WHERE NOT EXISTS (SELECT 1 FROM programmes WHERE institute_id=@unmapped_institute AND programme_name='[Unmapped - needs Admin review] Sample Programme - replace via Admin');
SET @unmapped_programme := (SELECT programme_id FROM programmes WHERE institute_id=@unmapped_institute AND programme_name='[Unmapped - needs Admin review] Sample Programme - replace via Admin' ORDER BY programme_id LIMIT 1);

-- Reconcile only unambiguous IST students. The other legacy institute names have no official equivalent.
UPDATE students s JOIN institutes i ON i.institute_name='Institute for Social Transformation (IST)'
JOIN programmes p ON p.institute_id=i.institute_id AND p.programme_name=TRIM(s.programme)
SET s.institute_id=i.institute_id, s.programme_id=p.programme_id, s.school_id=NULL
WHERE LOWER(TRIM(s.institute))='institute of social transformation';

-- Do not guess mappings for legacy Education, Science/Technology, Not assigned, or corrupt programme labels.
UPDATE students
SET school_id=NULL, institute_id=@unmapped_institute, programme_id=@unmapped_programme
WHERE LOWER(TRIM(institute)) IN ('institute of education','institute of science and technology','not assigned')
   OR LOWER(TRIM(programme)) IN ('institute of social communication','institute of theology');

-- Student login accounts inherit the reconciled academic IDs.
UPDATE users u JOIN students s ON u.role='student' AND u.linked_id=s.student_id
SET u.school_id=s.school_id, u.institute_id=s.institute_id, u.programme_id=s.programme_id;

-- Retain genuine legacy programme labels, but remove the two rows that are institute names, after references moved above.
DELETE FROM programmes WHERE LOWER(TRIM(programme_name)) IN ('institute of social communication','institute of theology');

-- Legacy institute rows without an official counterpart can now be removed only when completely unreferenced.
UPDATE programmes p JOIN institutes i ON i.institute_id=p.institute_id
SET p.institute_id=@unmapped_institute
WHERE LOWER(TRIM(i.institute_name)) IN ('institute of education','institute of science and technology');
DELETE i FROM institutes i
LEFT JOIN students s ON s.institute_id=i.institute_id
LEFT JOIN users u ON u.institute_id=i.institute_id
LEFT JOIN programmes p ON p.institute_id=i.institute_id
WHERE LOWER(TRIM(i.institute_name)) IN ('institute of education','institute of science and technology')
  AND s.student_id IS NULL AND u.user_id IS NULL AND p.programme_id IS NULL;

INSERT INTO audit_logs (user_id,action,details)
SELECT NULL, 'academic_structure_unmapped', CONCAT('Academic structure correction: ', registration_no, ' (student #', student_id, ') requires Admin review')
FROM students s
WHERE s.institute_id=@unmapped_institute
  AND NOT EXISTS (SELECT 1 FROM audit_logs a WHERE a.action='academic_structure_unmapped' AND a.details=CONCAT('Academic structure correction: ', s.registration_no, ' (student #', s.student_id, ') requires Admin review'));

-- The actual live registry uses migration_id (confirmed with DESCRIBE), not migration_name.
INSERT IGNORE INTO schema_migrations (migration_id,checksum,notes)
VALUES ('004_academic_structure_correction',NULL,'Official academic references; corrected programmes; explicit unmapped reconciliation');
COMMIT;

