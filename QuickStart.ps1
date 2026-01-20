# Script de Instalación Rápida
# Sistema de Gestión de Clientes y Contactos

Write-Host "`n??????????????????????????????????????????????????????" -ForegroundColor Cyan
Write-Host "?  Sistema de Gestión - Instalación con Docker  ?" -ForegroundColor Cyan
Write-Host "??????????????????????????????????????????????????????`n" -ForegroundColor Cyan

# Verificar Docker
Write-Host "? Verificando Docker..." -ForegroundColor Yellow
try {
    docker --version | Out-Null
    Write-Host "? Docker está instalado" -ForegroundColor Green
} catch {
    Write-Host "? Docker no está instalado" -ForegroundColor Red
    Write-Host "`nPor favor instala Docker Desktop desde:" -ForegroundColor Yellow
    Write-Host "https://www.docker.com/products/docker-desktop`n" -ForegroundColor Cyan
    Read-Host "Presiona Enter para salir"
    exit 1
}

# Detener contenedores existentes
Write-Host "`n? Deteniendo contenedores existentes..." -ForegroundColor Yellow
docker-compose down 2>$null

# Descargar última versión
Write-Host "? Descargando última versión de la imagen..." -ForegroundColor Yellow
docker-compose pull

# Levantar contenedores
Write-Host "? Iniciando contenedores..." -ForegroundColor Yellow
docker-compose up -d

if ($LASTEXITCODE -ne 0) {
    Write-Host "? Error al iniciar contenedores" -ForegroundColor Red
    Read-Host "Presiona Enter para salir"
    exit 1
}

Write-Host "? Contenedores iniciados" -ForegroundColor Green

# Esperar a SQL Server
Write-Host "`n? Esperando a que SQL Server esté listo..." -ForegroundColor Yellow
Write-Host "  (esto toma aproximadamente 30 segundos)" -ForegroundColor Gray
Start-Sleep -Seconds 30

# Aplicar migraciones
Write-Host "? Configurando base de datos..." -ForegroundColor Yellow
docker-compose exec -T webapp dotnet ef database update

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n??????????????????????????????????????????????????????" -ForegroundColor Green
    Write-Host "?            ¡INSTALACIÓN EXITOSA!               ?" -ForegroundColor Green
    Write-Host "??????????????????????????????????????????????????????" -ForegroundColor Green
    
    Write-Host "`nAbre tu navegador en:" -ForegroundColor Cyan
    Write-Host "  http://localhost:8080" -ForegroundColor White -BackgroundColor DarkBlue
    
    Write-Host "`nComandos útiles:" -ForegroundColor Yellow
    Write-Host "  Ver logs de la app:    docker-compose logs -f webapp" -ForegroundColor Gray
    Write-Host "  Ver logs de SQL:       docker-compose logs -f sqlserver" -ForegroundColor Gray
    Write-Host "  Detener aplicación:    docker-compose down" -ForegroundColor Gray
    Write-Host "  Reiniciar aplicación:  docker-compose restart" -ForegroundColor Gray
    
    Write-Host "`n¿Deseas abrir la aplicación en el navegador? (S/N)" -ForegroundColor Cyan
    $response = Read-Host
    if ($response -eq "S" -or $response -eq "s") {
        Start-Process "http://localhost:8080"
    }
} else {
    Write-Host "`n? Error al configurar la base de datos" -ForegroundColor Red
    Write-Host "Intenta ejecutar manualmente:" -ForegroundColor Yellow
    Write-Host "  docker-compose exec webapp dotnet ef database update" -ForegroundColor Gray
}

Write-Host "`nPresiona Enter para salir..." -ForegroundColor Gray
Read-Host
