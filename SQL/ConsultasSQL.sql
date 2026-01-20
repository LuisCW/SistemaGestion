-- ============================================================================
-- SENTENCIAS SQL PARA CLIENTES Y CONTACTOS
-- ============================================================================

-- a. Los clientes que tienen contactos que su nombre empieza por "carl"
SELECT DISTINCT c.*
FROM Clientes c
INNER JOIN Contactos con ON c.Id = con.ClienteId
WHERE con.NombreCompleto LIKE 'carl%';

-- ============================================================================

-- b. Los clientes ordenados de forma ascendente por fecha de creación
SELECT *
FROM Clientes
ORDER BY FechaCreacion ASC;

-- ============================================================================

-- c. Clientes con más de un contacto
SELECT c.*, COUNT(con.Id) AS CantidadContactos
FROM Clientes c
INNER JOIN Contactos con ON c.Id = con.ClienteId
GROUP BY c.Id, c.NombreCompleto, c.Direccion, c.Telefono, c.FechaCreacion
HAVING COUNT(con.Id) > 1;

-- ============================================================================

-- d. Eliminar los contactos de un cliente determinado
-- Reemplazar @ClienteId con el ID del cliente deseado
DECLARE @ClienteId INT = 1; -- Cambiar por el ID del cliente

DELETE FROM Contactos
WHERE ClienteId = @ClienteId;

-- ============================================================================

-- e. Eliminar los clientes que no tienen contactos
DELETE FROM Clientes
WHERE Id NOT IN (
    SELECT DISTINCT ClienteId
    FROM Contactos
);

-- O también puede hacerse con LEFT JOIN:
DELETE c
FROM Clientes c
LEFT JOIN Contactos con ON c.Id = con.ClienteId
WHERE con.Id IS NULL;

-- ============================================================================

-- f. Insertar un cliente con un contacto determinado
-- Opción 1: Con transacción para asegurar integridad
BEGIN TRANSACTION;

-- Insertar el cliente
INSERT INTO Clientes (NombreCompleto, Direccion, Telefono, FechaCreacion)
VALUES ('Juan Pérez', 'Calle Principal 123', '555-1234', GETDATE());

-- Obtener el ID del cliente recién insertado
DECLARE @NuevoClienteId INT = SCOPE_IDENTITY();

-- Insertar el contacto relacionado
INSERT INTO Contactos (NombreCompleto, Direccion, Telefono, ClienteId)
VALUES ('Carlos López', 'Avenida Central 456', '555-5678', @NuevoClienteId);

COMMIT TRANSACTION;

-- ============================================================================

-- Opción 2: Insertar cliente con contacto usando OUTPUT (más moderno)
DECLARE @NuevoClienteId2 INT;

INSERT INTO Clientes (NombreCompleto, Direccion, Telefono, FechaCreacion)
OUTPUT INSERTED.Id INTO @NuevoClienteId2
VALUES ('María González', 'Calle Secundaria 789', '555-9012', GETDATE());

INSERT INTO Contactos (NombreCompleto, Direccion, Telefono, ClienteId)
VALUES ('Ana Martínez', 'Boulevard Norte 321', '555-3456', @NuevoClienteId2);

-- ============================================================================

-- CONSULTAS ADICIONALES ÚTILES
-- ============================================================================

-- Obtener todos los clientes con sus contactos
SELECT 
    c.Id AS ClienteId,
    c.NombreCompleto AS ClienteNombre,
    c.Direccion AS ClienteDireccion,
    c.Telefono AS ClienteTelefono,
    c.FechaCreacion,
    con.Id AS ContactoId,
    con.NombreCompleto AS ContactoNombre,
    con.Direccion AS ContactoDireccion,
    con.Telefono AS ContactoTelefono
FROM Clientes c
LEFT JOIN Contactos con ON c.Id = con.ClienteId
ORDER BY c.FechaCreacion DESC, con.NombreCompleto;

-- ============================================================================

-- Contar contactos por cliente
SELECT 
    c.Id,
    c.NombreCompleto,
    COUNT(con.Id) AS TotalContactos
FROM Clientes c
LEFT JOIN Contactos con ON c.Id = con.ClienteId
GROUP BY c.Id, c.NombreCompleto
ORDER BY TotalContactos DESC;
