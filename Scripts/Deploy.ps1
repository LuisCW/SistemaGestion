# Script de Deployment Automatizado
# Sistema de Gestión de Clientes y Contactos

param(
    [switch]$SkipGit,
    [switch]$SkipDocker,
    [switch]$TestOnly
)

$ErrorActionPreference = "Stop"

function Write-Header {
    param([string]$Message)
    Write-Host "`n========================================" -ForegroundColor Cyan
    Write-Host "  $Message" -ForegroundColor Green
    Write-Host "========================================`n" -ForegroundColor Cyan
}

function Write-Success {
    param([string]$Message)
    Write-Host "? $Message" -ForegroundColor Green
}

function Write-Info {
    param([string]$Message)
    Write-Host "? $Message" -ForegroundColor Yellow
}

function Write-Error-Custom {
    param([string]$Message)
    Write-Host "? $Message" -ForegroundColor Red
}

# ============================================
# 1. VERIFICACIÓN INICIAL
# ============================================
Write-Header "VERIFICACIÓN INICIAL"

# Verificar que estamos en el directorio correcto
if (-not (Test-Path "CustomersClients.csproj")) {
    Write-Error-Custom "No se encontró CustomersClients.csproj"
    Write-Info "Asegúrate de ejecutar este script desde la raíz del proyecto"
    exit 1
}
Write-Success "Directorio del proyecto correcto"

# Verificar .NET SDK
try {
    $dotnetVersion = dotnet --version
    Write-Success ".NET SDK instalado: $dotnetVersion"
} catch {
    Write-Error-Custom ".NET SDK no encontrado"
    Write-Info "Descarga desde: https://dotnet.microsoft.com/download"
    exit 1
}

# Verificar Docker (si no se omite)
if (-not $SkipDocker) {
    try {
        docker --version | Out-Null
        Write-Success "Docker instalado"
    } catch {
        Write-Error-Custom "Docker no encontrado"
        Write-Info "Descarga desde: https://www.docker.com/products/docker-desktop"
        exit 1
    }
}

# Verificar Git (si no se omite)
if (-not $SkipGit) {
    try {
        git --version | Out-Null
        Write-Success "Git instalado"
    } catch {
        Write-Error-Custom "Git no encontrado"
        Write-Info "Descarga desde: https://git-scm.com/downloads"
        exit 1
    }
}

# ============================================
# 2. COMPILACIÓN Y PRUEBAS
# ============================================
Write-Header "COMPILACIÓN Y PRUEBAS"

Write-Info "Restaurando paquetes NuGet..."
dotnet restore
Write-Success "Paquetes restaurados"

Write-Info "Compilando el proyecto..."
dotnet build -c Release
if ($LASTEXITCODE -ne 0) {
    Write-Error-Custom "Error en la compilación"
    exit 1
}
Write-Success "Compilación exitosa"

# ============================================
# 3. GIT Y GITHUB
# ============================================
if (-not $SkipGit -and -not $TestOnly) {
    Write-Header "CONFIGURACIÓN DE GIT Y GITHUB"
    
    # Verificar si ya está inicializado
    if (-not (Test-Path ".git")) {
        Write-Info "Inicializando repositorio Git..."
        git init
        Write-Success "Repositorio Git inicializado"
    } else {
        Write-Success "Repositorio Git ya existe"
    }
    
    # Verificar remote
    $remotes = git remote
    if ($remotes -notcontains "origin") {
        Write-Info "Agregando remote de GitHub..."
        git remote add origin https://github.com/LuisCW/SistemaGestion.git
        Write-Success "Remote agregado"
    } else {
        Write-Success "Remote ya configurado"
    }
    
    # Verificar branch
    $currentBranch = git branch --show-current
    if ([string]::IsNullOrEmpty($currentBranch)) {
        Write-Info "Creando rama main..."
        git checkout -b main
    }
    
    Write-Info "Agregando archivos al staging..."
    git add .
    
    Write-Info "Creando commit..."
    $commitMessage = "Sistema de Gestión: Web App + API REST + Docker - $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
    git commit -m $commitMessage
    Write-Success "Commit creado: $commitMessage"
    
    Write-Info "¿Deseas subir los cambios a GitHub ahora? (S/N)"
    $response = Read-Host
    if ($response -eq "S" -or $response -eq "s") {
        Write-Info "Subiendo a GitHub..."
        git push -u origin main
        if ($LASTEXITCODE -eq 0) {
            Write-Success "Código subido a GitHub exitosamente"
            Write-Info "URL: https://github.com/LuisCW/SistemaGestion"
        } else {
            Write-Error-Custom "Error al subir a GitHub"
            Write-Info "Verifica tus credenciales y permisos"
        }
    } else {
        Write-Info "Push a GitHub omitido. Puedes hacerlo manualmente con: git push -u origin main"
    }
}

