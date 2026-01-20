using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using CustomersClients.Data;
using CustomersClients.Models;

namespace CustomersClients.Pages.Contactos;

public class EditModel : PageModel
{
    private readonly ApplicationDbContext _context;

    public EditModel(ApplicationDbContext context)
    {
        _context = context;
    }

    [BindProperty]
    public Contacto Contacto { get; set; } = default!;

    public SelectList ClientesSelectList { get; set; } = default!;

    public async Task<IActionResult> OnGetAsync(int? id)
    {
        if (id == null)
        {
            return NotFound();
        }

        var contacto = await _context.Contactos.FirstOrDefaultAsync(m => m.Id == id);
        if (contacto == null)
        {
            return NotFound();
        }
        Contacto = contacto;
        
        await LoadClientesSelectList();
        return Page();
    }

    public async Task<IActionResult> OnPostAsync()
    {
        if (!ModelState.IsValid)
        {
            await LoadClientesSelectList();
            return Page();
        }

        _context.Attach(Contacto).State = EntityState.Modified;

        try
        {
            await _context.SaveChangesAsync();
        }
        catch (DbUpdateConcurrencyException)
        {
            if (!ContactoExists(Contacto.Id))
            {
                return NotFound();
            }
            else
            {
                throw;
            }
        }

        return RedirectToPage("./Index", new { clienteId = Contacto.ClienteId });
    }

    private bool ContactoExists(int id)
    {
        return _context.Contactos.Any(e => e.Id == id);
    }

    private async Task LoadClientesSelectList()
    {
        var clientes = await _context.Clientes.ToListAsync();
        ClientesSelectList = new SelectList(clientes, "Id", "NombreCompleto");
    }
}
