# Script de PowerShell para probar el API de Contactos
# Asegúrate de que la aplicación esté ejecutándose antes de ejecutar este script

# Configuración
$baseUrl = "https://localhost:7000" # Ajusta el puerto según tu configuración
$apiUrl = "$baseUrl/api/contactos/CrearContacto"

Write-Host "=== Prueba del API de Creación de Contactos ===" -ForegroundColor Cyan
Write-Host ""

# Caso 1: Crear contacto para un cliente existente (asume ClienteId = 1)
Write-Host "Caso 1: Crear contacto para cliente con ID 1" -ForegroundColor Yellow

$body1 = @{
    clienteId = 1
    nombreCompleto = "Carlos Mendez"
    direccion = "Av. Principal 123"
    telefono = "555-1111"
} | ConvertTo-Json

try {
    $response1 = Invoke-RestMethod -Uri $apiUrl `
        -Method Post `
        -ContentType "application/json" `
        -Body $body1 `
        -SkipCertificateCheck

    Write-Host "Respuesta:" -ForegroundColor Green
    Write-Host "  Éxito: $($response1.exito)"
    Write-Host "  Mensaje: $($response1.mensaje)"
    Write-Host "  ContactoId: $($response1.contactoId)"
} catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Asegúrate de que:" -ForegroundColor Yellow
    Write-Host "  1. La aplicación está ejecutándose"
    Write-Host "  2. El puerto es correcto (ajusta `$baseUrl si es necesario)"
    Write-Host "  3. Existe un cliente con ID 1 en la base de datos"
}

Write-Host ""
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host ""

# Caso 2: Intentar crear contacto para un cliente inexistente
Write-Host "Caso 2: Intentar crear contacto para cliente inexistente (ID 9999)" -ForegroundColor Yellow

$body2 = @{
    clienteId = 9999
    nombreCompleto = "Ana Silva"
    direccion = "Calle Ficticia 456"
    telefono = "555-2222"
} | ConvertTo-Json

try {
    $response2 = Invoke-RestMethod -Uri $apiUrl `
        -Method Post `
        -ContentType "application/json" `
        -Body $body2 `
        -SkipCertificateCheck

    Write-Host "Respuesta:" -ForegroundColor Green
    Write-Host "  Éxito: $($response2.exito)"
    Write-Host "  Mensaje: $($response2.mensaje)"
    Write-Host "  ContactoId: $($response2.contactoId)"
} catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""
Write-Host "=== Pruebas completadas ===" -ForegroundColor Cyan
