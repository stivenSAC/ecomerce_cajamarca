@echo off
echo ========================================
echo    LIMPIEZA Y REINICIO COMPLETO
echo ========================================

echo [1/4] Deteniendo todos los contenedores...
docker-compose down -v --remove-orphans

echo [2/4] Limpiando imágenes antiguas...
docker system prune -f

echo [3/4] Reconstruyendo imágenes...
docker-compose build --no-cache

echo [4/4] Iniciando servicios...
docker-compose up -d

echo.
echo ✅ Reinicio completado!
echo.
echo Servicios:
echo - Frontend: http://127.0.0.1:3000
echo - Backend: http://127.0.0.1:8085
echo - PostgreSQL: 127.0.0.1:5432
echo.
pause