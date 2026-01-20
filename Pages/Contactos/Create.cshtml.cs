using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using CustomersClients.Data;
using CustomersClients.Models;

namespace CustomersClients.Pages.Contactos;

public class CreateModel : PageModel
{
    private readonly ApplicationDbContext _context;

    public CreateModel(ApplicationDbContext context)
    {
        _context = context;
    }

    public async Task<IActionResult> OnGetAsync(int? clienteId)
    {
        await LoadClientesSelectList(clienteId);
        return Page();
    }

    [BindProperty]
    public Contacto Contacto { get; set; } = default!;

    public SelectList ClientesSelectList { get; set; } = default!;

    public async Task<IActionResult> OnPostAsync()
    {
        if (!ModelState.IsValid)
        {
            await LoadClientesSelectList(Contacto.ClienteId);
            return Page();
        }

        _context.Contactos.Add(Contacto);
        await _context.SaveChangesAsync();

        return RedirectToPage("./Index", new { clienteId = Contacto.ClienteId });
    }

    private async Task LoadClientesSelectList(int? selectedClienteId)
    {
        var clientes = await _context.Clientes.ToListAsync();
        ClientesSelectList = new SelectList(clientes, "Id", "NombreCompleto", selectedClienteId);
    }
}
