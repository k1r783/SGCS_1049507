SGCS MIGRATION GUIDE

This folder was cleaned for organization only. No database was changed.

Canonical migrations (run only if not already recorded/applied in your existing database):
000_schema_migrations.sql
001_requirements_1_2_foundation.sql
002_part_3_4_profile_workflow_safeguards.sql
003_part_5_6_review_security.sql
004_academic_structure_correction.sql
005_add_academic_year_to_graduation_sets.sql
006_flexible_qualification_graduation.sql

IMPORTANT:
- Do NOT rerun migrations already applied to your live sgcs_db.
- Check schema_migrations before running anything.
- Files in archive_not_for_rerun are retained for history/reference and should not be run as normal migrations.
- database/backups contains database backups and must not be imported unless intentionally restoring a database.
- The cleanup only renamed/moved files inside the project ZIP; it does not alter MySQL/MariaDB.
