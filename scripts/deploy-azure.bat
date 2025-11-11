@echo off
echo ========================================
echo    DESPLIEGUE A AZURE - ECOMMERCE
echo ========================================

REM Configuración
set RESOURCE_GROUP=rg-ecommerce-cajamarca
set LOCATION=eastus
set ACR_NAME=ecommercecajamarca%RANDOM%
set APP_NAME=ecommerce-cajamarca-app

echo [1/6] Verificando Azure CLI...
az --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Azure CLI no está instalado
    echo Instalar desde: https://aka.ms/installazurecliwindows
    pause
    exit /b 1
)

echo [2/6] Creando grupo de recursos...
az group create --name %RESOURCE_GROUP% --location %LOCATION%

echo [3/6] Creando Azure Container Registry...
az acr create --resource-group %RESOURCE_GROUP% --name %ACR_NAME% --sku Basic --admin-enabled true

echo [4/6] Construyendo y subiendo imágenes...
az acr build --registry %ACR_NAME% --image ecommerce-backend:latest ./E-comerce_Mujeres_Cajamarca
az acr build --registry %ACR_NAME% --image ecommerce-frontend:latest ./ecommerceCajamrca-frontend

echo [5/6] Creando Azure Database for PostgreSQL...
az postgres flexible-server create ^
  --resource-group %RESOURCE_GROUP% ^
  --name %APP_NAME%-db ^
  --location %LOCATION% ^
  --admin-user postgres ^
  --admin-password "CajamarcaDB2024!" ^
  --sku-name Standard_B1ms ^
  --tier Burstable ^
  --public-access 0.0.0.0 ^
  --storage-size 32

echo [6/6] Desplegando aplicación...
az container create ^
  --resource-group %RESOURCE_GROUP% ^
  --name %APP_NAME%-backend ^
  --image %ACR_NAME%.azurecr.io/ecommerce-backend:latest ^
  --registry-login-server %ACR_NAME%.azurecr.io ^
  --registry-username %ACR_NAME% ^
  --registry-password $(az acr credential show --name %ACR_NAME% --query "passwords[0].value" -o tsv) ^
  --dns-name-label %APP_NAME%-backend ^
  --ports 8085 ^
  --environment-variables ^
    SPRING_DATASOURCE_URL="jdbc:postgresql://%APP_NAME%-db.postgres.database.azure.com:5432/postgres" ^
    SPRING_DATASOURCE_USERNAME="postgres" ^
    SPRING_DATASOURCE_PASSWORD="CajamarcaDB2024!" ^
    SPRING_JPA_HIBERNATE_DDL_AUTO="update"

az container create ^
  --resource-group %RESOURCE_GROUP% ^
  --name %APP_NAME%-frontend ^
  --image %ACR_NAME%.azurecr.io/ecommerce-frontend:latest ^
  --registry-login-server %ACR_NAME%.azurecr.io ^
  --registry-username %ACR_NAME% ^
  --registry-password $(az acr credential show --name %ACR_NAME% --query "passwords[0].value" -o tsv) ^
  --dns-name-label %APP_NAME%-frontend ^
  --ports 3000

echo.
echo ✅ Despliegue completado!
echo.
echo URLs públicas:
echo - Frontend: http://%APP_NAME%-frontend.%LOCATION%.azurecontainer.io:3000
echo - Backend: http://%APP_NAME%-backend.%LOCATION%.azurecontainer.io:8085
echo.
pause