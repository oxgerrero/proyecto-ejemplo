using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Web;

/// <summary>
/// Descripción breve de catalogo
/// </summary>
public class catalogo
{
    public List<Ecatalogo> OB_datos(string contenido)
    {
        if (contenido == null)
        {
            using (var db = new mapeo())
            {
                return (List<Ecatalogo>)db.Db_catalogo.Where(x => x.Estado == 1).OrderBy(x => x.Referencia).ToList();
            }
        }
        else
        {
            using (var db = new mapeo())
            {
                return (List<Ecatalogo>)db.Db_catalogo.Where(x => x.Estado == 1).Where(x => x.Referencia.ToLower().Contains(contenido.ToLower())).OrderBy(x => x.Referencia).ToList();
            }
        }
    }
    public List<Ecatalogo> Ob_datos_activos()
    {
        using (var db = new mapeo())
        {
            return (List<Ecatalogo>)db.Db_catalogo.Where(x => x.Estado == 1 || x.Estado == 3 || x.Estado == 0).OrderBy(x => x.Referencia).ToList();
        }
    }

    public void insertarArchivo(Ecatalogo productos)
    {
        using (var db = new mapeo())
        {
            db.Db_catalogo.Add(productos);
            db.SaveChanges();
        }
    }
    public Ecatalogo producto_click(string image)
    {
        using (var db = new mapeo())
        {
            return (Ecatalogo)db.Db_catalogo.Where(x => x.Imagen1.Equals(image)).FirstOrDefault();
        }
    }
    public Ecatalogo editar_producto(int id)
    {
        using (var db = new mapeo())
        {
            return (Ecatalogo)db.Db_catalogo.Where(x => x.Id.Equals(id)).FirstOrDefault();
        }
    }
    public List<Ecatalogo> OB_datos_usuario(string datos)
    {
        if (datos == null)
        {
            return null;
        }
        else
        {
            using (var db = new mapeo())
            {
                return (List<Ecatalogo>)db.Db_catalogo.Where(u => u.Session.Equals(datos)).Where(y => y.Estado == 1).OrderBy(x => x.Referencia).ToList();
            }
        }
    }
    public Ecatalogo OB_producto_id(int id)
    {
        using (var db = new mapeo())
        {
            return (Ecatalogo)db.Db_catalogo.Where(x => x.Id == id).FirstOrDefault();
        }
    }
    public void insertarSubasta(Esubasta subastar)
    {
        using (var db = new mapeo())
        {
            db.Db_subasta.Add(subastar);
            db.SaveChanges();
        }
    }
    public Esubasta OB_subasta_id(int id)
    {
        using (var db = new mapeo())
        {
            return (Esubasta)db.Db_subasta.Where(x => x.Id == id).FirstOrDefault();
        }
    }
    public List<Esubasta> OB_subasta()
    {
        using (var db = new mapeo())
        {
            return (List<Esubasta>)db.Db_subasta.OrderBy(x => x.Id).ToList();
        }
    }
    public List<Edatos_subasta> OB_datos_subastas()
    {
        using (var db = new mapeo())
        {
            return (List<Edatos_subasta>)(from subasta in db.Db_subasta
                                          join producto in db.Db_catalogo on subasta.Id_producto equals producto.Id

                                          select new
                                          {
                                              subasta,
                                              producto,
                                          }).Where(x => x.subasta.Estado == 1).ToList().Select(m => new Edatos_subasta
                                          {
                                              Id = m.subasta.Id,
                                              Imagen1 = m.producto.Imagen1,
                                              Imagen2 = m.producto.Imagen2,
                                              Imagen3 = m.producto.Imagen3,
                                              TipoBicicleta = m.producto.TipoBicicleta,
                                              Talla = m.producto.Talla,
                                              N_piñones = m.producto.N_piñones,
                                              Referencia = m.producto.Referencia,
                                              Marca = m.producto.Marca,
                                              Anio = m.producto.Anio,
                                              TipoFrenos = m.producto.TipoFrenos,
                                              FechaRevicion = m.producto.FechaRevicion,
                                              Color = m.producto.Color,
                                              Ciudad = m.producto.Ciudad,
                                              Valor_inicial = m.subasta.Valor_inicial,
                                              Estado = m.subasta.Estado,
                                              Puja_alta = m.subasta.Puja_alta,
                                              Fecha_inicio = m.subasta.Fecha_inicio,
                                              Fecha_fin = m.subasta.Fecha_fin,
                                          }).ToList();
        }
    }
    public void In_historico(EhistoricoSubasta historico)
    {
        using (var db = new mapeo())
        {
            db.Db_historico.Add(historico);
            db.SaveChanges();
        }
    }

