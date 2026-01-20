using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.EntityFrameworkCore;
using CustomersClients.Data;
using CustomersClients.Models;

namespace CustomersClients.Pages.Clientes;

public class DetailsModel : PageModel
{
    private readonly ApplicationDbContext _context;

    public DetailsModel(ApplicationDbContext context)
    {
        _context = context;
    }

    public Cliente Cliente { get; set; } = default!;

    public async Task<IActionResult> OnGetAsync(int? id)
    {
        if (id == null)
        {
            return NotFound();
        }

        var cliente = await _context.Clientes
            .Include(c => c.Contactos)
            .FirstOrDefaultAsync(m => m.Id == id);

        if (cliente == null)
        {
            return NotFound();
        }
        
        Cliente = cliente;
        return Page();
    }
}
