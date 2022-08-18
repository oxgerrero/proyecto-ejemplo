using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class vista_catalogo : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            Session["nombrePB"] = null;
            Session["valido"] = true;
        }
    }


    protected void B_insertar_Click(object sender, EventArgs e)
    {
        Response.Redirect("insertar.aspx");

    }

    protected void IB_Productos_Command(object sender, CommandEventArgs e)
    {
        if (e.CommandName != null)
        {
            Ecatalogo producto = new catalogo().producto_click(e.CommandArgument.ToString());
            Session["producto"] = producto;
            Session["contador"] = 1;
            Response.Redirect("producto.aspx");
        }
    }



    protected void ImageButton1_Command(object sender, CommandEventArgs e)
    {
        if (e.CommandName != null)
        {
            Ecatalogo producto = new catalogo().producto_click(e.CommandArgument.ToString());
            Session["producto"] = producto;
            Response.Redirect("producto.aspx");
        }
    }

    protected void B_buscar_Click(object sender, EventArgs e)
    {
        Session["nombrePB"] = TB_buscar.Text;
        DL_Productos.DataBind();
    }
}