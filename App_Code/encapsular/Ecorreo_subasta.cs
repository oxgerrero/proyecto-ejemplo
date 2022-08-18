using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Descripción breve de Ecorreo_subasta
/// </summary>
public class Ecorreo_subasta
{
    private int id;
    private string nombre;
    private string correo;
    private string referencia;
    

    public int Id { get => id; set => id = value; }
    public string Nombre { get => nombre; set => nombre = value; }
    public string Correo { get => correo; set => correo = value; }
    public string Referencia { get => referencia; set => referencia = value; }
}