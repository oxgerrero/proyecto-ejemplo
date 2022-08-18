using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Descripción breve de bicicletas
/// </summary>
public class bicicletas
{
    
    public List<Efrenos> tipoFrenos()
    {
        List<Efrenos> listaB = new List<Efrenos>();
        using (var db = new mapeo())
        {
            listaB = db.Db_frenos.ToList();
        }
        Efrenos nuevo = new Efrenos();
        nuevo.Id = 0;
        nuevo.Descripcion = "Seleccione";
        listaB.Add(nuevo);
        return listaB.OrderBy(x => x.Id).ToList();
    }
    public List<ETbicicletas> tipoBicicletas()
    {
        List<ETbicicletas> listaB = new List<ETbicicletas>();
        using (var db = new mapeo())
        {
            listaB=db.Db_Tbicicletas.ToList();
        }
        ETbicicletas nuevo = new ETbicicletas();
        nuevo.Id = 0;
        nuevo.Descripcion = "Seleccione";
        listaB.Add(nuevo);
        return listaB.OrderBy(x => x.Id).ToList();

    }
    public List<Etalla> talla()
    {
        List<Etalla> listaB = new List<Etalla>();
        using (var db = new mapeo())
        {
            listaB = db.Db_talla.ToList();
        }
        Etalla nuevo = new Etalla();
        nuevo.Id = 0;
        nuevo.Descripcion = "Seleccione";
        listaB.Add(nuevo);
        return listaB.OrderBy(x => x.Id).ToList();
    }
    public List<Epiniones> tipoPiniones()
    {
        List<Epiniones> listaB = new List<Epiniones>();
        using (var db = new mapeo())
        {
            listaB = db.Db_piniones.ToList();
        }

        Epiniones nuevo = new Epiniones();
        nuevo.Id = 0;
        nuevo.Descripcion = "Seleccione";
        listaB.Add(nuevo);
        return listaB.OrderBy(x => x.Id).ToList();
    }
    //DDL's
    public List<Efrenos> ddl_tipoFrenos()
    {
        List<Efrenos> listaB = new List<Efrenos>();
        using (var db = new mapeo())
        {
            listaB = db.Db_frenos.ToList();
        }
        return listaB.OrderBy(x => x.Id).ToList();
    }
    public List<ETbicicletas> ddl_tipoBicicletas()
    {
        List<ETbicicletas> listaB = new List<ETbicicletas>();
        using (var db = new mapeo())
        {
            listaB = db.Db_Tbicicletas.ToList();
        }
        return listaB.OrderBy(x => x.Id).ToList();

    }
    public List<Etalla> ddl_talla()
    {
        List<Etalla> listaB = new List<Etalla>();
        using (var db = new mapeo())
        {
            listaB = db.Db_talla.ToList();
        }
        return listaB.OrderBy(x => x.Id).ToList();
    }
    public List<Epiniones> ddl_tipoPiniones()
    {
        List<Epiniones> listaB = new List<Epiniones>();
        using (var db = new mapeo())
        {
            listaB = db.Db_piniones.ToList();
        }
        return listaB.OrderBy(x => x.Id).ToList();
    }

    public void insertarTipoBicileta(ETbicicletas tipoBicicleta)
    {
        using (var db = new mapeo())
        {
            db.Db_Tbicicletas.Add(tipoBicicleta);
            db.SaveChanges();
        }
    }
    public void insertarTipoPiniones(Epiniones tipoPinio)
    {
        using (var db = new mapeo())
        {
            db.Db_piniones.Add(tipoPinio);
            db.SaveChanges();
        }
    }
    public void insertarTipoFrenos(Efrenos tipoFrenos)
    {
        using (var db = new mapeo())
        {
            db.Db_frenos.Add(tipoFrenos);
            db.SaveChanges();
        }
    }
    public void insertarTallas(Etalla tallas)
    {
        using (var db = new mapeo())
        {
            db.Db_talla.Add(tallas);
            db.SaveChanges();
        }
    }
}