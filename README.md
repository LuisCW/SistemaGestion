# Sistema de Gestión de Clientes y Contactos

Aplicación web desarrollada en **ASP.NET Core 10.0** con **Razor Pages**, **Entity Framework Core** y **SQL Server** para la administración integral de clientes y sus contactos.

---

## ?? Índice

1. [Descripción General](#-descripción-general)
2. [Diagrama Entidad-Relación](#-diagrama-entidad-relación)
3. [Características](#-características)
4. [Requisitos del Sistema](#-requisitos-del-sistema)
5. [?? Instalación con Docker (RECOMENDADO)](#-instalación-con-docker-recomendado)
6. [Instalación Manual](#-instalación-manual)
7. [Estructura de la Base de Datos](#-estructura-de-la-base-de-datos)
8. [Sentencias SQL](#-sentencias-sql)
9. [API REST](#-api-rest)
10. [Tecnologías Utilizadas](#-tecnologías-utilizadas)

---

## ?? Descripción General

Sistema web completo para gestionar **Clientes** y sus **Contactos** asociados, con las siguientes funcionalidades principales:

- ? **CRUD Completo**: Crear, leer, actualizar y eliminar clientes y contactos
- ?? **Búsqueda Avanzada**: Filtrado por múltiples criterios
- ?? **Ordenamiento Dinámico**: Por cualquier columna
- ?? **Interfaz Responsive**: Compatible con dispositivos móviles
- ?? **API REST**: Para integración con otros sistemas

---

## ??? Diagrama Entidad-Relación

```
???????????????????????????????????????
?           CLIENTES                  ?
???????????????????????????????????????
? • Id (PK, int, Identity)            ?
? • NombreCompleto (nvarchar(200))    ?
? • Direccion (nvarchar(500))         ?
? • Telefono (nvarchar(20))           ?
? • FechaCreacion (datetime2)         ?
???????????????????????????????????????
                ?
                ? 1
                ?
                ?
                ? N
                ?
???????????????????????????????????????
?           CONTACTOS                 ?
???????????????????????????????????????
? • Id (PK, int, Identity)            ?
? • NombreCompleto (nvarchar(200))    ?
? • Direccion (nvarchar(500))         ?
? • Telefono (nvarchar(20))           ?
? • ClienteId (FK, int)               ?
???????????????????????????????????????

Relación: 1 Cliente puede tener N Contactos (uno a muchos)
Eliminación: ON DELETE CASCADE
```

### Descripción de las Entidades

#### **CLIENTES**
| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| Id | int | PK, Identity | Identificador único |
| NombreCompleto | nvarchar(200) | NOT NULL | Nombre completo del cliente |
| Direccion | nvarchar(500) | NOT NULL | Dirección física |
| Telefono | nvarchar(20) | NOT NULL | Número telefónico |
| FechaCreacion | datetime2 | NOT NULL, Default: GETDATE() | Fecha de registro |

#### **CONTACTOS**
| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| Id | int | PK, Identity | Identificador único |
| NombreCompleto | nvarchar(200) | NOT NULL | Nombre completo del contacto |
| Direccion | nvarchar(500) | NOT NULL | Dirección física |
| Telefono | nvarchar(20) | NOT NULL | Número telefónico |
| ClienteId | int | FK, NOT NULL | Referencia al cliente |

---

## ? Características

### ?? Gestión de Clientes
- ? Crear nuevos clientes
- ? Editar información existente
- ? Ver detalles completos con todos sus contactos
- ? Eliminar clientes (elimina automáticamente sus contactos)
- ?? **Búsqueda**: Por nombre, dirección o teléfono
- ?? **Filtros**:
  - Clientes con contactos
  - Clientes sin contactos
  - Clientes con múltiples contactos (más de 1)
  - Rango de fechas de creación
- ?? **Ordenamiento**:
  - Por nombre (ascendente/descendente)
  - Por fecha de creación (ascendente/descendente)
  - Por cantidad de contactos (ascendente/descendente)

### ?? Gestión de Contactos
- ? Crear contactos asociados a clientes
- ? Editar información de contactos
- ? Eliminar contactos
- ?? **Búsqueda**: Por nombre, dirección, teléfono o cliente
- ?? **Vistas**:
  - Vista global de todos los contactos
  - Vista filtrada por cliente específico
- ?? **Ordenamiento**:
  - Por nombre del contacto
  - Por nombre del cliente

### ?? Interfaz de Usuario
- ?? Diseño moderno con Bootstrap 5
- ?? Dashboard con estadísticas en tiempo real
- ?? Paneles de filtros intuitivos
- ?? Totalmente responsive
- ?? Iconos Bootstrap Icons

---

## ?? Requisitos del Sistema

### Para Docker (RECOMENDADO) ??
- **Docker Desktop** instalado ([Descargar aquí](https://www.docker.com/products/docker-desktop))
- **Git** (opcional, para clonar el repositorio)

### Para Instalación Manual
- **.NET SDK 10.0** o superior
- **SQL Server 2019** o superior (Express, Developer o Enterprise)
- **Visual Studio 2022** o **VS Code** (opcional)
- **Windows 10/11** o **Linux/macOS** con .NET instalado

---

## ?? Instalación con Docker (RECOMENDADO)

### Opción 1: Usando Docker Hub (MÁS RÁPIDO)

1. **Descargar el archivo docker-compose.yml**

```bash
curl -O https://raw.githubusercontent.com/LuisCW/SistemaGestion/main/docker-compose.yml
```

2. **Levantar los contenedores**

```bash
docker-compose up -d
```

3. **Esperar a que SQL Server inicie (aproximadamente 30 segundos)**

4. **Aplicar migraciones de base de datos**

```bash
docker-compose exec webapp dotnet ef database update
```

5. **¡Listo! Abrir el navegador**

```
http://localhost:8080
```

### Opción 2: Clonando el Repositorio

1. **Clonar el repositorio**

```bash
git clone https://github.com/LuisCW/SistemaGestion.git
cd SistemaGestion
```

2. **Construir y levantar los contenedores**

```bash
docker-compose up -d --build
```

3. **Aplicar migraciones**

```bash
docker-compose exec webapp dotnet ef database update
```

4. **Abrir el navegador**

```
http://localhost:8080
```

### Comandos Útiles Docker

```bash
# Ver logs de la aplicación
docker-compose logs -f webapp

# Ver logs de SQL Server
docker-compose logs -f sqlserver

# Detener los contenedores
docker-compose down

# Detener y eliminar volúmenes (?? ELIMINA LA BASE DE DATOS)
docker-compose down -v

# Reiniciar los contenedores
docker-compose restart

# Ver contenedores en ejecución
docker-compose ps
```

### Datos de Conexión Docker

- **Aplicación Web**: http://localhost:8080
- **SQL Server**: 
  - Host: `localhost`
  - Puerto: `1433`
  - Usuario: `sa`
  - Password: `YourStrong@Passw0rd`
  - Database: `ClientesContactosDB`

---

## ?? Instalación Manual

### 1. Clonar o Descargar el Proyecto

```bash
git clone <url-del-repositorio>
cd CustomersClients
```

### 2. Configurar la Cadena de Conexión

Edita el archivo `appsettings.json`:

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=localhost;Database=ClientesContactosDB;Integrated Security=True;TrustServerCertificate=True"
  }
}
```

**Opciones de conexión:**

**Autenticación de Windows:**
```
Server=localhost;Database=ClientesContactosDB;Integrated Security=True;TrustServerCertificate=True
```

**Autenticación SQL Server:**
```
Server=localhost;Database=ClientesContactosDB;User Id=sa;Password=TuPassword;TrustServerCertificate=True
```

### 3. Restaurar Paquetes NuGet

```bash
dotnet restore
```

### 4. Crear la Base de Datos

#### Opción A: Con PowerShell
```powershell
.\Scripts\CrearBaseDatos.ps1
```

#### Opción B: Manualmente con dotnet CLI
```bash
dotnet ef migrations add InitialCreate
dotnet ef database update
```

### 5. Insertar Datos de Prueba (Opcional)

Ejecuta el script SQL ubicado en `SQL/DatosPrueba.sql` usando SQL Server Management Studio o:

```bash
sqlcmd -S localhost -E -d ClientesContactosDB -i SQL/DatosPrueba.sql
```

### 6. Ejecutar la Aplicación

```bash
dotnet run
```

O presiona **F5** en Visual Studio.

La aplicación estará disponible en:
- HTTPS: `https://localhost:7000`
- HTTP: `http://localhost:5000`

---

## ??? Estructura de la Base de Datos

### Script de Creación

```sql
-- Tabla Clientes
CREATE TABLE Clientes (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    NombreCompleto NVARCHAR(200) NOT NULL,
    Direccion NVARCHAR(500) NOT NULL,
    Telefono NVARCHAR(20) NOT NULL,
    FechaCreacion DATETIME2 NOT NULL DEFAULT GETDATE()
);

-- Tabla Contactos
CREATE TABLE Contactos (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    NombreCompleto NVARCHAR(200) NOT NULL,
    Direccion NVARCHAR(500) NOT NULL,
    Telefono NVARCHAR(20) NOT NULL,
    ClienteId INT NOT NULL,
    CONSTRAINT FK_Contactos_Clientes FOREIGN KEY (ClienteId) 
        REFERENCES Clientes(Id) ON DELETE CASCADE
);

-- Índices para mejorar rendimiento
CREATE INDEX IX_Contactos_ClienteId ON Contactos(ClienteId);
CREATE INDEX IX_Clientes_FechaCreacion ON Clientes(FechaCreacion);
```

---

## ?? Sentencias SQL

### a. Clientes que tienen contactos cuyo nombre empieza por "carl"

```sql
SELECT DISTINCT c.*
FROM Clientes c
INNER JOIN Contactos con ON c.Id = con.ClienteId
WHERE con.NombreCompleto LIKE 'carl%';
```

**Explicación:** 
- Usa `INNER JOIN` para relacionar clientes con sus contactos
- Filtra contactos cuyo nombre comienza con "carl" (case-insensitive)
- `DISTINCT` evita duplicados si un cliente tiene múltiples contactos con "carl"

---

### b. Clientes ordenados ascendentemente por fecha de creación

```sql
SELECT *
FROM Clientes
ORDER BY FechaCreacion ASC;
```

**Explicación:**
- Retorna todos los clientes
- Ordenados del más antiguo al más reciente
- Útil para ver el histórico de registro

---

### c. Clientes con más de un contacto

```sql
SELECT 
    c.Id,
    c.NombreCompleto,
    c.Direccion,
    c.Telefono,
    c.FechaCreacion,
    COUNT(con.Id) AS CantidadContactos
FROM Clientes c
INNER JOIN Contactos con ON c.Id = con.ClienteId
GROUP BY c.Id, c.NombreCompleto, c.Direccion, c.Telefono, c.FechaCreacion
HAVING COUNT(con.Id) > 1
ORDER BY CantidadContactos DESC;
```

**Explicación:**
- Agrupa por cliente y cuenta sus contactos
- `HAVING` filtra solo clientes con más de 1 contacto
- Incluye la cantidad de contactos en el resultado
- Ordenado de mayor a menor cantidad

---

### d. Eliminar los contactos de un cliente determinado

```sql
-- Opción 1: Con variable
DECLARE @ClienteId INT = 1;

DELETE FROM Contactos
WHERE ClienteId = @ClienteId;

-- Opción 2: Directa
DELETE FROM Contactos
WHERE ClienteId = 5;
```

**Explicación:**
- Elimina todos los contactos asociados a un cliente específico
- El cliente permanece en la base de datos
- Cambiar el valor del `@ClienteId` según necesidad

---

### e. Eliminar clientes que no tienen contactos

```sql
-- Opción 1: Con subconsulta
DELETE FROM Clientes
WHERE Id NOT IN (
    SELECT DISTINCT ClienteId
    FROM Contactos
);

-- Opción 2: Con LEFT JOIN
DELETE c
FROM Clientes c
LEFT JOIN Contactos con ON c.Id = con.ClienteId
WHERE con.Id IS NULL;
```

**Explicación:**
- **Opción 1**: Busca IDs de clientes que no están en la tabla Contactos
- **Opción 2**: Usa LEFT JOIN y elimina donde no hay coincidencias
- Ambas opciones son funcionalmente equivalentes

---

### f. Insertar un cliente con un contacto determinado

```sql
-- Usando transacción para garantizar integridad
BEGIN TRANSACTION;

    -- Insertar el cliente
    INSERT INTO Clientes (NombreCompleto, Direccion, Telefono, FechaCreacion)
    VALUES ('Juan Pérez García', 'Calle Principal 123', '555-1234', GETDATE());

    -- Obtener el ID del cliente recién insertado
    DECLARE @NuevoClienteId INT = SCOPE_IDENTITY();

    -- Insertar el contacto relacionado
    INSERT INTO Contactos (NombreCompleto, Direccion, Telefono, ClienteId)
    VALUES ('Carlos López Martínez', 'Avenida Central 456', '555-5678', @NuevoClienteId);

COMMIT TRANSACTION;

-- Verificar la inserción
SELECT 
    c.Id AS ClienteId,
    c.NombreCompleto AS Cliente,
    con.Id AS ContactoId,
    con.NombreCompleto AS Contacto
FROM Clientes c
INNER JOIN Contactos con ON c.Id = con.ClienteId
WHERE c.Id = SCOPE_IDENTITY();
```

**Explicación:**
- `BEGIN TRANSACTION` garantiza que ambas inserciones se realicen o ninguna
- `SCOPE_IDENTITY()` retorna el último ID insertado en la sesión actual
- Si algo falla, se puede hacer `ROLLBACK` para deshacer cambios

---

### Consultas Adicionales Útiles

#### Obtener clientes con todos sus contactos
```sql
SELECT 
    c.Id AS ClienteId,
    c.NombreCompleto AS Cliente,
    c.FechaCreacion,
    con.Id AS ContactoId,
    con.NombreCompleto AS Contacto,
    con.Telefono AS TelefonoContacto
FROM Clientes c
LEFT JOIN Contactos con ON c.Id = con.ClienteId
ORDER BY c.FechaCreacion DESC, con.NombreCompleto;
```

#### Estadísticas generales
```sql
SELECT 
    'Total Clientes' AS Metrica,
    COUNT(*) AS Valor
FROM Clientes
UNION ALL
SELECT 
    'Total Contactos',
    COUNT(*)
FROM Contactos
UNION ALL
SELECT 
    'Clientes con Contactos',
    COUNT(DISTINCT ClienteId)
FROM Contactos
UNION ALL
SELECT 
    'Clientes sin Contactos',
    COUNT(*)
FROM Clientes c
WHERE NOT EXISTS (SELECT 1 FROM Contactos WHERE ClienteId = c.Id);
```

---

## ?? API REST

### Endpoint de Creación de Contactos

**URL:** `POST /api/contactos/CrearContacto`

**Headers:**
```
Content-Type: application/json
```

**Request Body:**
```json
{
  "clienteId": 1,
  "nombreCompleto": "Carlos Rodríguez",
  "direccion": "Calle Ejemplo 123",
  "telefono": "555-9999"
}
```

**Response Exitosa (200 OK):**
```json
{
  "exito": true,
  "mensaje": "Contacto creado exitosamente",
  "contactoId": 21
}
```

**Response con Error (200 OK):**
```json
{
  "exito": false,
  "mensaje": "No se encontró el cliente con ID 999",
  "contactoId": null
}
```

### Ejemplos de Uso

#### Con cURL:
```bash
curl -X POST https://localhost:7000/api/contactos/CrearContacto \
  -H "Content-Type: application/json" \
  -d '{
    "clienteId": 1,
    "nombreCompleto": "Carlos Rodríguez",
    "direccion": "Calle Ejemplo 123",
    "telefono": "555-9999"
  }'
```

#### Con PowerShell:
```powershell
$body = @{
    clienteId = 1
    nombreCompleto = "Carlos Rodríguez"
    direccion = "Calle Ejemplo 123"
    telefono = "555-9999"
} | ConvertTo-Json

Invoke-RestMethod -Uri "https://localhost:7000/api/contactos/CrearContacto" `
    -Method Post `
    -ContentType "application/json" `
    -Body $body
```

#### Con el Script incluido:
```powershell
.\Scripts\TestAPI.ps1
```

---

## ??? Tecnologías Utilizadas

### Backend
- **ASP.NET Core 10.0** - Framework web
- **Razor Pages** - Patrón de desarrollo
- **Entity Framework Core 9.0** - ORM
- **C# 14.0** - Lenguaje de programación

### Base de Datos
- **SQL Server** - Sistema de gestión de base de datos

### Frontend
- **Bootstrap 5** - Framework CSS
- **Bootstrap Icons** - Iconografía
- **jQuery** - Biblioteca JavaScript
- **HTML5 / CSS3** - Marcado y estilos

### Herramientas
- **Entity Framework Tools** - Migraciones de base de datos
- **dotnet CLI** - Línea de comandos
- **PowerShell** - Scripts de automatización

---

## ?? Estructura del Proyecto

```
CustomersClients/
??? Controllers/
?   ??? ContactosController.cs        # API REST
??? Data/
?   ??? ApplicationDbContext.cs       # Contexto de EF Core
??? Models/
?   ??? Cliente.cs                    # Entidad Cliente
?   ??? Contacto.cs                   # Entidad Contacto
??? Pages/
?   ??? Clientes/
?   ?   ??? Index.cshtml              # Lista con filtros
?   ?   ??? Create.cshtml             # Crear cliente
?   ?   ??? Edit.cshtml               # Editar cliente
?   ?   ??? Details.cshtml            # Ver detalles
?   ?   ??? Delete.cshtml             # Confirmar eliminación
?   ??? Contactos/
?   ?   ??? Index.cshtml              # Lista con búsqueda
?   ?   ??? Create.cshtml             # Crear contacto
?   ?   ??? Edit.cshtml               # Editar contacto
?   ?   ??? Delete.cshtml             # Confirmar eliminación
?   ??? Shared/
?   ?   ??? _Layout.cshtml            # Layout principal
?   ??? Index.cshtml                  # Página de inicio
??? SQL/
?   ??? ConsultasSQL.sql              # Sentencias SQL solicitadas
?   ??? DatosPrueba.sql               # Datos de prueba
??? Scripts/
?   ??? CrearBaseDatos.ps1            # Script para crear BD
?   ??? TestAPI.ps1                   # Script para probar API
??? wwwroot/                          # Archivos estáticos
??? appsettings.json                  # Configuración
??? Program.cs                        # Punto de entrada
??? CustomersClients.csproj           # Archivo de proyecto
```

---

## ?? Características Técnicas

### Patrones y Prácticas
- ? **Repository Pattern** (vía DbContext)
- ? **Dependency Injection**
- ? **Data Annotations** para validación
- ? **Async/Await** para operaciones I/O
- ? **LINQ** para consultas a base de datos

### Validaciones
- ? Validación del lado del servidor (Data Annotations)
- ? Validación del lado del cliente (jQuery Validation)
- ? Campos obligatorios
- ? Longitudes máximas

### Seguridad
- ? SQL Injection protegido (EF Core parametriza automáticamente)
- ? HTTPS habilitado por defecto
- ? CORS configurado
- ? Validación de entrada

### Rendimiento
- ? Consultas LINQ optimizadas
- ? Índices en columnas clave
- ? Eager Loading con `.Include()`
- ? Paginación lista para implementar

---

## ?? Capturas de Funcionalidad

### Página Principal
- Dashboard con acceso rápido a Clientes y Contactos
- Diseño limpio y profesional

### Lista de Clientes
- Estadísticas en tiempo real
- Panel de filtros múltiples
- Tabla interactiva con ordenamiento
- Acciones por registro

### Lista de Contactos
- Búsqueda instantánea
- Vista global o por cliente
- Ordenamiento flexible

---

## ?? Despliegue

### Publicar en Docker Hub

1. **Construir la imagen**

```bash
docker build -t luiscw/sistemagestion:latest .
```

2. **Login en Docker Hub**

```bash
docker login
```

3. **Subir la imagen**

```bash
docker push luiscw/sistemagestion:latest
```

### Publicación para IIS

```bash
dotnet publish -c Release -o ./publish
```

### Publicación para Azure

```bash
dotnet publish -c Release -o ./publish
# Seguir pasos de Azure App Service
```

---

## ?? Enlaces

- **Repositorio GitHub**: https://github.com/LuisCW/SistemaGestion
- **Docker Hub**: https://hub.docker.com/r/luiscw/sistemagestion

## ?? Documentación Adicional

- **[Guía de GitHub y Docker](GITHUB_DOCKER_GUIDE.md)** - Paso a paso para deployment
- **[Checklist de Deployment](DEPLOYMENT_CHECKLIST.md)** - Verificación completa
- **[Comandos Git](GIT_COMMANDS.md)** - Referencia rápida de Git
- **[Comandos Docker](DOCKER_COMMANDS.md)** - Referencia rápida de Docker

## ?? Scripts Automatizados

- **`Scripts/Deploy.ps1`** - Script completo de deployment
- **`QuickStart.ps1`** - Instalación rápida con Docker
- **`Scripts/TestAPI.ps1`** - Prueba del API REST
- **`Scripts/CrearBaseDatos.ps1`** - Crear base de datos manualmente

---

## ?? Soporte

Para problemas o preguntas:
1. Verificar que SQL Server esté ejecutándose
2. Verificar la cadena de conexión en `appsettings.json`
3. Ejecutar `dotnet build` para verificar compilación
4. Revisar logs en la consola

---

## ?? Licencia

Este proyecto fue desarrollado con fines educativos y de demostración.

---

**Desarrollado con ASP.NET Core 10.0 - 2026**