# ============================================
# 4. DOCKER
# ============================================
if (-not $SkipDocker -and -not $TestOnly) {
    Write-Header "CONSTRUCCIÓN DE IMAGEN DOCKER"
    
    Write-Info "Construyendo imagen Docker..."
    Write-Info "Esto puede tomar varios minutos..."
    docker build -t luiscw/sistemagestion:latest .
    
    if ($LASTEXITCODE -eq 0) {
        Write-Success "Imagen Docker construida exitosamente"
        
        Write-Info "`n¿Deseas subir la imagen a Docker Hub? (S/N)"
        $response = Read-Host
        if ($response -eq "S" -or $response -eq "s") {
            Write-Info "Iniciando sesión en Docker Hub..."
            docker login
            
            if ($LASTEXITCODE -eq 0) {
                Write-Info "Subiendo imagen a Docker Hub..."
                docker push luiscw/sistemagestion:latest
                
                if ($LASTEXITCODE -eq 0) {
                    Write-Success "Imagen subida a Docker Hub exitosamente"
                    Write-Info "URL: https://hub.docker.com/r/luiscw/sistemagestion"
                } else {
                    Write-Error-Custom "Error al subir imagen a Docker Hub"
                }
            }
        } else {
            Write-Info "Push a Docker Hub omitido"
        }
    } else {
        Write-Error-Custom "Error al construir la imagen Docker"
        exit 1
    }
}

# ============================================
# 5. PRUEBA LOCAL CON DOCKER
# ============================================
if (-not $SkipDocker -and $TestOnly) {
    Write-Header "PRUEBA LOCAL CON DOCKER"
    
    Write-Info "Deteniendo contenedores existentes..."
    docker-compose down 2>$null
    
    Write-Info "Levantando contenedores..."
    docker-compose up -d
    
    if ($LASTEXITCODE -eq 0) {
        Write-Success "Contenedores iniciados"
        
        Write-Info "Esperando a que SQL Server esté listo (30 segundos)..."
        Start-Sleep -Seconds 30
        
        Write-Info "Aplicando migraciones..."
        docker-compose exec -T webapp dotnet ef database update
        
        Write-Success "`nAplicación lista!"
        Write-Info "Abre tu navegador en: http://localhost:8080"
        Write-Info "`nComandos útiles:"
        Write-Info "  Ver logs: docker-compose logs -f webapp"
        Write-Info "  Detener: docker-compose down"
    } else {
        Write-Error-Custom "Error al levantar contenedores"
    }
}

# ============================================
# 6. RESUMEN FINAL
# ============================================
Write-Header "RESUMEN FINAL"

Write-Host "Estado del deployment:" -ForegroundColor Cyan
Write-Host ""

if (-not $SkipGit) {
    Write-Success "? Código en GitHub: https://github.com/LuisCW/SistemaGestion"
}

if (-not $SkipDocker) {
    Write-Success "? Imagen Docker: luiscw/sistemagestion:latest"
    Write-Success "? Docker Hub: https://hub.docker.com/r/luiscw/sistemagestion"
}

Write-Host ""
Write-Host "Próximos pasos:" -ForegroundColor Yellow
Write-Host "  1. Verifica tu repositorio: https://github.com/LuisCW/SistemaGestion"
Write-Host "  2. Comparte el docker-compose.yml o el link del repo"
Write-Host "  3. Los usuarios pueden levantar la app con: docker-compose up -d"
Write-Host ""

Write-Header "DEPLOYMENT COMPLETADO"
Write-Host "¡Felicidades! Tu aplicación está lista para usar." -ForegroundColor Green
Write-Host ""
