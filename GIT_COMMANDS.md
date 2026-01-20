# Comandos Git - Sistema de Gestión

## Configuración Inicial (solo la primera vez)

# Configurar tu nombre y email
git config --global user.name "Luis CW"
git config --global user.email "tu-email@ejemplo.com"

## Inicializar Repositorio

# 1. Inicializar Git
git init

# 2. Agregar remote
git remote add origin https://github.com/LuisCW/SistemaGestion.git

# 3. Crear rama main
git checkout -b main

# 4. Agregar todos los archivos
git add .

# 5. Crear primer commit
git commit -m "Initial commit: Sistema de Gestión de Clientes y Contactos"

# 6. Subir a GitHub
git push -u origin main

## Actualizaciones Posteriores

# Ver cambios
git status

# Agregar cambios
git add .

# Commit
git commit -m "Descripción de los cambios"

# Push
git push

## Comandos Útiles

# Ver historial
git log --oneline --graph --all

# Ver diferencias
git diff

# Ver ramas
git branch -a

# Cambiar de rama
git checkout nombre-rama

# Crear nueva rama
git checkout -b feature/nueva-funcionalidad

# Descartar cambios locales
git checkout -- nombre-archivo

# Actualizar desde GitHub
git pull

## Solución de Problemas

# Si hay conflictos al hacer push
git pull --rebase origin main
# Resolver conflictos
git add .
git rebase --continue
git push

# Si necesitas forzar el push (CUIDADO)
git push -f origin main

# Ver configuración
git config --list
