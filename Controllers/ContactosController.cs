using Microsoft.AspNetCore.Mvc;
using CustomersClients.Data;
using CustomersClients.Models;
using Microsoft.EntityFrameworkCore;

namespace CustomersClients.Controllers;

[ApiController]
[Route("api/[controller]")]
public class ContactosController : ControllerBase
{
    private readonly ApplicationDbContext _context;

    public ContactosController(ApplicationDbContext context)
    {
        _context = context;
    }

    [HttpPost("CrearContacto")]
    public async Task<ActionResult<ContactoResponse>> CrearContacto([FromBody] CrearContactoRequest request)
    {
        try
        {
            var cliente = await _context.Clientes.FindAsync(request.ClienteId);
            
            if (cliente == null)
            {
                return Ok(new ContactoResponse
                {
                    Exito = false,
                    Mensaje = $"No se encontró el cliente con ID {request.ClienteId}",
                    ContactoId = null
                });
            }

            var contacto = new Contacto
            {
                NombreCompleto = request.NombreCompleto,
                Direccion = request.Direccion,
                Telefono = request.Telefono,
                ClienteId = request.ClienteId
            };

            _context.Contactos.Add(contacto);
            await _context.SaveChangesAsync();

            return Ok(new ContactoResponse
            {
                Exito = true,
                Mensaje = "Contacto creado exitosamente",
                ContactoId = contacto.Id
            });
        }
        catch (Exception ex)
        {
            return Ok(new ContactoResponse
            {
                Exito = false,
                Mensaje = $"Error al crear el contacto: {ex.Message}",
                ContactoId = null
            });
        }
    }
}

public class CrearContactoRequest
{
    public int ClienteId { get; set; }
    public string NombreCompleto { get; set; } = string.Empty;
    public string Direccion { get; set; } = string.Empty;
    public string Telefono { get; set; } = string.Empty;
}

public class ContactoResponse
{
    public bool Exito { get; set; }
    public string Mensaje { get; set; } = string.Empty;
    public int? ContactoId { get; set; }
}
