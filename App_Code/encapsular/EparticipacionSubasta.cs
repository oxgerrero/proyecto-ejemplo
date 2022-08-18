using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Descripción breve de EparticipacionSubasta
/// </summary>
public class EparticipacionSubasta
{
    private String nombreComprador;
    private int valor;

    public string NombreComprador { get => nombreComprador; set => nombreComprador = value; }
    public int Valor { get => valor; set => valor = value; }
}