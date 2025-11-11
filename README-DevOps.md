# E-commerce Cajamarca - Guía DevOps

## 🚀 Inicio Rápido

### Prerrequisitos
- Docker Desktop
- Git
- Azure CLI (para despliegue)
- Make (opcional, para comandos simplificados)

### Configuración Inicial
```bash
# 1. Clonar el repositorio
git clone <tu-repo>
cd "Mujeres de cajamrca"

# 2. Configurar entorno (Windows)
scripts\dev-setup.bat

# 3. O usando Make
make setup
```

## 🛠️ Comandos de Desarrollo

### Usando Scripts de Windows
```bash
# Iniciar desarrollo
scripts\run-dev.bat

# Detener servicios
scripts\stop-dev.bat

# Conectar a BD
scripts\db-connect.bat
```

### Usando Make
```bash
# Ver todos los comandos
make help

# Iniciar desarrollo
make dev

# Ver logs
make logs

# Detener
make stop
```

## 🗄️ Base de Datos

### Opción 1: PostgreSQL en Docker (Recomendado)
- Se configura automáticamente con docker-compose
- Datos persistentes en volumen Docker
- Puerto: 5432

### Opción 2: PostgreSQL Local
1. Instalar PostgreSQL en tu máquina
2. Crear base de datos: `ecommerce_cajamarca`
3. Modificar `.env`:
```env
SPRING_DATASOURCE_URL=jdbc:postgresql://localhost:5432/ecommerce_cajamarca
```

### Opción 3: Azure Database for PostgreSQL
1. Crear instancia en Azure Portal
2. Configurar variables de entorno para producción
3. Usar Azure Key Vault para credenciales

## ☁️ Despliegue en Azure

### Azure Container Registry
```bash
# Login
az acr login --name your-registry

# Build y push
az acr build --registry your-registry --image ecommerce-backend ./E-comerce_Mujeres_Cajamarca
az acr build --registry your-registry --image ecommerce-frontend ./ecommerceCajamrca-frontend
```

### Azure Container Instances
```bash
# Crear grupo de recursos
az group create --name rg-ecommerce --location eastus

# Desplegar backend
az container create \
  --resource-group rg-ecommerce \
  --name ecommerce-backend \
  --image your-registry.azurecr.io/ecommerce-backend:latest \
  --ports 8085
```

### Azure DevOps Pipeline
1. Conectar repositorio a Azure DevOps
2. Configurar Service Connections:
   - Azure Container Registry
   - Azure Subscription
3. Ejecutar pipeline: `azure-pipelines.yml`

## 🔧 Configuración de Entornos

### Desarrollo Local
- Archivo: `.env`
- Base de datos: PostgreSQL en Docker
- Hot reload habilitado

### Staging/Producción
- Variables en Azure DevOps
- Azure Database for PostgreSQL
- Azure Container Registry

## 📊 Monitoreo

### Logs Locales
```bash
# Ver logs en tiempo real
docker-compose logs -f

# Logs específicos
docker-compose logs backend
docker-compose logs frontend
```

### Azure Application Insights
- Configurar en `application.properties`
- Métricas automáticas de Spring Boot
- Dashboards personalizados

## 🔐 Seguridad

### Desarrollo
- Credenciales en `.env` (no commitear)
- PostgreSQL con contraseña básica

### Producción
- Azure Key Vault para secretos
- Managed Identity para autenticación
- HTTPS obligatorio

## 🚨 Troubleshooting

### Problemas Comunes
1. **Puerto ocupado**: Cambiar puertos en `.env`
2. **Docker no inicia**: Verificar Docker Desktop
3. **BD no conecta**: Verificar healthcheck en logs

### Comandos Útiles
```bash
# Reiniciar todo
make clean && make setup

# Ver estado de contenedores
docker ps

# Acceder a contenedor
docker exec -it ecommerce-backend bash
```