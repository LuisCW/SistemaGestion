# Script para crear la base de datos y aplicar migraciones
# Ejecutar desde la raíz del proyecto

Write-Host "=== Creación de Base de Datos ===" -ForegroundColor Cyan
Write-Host ""

# Verificar si existe una migración
Write-Host "1. Verificando migraciones existentes..." -ForegroundColor Yellow
$migrations = dotnet ef migrations list 2>&1

if ($migrations -match "No migrations") {
    Write-Host "   No hay migraciones. Creando migración inicial..." -ForegroundColor Yellow
    dotnet ef migrations add InitialCreate
} else {
    Write-Host "   Migraciones encontradas." -ForegroundColor Green
}

Write-Host ""
Write-Host "2. Aplicando migraciones a la base de datos..." -ForegroundColor Yellow
dotnet ef database update

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "=== Base de datos creada exitosamente ===" -ForegroundColor Green
    Write-Host ""
    Write-Host "Ahora puedes:" -ForegroundColor Cyan
    Write-Host "  1. Ejecutar la aplicación con: dotnet run"
    Write-Host "  2. Cargar datos de prueba ejecutando: SQL\DatosPrueba.sql"
} else {
    Write-Host ""
    Write-Host "=== Error al crear la base de datos ===" -ForegroundColor Red
    Write-Host "Verifica:" -ForegroundColor Yellow
    Write-Host "  1. SQL Server está ejecutándose"
    Write-Host "  2. La cadena de conexión en appsettings.json es correcta"
    Write-Host "  3. Tienes permisos para crear bases de datos"
}
