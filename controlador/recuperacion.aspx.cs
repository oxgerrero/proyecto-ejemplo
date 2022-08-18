using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class vista_recuperacion : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void B_recuperar_Click(object sender, EventArgs e)
    {
        string user = TB_user.Text;
        usuarios datos = new usuarios();
        Eusuarios Rusuario = datos.contraseña(user);
        contraseña rec = new contraseña();
        token Otoken = new token();
        Otoken.Fecha_inicio = DateTime.Now;
        Otoken.Fecha_fin = DateTime.Now.AddMinutes(10);
        Otoken.Id_user = Rusuario.Id;
        Otoken.Tactivo = rec.encriptar(JsonConvert.SerializeObject(Otoken));//convierte en cadena JSON clase Token obj token
        datos.insertarRusuario(Otoken);
        string linkacceso = Otoken.Tactivo;
        rec.enviarmail(Rusuario.Email, Otoken.Tactivo, linkacceso);
        Session["Rtoken"] = Otoken;
        Session["Rusuario"] = Rusuario;

    }
}