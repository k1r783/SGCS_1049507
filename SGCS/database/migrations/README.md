# SGCS migration runbook

1. Back up `sgcs_db` before any migration.
2. Run `000_schema_migrations.sql` once.
3. Run migrations in numeric order. Do not rerun a migration already recorded in `schema_migrations`.
4. Run `005_add_academic_year_to_graduation_sets.sql.txt` before the flexible graduation migration.
5. Run `006_add_student_stage_and_graduation_application.sql.txt` (or the identical `database/006_flexible_qualification_graduation.sql`) once, not both.
6. Verify the required columns with `SHOW COLUMNS` before testing the application.

## Recommended order
- 001 foundation
- 002 profile/workflow safeguards
- 003 review/security
- 004 academic structure correction
- 005 academic year and flexible stage support
- 006 flexible qualification/graduation

If your existing database already contains some columns, the 005/006 migrations use `IF NOT EXISTS` and are designed to add only missing fields.
