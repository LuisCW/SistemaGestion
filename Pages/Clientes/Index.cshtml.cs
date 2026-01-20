using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.EntityFrameworkCore;
using CustomersClients.Data;
using CustomersClients.Models;

namespace CustomersClients.Pages.Clientes;

public class IndexModel : PageModel
{
    private readonly ApplicationDbContext _context;

    public IndexModel(ApplicationDbContext context)
    {
        _context = context;
    }

    public IList<Cliente> Clientes { get; set; } = default!;
    
    [BindProperty(SupportsGet = true)]
    public string? SearchString { get; set; }
    
    [BindProperty(SupportsGet = true)]
    public string? SortOrder { get; set; }
    
    [BindProperty(SupportsGet = true)]
    public string? FiltroContactos { get; set; }
    
    [BindProperty(SupportsGet = true)]
    public DateTime? FechaDesde { get; set; }
    
    [BindProperty(SupportsGet = true)]
    public DateTime? FechaHasta { get; set; }
    
    public string NombreSort { get; set; } = string.Empty;
    public string FechaSort { get; set; } = string.Empty;
    public string ContactosSort { get; set; } = string.Empty;
    public string CurrentFilter { get; set; } = string.Empty;
    public int TotalClientes { get; set; }
    public int ClientesConContactos { get; set; }
    public int ClientesSinContactos { get; set; }

    public async Task OnGetAsync()
    {
        NombreSort = SortOrder == "nombre" ? "nombre_desc" : "nombre";
        FechaSort = SortOrder == "fecha" ? "fecha_desc" : "fecha";
        ContactosSort = SortOrder == "contactos" ? "contactos_desc" : "contactos";
        CurrentFilter = SearchString ?? string.Empty;

        IQueryable<Cliente> clientesQuery = _context.Clientes.Include(c => c.Contactos);

        if (!string.IsNullOrEmpty(SearchString))
        {
            clientesQuery = clientesQuery.Where(c => 
                c.NombreCompleto.Contains(SearchString) ||
                c.Direccion.Contains(SearchString) ||
                c.Telefono.Contains(SearchString));
        }

        if (FechaDesde.HasValue)
        {
            clientesQuery = clientesQuery.Where(c => c.FechaCreacion >= FechaDesde.Value);
        }

        if (FechaHasta.HasValue)
        {
            clientesQuery = clientesQuery.Where(c => c.FechaCreacion <= FechaHasta.Value);
        }

        if (!string.IsNullOrEmpty(FiltroContactos))
        {
            clientesQuery = FiltroContactos switch
            {
                "con" => clientesQuery.Where(c => c.Contactos.Any()),
                "sin" => clientesQuery.Where(c => !c.Contactos.Any()),
                "multiples" => clientesQuery.Where(c => c.Contactos.Count > 1),
                _ => clientesQuery
            };
        }

        clientesQuery = SortOrder switch
        {
            "nombre" => clientesQuery.OrderBy(c => c.NombreCompleto),
            "nombre_desc" => clientesQuery.OrderByDescending(c => c.NombreCompleto),
            "fecha" => clientesQuery.OrderBy(c => c.FechaCreacion),
            "fecha_desc" => clientesQuery.OrderByDescending(c => c.FechaCreacion),
            "contactos" => clientesQuery.OrderBy(c => c.Contactos.Count),
            "contactos_desc" => clientesQuery.OrderByDescending(c => c.Contactos.Count),
            _ => clientesQuery.OrderByDescending(c => c.FechaCreacion)
        };

        Clientes = await clientesQuery.ToListAsync();

        TotalClientes = await _context.Clientes.CountAsync();
        ClientesConContactos = await _context.Clientes.Where(c => c.Contactos.Any()).CountAsync();
        ClientesSinContactos = TotalClientes - ClientesConContactos;
    }
}

