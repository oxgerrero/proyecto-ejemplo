using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class vista_administrador : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Eusuarios datos = (Eusuarios)Session["usuario"];
        if (datos.Id_rol!=2)
        {
            Response.Write("<script>alert('Usted no puede estar aqui');window.location = 'catalogo.aspx';</script>");
        }
    }


    protected void B_tipoBicla_Click(object sender, EventArgs e)
    {
        ETbicicletas tipoBicla = new ETbicicletas();
        tipoBicla.Descripcion = TB_tipoB.Text;
        new bicicletas().insertarTipoBicileta(tipoBicla);
        GV_tipoBiclas.DataBind();
    }

    protected void B_tipoPinion_Click(object sender, EventArgs e)
    {
        Epiniones pinion = new Epiniones();
        pinion.Descripcion = TB_tipoPinion.Text;
        new bicicletas().insertarTipoPiniones(pinion);
        GV_piniones.DataBind();
    }

    protected void B_tipoFrenos_Click(object sender, EventArgs e)
    {
        Efrenos frenos = new Efrenos();
        frenos.Descripcion = TB_tipoFrenos.Text;
        new bicicletas().insertarTipoFrenos(frenos);
        GV_frenos.DataBind();
    }

    protected void B_tallas_Click(object sender, EventArgs e)
    {
        Etalla tallas = new Etalla();
        tallas.Descripcion = TB_tallas.Text;
        new bicicletas().insertarTallas(tallas);
        GV_tallas.DataBind();
    }

    protected void GV_publicaciones_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
        Ecatalogo catalogo =new Ecatalogo();
        catalogo.Id = int.Parse(e.NewValues[0].ToString());
        catalogo.Precio = int.Parse(e.NewValues[1].ToString());
        catalogo.TipoBicicleta = (String)e.NewValues[2];
        catalogo.Talla = (String)e.NewValues[3];
        catalogo.N_piñones = (String)e.NewValues[4];
        catalogo.Referencia = (String)e.NewValues[5];
        catalogo.Marca = (String)e.NewValues[6];
        catalogo.Anio = DateTime.Parse(e.NewValues[7].ToString());
        catalogo.TipoFrenos = (String)e.NewValues[8];
        catalogo.FechaRevicion = DateTime.Parse(e.NewValues[9].ToString());
        catalogo.Ciudad = (String)e.NewValues[10];
        catalogo.Estado = int.Parse(e.NewValues[11].ToString());

        catalogo.Anio = Convert.ToDateTime(catalogo.Anio);
        catalogo.FechaRevicion = Convert.ToDateTime(catalogo.FechaRevicion);
    }

    protected void GV_publicaciones_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        Ecatalogo catalogo = (Ecatalogo)e.Row.DataItem; 
        if (catalogo != null)
        {
            if (e.Row.FindControl("LB_Editar") != null)
            {
                ((Label)e.Row.FindControl("L_anio")).Text = catalogo.Anio.ToString("yyyy-MM-dd");
                ((Label)e.Row.FindControl("L_fechaRevicion")).Text = catalogo.FechaRevicion.ToString("yyyy-MM-dd");
            }
        }
    }
    protected void GV_usuarios_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        
    }
}