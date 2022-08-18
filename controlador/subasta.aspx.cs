using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class vista_subasta : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void B_subasatParticipar_Command(object sender, CommandEventArgs e)
    {
        int id = int.Parse(e.CommandArgument.ToString());
        List<Edatos_subasta> lista = new catalogo().OB_datos_subastas();
        foreach(var item in lista)
        {
            if(item.Id == id){
                Session["producto_subasta"] = item;
                Response.Redirect("detallesSubasta.aspx");
            }
        }
    }


}