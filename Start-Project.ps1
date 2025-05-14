Write-Host "Starting Temporal Learning project..." -ForegroundColor Green

# Get the directory where the script is located
$scriptDir = $PSScriptRoot

# First stop any existing containers
Write-Host "Stopping any existing containers..." -ForegroundColor Yellow
docker-compose down --remove-orphans
Push-Location -Path (Join-Path $scriptDir "temporal-docker")
docker-compose down --remove-orphans
Pop-Location

# Make sure no temporal containers are running (PowerShell friendly version)
Write-Host "Cleaning up any leftover containers..." -ForegroundColor Yellow
$temporalContainers = docker ps -a -q --filter "name=temporal"
if ($temporalContainers) {
    docker rm -f $temporalContainers
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
Start-Sleep -Seconds 30

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
Start-Sleep -Seconds 10

$servers = docker ps --format "{{.Names}}"
$requiredServices = @(
    "temporal",
    "temporal-ui",
    "temporal-worker",
    "temporal-postgresql",
    "temporal-elasticsearch"
)

$missingServices = @()
foreach ($service in $requiredServices) {
    if ($servers -notcontains $service) {
        $missingServices += $service
    }
}

if ($missingServices.Count -eq 0) {
    Write-Host "All services are running successfully!" -ForegroundColor Green
} else {
    Write-Host "Warning: Some services are not running properly:" -ForegroundColor Red
    foreach ($service in $missingServices) {
        Write-Host "  - $service is missing" -ForegroundColor Yellow
    }
    Write-Host "Check status with: docker ps" -ForegroundColor Yellow
    Write-Host "Check logs with: docker-compose logs" -ForegroundColor Yellow
}

Write-Host "Project started successfully!" -ForegroundColor Green
Write-Host "Temporal UI is available at: http://localhost:8080" -ForegroundColor Cyan
Write-Host ""
Write-Host "To run a workflow, use: docker-compose run client" -ForegroundColor Cyan
Write-Host "To access development shell, use: docker-compose exec dev /bin/bash" -ForegroundColor Cyan
Write-Host "To view logs, use: docker-compose logs -f" -ForegroundColor Cyan
Write-Host ""
Write-Host "To stop the project, use: .\Stop-Project.ps1" -ForegroundColor Cyan 