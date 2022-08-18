using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class vista_clientes : System.Web.UI.MasterPage
{
    public static bool carga = true;
    protected void Page_Load(object sender, EventArgs e)
    {
        Eusuarios datos = (Eusuarios)Session["usuario"];
        if (datos != null)
        {
            Eusuarios user = new usuarios().login(datos.Usuario, datos.Contraseña);
            if (user == null)
            {
                Response.Redirect("inicio.aspx");
            }
            else
            {
                if (user.Activo==1)
                {
                    Session["usuario"] = user;
                }
                else
                {
                    Session["usuario"] = null;
                    Response.Redirect("inicio.aspx");
                }
                L_info.Text = "Bienvenido " + datos.Nombre;
                
                if (user.Id_rol == 1 && carga)
                {
                    Button2.Visible = false;
                    Button3.Visible = false;
                    B_admin.Visible = true;
                    carga = false;
                    Response.Write("<script>alert('bienvenido desarrollador " + datos.Nombre + "');window.location = 'desarrollador.aspx';</script>");
                }
                if (user.Id_rol == 2 && carga)
                {
                    Button2.Visible = false;
                    Button3.Visible = false;
                    B_admin.Visible = true;
                    carga = false;
                    Response.Write("<script>alert('bienvenido administrador "+ datos.Nombre+"');window.location = 'administrador.aspx';</script>");
                }
                if (user.Id_rol==3)
                {
                    Button2.Visible = true;
                    Button3.Visible = true;
                    B_admin.Visible = false;
                }
                
            }
        }
        else
        {
            Response.Redirect("inicio.aspx");
        }
    }


    protected void B_salir_Click(object sender, EventArgs e)
    {
        Session["usuario"] = null;
        carga = true;
        Response.Redirect("inicio.aspx");
    }

    protected void Button2_Click(object sender, EventArgs e)
    {
        Response.Redirect("catalogo.aspx");
    }

    protected void Button3_Click(object sender, EventArgs e)
    {
        Response.Redirect("subasta.aspx");
    }

    protected void B_admin_Click(object sender, EventArgs e)
    {
        Response.Redirect("administrador.aspx");
    }
}
