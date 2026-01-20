# Guía Rápida: Subir a GitHub y Docker Hub

## ?? Subir a GitHub

### Primera vez (inicializar repositorio)

```bash
# Inicializar Git
git init

# Agregar remote
git remote add origin https://github.com/LuisCW/SistemaGestion.git

# Agregar todos los archivos
git add .

# Crear commit inicial
git commit -m "Initial commit: Sistema de Gestión de Clientes y Contactos"

# Subir al repositorio
git push -u origin main
```

### Actualizaciones posteriores

```bash
# Ver cambios
git status

# Agregar archivos modificados
git add .

# Crear commit
git commit -m "Descripción de los cambios"

# Subir cambios
git push
```

---

## ?? Subir a Docker Hub

### 1. Login en Docker Hub

```bash
docker login
# Ingresa tu usuario: luiscw
# Ingresa tu password: [tu password]
```

### 2. Construir la imagen

```bash
docker build -t luiscw/sistemagestion:latest .
```

### 3. Subir la imagen

```bash
docker push luiscw/sistemagestion:latest
```

### 4. Verificar en Docker Hub

Visita: https://hub.docker.com/r/luiscw/sistemagestion

---

## ? Verificación Rápida

### Probar desde Docker Hub

```bash
# Descargar docker-compose.yml
curl -O https://raw.githubusercontent.com/LuisCW/SistemaGestion/main/docker-compose.yml

# Levantar contenedores
docker-compose up -d

# Esperar 30 segundos y aplicar migraciones
sleep 30
docker-compose exec webapp dotnet ef database update

# Abrir navegador
start http://localhost:8080  # Windows
open http://localhost:8080   # macOS
xdg-open http://localhost:8080  # Linux
```

---

## ?? Workflow Completo

1. **Hacer cambios en el código**
2. **Probar localmente**: `dotnet run`
3. **Commit a Git**:
   ```bash
   git add .
   git commit -m "Descripción"
   git push
   ```
4. **Construir imagen Docker**:
   ```bash
   docker build -t luiscw/sistemagestion:latest .
   ```
5. **Subir a Docker Hub**:
   ```bash
   docker push luiscw/sistemagestion:latest
   ```
6. **Listo!** Cualquiera puede descargar con `docker-compose up -d`

---

## ?? Comandos de Referencia

### Git
```bash
git status                      # Ver estado
git log --oneline              # Ver historial
git branch                      # Ver ramas
git checkout -b feature/nueva   # Crear rama nueva
```

### Docker
```bash
docker images                   # Ver imágenes
docker ps                       # Ver contenedores corriendo
docker ps -a                    # Ver todos los contenedores
docker logs <container_id>      # Ver logs
docker exec -it <container> bash  # Entrar al contenedor
```

### Docker Compose
```bash
docker-compose up -d            # Levantar en background
docker-compose down             # Detener y eliminar
docker-compose logs -f webapp   # Ver logs en tiempo real
docker-compose restart          # Reiniciar servicios
```
