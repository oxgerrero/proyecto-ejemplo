using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class vista_login : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void B_registrar_Click(object sender, EventArgs e)
    {
        Response.Redirect("registrar.aspx");
    }

    protected void B_login_Click(object sender, EventArgs e)
    {
        Eusuarios user= new usuarios().login(TB_usuario.Text, TB_contraseña.Text);
        if (user!=null)
        {
            if (user.Activo==1)
            {
                Session["usuario"] = user;
                Response.Redirect("catalogo.aspx");
                Session["nombrePB"] = null;
            }
            else
            {
                ClientScriptManager cm = this.ClientScript;
                cm.RegisterClientScriptBlock(this.GetType(), "", "<script type='text/javascript'>alert('usuario inactivo');</script>");
                TB_contraseña.Text = "";
                TB_usuario.Text = "";
                Session["usuario"]= null;
            }
        }
        else
        {
            ClientScriptManager cm = this.ClientScript;
            cm.RegisterClientScriptBlock(this.GetType(), "", "<script type='text/javascript'>alert('Usuario o contraseña invalidos');</script>");
            TB_contraseña.Text = "";
            TB_usuario.Text = "";
            return;
        }
        
    }
}