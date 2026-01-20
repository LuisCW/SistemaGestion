# Sistema de Gestión de Clientes y Contactos

Aplicación web ASP.NET Core 10.0 con Razor Pages, Entity Framework Core y SQL Server para administración de clientes y contactos.

---

## ?? Inicio Rápido con Docker

```bash
git clone https://github.com/LuisCW/SistemaGestion.git
cd SistemaGestion
docker-compose up -d
```

Abre: http://localhost:8080

---

## ?? 1. Diagrama Entidad-Relación

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
                ? 1:N
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

Relación: 1 Cliente ? N Contactos (ON DELETE CASCADE)
```

---

## ?? 2. Sentencias SQL

### a. Clientes con contactos cuyo nombre empieza por "carl"
```sql
SELECT DISTINCT c.*
FROM Clientes c
INNER JOIN Contactos con ON c.Id = con.ClienteId
WHERE con.NombreCompleto LIKE 'carl%';
```

### b. Clientes ordenados ascendentemente por fecha de creación
```sql
SELECT *
FROM Clientes
ORDER BY FechaCreacion ASC;
```

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

### d. Eliminar contactos de un cliente determinado
```sql
DECLARE @ClienteId INT = 1;
DELETE FROM Contactos WHERE ClienteId = @ClienteId;
```

### e. Eliminar clientes sin contactos
```sql
DELETE FROM Clientes
WHERE Id NOT IN (SELECT DISTINCT ClienteId FROM Contactos);
```

### f. Insertar cliente con contacto
```sql
BEGIN TRANSACTION;
    INSERT INTO Clientes (NombreCompleto, Direccion, Telefono, FechaCreacion)
    VALUES ('Juan Pérez García', 'Calle Principal 123', '555-1234', GETDATE());
    
    DECLARE @NuevoClienteId INT = SCOPE_IDENTITY();
    
    INSERT INTO Contactos (NombreCompleto, Direccion, Telefono, ClienteId)
    VALUES ('Carlos López Martínez', 'Avenida Central 456', '555-5678', @NuevoClienteId);
COMMIT TRANSACTION;
```

---

## ?? 3. Aplicación Web (CRUD + Filtros + Ordenamientos)

### Funcionalidades Implementadas:

**Gestión de Clientes:**
- ? CRUD completo (Crear, Leer, Actualizar, Eliminar)
- ? Búsqueda por nombre, dirección o teléfono
- ? Filtros: con/sin contactos, múltiples contactos, rango de fechas
- ? Ordenamiento: por nombre, fecha, cantidad de contactos

**Gestión de Contactos:**
- ? CRUD completo
- ? Búsqueda por nombre, dirección, teléfono, cliente
- ? Ordenamiento: por nombre de contacto o cliente
- ? Vista global y filtrada por cliente

### Instalación Local:

```bash
# 1. Clonar repositorio
git clone https://github.com/LuisCW/SistemaGestion.git
cd SistemaGestion

# 2. Configurar base de datos (appsettings.json)
"ConnectionStrings": {
  "DefaultConnection": "Server=localhost;Database=ClientesContactosDB;Integrated Security=True;TrustServerCertificate=True"
}

# 3. Aplicar migraciones
dotnet ef database update

# 4. Ejecutar
dotnet run
```

Abre: https://localhost:7000

---

## ?? 4. Web Service REST

### Endpoint: Crear Contacto

**URL:** `POST /api/contactos/CrearContacto`

**Request:**
```json
{
  "clienteId": 1,
  "nombreCompleto": "Carlos Rodríguez",
  "direccion": "Calle Ejemplo 123",
  "telefono": "555-9999"
}
```

**Response Exitosa:**
```json
{
  "exito": true,
  "mensaje": "Contacto creado exitosamente",
  "contactoId": 21
}
```

**Response con Error:**
```json
{
  "exito": false,
  "mensaje": "No se encontró el cliente con ID 999",
  "contactoId": null
}
```

### Ejemplo de Uso:

**PowerShell:**
```powershell
$body = @{
    clienteId = 1
    nombreCompleto = "Carlos Rodríguez"
    direccion = "Calle Ejemplo 123"
    telefono = "555-9999"
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:5000/api/contactos/CrearContacto" `
    -Method Post `
    -ContentType "application/json" `
    -Body $body
```

**cURL:**
```bash
curl -X POST http://localhost:5000/api/contactos/CrearContacto \
  -H "Content-Type: application/json" \
  -d '{"clienteId":1,"nombreCompleto":"Carlos Rodríguez","direccion":"Calle Ejemplo 123","telefono":"555-9999"}'
```

---

## ??? Tecnologías

- **ASP.NET Core 10.0** - Framework web
- **Razor Pages** - Patrón de desarrollo
- **Entity Framework Core 9.0** - ORM
- **SQL Server** - Base de datos
- **Bootstrap 5** - UI Framework
- **Docker** - Containerización

---

## ?? Estructura de Base de Datos

```sql
CREATE TABLE Clientes (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    NombreCompleto NVARCHAR(200) NOT NULL,
    Direccion NVARCHAR(500) NOT NULL,
    Telefono NVARCHAR(20) NOT NULL,
    FechaCreacion DATETIME2 NOT NULL DEFAULT GETDATE()
);

CREATE TABLE Contactos (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    NombreCompleto NVARCHAR(200) NOT NULL,
    Direccion NVARCHAR(500) NOT NULL,
    Telefono NVARCHAR(20) NOT NULL,
    ClienteId INT NOT NULL,
    CONSTRAINT FK_Contactos_Clientes FOREIGN KEY (ClienteId) 
        REFERENCES Clientes(Id) ON DELETE CASCADE
);

CREATE INDEX IX_Contactos_ClienteId ON Contactos(ClienteId);
CREATE INDEX IX_Clientes_FechaCreacion ON Clientes(FechaCreacion);
```

---

## ?? Docker Hub

**Imagen:** `luiscw/sistemagestion:latest`

**Uso:**
```bash
docker pull luiscw/sistemagestion:latest
docker-compose up -d
```

---

## ?? Enlaces

- **GitHub:** https://github.com/LuisCW/SistemaGestion
- **Docker Hub:** https://hub.docker.com/r/luiscw/sistemagestion

---

**Desarrollado con ASP.NET Core 10.0 - 2026**
