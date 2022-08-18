using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

/// <summary>
/// Descripción breve de Esubasta
/// </summary>
[Serializable]
[Table("subasta", Schema = "publicaciones")]
public class Esubasta
{
    private int id;
    private int id_cliente;
    private int id_comprador;
    private int id_producto;
    private int valor_inicial;
    private int estado;
    private int puja_alta;
    private DateTime fecha_inicio;
    private DateTime fecha_fin;
    private string session;
    private DateTime modified_by;
    private Boolean correo;
    [Key]
    [Column("id")]
    public int Id { get => id; set => id = value; }
    [Column("id_cliente")]
    public int Id_cliente { get => id_cliente; set => id_cliente = value; }
    [Column("id_comprador")]
    public int Id_comprador { get => id_comprador; set => id_comprador = value; }
    [Column("id_producto")]
    public int Id_producto { get => id_producto; set => id_producto = value; }
    [Column("valor_inicial")]
    public int Valor_inicial { get => valor_inicial; set => valor_inicial = value; }
    [Column("status")]
    public int Estado { get => estado; set => estado = value; }
    [Column("puja_alta")]
    public int Puja_alta { get => puja_alta; set => puja_alta = value; }
    [Column("fecha_inicio")]
    public DateTime Fecha_inicio { get => fecha_inicio; set => fecha_inicio = value; }
    [Column("fecha_fin")]
    public DateTime Fecha_fin { get => fecha_fin; set => fecha_fin = value; }
    [Column("session")]
    public string Session { get => session; set => session = value; }
    [Column("modified_by")]
    [NotMapped]
    public DateTime Modified_by { get => modified_by; set => modified_by = value; }
    [Column("correo")]
    public bool Correo { get => correo; set => correo = value; }
}