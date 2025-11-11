@echo off
echo Desplegando en Azure Container Instances...

REM Variables
set RESOURCE_GROUP=ecommerce-rg
set LOCATION=eastus
set ACR_NAME=ecommerceacr%RANDOM%
set CONTAINER_GROUP=ecommerce-group

REM 1. Login y crear grupo de recursos
az login
az group create --name %RESOURCE_GROUP% --location %LOCATION%

REM 2. Crear Container Registry
az acr create --resource-group %RESOURCE_GROUP% --name %ACR_NAME% --sku Basic --admin-enabled true

REM 3. Build y push imágenes
az acr build --registry %ACR_NAME% --image backend:latest ./E-comerce_Mujeres_Cajamarca
az acr build --registry %ACR_NAME% --image frontend:latest ./ecommerceCajamrca-frontend

REM 4. Obtener credenciales ACR
for /f "tokens=*" %%i in ('az acr credential show --name %ACR_NAME% --query "passwords[0].value" -o tsv') do set ACR_PASSWORD=%%i

REM 5. Crear Container Group
az container create ^
  --resource-group %RESOURCE_GROUP% ^
  --name %CONTAINER_GROUP% ^
  --image postgres:15-alpine ^
  --registry-login-server %ACR_NAME%.azurecr.io ^
  --registry-username %ACR_NAME% ^
  --registry-password %ACR_PASSWORD% ^
  --environment-variables POSTGRES_DB=ecommerce_cajamarca POSTGRES_USER=postgres POSTGRES_PASSWORD=password ^
  --ports 5432 8085 3000 ^
  --dns-name-label ecommerce-%RANDOM% ^
  --cpu 2 --memory 4

echo Despliegue completado!
echo Frontend: http://ecommerce-%RANDOM%.%LOCATION%.azurecontainer.io:3000
pause