Write-Host "Starting Temporal Learning project..." -ForegroundColor Green

# Get the directory where the script is located
$scriptDir = $PSScriptRoot

# Ensure temporal-docker network exists
$networkExists = docker network ls | Select-String -Pattern "temporal-network"
if (-not $networkExists) {
    Write-Host "Creating temporal-network..." -ForegroundColor Yellow
    docker network create temporal-network
}

# Set environment variables for Temporal server
$env:TEMPORAL_VERSION = "1.21.5"
$env:TEMPORAL_UI_VERSION = "2.19.0"
$env:TEMPORAL_ADMINTOOLS_VERSION = "1.21.5"
$env:POSTGRESQL_VERSION = "14"
$env:ELASTICSEARCH_VERSION = "7.16.2"

# Start Temporal server
Write-Host "Starting Temporal Server..." -ForegroundColor Yellow
Push-Location -Path (Join-Path $scriptDir "temporal-docker")
docker-compose up -d
Pop-Location

# Wait for Temporal server to be ready
Write-Host "Waiting for Temporal server to be ready..." -ForegroundColor Yellow
Start-Sleep -Seconds 15

# Start the worker
Write-Host "Starting worker..." -ForegroundColor Yellow
Push-Location -Path $scriptDir
docker-compose up -d worker
Pop-Location

# Start the dev environment
Write-Host "Starting development environment..." -ForegroundColor Yellow
docker-compose up -d dev

# Verify services are running
Write-Host "Verifying services are running..." -ForegroundColor Yellow
Start-Sleep -Seconds 5

$temporal = docker ps | Select-String -Pattern "temporal " -Quiet
$worker = docker ps | Select-String -Pattern "temporal-worker" -Quiet
$ui = docker ps | Select-String -Pattern "temporal-ui" -Quiet

if ($temporal -and $worker -and $ui) {
    Write-Host "All services are running successfully!" -ForegroundColor Green
} else {
    Write-Host "Warning: Some services may not be running properly." -ForegroundColor Red
    Write-Host "Check status with: docker ps" -ForegroundColor Yellow
}

Write-Host "Project started successfully!" -ForegroundColor Green
Write-Host "Temporal UI is available at: http://localhost:8080" -ForegroundColor Cyan
Write-Host ""
Write-Host "To run a workflow, use: docker-compose run client" -ForegroundColor Cyan
Write-Host "To access development shell, use: docker-compose exec dev /bin/bash" -ForegroundColor Cyan
Write-Host "To view logs, use: docker-compose logs -f" -ForegroundColor Cyan
Write-Host ""
Write-Host "To stop the project, use: .\Stop-Project.ps1" -ForegroundColor Cyan 