    public List<ETbicicletas> OB_tiposB()
    {
        using (var db = new mapeo())
        {
            return (List<ETbicicletas>)db.Db_Tbicicletas.OrderBy(x => x.Id).ToList();
        }
    }
    public List<Efrenos> OB_tiposF()
    {
        using (var db = new mapeo())
        {
            return (List<Efrenos>)db.Db_frenos.OrderBy(x => x.Id).ToList();
        }
    }
    public List<Etalla> OB_TallasB()
    {
        using (var db = new mapeo())
        {
            return (List<Etalla>)db.Db_talla.OrderBy(x => x.Id).ToList();
        }
    }
    public List<Epiniones> OB_TiposPiniones()
    {
        using (var db = new mapeo())
        {
            return (List<Epiniones>)db.Db_piniones.OrderBy(x => x.Id).ToList();
        }
    }
    public void Ac_Subasta(Esubasta producto)
    {
        using (var db = new mapeo())
        {
            db.Db_subasta.Attach(producto);
            var entry = db.Entry(producto);
            entry.State = EntityState.Modified;
            db.SaveChanges();
        }
    }
    public void Ac_Catalogo(Ecatalogo catalogo)
    {
        using (var db = new mapeo())
        {
            db.Db_catalogo.Attach(catalogo);
            var entry = db.Entry(catalogo);
            entry.State = EntityState.Modified;
            db.SaveChanges();
        }
    }
    public void Ac_publicacion(Ecatalogo publicacion)
    {
        using (var db = new mapeo())
        {
            db.Db_catalogo.Attach(publicacion);
            var entry = db.Entry(publicacion);
            entry.State = EntityState.Modified;
            db.SaveChanges();
        }
    }
    public void Ac_tipoBiclas(ETbicicletas tipoBiclas)
    {
        using (var db = new mapeo())
        {
            db.Db_Tbicicletas.Attach(tipoBiclas);
            var entry = db.Entry(tipoBiclas);
            entry.State = EntityState.Modified;
            db.SaveChanges();
        }
    }
    public void Ac_tipoPiniones(Epiniones piniones)
    {
        using (var db = new mapeo())
        {
            db.Db_piniones.Attach(piniones);
            var entry = db.Entry(piniones);
            entry.State = EntityState.Modified;
            db.SaveChanges();
        }
    }
    public void Ac_tipofrenos(Efrenos frenos)
    {
        using (var db = new mapeo())
        {
            db.Db_frenos.Attach(frenos);
            var entry = db.Entry(frenos);
            entry.State = EntityState.Modified;
            db.SaveChanges();
        }
    }
    public void Ac_tallas(Etalla tallas)
    {
        using (var db = new mapeo())
        {
            db.Db_talla.Attach(tallas);
            var entry = db.Entry(tallas);
            entry.State = EntityState.Modified;
            db.SaveChanges();
        }
    }
    public Eusuarios ob_validado(int id)
    {
        using (var db = new mapeo())
        {
            return (Eusuarios)db.Db_usuarios.Where(x => x.Id == id).OrderBy(x => x.Id).FirstOrDefault(); ;
        }
    }
    public List<EdatalistProductos> OB_productosV()
    {
        using (var db = new mapeo())
        {
            return (List<EdatalistProductos>)(from productos in db.Db_catalogo
                                              join usuario in db.Db_usuarios on productos.IdVendedor equals usuario.Id
                                              select new
                                              {
                                                  productos,
                                                  usuario,
                                              }).Where(x => x.productos.Estado == 1).ToList().Select(m => new EdatalistProductos
                                              {

                                                  Image1 = m.productos.Imagen1,
                                                  Referencia = m.productos.Referencia,
                                                  Marca = m.productos.Marca,
                                                  Precio = m.productos.Precio,
                                                  Verificado = m.usuario.Validado,
                                              }).ToList();
        }
    }
    public Esubasta resubasta(int id)
    {
        using (var db = new mapeo())
        {
            return (Esubasta)db.Db_subasta.Where(x => x.Id_producto == id).FirstOrDefault();
        }
    }

    public List<EparticipacionSubasta> OB_datos_historico(int id)
    {
        using (var db = new mapeo())
        {
            return (List<EparticipacionSubasta>)(from historico in db.Db_historico
                                                 join usuario in db.Db_usuarios on historico.Id_comprador equals usuario.Id
                                                 select new
                                                 {
                                                     historico,
                                                     usuario,
                                                 }).Where(x => x.historico.Id_subasta == id).ToList().Select(m => new EparticipacionSubasta
                                                 {
                                                     NombreComprador = m.usuario.Nombre,
                                                     Valor = m.historico.Valor,
                                                 }).OrderByDescending(x => x.Valor).ToList();
        }
    }
}