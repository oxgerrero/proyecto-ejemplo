using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

/// <summary>
/// Descripción breve de EPQRS
/// </summary>
[Serializable]
[Table("pqrs", Schema = "publicaciones")]
public class EPQRS
{
    private int id;
    private int id_publicacion;
    private int id_cliente_reporto;
    private string descripcion;
    private string session;
    private DateTime modified_by;
    private int status;
    [Key]
    [Column("id")]
    public int Id { get => id; set => id = value; }
    [Column("id_publicacion")]
    public int Id_publicacion { get => id_publicacion; set => id_publicacion = value; }
    [Column("id_cliente_reporto")]
    public int Id_cliente_reporto { get => id_cliente_reporto; set => id_cliente_reporto = value; }
    [Column("descripcion")]
    public string Descripcion { get => descripcion; set => descripcion = value; }
    [Column("session")]
    public string Session { get => session; set => session = value; }
    [Column("modified_by")]
    [NotMapped]
    public DateTime Modified_by { get => modified_by; set => modified_by = value; }
    [Column("status")]
    public int Status { get => status; set => status = value; }
}