using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

/// <summary>
/// Descripción breve de EhistoricoSubasta
/// </summary>
[Serializable]
[Table("historico_subastas", Schema = "publicaciones")]
public class EhistoricoSubasta
{
        private int id;
        private int id_comprador;
        private int id_subasta;
        private int valor;
    [Key]
    [Column("id")]
    public int Id { get => id; set => id = value; }
    [Column("id_comprador")]
    public int Id_comprador { get => id_comprador; set => id_comprador = value; }
    [Column("id_subasta")]
    public int Id_subasta { get => id_subasta; set => id_subasta = value; }
    [Column("valor")]
    public int Valor { get => valor; set => valor = value; }

    
}