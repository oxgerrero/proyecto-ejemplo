using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

/// <summary>
/// Descripción breve de token
/// </summary>

[Serializable]
[Table("token", Schema = "usuarios")]
public class token
{

    private int id;
    private int id_user;
    private DateTime fecha_inicio;
    private DateTime fecha_fin;
    private string tactivo;
    [Key]
    [Column("id")]
    public int Id { get => id; set => id = value; }
    [Column("id_user")]
    public int Id_user { get => id_user; set => id_user = value; }
    [Column("finicio")]
    public DateTime Fecha_inicio { get => fecha_inicio; set => fecha_inicio = value; }
    [Column("ffin")]
    public DateTime Fecha_fin { get => fecha_fin; set => fecha_fin = value; }
    [Column("tactivo")]
    public String Tactivo { get => tactivo; set => tactivo = value; }

}