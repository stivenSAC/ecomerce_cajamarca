@echo off
echo ========================================
echo    DESPLIEGUE RÁPIDO A AZURE
echo ========================================

REM Variables
set RG=rg-ecommerce-cajamarca
set LOCATION=eastus
set ACR=ecommercecajamarca%RANDOM%

echo [1/3] Login a Azure...
az login

echo [2/3] Creando recursos básicos...
az group create --name %RG% --location %LOCATION%
az acr create --resource-group %RG% --name %ACR% --sku Basic --admin-enabled true

echo [3/3] Desplegando aplicación...
az acr build --registry %ACR% --image backend:latest ./E-comerce_Mujeres_Cajamarca
az acr build --registry %ACR% --image frontend:latest ./ecommerceCajamrca-frontend

REM Obtener credenciales ACR
for /f %%i in ('az acr credential show --name %ACR% --query "passwords[0].value" -o tsv') do set ACR_PASSWORD=%%i

REM Desplegar contenedores
az container create ^
  --resource-group %RG% ^
  --name backend ^
  --image %ACR%.azurecr.io/backend:latest ^
  --registry-login-server %ACR%.azurecr.io ^
  --registry-username %ACR% ^
  --registry-password %ACR_PASSWORD% ^
  --dns-name-label ecommerce-backend ^
  --ports 8085

az container create ^
  --resource-group %RG% ^
  --name frontend ^
  --image %ACR%.azurecr.io/frontend:latest ^
  --registry-login-server %ACR%.azurecr.io ^
  --registry-username %ACR% ^
  --registry-password %ACR_PASSWORD% ^
  --dns-name-label ecommerce-frontend ^
  --ports 3000

echo.
echo ✅ Despliegue completado!
echo.
echo URLs:
echo - Frontend: http://ecommerce-frontend.%LOCATION%.azurecontainer.io:3000
echo - Backend: http://ecommerce-backend.%LOCATION%.azurecontainer.io:8085
echo.
pause