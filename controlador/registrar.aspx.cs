using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class vista_registrar : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void B_registrar_Click(object sender, EventArgs e)
    {
        Eusuarios usuario = new Eusuarios();
        usuario.Nombre = TB_nombre.Text;
        usuario.Apellido = TB_apellido.Text;
        usuario.Email = TB_email.Text;
        usuario.Telefono = TB_telefono.Text;
        usuario.Usuario = TB_usuario.Text;
        usuario.Contraseña = TB_contraseña.Text;
        //comprovacion de existencia
        Eusuarios usuario2 = new Eusuarios();
        Eusuarios usuario3 = new Eusuarios();
        usuario2.Email = TB_email.Text;
        usuario3.Usuario = TB_usuario.Text;
        usuario2 = new usuarios().comprovar_email(usuario2);
        usuario3 = new usuarios().comprovar_usuario(usuario3);
        if ((usuario2 == null) && (usuario3 == null))
        {
            new usuarios().insertarUsuario(usuario);
            limpiarcampos();
            Response.Write("<script>alert('usuario registrado exitosamente');window.location = 'login.aspx';</script>");
        }
        else if(usuario3 != null)
        {
            FT_User.Text = "Usuario Ya existe";
        }
        else if (usuario2 != null)
        {
            FT_User.Text = "Correo Ya existe";
        }
    }

    public void limpiarcampos()
    {
        TB_nombre.Text="";
        TB_apellido.Text = "";
        TB_email.Text = "";
        TB_telefono.Text = "";
        TB_usuario.Text = "";
        TB_contraseña.Text = "";
    }
}