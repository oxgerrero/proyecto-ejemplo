using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class vista_detallesSubasta : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Edatos_subasta datos = (Edatos_subasta)Session["producto_subasta"];
        I_Producto1.ImageUrl = datos.Imagen1;
        I_Producto2.ImageUrl = datos.Imagen2;
        I_Producto3.ImageUrl = datos.Imagen3;
        L_PrecioU.Text = ""+datos.Puja_alta;
        Label1.Text = datos.Marca;
        Label2.Text = datos.Referencia;
        Label3.Text = datos.Talla;
        Label4.Text = datos.TipoBicicleta;
        Label5.Text = datos.TipoFrenos;
        Label6.Text = ""+datos.N_piñones;
        TB_color.Text = datos.Color;
        Session["idSubasta"] = datos.Id;
    }

    protected void B_Atras_Click(object sender, EventArgs e)
    {
        Session["producto_subasta"] = null;
        Response.Redirect("subasta.aspx");
    }

    protected void B_comprar_Click(object sender, EventArgs e)
    {
        if (int.Parse(TB_oferta.Text) < int.Parse(L_PrecioU.Text))
        {
            Response.Write("<script>alert('no puedes ofertar un valor menor al precio base');</script>");
            return;
        }
        Edatos_subasta datos = (Edatos_subasta)Session["producto_subasta"];
        Eusuarios usuario = (Eusuarios)Session["usuario"];
        if (datos.Fecha_fin>DateTime.Now)
        {
            Esubasta subasta = new Esubasta();
            subasta = new catalogo().OB_subasta_id(datos.Id);
            subasta.Id_comprador = usuario.Id;
            subasta.Puja_alta = int.Parse(TB_oferta.Text);
            EhistoricoSubasta historico = new EhistoricoSubasta();
            historico.Id_comprador = usuario.Id;
            historico.Id_subasta = datos.Id;
            historico.Valor= int.Parse(TB_oferta.Text);
            new catalogo().Ac_Subasta(subasta);
            new catalogo().In_historico(historico);
            Response.Write("<script>alert('se a completado tu oferta');window.location = 'subasta.aspx';</script>");

        }
        else
        {
            Response.Write("<script>alert('no puedes ofertar, esta subasta ya termino');window.location = 'subasta.aspx';</script>");
        }
    }
}