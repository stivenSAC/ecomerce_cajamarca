#!/bin/bash
echo "Desplegando en Azure Container Instances..."

# Variables
RESOURCE_GROUP="ecommerce-rg"
LOCATION="eastus"
ACR_NAME="ecommerceacr$RANDOM"
CONTAINER_GROUP="ecommerce-group"

# 1. Login y crear grupo de recursos
az login
az group create --name $RESOURCE_GROUP --location $LOCATION

# 2. Crear Container Registry
az acr create --resource-group $RESOURCE_GROUP --name $ACR_NAME --sku Basic --admin-enabled true

# 3. Build y push imágenes
az acr build --registry $ACR_NAME --image backend:latest ./E-comerce_Mujeres_Cajamarca
az acr build --registry $ACR_NAME --image frontend:latest ./ecommerceCajamrca-frontend

# 4. Obtener credenciales ACR
ACR_PASSWORD=$(az acr credential show --name $ACR_NAME --query "passwords[0].value" -o tsv)

# 5. Crear Container Group con múltiples contenedores
az container create \
  --resource-group $RESOURCE_GROUP \
  --name postgres \
  --image postgres:15-alpine \
  --environment-variables POSTGRES_DB=ecommerce_cajamarca POSTGRES_USER=postgres POSTGRES_PASSWORD=password \
  --ports 5432 \
  --cpu 1 --memory 2

az container create \
  --resource-group $RESOURCE_GROUP \
  --name backend \
  --image $ACR_NAME.azurecr.io/backend:latest \
  --registry-login-server $ACR_NAME.azurecr.io \
  --registry-username $ACR_NAME \
  --registry-password $ACR_PASSWORD \
  --environment-variables SPRING_DATASOURCE_URL=jdbc:postgresql://postgres:5432/ecommerce_cajamarca SPRING_DATASOURCE_USERNAME=postgres SPRING_DATASOURCE_PASSWORD=password \
  --ports 8085 \
  --cpu 1 --memory 2

az container create \
  --resource-group $RESOURCE_GROUP \
  --name frontend \
  --image $ACR_NAME.azurecr.io/frontend:latest \
  --registry-login-server $ACR_NAME.azurecr.io \
  --registry-username $ACR_NAME \
  --registry-password $ACR_PASSWORD \
  --ports 3000 \
  --dns-name-label ecommerce-$RANDOM \
  --cpu 1 --memory 1

echo "Despliegue completado!"