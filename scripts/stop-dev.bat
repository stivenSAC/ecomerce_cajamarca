@echo off
echo ========================================
echo    DETENIENDO SERVICIOS
echo ========================================

echo Deteniendo todos los contenedores...
docker-compose down

echo.
echo ✅ Servicios detenidos correctamente
echo.
pause