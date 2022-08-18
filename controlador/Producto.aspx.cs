using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class vista_Producto : System.Web.UI.Page
{
    public static int contador;
    protected void Page_Load(object sender, EventArgs e)
    {
        String imagen1 = ((Ecatalogo)Session["producto"]).Imagen1;
        String imagen2 = ((Ecatalogo)Session["producto"]).Imagen2;
        String imagen3 = ((Ecatalogo)Session["producto"]).Imagen3;
        I_Producto1.ImageUrl = imagen1;
        I_Producto2.ImageUrl = imagen2;
        I_Producto3.ImageUrl = imagen3;
        L_PrecioU.Text = (((Ecatalogo)Session["producto"]).Precio).ToString();
        Label1.Text = (((Ecatalogo)Session["producto"]).Marca).ToString();
        Label2.Text = (((Ecatalogo)Session["producto"]).Referencia).ToString();
        Label3.Text = (((Ecatalogo)Session["producto"]).Talla).ToString();
        Label4.Text = (((Ecatalogo)Session["producto"]).TipoBicicleta).ToString();
        Label5.Text = (((Ecatalogo)Session["producto"]).TipoFrenos).ToString();
        Label6.Text = (((Ecatalogo)Session["producto"]).N_piñones).ToString();
        TB_color.Text = (((Ecatalogo)Session["producto"]).Color).ToString();
    }

    
    protected void B_Atras_Click(object sender, EventArgs e)
    {
        Session["producto"] = null;
        Response.Redirect("catalogo.aspx");
    }

    protected void B_comprar_Click(object sender, EventArgs e)
    {
        Ecatalogo producto = ((Ecatalogo)Session["producto"]);
        Eusuarios usuario = ((Eusuarios)Session["usuario"]);
        string pr = new usuarios().Encriptar(producto.Id.ToString());
        string us = new usuarios().Encriptar(usuario.Id.ToString());
        Response.Write("<script>alert('sera redirigido para continuar con el pago');window.location = 'pago.aspx?pr="+pr+"&us="+us+"';</script>");

    }
}