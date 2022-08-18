using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

/// <summary>
/// Descripción breve de Eform1
/// </summary>

[Serializable]
[Table("inventario", Schema = "publicaciones")]
public class Ecatalogo
{
    private int id;
    private string imagen1;
    private string imagen2;
    private string imagen3;
    private int precio;
    private int estado;
    private String tipoBicicleta;
    private string talla;
    private String n_piñones;//relacion
    private string referencia;
    private string marca;
    private DateTime anio;
    private string tipoFrenos;
    private DateTime fechaRevicion;
    private string color;
    private int idVendedor;
    private int idComprador;
    private string ciudad;
    private string session;
    private DateTime modified_by;
    private Boolean correo;

    private Boolean userValidado;

    [Key]
    [Column("id")]
    public int Id { get => id; set => id = value; }
    [Column("imagen1")]
    public string Imagen1 { get => imagen1; set => imagen1 = value; }
    [Column("imagen2")]
    public string Imagen2 { get => imagen2; set => imagen2 = value; }
    [Column("imagen3")]
    public string Imagen3 { get => imagen3; set => imagen3 = value; }
    [Column("precio")]
    public int Precio { get => precio; set => precio = value; }
    [Column("status")]
    public int Estado { get => estado; set => estado = value; }
    [Column("session")]
    public string Session { get => session; set => session = value; }
    [Column("modified_by")]
    [NotMapped]
    public DateTime Modified_by { get => modified_by; set => modified_by = value; }
    [Column("tipo_bicicleta")]
    public string TipoBicicleta { get => tipoBicicleta; set => tipoBicicleta = value; }
    [Column("talla")]
    public string Talla { get => talla; set => talla = value; }
    [Column("n_piñones")]
    public String N_piñones { get => n_piñones; set => n_piñones = value; }
    [Column("referencia")]
    public string Referencia { get => referencia; set => referencia = value; }
    [Column("marca")]
    public string Marca { get => marca; set => marca = value; }
    [Column("año")]
    public DateTime Anio { get => anio; set => anio = value; }
    [Column("tipo_frenos")]
    public string TipoFrenos { get => tipoFrenos; set => tipoFrenos = value; }
    [Column("fecha_revicion")]
    public DateTime FechaRevicion { get => fechaRevicion; set => fechaRevicion = value; }
    [Column("color")]
    public string Color { get => color; set => color = value; }
    [Column("id_vendedor")]
    public int IdVendedor { get => idVendedor; set => idVendedor = value; }
    [Column("id_comprador")]
    public int IdComprador { get => idComprador; set => idComprador = value; }
    [Column("ciudad")]
    public string Ciudad { get => ciudad; set => ciudad = value; }
    [Column("correo")]
    public bool Correo { get => correo; set => correo = value; }
    [NotMapped]
    public bool UserValidado { get => userValidado; set => userValidado = value; }
}