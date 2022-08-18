using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Descripción breve de EdatalistProductos
/// </summary>
public class EdatalistProductos
{
    private string image1;
    private Boolean verificado;
    private int precio;
    private string marca;
    private string referencia;

    public string Image1 { get => image1; set => image1 = value; }
    public bool Verificado { get => verificado; set => verificado = value; }
    public int Precio { get => precio; set => precio = value; }
    public string Marca { get => marca; set => marca = value; }
    public string Referencia { get => referencia; set => referencia = value; }
}