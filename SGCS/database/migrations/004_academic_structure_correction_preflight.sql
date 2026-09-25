-- 004 academic-structure correction preflight (read-only).
-- Resolve any result rows before applying 004.
SELECT 'duplicate_official_institute_names' AS check_name, institute_name, COUNT(*) AS total
FROM institutes
WHERE institute_name IN ('Institute of Philosophy (IOP)','Institute for Interreligious Dialogue and Islamic Studies (IRDIS)','Institute of Youth Studies (IYS)','Centre for Leadership Management (CLM)','Institute of Communication, Journalism and Media Studies (ICJMS)','Institute for Social Transformation (IST)','Tangaza English as a Foreign Language Program (TEFLAP)','Tangaza Centre for Ethical Leadership & Safeguarding (TCELS)')
GROUP BY institute_name HAVING COUNT(*) > 1;
SELECT 'unexpected_student_academic_reference' AS check_name, student_id, registration_no, institute, programme
FROM students
WHERE institute_id IS NOT NULL AND institute_id NOT IN (SELECT institute_id FROM institutes)
   OR programme_id IS NOT NULL AND programme_id NOT IN (SELECT programme_id FROM programmes);
