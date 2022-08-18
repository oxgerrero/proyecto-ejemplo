using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class vista_editar : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Ecatalogo bike = (Ecatalogo)Session["producto"];
        
        TB_editarMarca.Text = bike.Marca;
        TB_editarReferencia.Text = bike.Referencia;
        TB_editarPrecio.Text = (bike.Precio).ToString();
        TB_editarAnio.Text = (bike.Anio).ToString("yyyy-MM-dd");
        TB_editarFechaR.Text = (bike.FechaRevicion).ToString("yyyy-MM-dd");
        TB_editarColor.Text = bike.Color;
        TB_editarCiudad.Text = bike.Ciudad;
    }

    protected void B_Atras_Click(object sender, EventArgs e)
    {
        Response.Redirect("perfil.aspx");
    }
    protected void DDL_Tbicla_DataBound(object sender, EventArgs e)
    {
        Ecatalogo bike = (Ecatalogo)Session["producto"];
        List<ETbicicletas> lista = new bicicletas().tipoBicicletas();
        String valor = "";
        foreach (var item in lista)
        {
            if (item.Descripcion.Equals(bike.TipoBicicleta))
            {
                valor = item.Descripcion;
            }
        }
        DDL_Tbicla.SelectedValue = valor;
    }

    protected void DDL_talla_DataBound(object sender, EventArgs e)
    {
        Ecatalogo bike = (Ecatalogo)Session["producto"];
        List<Etalla> lista = new bicicletas().talla();
        String valor = "";
        foreach (var item in lista)
        {
            if (item.Descripcion.Equals(bike.Talla))
            {
                valor = item.Descripcion;
            }
        }
        DDL_talla.SelectedValue = valor;
    }

    protected void DDL_frenos_DataBound(object sender, EventArgs e)
    {
        Ecatalogo bike = (Ecatalogo)Session["producto"];
        List<Efrenos> lista = new bicicletas().tipoFrenos();
        String valor = "";
        foreach (var item in lista)
        {
            if (item.Descripcion.Equals(bike.TipoFrenos))
            {
                valor = item.Descripcion;
            }
        }
        DDL_frenos.SelectedValue = valor;
    }

    protected void DDL_piniones_DataBound(object sender, EventArgs e)
    {
        Ecatalogo bike = (Ecatalogo)Session["producto"];
        List<Epiniones> lista = new bicicletas().tipoPiniones();
        String valor="";
        foreach (var item in lista)
        {
            if (item.Descripcion.Equals(bike.N_piñones))
            {
                valor = item.Descripcion;
            }
        }
        DDL_piniones.SelectedValue = valor;
    }

    protected void B_guardar_Click(object sender, EventArgs e)
    {
        Ecatalogo bike = (Ecatalogo)Session["producto"];
        Ecatalogo nuevo = bike;
        nuevo.Marca = TB_editarMarca.Text;
        nuevo.Talla = DDL_talla.SelectedValue;
        nuevo.Referencia = TB_editarReferencia.Text;
        nuevo.TipoBicicleta = DDL_Tbicla.SelectedValue;
        nuevo.TipoFrenos = DDL_frenos.SelectedValue;
        nuevo.N_piñones = DDL_piniones.SelectedValue;
        nuevo.Precio = int.Parse(TB_editarPrecio.Text);
        nuevo.Anio = DateTime.Parse(TB_editarAnio.Text);
        nuevo.FechaRevicion = DateTime.Parse(TB_editarFechaR.Text);
        nuevo.Color = TB_editarColor.Text;
        nuevo.Ciudad = TB_editarCiudad.Text;

        new catalogo().Ac_Catalogo(nuevo);
        Response.Write("<script>alert('publicacion actualizado exitosamente');window.location = 'perfil.aspx';</script>");
    }
}