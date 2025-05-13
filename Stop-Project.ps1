Write-Host "Stopping Temporal Learning project..." -ForegroundColor Green

# Stop application stack
Write-Host "Stopping application stack..." -ForegroundColor Yellow
docker-compose down

# Stop Temporal server
Write-Host "Stopping Temporal Server..." -ForegroundColor Yellow
Push-Location -Path "temporal-docker"
docker-compose down
Pop-Location

Write-Host "Project stopped successfully!" -ForegroundColor Green 