-- Script de inicialización para desarrollo local
-- Se ejecuta automáticamente cuando se crea el contenedor de PostgreSQL

-- Crear extensiones útiles
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Crear esquemas si es necesario
-- CREATE SCHEMA IF NOT EXISTS ecommerce;

-- Datos de prueba para desarrollo (opcional)
-- INSERT INTO usuarios (nombre, email) VALUES ('Usuario Test', 'test@example.com');

-- Configuraciones específicas para desarrollo
-- Se ejecuta después de crear la BD
\c ecommerce_cajamarca;
SET timezone TO 'America/Lima';