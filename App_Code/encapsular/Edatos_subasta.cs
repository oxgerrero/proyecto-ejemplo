using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Descripción breve de Edatos_subasta
/// </summary>
public class Edatos_subasta
{
    private int id;
    private string imagen1;
    private string imagen2;
    private string imagen3;
    private String tipoBicicleta;
    private string talla;
    private String n_piñones;//relacion
    private string referencia;
    private string marca;
    private DateTime anio;
    private string tipoFrenos;
    private DateTime fechaRevicion;
    private string color;
    private string ciudad;
    private int valor_inicial;
    private int estado;
    private int puja_alta;
    private DateTime fecha_inicio;
    private DateTime fecha_fin;

    public int Id { get => id; set => id = value; }
    public string Imagen1 { get => imagen1; set => imagen1 = value; }
    public string Imagen2 { get => imagen2; set => imagen2 = value; }
    public string Imagen3 { get => imagen3; set => imagen3 = value; }
    public string TipoBicicleta { get => tipoBicicleta; set => tipoBicicleta = value; }
    public string Talla { get => talla; set => talla = value; }
    public String N_piñones { get => n_piñones; set => n_piñones = value; }
    public string Referencia { get => referencia; set => referencia = value; }
    public string Marca { get => marca; set => marca = value; }
    public DateTime Anio { get => anio; set => anio = value; }
    public string TipoFrenos { get => tipoFrenos; set => tipoFrenos = value; }
    public DateTime FechaRevicion { get => fechaRevicion; set => fechaRevicion = value; }
    public string Color { get => color; set => color = value; }
    public string Ciudad { get => ciudad; set => ciudad = value; }
    public int Valor_inicial { get => valor_inicial; set => valor_inicial = value; }
    public int Estado { get => estado; set => estado = value; }
    public int Puja_alta { get => puja_alta; set => puja_alta = value; }
    public DateTime Fecha_inicio { get => fecha_inicio; set => fecha_inicio = value; }
    public DateTime Fecha_fin { get => fecha_fin; set => fecha_fin = value; }
}