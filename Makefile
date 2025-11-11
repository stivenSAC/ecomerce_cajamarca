# Makefile para gestión del proyecto E-commerce Cajamarca
.PHONY: help setup dev stop clean logs db-connect build deploy

# Variables
COMPOSE_FILE = docker-compose.yml
PROJECT_NAME = ecommerce-cajamarca

help: ## Mostrar ayuda
	@echo "Comandos disponibles:"
	@echo "  setup     - Configurar entorno de desarrollo"
	@echo "  dev       - Iniciar entorno de desarrollo"
	@echo "  stop      - Detener todos los servicios"
	@echo "  clean     - Limpiar contenedores y volúmenes"
	@echo "  logs      - Ver logs de todos los servicios"
	@echo "  db-connect - Conectar a la base de datos"
	@echo "  build     - Construir todas las imágenes"
	@echo "  deploy    - Desplegar a Azure (requiere configuración)"

setup: ## Configurar entorno de desarrollo
	@echo "🚀 Configurando entorno de desarrollo..."
	docker-compose down -v
	docker-compose build --no-cache
	docker-compose up -d postgres
	@echo "✅ Setup completado!"

dev: ## Iniciar entorno de desarrollo
	@echo "🔄 Iniciando servicios..."
	docker-compose up -d
	@echo "📋 Servicios iniciados:"
	@echo "  - Frontend: http://localhost:3000"
	@echo "  - Backend: http://localhost:8085"
	@echo "  - PostgreSQL: localhost:5432"

stop: ## Detener servicios
	@echo "⏹️ Deteniendo servicios..."
	docker-compose down

clean: ## Limpiar contenedores y volúmenes
	@echo "🧹 Limpiando contenedores y volúmenes..."
	docker-compose down -v --remove-orphans
	docker system prune -f

logs: ## Ver logs
	docker-compose logs -f

db-connect: ## Conectar a PostgreSQL
	docker exec -it ecommerce-postgres psql -U postgres -d ecommerce_cajamarca

build: ## Construir imágenes
	@echo "🔨 Construyendo imágenes..."
	docker-compose build --no-cache

deploy: ## Desplegar a Azure
	@echo "🚀 Desplegando a Azure..."
	@echo "Ejecutar: az acr build --registry your-registry --image ecommerce-backend ."