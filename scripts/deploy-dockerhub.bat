@echo off
echo ========================================
echo    DESPLIEGUE CON DOCKER HUB
echo ========================================

set DOCKER_USER=tu-usuario-dockerhub
set IMAGE_TAG=latest

echo [1/4] Login a Docker Hub...
docker login

echo [2/4] Construyendo imágenes...
docker build -t %DOCKER_USER%/ecommerce-backend:%IMAGE_TAG% ./E-comerce_Mujeres_Cajamarca
docker build -t %DOCKER_USER%/ecommerce-frontend:%IMAGE_TAG% ./ecommerceCajamrca-frontend

echo [3/4] Subiendo a Docker Hub...
docker push %DOCKER_USER%/ecommerce-backend:%IMAGE_TAG%
docker push %DOCKER_USER%/ecommerce-frontend:%IMAGE_TAG%

echo [4/4] Creando docker-compose para producción...
echo services: > docker-compose.prod.yml
echo   postgres: >> docker-compose.prod.yml
echo     image: postgres:15-alpine >> docker-compose.prod.yml
echo     environment: >> docker-compose.prod.yml
echo       POSTGRES_DB: ecommerce_cajamarca >> docker-compose.prod.yml
echo       POSTGRES_USER: postgres >> docker-compose.prod.yml
echo       POSTGRES_PASSWORD: prod_password_2024 >> docker-compose.prod.yml
echo     ports: >> docker-compose.prod.yml
echo       - "5432:5432" >> docker-compose.prod.yml
echo. >> docker-compose.prod.yml
echo   backend: >> docker-compose.prod.yml
echo     image: %DOCKER_USER%/ecommerce-backend:%IMAGE_TAG% >> docker-compose.prod.yml
echo     environment: >> docker-compose.prod.yml
echo       SPRING_DATASOURCE_URL: jdbc:postgresql://postgres:5432/ecommerce_cajamarca >> docker-compose.prod.yml
echo       SPRING_DATASOURCE_USERNAME: postgres >> docker-compose.prod.yml
echo       SPRING_DATASOURCE_PASSWORD: prod_password_2024 >> docker-compose.prod.yml
echo     ports: >> docker-compose.prod.yml
echo       - "8085:8085" >> docker-compose.prod.yml
echo     depends_on: >> docker-compose.prod.yml
echo       - postgres >> docker-compose.prod.yml
echo. >> docker-compose.prod.yml
echo   frontend: >> docker-compose.prod.yml
echo     image: %DOCKER_USER%/ecommerce-frontend:%IMAGE_TAG% >> docker-compose.prod.yml
echo     ports: >> docker-compose.prod.yml
echo       - "3000:3000" >> docker-compose.prod.yml
echo     depends_on: >> docker-compose.prod.yml
echo       - backend >> docker-compose.prod.yml

echo.
echo ✅ Imágenes subidas a Docker Hub!
echo.
echo Para desplegar en cualquier servidor:
echo 1. Instalar Docker
echo 2. Ejecutar: docker-compose -f docker-compose.prod.yml up -d
echo.
echo URLs cuando esté desplegado:
echo - Frontend: http://tu-servidor:3000
echo - Backend: http://tu-servidor:8085
echo.
pause