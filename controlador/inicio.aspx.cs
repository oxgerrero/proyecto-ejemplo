using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class vista_inicio : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            Session["nombrePB"] = null;
            Session["valido"] = true;
        }
    }

    protected void IB_Productos_Command(object sender, CommandEventArgs e)
    {
        if (e.CommandName != null)
        {
            Ecatalogo producto = new catalogo().producto_click(e.CommandArgument.ToString());
            Session["producto"] = producto;
            Session["contador"] = 1;
            Eusuarios datos = (Eusuarios)Session["usuario"];
            if (datos != null)
            {
                Eusuarios user = new usuarios().login(datos.Usuario, datos.Contraseña);
                if (user == null)
                {
                    Response.Write("<script>alert('Inicie sesion para continuar');window.location = 'login.aspx';</script>");
                }
                else
                {
                    Response.Redirect("producto.aspx");
                }
            }
            else
            {
                Response.Write("<script>alert('Inicie sesion para continuar');window.location = 'login.aspx';</script>");
            }
        }
    }

    protected void ImageButton1_Command(object sender, CommandEventArgs e)
    {
        if (e.CommandName != null)
        {
            Ecatalogo producto = new catalogo().producto_click(e.CommandArgument.ToString());
            Session["producto"] = producto;
            Session["contador"] = 1;
            Eusuarios datos = (Eusuarios)Session["usuario"];
            if (datos != null)
            {
                Eusuarios user = new usuarios().login(datos.Usuario, datos.Contraseña);
                if (user == null)
                {
                    Response.Write("<script>alert('Inicie sesion para continuar');window.location = 'login.aspx';</script>");
                }
                else
                {
                    Response.Redirect("producto.aspx");
                }
            }
            else
            {
                Response.Write("<script>alert('Inicie sesion para continuar');window.location = 'login.aspx';</script>");
            }
        }
    }

    protected void RegularExpressionValidator1_DataBinding(object sender, EventArgs e)
    {
        if (RegularExpressionValidator1.IsValid)
        {
            Session["valido"] = true;
        }
        else
        {
            Session["valido"] = false;
        }
    }
    protected void B_buscar_Click1(object sender, EventArgs e)
    {
         Session["nombrePB"] = TB_buscar.Text;
         DL_Productos.DataBind();
    }

    public void sololetras(object sender, EventArgs e)
    {

    }
}