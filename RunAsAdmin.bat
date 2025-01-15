@echo off
:: Verifica si el script se está ejecutando como administrador
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting admin privileges...
    powershell -Command "Start-Process cmd -ArgumentList '/c %~dpnx0' -Verb RunAs"
    exit /b
)

:: Cambia al directorio donde está el script
cd /d "%~dp0"

:: Ejecuta el script de PowerShell
powershell -NoExit -ExecutionPolicy Bypass -File setup.ps1

