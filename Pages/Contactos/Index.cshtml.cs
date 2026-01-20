using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.EntityFrameworkCore;
using CustomersClients.Data;
using CustomersClients.Models;

namespace CustomersClients.Pages.Contactos;

public class IndexModel : PageModel
{
    private readonly ApplicationDbContext _context;

    public IndexModel(ApplicationDbContext context)
    {
        _context = context;
    }

    public IList<Contacto> Contactos { get; set; } = default!;
    public int? ClienteId { get; set; }
    public string ClienteNombre { get; set; } = string.Empty;
    
    [BindProperty(SupportsGet = true)]
    public string? SearchString { get; set; }
    
    [BindProperty(SupportsGet = true)]
    public string? SortOrder { get; set; }
    
    public string NombreSort { get; set; } = string.Empty;
    public string ClienteSort { get; set; } = string.Empty;
    public int TotalContactos { get; set; }

    public async Task OnGetAsync(int? clienteId)
    {
        ClienteId = clienteId;
        
        NombreSort = SortOrder == "nombre" ? "nombre_desc" : "nombre";
        ClienteSort = SortOrder == "cliente" ? "cliente_desc" : "cliente";

        IQueryable<Contacto> contactosQuery = _context.Contactos.Include(c => c.Cliente);

        if (clienteId.HasValue)
        {
            var cliente = await _context.Clientes.FindAsync(clienteId.Value);
            if (cliente != null)
            {
                ClienteNombre = cliente.NombreCompleto;
            }

            contactosQuery = contactosQuery.Where(c => c.ClienteId == clienteId.Value);
        }

        if (!string.IsNullOrEmpty(SearchString))
        {
            contactosQuery = contactosQuery.Where(c => 
                c.NombreCompleto.Contains(SearchString) ||
                c.Direccion.Contains(SearchString) ||
                c.Telefono.Contains(SearchString) ||
                (c.Cliente != null && c.Cliente.NombreCompleto.Contains(SearchString)));
        }

        contactosQuery = SortOrder switch
        {
            "nombre" => contactosQuery.OrderBy(c => c.NombreCompleto),
            "nombre_desc" => contactosQuery.OrderByDescending(c => c.NombreCompleto),
            "cliente" => contactosQuery.OrderBy(c => c.Cliente!.NombreCompleto),
            "cliente_desc" => contactosQuery.OrderByDescending(c => c.Cliente!.NombreCompleto),
            _ => contactosQuery.OrderBy(c => c.NombreCompleto)
        };

        Contactos = await contactosQuery.ToListAsync();
        TotalContactos = await _context.Contactos.CountAsync();
    }
}

