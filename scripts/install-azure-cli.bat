@echo off
echo ========================================
echo    INSTALANDO AZURE CLI
========================================

echo [1/3] Descargando Azure CLI...
powershell -Command "Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile AzureCLI.msi"

echo [2/3] Instalando Azure CLI...
msiexec /i AzureCLI.msi /quiet

echo [3/3] Limpiando archivos temporales...
del AzureCLI.msi

echo.
echo ✅ Azure CLI instalado!
echo.
echo IMPORTANTE: Cierra y abre una nueva terminal para usar 'az'
echo.
pause