using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

/// <summary>
/// Descripción breve de Eusuarios
/// </summary>

[Serializable]
[Table("usuarios", Schema = "usuarios")]
public class Eusuarios
{
    private int id;
    private string nombre;
    private string apellido;
    private string email;
    private string telefono;
    private string usuario;
    private string contraseña;
    private int id_rol;
    private string session;
    private int activo;
    private Boolean validado;

    [Key]
    [Column("id")]
    public int Id { get => id; set => id = value; }

    [Column("nombre")]
    public string Nombre { get => nombre; set => nombre = value; }

    [Column("apellido")]
    public string Apellido { get => apellido; set => apellido = value; }
    [Column("email")]
    public string Email { get => email; set => email = value; }

    [Column("telefono")]
    public string Telefono { get => telefono; set => telefono = value; }
    [Column("usuario")]
    public string Usuario { get => usuario; set => usuario = value; }

    [Column("contraseña")]
    public string Contraseña { get => contraseña; set => contraseña = value; }
    [Column("id_rol")]
    public int Id_rol { get => id_rol; set => id_rol = value; }

    [Column("session")]
    public string Session { get => session; set => session = value; }
    
    [Column("activo")]
    public int Activo { get => activo; set => activo = value; }
    [Column("validado")]
    public bool Validado { get => validado; set => validado = value; }
}