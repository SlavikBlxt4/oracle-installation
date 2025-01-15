

# Verificar si Docker Desktop está instalado
if (-not (Get-Command "docker" -ErrorAction SilentlyContinue)) {
    Write-Host "Docker no está instalado. Por favor, instálalo primero." -ForegroundColor Red
    Exit 1
}

# Verificar si Docker Desktop está corriendo
if (-not (docker info --format '{{.ServerErrors}}' 2>$null)) {
    Write-Host "Iniciando Docker Desktop..."
    Start-Process "Docker Desktop" -Wait
    Start-Sleep -Seconds 15
    if (-not (docker info --format '{{.ServerErrors}}' 2>$null)) {
        Write-Host "Error: Docker Desktop no está corriendo. Por favor, inícialo manualmente." -ForegroundColor Red
        Exit 1
    }
}

# Crear directorios necesarios
$oracleDataDir = "./oracle-data"
if (-not (Test-Path -Path $oracleDataDir)) {
    New-Item -ItemType Directory -Path $oracleDataDir | Out-Null
    Write-Host "Directorio oracle-data creado para persistencia de datos." -ForegroundColor Green
}

# Iniciar servicios con Docker Compose
Write-Host "Iniciando servicios con Docker Compose..."
docker-compose up -d

# Esperar a que la base de datos esté lista
Write-Host "Esperando a que la base de datos Oracle XE esté lista..."
do {
    Start-Sleep -Seconds 5
    $logs = docker logs oracle-xe 2>&1
    if ($logs -match "DATABASE IS READY TO USE") {
        Write-Host "La base de datos Oracle XE está lista para usarse." -ForegroundColor Green
        break
    }
} while ($true)


# Mostrar detalles de conexión
Write-Host "Base de datos creada con éxito. Conéctate con estos detalles:"
Write-Host "Host: localhost"
Write-Host "Port: 1521"
Write-Host "SID: XEPDB1"
Write-Host "User: sys as sysdba"
Write-Host "Password: admin_password"
