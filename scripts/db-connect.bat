@echo off
echo ========================================
echo    CONECTANDO A BASE DE DATOS
echo ========================================

echo Conectando a PostgreSQL...
echo Usuario: postgres
echo Base de datos: ecommerce_cajamarca
echo.

docker exec -it ecommerce-postgres psql -U postgres -d ecommerce_cajamarca