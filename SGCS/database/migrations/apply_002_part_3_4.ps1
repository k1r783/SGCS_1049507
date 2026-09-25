param([string]$Database = 'sgcs_db')
$ErrorActionPreference = 'Stop'
$mysql = 'C:\xampp\mysql\bin\mysql.exe'
& $mysql -u root --abort-source-on-error $Database -e "SOURCE database/migrations/002_part_3_4_profile_workflow_safeguards.sql"
if ($LASTEXITCODE -ne 0) { throw 'Part 3–4 migration failed. Do not enable the updated pages; restore the pre-migration backup if verification fails.' }
Write-Host 'Part 3–4 migration applied. Verify profile save, PDF rejection, clearance initiation, rejection/resubmission, and final approval.'