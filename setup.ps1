# Check if Docker Desktop is installed
if (-not (Get-Command "docker" -ErrorAction SilentlyContinue)) {
    Write-Host "Docker is not installed. Please install it first." -ForegroundColor Red
    Exit 1
}

# Check if Docker Desktop is running
if (-not (docker info --format '{{.ServerErrors}}' 2>$null)) {
    Write-Host "Starting Docker Desktop..."
    Start-Process "Docker Desktop" -Wait
    Start-Sleep -Seconds 15
    if (-not (docker info --format '{{.ServerErrors}}' 2>$null)) {
        Write-Host "Error: Docker Desktop is not running. Please start it manually." -ForegroundColor Red
        Exit 1
    }
}

# Create necessary directories
$oracleDataDir = "./oracle-data"
if (-not (Test-Path -Path $oracleDataDir)) {
    New-Item -ItemType Directory -Path $oracleDataDir | Out-Null
    Write-Host "Directory oracle-data created for data persistence." -ForegroundColor Green
}

# Start services with Docker Compose
Write-Host "Starting services with Docker Compose..."
docker-compose up -d

# Wait for the database to be ready
Write-Host "Waiting for Oracle XE database to be ready..."
do {
    Start-Sleep -Seconds 5
    $logs = docker logs oracle-xe 2>&1
    if ($logs -match "DATABASE IS READY TO USE") {
        Write-Host "Oracle XE database is ready to use!!!" -ForegroundColor Green
        break
    }
} while ($true)


# Mostrar detalles de conexión
Write-Host "Database created successfully! You can connect to the database using the following details:"
Write-Host "Host: localhost"
Write-Host "Port: 1521"
Write-Host "SID: XEPDB1"
Write-Host "User: sys as sysdba"
Write-Host "Password: admin_password"
