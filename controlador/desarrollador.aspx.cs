using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class vista_administrador : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Eusuarios datos = (Eusuarios)Session["usuario"];
        if (datos.Id_rol!=1)
        {
            Response.Write("<script>alert('Usted no puede estar aqui');window.location = 'catalogo.aspx';</script>");
        }

        
    }

    protected void Button4_Click(object sender, EventArgs e)
    {
        hilos rutina = new hilos();
        Thread hilo1=new Thread(rutina.enviar_correo1); 
        Thread hilo2= new Thread(rutina.enviar_correo2);
        if (hilo1.IsAlive)
        {
            hilo1.Abort();
        }
        else
        {
            hilo1 = new Thread(new ThreadStart(rutina.enviar_correo1));
            hilo1.Start();
        }
        if (hilo2.IsAlive)
        {
            hilo2.Abort();
        }
        else
        {
            hilo2 = new Thread(new ThreadStart(rutina.enviar_correo2));
            hilo2.Start();
        }

    }
}