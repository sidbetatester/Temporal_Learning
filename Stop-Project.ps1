Write-Host "Stopping Temporal Learning project..." -ForegroundColor Green

# Get the directory where the script is located
$scriptDir = $PSScriptRoot

# Stop application stack
Write-Host "Stopping application stack..." -ForegroundColor Yellow
Push-Location -Path $scriptDir
docker-compose down
Pop-Location

# Stop Temporal server
Write-Host "Stopping Temporal Server..." -ForegroundColor Yellow
Push-Location -Path (Join-Path $scriptDir "temporal-docker")
docker-compose down
Pop-Location

Write-Host "Project stopped successfully!" -ForegroundColor Green 