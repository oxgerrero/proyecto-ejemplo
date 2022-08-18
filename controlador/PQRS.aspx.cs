using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class vista_PQRS : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void B_pqrs_Click(object sender, EventArgs e)
    {
        Ecatalogo producto = (Ecatalogo)Session["producto"];
        Eusuarios usuario = (Eusuarios)Session["usuario"];
        EPQRS pqrs = new EPQRS();
        pqrs.Id_publicacion = producto.Id;
        pqrs.Id_cliente_reporto = usuario.Id;
        pqrs.Status = 0;
        pqrs.Descripcion = TB_pqrs.Text;
        pqrs.Session = ""+usuario.Id;
        new PQRS().In_PQRS(pqrs);
        new PQRS().enviar_correo(pqrs);
        Response.Write("<script>alert('su reporte se realizo exitosamente, los administradores los revisaran prontamente');window.location = 'catalogo.aspx';</script>");

    }
}