using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class vista_Rcontraseña : System.Web.UI.Page
{

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            Session["Rtoken"] = Request.QueryString["tk"].ToString();
        }
        if(Session["Rtoken"] == null)
        {
            Response.Redirect("login.aspx");
        }
    }

    protected void B_confirmar_Click(object sender, EventArgs e)
    {
        string tk= Session["Rtoken"].ToString();
        token id=new usuarios().token_id_us(tk);
        Eusuarios us = new usuarios().id_us_usuario(id.Id_user);
        us.Contraseña = TB_Ncontraseña.Text;
        token to = new contraseña().validartoken(tk, us.Id);
        if (to.Fecha_fin > DateTime.Now)
        {
            new usuarios().Ac_User(us);
            Response.Redirect("login.aspx");
        }
        else
        {
            ClientScriptManager cm = this.ClientScript;
            cm.RegisterClientScriptBlock(this.GetType(), "", "<script type='text/javascript'>alert('Este token ya no es valido');</script>");

        }
    }
}