# ?? GUÍA RÁPIDA - DEPLOYMENT FINAL

## ? PASOS RÁPIDOS (5 minutos)

### 1?? REINICIA TU TERMINAL

**IMPORTANTE**: Debes cerrar y abrir una nueva ventana de PowerShell para que reconozca Git.

1. Cierra esta ventana de PowerShell
2. Abre una nueva ventana de PowerShell
3. Navega a la carpeta del proyecto:
   ```powershell
   cd D:\Pruebas\CustomersClients
   ```

---

### 2?? EJECUTA EL SCRIPT DE DEPLOYMENT

```powershell
.\Deploy-Final.ps1
```

Este script hará TODO automáticamente:
- ? Configura Git
- ? Inicializa el repositorio
- ? Crea el commit
- ? Sube a GitHub
- ? Construye imagen Docker
- ? Sube a Docker Hub

---

### 3?? PREPARA TUS CREDENCIALES

#### Para GitHub:
- **Usuario**: `LuisCW`
- **Password**: Necesitas un **Personal Access Token**

**Cómo crear el token:**
1. Ve a: https://github.com/settings/tokens
2. Click en "Generate new token (classic)"
3. Selecciona el scope: **`repo`**
4. Copia el token generado
5. Úsalo como password cuando Git lo pida

#### Para Docker Hub:
- **Usuario**: `luiscw`
- **Password**: Tu contraseña de Docker Hub

---

## ?? CHECKLIST RÁPIDO

Antes de ejecutar el script:

- [ ] Terminal PowerShell cerrada y reabierta
- [ ] Navegado a `D:\Pruebas\CustomersClients`
- [ ] Token de GitHub listo
- [ ] Contraseña de Docker Hub lista
- [ ] Docker Desktop ejecutándose

---

## ?? COMANDOS EXACTOS

```powershell
# 1. Cierra esta ventana y abre una nueva PowerShell

# 2. Navega al proyecto
cd D:\Pruebas\CustomersClients

# 3. Ejecuta el script
.\Deploy-Final.ps1

# 4. Sigue las instrucciones en pantalla
```

---

## ?? SOLUCIÓN DE PROBLEMAS

### Error: "git no se reconoce"
**Solución**: Reinicia tu computadora (no solo la terminal)

### Error: "Authentication failed" en GitHub
**Solución**: 
1. Ve a https://github.com/settings/tokens
2. Crea un nuevo token con scope "repo"
3. Usa ese token como password

### Error: "Docker daemon no está corriendo"
**Solución**: Abre Docker Desktop y espera a que inicie

---

## ? RESULTADO ESPERADO

Después de ejecutar el script verás:

```
? GitHub: Código subido exitosamente
  https://github.com/LuisCW/SistemaGestion

? Docker Hub: Imagen subida exitosamente
  https://hub.docker.com/r/luiscw/sistemagestion

¡DEPLOYMENT COMPLETADO!
```

---

## ?? ¡ESO ES TODO!

Una vez completado, tu aplicación estará disponible públicamente en:
- **GitHub**: https://github.com/LuisCW/SistemaGestion
- **Docker Hub**: https://hub.docker.com/r/luiscw/sistemagestion

Cualquiera podrá descargarla y ejecutarla con:
```bash
git clone https://github.com/LuisCW/SistemaGestion.git
cd SistemaGestion
docker-compose up -d
```

---

**¡Suerte! ??**
