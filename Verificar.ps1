# Script de Verificación del Proyecto

Write-Host "`n????????????????????????????????????????????????????" -ForegroundColor Cyan
Write-Host "?     VERIFICACIÓN DEL PROYECTO                ?" -ForegroundColor Cyan
Write-Host "????????????????????????????????????????????????????`n" -ForegroundColor Cyan

$allOk = $true

# Verificar compilación
Write-Host "? Verificando compilación..." -ForegroundColor Yellow
$result = dotnet build --nologo --verbosity quiet 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "  ? Compilación exitosa" -ForegroundColor Green
} else {
    Write-Host "  ? Error en compilación" -ForegroundColor Red
    $allOk = $false
}

# Verificar archivos Docker
Write-Host "`n? Verificando archivos Docker..." -ForegroundColor Yellow
$dockerFiles = @("Dockerfile", "docker-compose.yml", ".dockerignore")
foreach ($file in $dockerFiles) {
    if (Test-Path $file) {
        Write-Host "  ? $file" -ForegroundColor Green
    } else {
        Write-Host "  ? $file falta" -ForegroundColor Red
        $allOk = $false
    }
}

# Verificar archivos Git
Write-Host "`n? Verificando archivos Git..." -ForegroundColor Yellow
if (Test-Path ".gitignore") {
    Write-Host "  ? .gitignore" -ForegroundColor Green
} else {
    Write-Host "  ? .gitignore falta" -ForegroundColor Red
    $allOk = $false
}

# Verificar documentación
Write-Host "`n? Verificando documentación..." -ForegroundColor Yellow
$docs = @("README.md", "START_HERE.md", "PROYECTO_COMPLETADO.md", "COMO_SUBIR_A_GITHUB_Y_DOCKER.md")
foreach ($doc in $docs) {
    if (Test-Path $doc) {
        Write-Host "  ? $doc" -ForegroundColor Green
    } else {
        Write-Host "  ? $doc falta" -ForegroundColor Red
        $allOk = $false
    }
}

# Verificar scripts
Write-Host "`n? Verificando scripts..." -ForegroundColor Yellow
$scripts = @("Scripts\Deploy.ps1", "QuickStart.ps1", "Scripts\TestAPI.ps1")
foreach ($script in $scripts) {
    if (Test-Path $script) {
        Write-Host "  ? $script" -ForegroundColor Green
    } else {
        Write-Host "  ? $script falta" -ForegroundColor Red
        $allOk = $false
    }
}

# Verificar Git instalado
Write-Host "`n? Verificando herramientas..." -ForegroundColor Yellow
try {
    $gitVersion = git --version 2>&1
    Write-Host "  ? Git instalado: $gitVersion" -ForegroundColor Green
    $gitInstalled = $true
} catch {
    Write-Host "  ? Git NO instalado" -ForegroundColor Red
    Write-Host "    Descarga desde: https://git-scm.com/downloads" -ForegroundColor Yellow
    $gitInstalled = $false
}

# Verificar Docker instalado
try {
    $dockerVersion = docker --version 2>&1
    Write-Host "  ? Docker instalado: $dockerVersion" -ForegroundColor Green
    $dockerInstalled = $true
} catch {
    Write-Host "  ? Docker NO instalado" -ForegroundColor Red
    Write-Host "    Descarga desde: https://www.docker.com/products/docker-desktop" -ForegroundColor Yellow
    $dockerInstalled = $false
}

# Resumen final
Write-Host "`n????????????????????????????????????????????????????" -ForegroundColor Cyan
if ($allOk) {
    Write-Host "?           ? PROYECTO 100% COMPLETO              ?" -ForegroundColor Green
} else {
    Write-Host "?     ? HAY ALGUNOS PROBLEMAS (ver arriba)       ?" -ForegroundColor Yellow
}
Write-Host "????????????????????????????????????????????????????`n" -ForegroundColor Cyan

# Próximos pasos
Write-Host "PRÓXIMOS PASOS:" -ForegroundColor Cyan
Write-Host ""

if (-not $gitInstalled) {
    Write-Host "1. Instala Git desde: https://git-scm.com/downloads" -ForegroundColor Yellow
} else {
    Write-Host "1. Git está listo ?" -ForegroundColor Green
}

if (-not $dockerInstalled) {
    Write-Host "2. Instala Docker Desktop desde: https://www.docker.com/products/docker-desktop" -ForegroundColor Yellow
} else {
    Write-Host "2. Docker está listo ?" -ForegroundColor Green
}

if ($gitInstalled) {
    Write-Host "`n3. Para subir a GitHub, ejecuta:" -ForegroundColor Cyan
    Write-Host "   git init" -ForegroundColor White
    Write-Host "   git checkout -b main" -ForegroundColor White
    Write-Host "   git remote add origin https://github.com/LuisCW/SistemaGestion.git" -ForegroundColor White
    Write-Host "   git add ." -ForegroundColor White
    Write-Host "   git commit -m 'Initial commit'" -ForegroundColor White
    Write-Host "   git push -u origin main" -ForegroundColor White
}

if ($dockerInstalled) {
    Write-Host "`n4. Para subir a Docker Hub, ejecuta:" -ForegroundColor Cyan
    Write-Host "   docker login" -ForegroundColor White
    Write-Host "   docker build -t luiscw/sistemagestion:latest ." -ForegroundColor White
    Write-Host "   docker push luiscw/sistemagestion:latest" -ForegroundColor White
}

Write-Host "`n?? Lee COMO_SUBIR_A_GITHUB_Y_DOCKER.md para instrucciones completas" -ForegroundColor Yellow
Write-Host ""
