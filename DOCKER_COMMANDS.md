# Comandos Docker - Sistema de Gestión

## Construcción de Imagen

# Construir imagen localmente
docker build -t luiscw/sistemagestion:latest .

# Construir sin caché
docker build --no-cache -t luiscw/sistemagestion:latest .

# Construir con un tag específico
docker build -t luiscw/sistemagestion:v1.0 .

## Docker Hub

# Login
docker login

# Subir imagen
docker push luiscw/sistemagestion:latest

# Descargar imagen
docker pull luiscw/sistemagestion:latest

# Ver imágenes locales
docker images

# Eliminar imagen local
docker rmi luiscw/sistemagestion:latest

## Docker Compose

# Levantar contenedores
docker-compose up -d

# Levantar con build
docker-compose up -d --build

# Ver logs
docker-compose logs -f

# Ver logs de un servicio específico
docker-compose logs -f webapp
docker-compose logs -f sqlserver

# Ver estado de contenedores
docker-compose ps

# Detener contenedores
docker-compose down

# Detener y eliminar volúmenes (ELIMINA LA BASE DE DATOS)
docker-compose down -v

# Reiniciar contenedores
docker-compose restart

# Reiniciar un servicio específico
docker-compose restart webapp

# Entrar a un contenedor
docker-compose exec webapp bash
docker-compose exec sqlserver bash

# Ejecutar comando en contenedor
docker-compose exec webapp dotnet ef database update

# Ver recursos usados
docker-compose stats

## Contenedores Individuales

# Listar contenedores en ejecución
docker ps

# Listar todos los contenedores
docker ps -a

# Detener un contenedor
docker stop sistemagestion-webapp
docker stop sistemagestion-sqlserver

# Eliminar un contenedor
docker rm sistemagestion-webapp

# Ver logs de un contenedor
docker logs sistemagestion-webapp
docker logs -f sistemagestion-webapp

# Entrar a un contenedor
docker exec -it sistemagestion-webapp bash

# Copiar archivos desde/hacia contenedor
docker cp sistemagestion-webapp:/app/appsettings.json ./
docker cp ./archivo.txt sistemagestion-webapp:/app/

## Limpieza

# Eliminar contenedores detenidos
docker container prune

# Eliminar imágenes no usadas
docker image prune

# Eliminar todo lo no usado
docker system prune -a

# Ver uso de disco
docker system df

## Troubleshooting

# Ver información de un contenedor
docker inspect sistemagestion-webapp

# Ver procesos en un contenedor
docker top sistemagestion-webapp

# Ver estadísticas en tiempo real
docker stats

# Ver redes
docker network ls

# Ver volúmenes
docker volume ls

# Eliminar volúmenes no usados
docker volume prune

## SQL Server en Docker

# Conectarse a SQL Server desde el host
sqlcmd -S localhost,1433 -U sa -P YourStrong@Passw0rd

# Ejecutar query directamente
docker-compose exec sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P YourStrong@Passw0rd -Q "SELECT DB_NAME()"

# Backup de base de datos
docker-compose exec sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P YourStrong@Passw0rd -Q "BACKUP DATABASE ClientesContactosDB TO DISK = '/var/opt/mssql/backup/ClientesContactosDB.bak'"

## Variables de Entorno

# Ver variables de entorno de un contenedor
docker-compose exec webapp env

# Ejecutar con variable de entorno específica
docker-compose run -e ASPNETCORE_ENVIRONMENT=Development webapp

## Producción

# Levantar en modo producción
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d

# Ver logs sin seguir
docker-compose logs --tail=100

# Actualizar imagen sin downtime
docker-compose pull
docker-compose up -d

## Monitoreo

# Ver uso de recursos
docker stats sistemagestion-webapp sistemagestion-sqlserver

# Ver eventos
docker events

# Ver cambios en el filesystem
docker diff sistemagestion-webapp
