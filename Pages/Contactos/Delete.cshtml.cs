using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.EntityFrameworkCore;
using CustomersClients.Data;
using CustomersClients.Models;

namespace CustomersClients.Pages.Contactos;

public class DeleteModel : PageModel
{
    private readonly ApplicationDbContext _context;

    public DeleteModel(ApplicationDbContext context)
    {
        _context = context;
    }

    [BindProperty]
    public Contacto Contacto { get; set; } = default!;

    public async Task<IActionResult> OnGetAsync(int? id)
    {
        if (id == null)
        {
            return NotFound();
        }

        var contacto = await _context.Contactos
            .Include(c => c.Cliente)
            .FirstOrDefaultAsync(m => m.Id == id);

        if (contacto == null)
        {
            return NotFound();
        }
        
        Contacto = contacto;
        return Page();
    }

    public async Task<IActionResult> OnPostAsync(int? id)
    {
        if (id == null)
        {
            return NotFound();
        }

        var contacto = await _context.Contactos.FindAsync(id);
        if (contacto != null)
        {
            Contacto = contacto;
            _context.Contactos.Remove(Contacto);
            await _context.SaveChangesAsync();
        }

        return RedirectToPage("./Index");
    }
}
