# Verificar permisos de administrador
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Este script debe ejecutarse como administrador." -ForegroundColor Red
    Exit 1
}

# Verificar si Docker está instalado
if (-not (Get-Command "docker" -ErrorAction SilentlyContinue)) {
    Write-Host "Docker no está instalado. Verificando si WSL está configurado..." -ForegroundColor Yellow

    # Verificar si WSL está instalado
    if (-not (Get-Command "wsl" -ErrorAction SilentlyContinue)) {
        Write-Host "WSL no está instalado. Procediendo con la instalación..." -ForegroundColor Yellow

        # Habilitar WSL y la plataforma de máquina virtual
        dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
        dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

        # Descargar e instalar el kernel de WSL2
        Write-Host "Descargando e instalando el kernel de WSL2..."
        Invoke-WebRequest -Uri "https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi" -OutFile "$env:TEMP\wsl_update_x64.msi"
        Start-Process -FilePath msiexec.exe -ArgumentList "/i `"$env:TEMP\wsl_update_x64.msi`" /quiet /norestart" -NoNewWindow -Wait

        # Establecer WSL2 como predeterminado
        wsl --set-default-version 2
        Write-Host "WSL2 configurado correctamente." -ForegroundColor Green
    } else {
        Write-Host "WSL ya está instalado. Configurando WSL2 como predeterminado..."
        wsl --set-default-version 2
    }

    # Descargar e instalar Docker Desktop
    Write-Host "Descargando e instalando Docker Desktop..."
    Invoke-WebRequest -Uri "https://desktop.docker.com/win/stable/Docker%20Desktop%20Installer.exe" -OutFile "$env:TEMP\\DockerDesktopInstaller.exe"
    Start-Process -FilePath "$env:TEMP\\DockerDesktopInstaller.exe" -ArgumentList "/quiet" -NoNewWindow -Wait
    Write-Host "Docker Desktop instalado correctamente. Por favor, reinicie su computadora y vuelva a ejecutar este script." -ForegroundColor Green
    Exit 0
}

# Verificar si Docker Desktop está corriendo
if (-not (docker info --format '{{.ServerErrors}}' 2>$null)) {
    Write-Host "Iniciando Docker Desktop..."
    Start-Process "Docker Desktop" -Wait
    Start-Sleep -Seconds 15
    if (-not (docker info --format '{{.ServerErrors}}' 2>$null)) {
        Write-Host "Error: Docker Desktop no se está ejecutando. Por favor, inícielo manualmente." -ForegroundColor Red
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
        Write-Host "¡La base de datos Oracle XE está lista para usar!" -ForegroundColor Green
        break
    }
} while ($true)

# Mostrar detalles de conexión
Write-Host "¡Base de datos creada con éxito! Puedes conectarte con los siguientes detalles:"
Write-Host "Host: localhost"
Write-Host "Port: 1521"
Write-Host "SID: XEPDB1"
Write-Host "User: sys as sysdba"
Write-Host "Password: admin_password"
