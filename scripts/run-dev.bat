@echo off
echo ========================================
echo    INICIANDO ENTORNO DE DESARROLLO
echo ========================================

echo [1/2] Iniciando todos los servicios...
docker-compose up -d

echo [2/2] Mostrando logs en tiempo real...
echo.
echo Presiona Ctrl+C para detener los logs (los servicios seguirán corriendo)
echo.
docker-compose logs -f