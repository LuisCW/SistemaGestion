# ========================================
# DEPLOYMENT COMPLETO - GITHUB Y DOCKER HUB
# ========================================
# Ejecuta este script DESPUÉS de reiniciar tu terminal

param(
    [string]$Email = "",
    [string]$UserName = "Luis CW"
)

$ErrorActionPreference = "Continue"

Write-Host "`n????????????????????????????????????????????????????" -ForegroundColor Cyan
Write-Host "?     DEPLOYMENT A GITHUB Y DOCKER HUB         ?" -ForegroundColor Cyan
Write-Host "????????????????????????????????????????????????????`n" -ForegroundColor Cyan

# ============================================
# VERIFICACIÓN
# ============================================
Write-Host "? Verificando requisitos..." -ForegroundColor Yellow

# Verificar Git
try {
    $gitVersion = git --version 2>&1
    Write-Host "? Git instalado: $gitVersion" -ForegroundColor Green
    $gitOk = $true
} catch {
    Write-Host "? Git NO encontrado" -ForegroundColor Red
    Write-Host "  Por favor:" -ForegroundColor Yellow
    Write-Host "  1. Cierra esta ventana de PowerShell" -ForegroundColor White
    Write-Host "  2. Abre una nueva ventana de PowerShell" -ForegroundColor White
    Write-Host "  3. Ejecuta nuevamente este script" -ForegroundColor White
    Read-Host "`nPresiona Enter para salir"
    exit 1
}

# Verificar Docker
try {
    $dockerVersion = docker --version 2>&1
    Write-Host "? Docker instalado: $dockerVersion" -ForegroundColor Green
    $dockerOk = $true
} catch {
    Write-Host "? Docker NO encontrado" -ForegroundColor Red
    $dockerOk = $false
}

# ============================================
# CONFIGURAR GIT
# ============================================
if ($gitOk) {
    Write-Host "`n? Configurando Git..." -ForegroundColor Yellow
    
    if ([string]::IsNullOrEmpty($Email)) {
        Write-Host "Ingresa tu email para Git:" -ForegroundColor Cyan
        $Email = Read-Host
    }
    
    git config --global user.name "$UserName"
    git config --global user.email "$Email"
    git config --global init.defaultBranch main
    
    Write-Host "? Git configurado" -ForegroundColor Green
}

# ============================================
# GITHUB
# ============================================
Write-Host "`n????????????????????????????????????????????????????" -ForegroundColor Cyan
Write-Host "?              SUBIDA A GITHUB                 ?" -ForegroundColor Cyan
Write-Host "????????????????????????????????????????????????????`n" -ForegroundColor Cyan

Write-Host "? Inicializando repositorio Git..." -ForegroundColor Yellow

# Inicializar si no existe
if (-not (Test-Path ".git")) {
    git init
    git checkout -b main
    Write-Host "? Repositorio Git inicializado" -ForegroundColor Green
} else {
    Write-Host "? Repositorio Git ya existe" -ForegroundColor Green
}

# Agregar remote
$remoteExists = git remote | Select-String "origin"
if (-not $remoteExists) {
    Write-Host "? Agregando remote de GitHub..." -ForegroundColor Yellow
    git remote add origin https://github.com/LuisCW/SistemaGestion.git
    Write-Host "? Remote agregado" -ForegroundColor Green
} else {
    Write-Host "? Remote ya existe" -ForegroundColor Green
}

# Agregar archivos
Write-Host "? Agregando archivos al staging..." -ForegroundColor Yellow
git add .

# Commit
Write-Host "? Creando commit..." -ForegroundColor Yellow
$commitMessage = "Sistema de Gestión: Web App + API REST + Docker - $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
git commit -m $commitMessage

# Push
Write-Host "`n? Subiendo a GitHub..." -ForegroundColor Yellow
Write-Host "  NOTA: GitHub te pedirá autenticación" -ForegroundColor Cyan
Write-Host "  Usuario: LuisCW" -ForegroundColor White
Write-Host "  Password: Usa un Personal Access Token (no tu contraseña)" -ForegroundColor White
Write-Host "`n  ¿Cómo crear un token?" -ForegroundColor Yellow
Write-Host "  1. Ve a GitHub.com > Settings > Developer settings" -ForegroundColor Gray
Write-Host "  2. Personal access tokens > Tokens (classic)" -ForegroundColor Gray
Write-Host "  3. Generate new token > Selecciona 'repo'" -ForegroundColor Gray
Write-Host "  4. Copia el token y úsalo como password`n" -ForegroundColor Gray

Read-Host "Presiona Enter cuando estés listo"

