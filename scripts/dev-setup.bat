@echo off
echo ========================================
echo    SETUP DESARROLLO LOCAL - ECOMMERCE
echo ========================================

REM Crear directorio para scripts de BD si no existe
if not exist "init-db" mkdir init-db

REM Verificar si Docker está corriendo
docker info >nul 2>&1
if errorlevel 1 (
    echo ERROR: Docker no está corriendo. Por favor inicia Docker Desktop.
    pause
    exit /b 1
)

echo [1/4] Limpiando contenedores anteriores...
docker-compose down -v

echo [2/4] Construyendo imágenes...
docker-compose build --no-cache

echo [3/4] Iniciando servicios...
docker-compose up -d postgres

echo [4/4] Esperando que PostgreSQL esté listo...
timeout /t 10 /nobreak >nul

echo.
echo ✅ Setup completado!
echo.
echo Servicios disponibles:
echo - PostgreSQL: localhost:5432
echo - Para iniciar backend y frontend: run-dev.bat
echo.
pause