using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Web;

/// <summary>
/// Descripción breve de mapeo
/// </summary>
public class mapeo : DbContext
{
    static mapeo()
    {
        Database.SetInitializer<mapeo>(null);
    }
    private readonly string schema;

    public mapeo()
        : base("name=postgres")
    {

    }
    protected override void OnModelCreating(DbModelBuilder builder)
    {
        builder.HasDefaultSchema(this.schema);

        base.OnModelCreating(builder);
    }
    public virtual DbSet<Eusuarios> Db_usuarios { get; set; }
    public virtual DbSet<token> Db_token { get; set; }
    public virtual DbSet<Ecatalogo> Db_catalogo { get; set; }
    public virtual DbSet<Efrenos> Db_frenos { get; set; }
    public virtual DbSet<ETbicicletas> Db_Tbicicletas { get; set; }
    public virtual DbSet<Etalla> Db_talla { get; set; }
    public virtual DbSet<Epiniones> Db_piniones { get; set; }
    public virtual DbSet<Esubasta> Db_subasta { get; set; }
    public virtual DbSet<EhistoricoSubasta> Db_historico { get; set; }
    public virtual DbSet<EPQRS> Db_PQRS { get; set; }
}