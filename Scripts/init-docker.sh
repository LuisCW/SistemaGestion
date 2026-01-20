#!/bin/bash

# Script para inicializar la base de datos en Docker
echo "Esperando a que SQL Server esté listo..."
sleep 30

echo "Aplicando migraciones..."
docker-compose exec -T webapp dotnet ef database update

echo "Base de datos inicializada correctamente!"
