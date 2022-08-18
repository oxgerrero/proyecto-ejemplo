using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class vista_plantilla : System.Web.UI.MasterPage
{
    int contador=0;
    protected void Page_Load(object sender, EventArgs e)
    {
        Eusuarios datos = (Eusuarios)Session["usuario"];
        if (datos != null)
        {
            Eusuarios user = new usuarios().login(datos.Usuario, datos.Contraseña);
            if (user != null)
            {
                Response.Redirect("catalogo.aspx");
            }
        }
        
    }
}
