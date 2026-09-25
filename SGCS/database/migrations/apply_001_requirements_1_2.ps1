param([string]$Database = 'sgcs_db')
$ErrorActionPreference = 'Stop'
$mysql = 'C:\xampp\mysql\bin\mysql.exe'
& $mysql -u root $Database -e "SOURCE database/migrations/000_schema_migrations.sql"
& $mysql -u root --abort-source-on-error $Database -e "SOURCE database/migrations/001_preflight_requirements_1_2.sql"
if ($LASTEXITCODE -ne 0) { throw 'Preflight failed. Resolve duplicate or assignment findings before migration.' }
& $mysql -u root --abort-source-on-error $Database -e "SOURCE database/migrations/001_requirements_1_2_foundation.sql"
if ($LASTEXITCODE -ne 0) { throw 'Migration failed; do not mark it applied. Restore the pre-migration backup if verification fails.' }
& $mysql -u root $Database -e "INSERT IGNORE INTO schema_migrations(migration_id,checksum,notes) VALUES('001_requirements_1_2_foundation',NULL,'Applied through apply_001_requirements_1_2.ps1');"
Write-Host 'Migration applied. Run post-migration row-count and workflow verification before enabling production use.'