git push -u origin main

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n? ¡Código subido a GitHub exitosamente!" -ForegroundColor Green
    Write-Host "  URL: https://github.com/LuisCW/SistemaGestion`n" -ForegroundColor Cyan
    $githubOk = $true
} else {
    Write-Host "`n? Error al subir a GitHub" -ForegroundColor Red
    Write-Host "  Verifica tu token de autenticación" -ForegroundColor Yellow
    $githubOk = $false
}

# ============================================
# DOCKER HUB
# ============================================
if ($dockerOk) {
    Write-Host "`n????????????????????????????????????????????????????" -ForegroundColor Cyan
    Write-Host "?            SUBIDA A DOCKER HUB               ?" -ForegroundColor Cyan
    Write-Host "????????????????????????????????????????????????????`n" -ForegroundColor Cyan
    
    Write-Host "¿Deseas construir y subir la imagen a Docker Hub? (S/N)" -ForegroundColor Cyan
    $response = Read-Host
    
    if ($response -eq "S" -or $response -eq "s") {
        # Docker Login
        Write-Host "`n? Iniciando sesión en Docker Hub..." -ForegroundColor Yellow
        Write-Host "  Usuario: luiscw" -ForegroundColor White
        docker login
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "? Sesión iniciada en Docker Hub" -ForegroundColor Green
            
            # Build
            Write-Host "`n? Construyendo imagen Docker..." -ForegroundColor Yellow
            Write-Host "  NOTA: Esto puede tomar varios minutos (5-10 min)" -ForegroundColor Cyan
            docker build -t luiscw/sistemagestion:latest .
            
            if ($LASTEXITCODE -eq 0) {
                Write-Host "? Imagen construida exitosamente" -ForegroundColor Green
                
                # Push
                Write-Host "`n? Subiendo imagen a Docker Hub..." -ForegroundColor Yellow
                Write-Host "  NOTA: Esto puede tomar varios minutos" -ForegroundColor Cyan
                docker push luiscw/sistemagestion:latest
                
                if ($LASTEXITCODE -eq 0) {
                    Write-Host "`n? ¡Imagen subida a Docker Hub exitosamente!" -ForegroundColor Green
                    Write-Host "  URL: https://hub.docker.com/r/luiscw/sistemagestion`n" -ForegroundColor Cyan
                    $dockerHubOk = $true
                } else {
                    Write-Host "`n? Error al subir imagen a Docker Hub" -ForegroundColor Red
                    $dockerHubOk = $false
                }
            } else {
                Write-Host "`n? Error al construir la imagen" -ForegroundColor Red
                $dockerHubOk = $false
            }
        } else {
            Write-Host "? Error al iniciar sesión en Docker Hub" -ForegroundColor Red
            $dockerHubOk = $false
        }
    } else {
        Write-Host "? Subida a Docker Hub omitida" -ForegroundColor Yellow
        $dockerHubOk = $null
    }
}

# ============================================
# RESUMEN FINAL
# ============================================
Write-Host "`n????????????????????????????????????????????????????" -ForegroundColor Cyan
Write-Host "?              RESUMEN FINAL                   ?" -ForegroundColor Cyan
Write-Host "????????????????????????????????????????????????????`n" -ForegroundColor Cyan

if ($githubOk) {
    Write-Host "? GitHub: Código subido exitosamente" -ForegroundColor Green
    Write-Host "  https://github.com/LuisCW/SistemaGestion" -ForegroundColor Cyan
} else {
    Write-Host "? GitHub: Error o no completado" -ForegroundColor Red
}

if ($dockerHubOk -eq $true) {
    Write-Host "? Docker Hub: Imagen subida exitosamente" -ForegroundColor Green
    Write-Host "  https://hub.docker.com/r/luiscw/sistemagestion" -ForegroundColor Cyan
} elseif ($dockerHubOk -eq $false) {
    Write-Host "? Docker Hub: Error" -ForegroundColor Red
} else {
    Write-Host "- Docker Hub: No procesado" -ForegroundColor Gray
}

Write-Host "`n????????????????????????????????????????????????????" -ForegroundColor Cyan
Write-Host "?          ¡DEPLOYMENT COMPLETADO!             ?" -ForegroundColor Green
Write-Host "????????????????????????????????????????????????????`n" -ForegroundColor Cyan

Write-Host "Próximos pasos:" -ForegroundColor Yellow
Write-Host "  1. Verifica tu repositorio en GitHub" -ForegroundColor White
Write-Host "  2. Comparte el link: https://github.com/LuisCW/SistemaGestion" -ForegroundColor White
Write-Host "  3. Los usuarios pueden clonar o usar docker-compose`n" -ForegroundColor White

Read-Host "Presiona Enter para salir"
