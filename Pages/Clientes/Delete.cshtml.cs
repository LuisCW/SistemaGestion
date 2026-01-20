using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.EntityFrameworkCore;
using CustomersClients.Data;
using CustomersClients.Models;

namespace CustomersClients.Pages.Clientes;

public class DeleteModel : PageModel
{
    private readonly ApplicationDbContext _context;

    public DeleteModel(ApplicationDbContext context)
    {
        _context = context;
    }

    [BindProperty]
    public Cliente Cliente { get; set; } = default!;

    public async Task<IActionResult> OnGetAsync(int? id)
    {
        if (id == null)
        {
            return NotFound();
        }

        var cliente = await _context.Clientes.FirstOrDefaultAsync(m => m.Id == id);

        if (cliente == null)
        {
            return NotFound();
        }
        
        Cliente = cliente;
        return Page();
    }

    public async Task<IActionResult> OnPostAsync(int? id)
    {
        if (id == null)
        {
            return NotFound();
        }

        var cliente = await _context.Clientes.FindAsync(id);
        if (cliente != null)
        {
            Cliente = cliente;
            _context.Clientes.Remove(Cliente);
            await _context.SaveChangesAsync();
        }

        return RedirectToPage("./Index");
    }
}
