using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace CustomersClients.Models;

public class Contacto
{
    public int Id { get; set; }
    
    [Required(ErrorMessage = "El nombre completo es requerido")]
    [StringLength(200)]
    [Display(Name = "Nombre Completo")]
    public string NombreCompleto { get; set; } = string.Empty;
    
    [Required(ErrorMessage = "La dirección es requerida")]
    [StringLength(500)]
    [Display(Name = "Dirección")]
    public string Direccion { get; set; } = string.Empty;
    
    [Required(ErrorMessage = "El teléfono es requerido")]
    [StringLength(20)]
    [Display(Name = "Teléfono")]
    public string Telefono { get; set; } = string.Empty;
    
    [Display(Name = "Cliente")]
    public int ClienteId { get; set; }
    
    [ForeignKey("ClienteId")]
    public Cliente? Cliente { get; set; }
}
