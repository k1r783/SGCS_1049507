# 004 academic-structure correction rollback note

This is a reference-data and live-data correction and is not safely reversible with a `DROP` statement. Restore `database/backups/sgcs_db_backup_before_academic_structure_fix_20260820_184721.sql` into a recovery database, compare the corrected `schools`, `institutes`, `programmes`, `students`, `users`, and `audit_logs` rows, then use a reviewed transaction to restore the prior values. Do not delete official reference rows or overwrite post-fix Admin changes without that comparison.
