using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Drawing;
using System.Windows;

public partial class vista_tarjeta : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            DataSet inf = llenartarjeta();
            CRS_TarjetaPropiedad.ReportDocument.SetDataSource(inf);
            CrystalReportViewer1.ReportSource = CRS_TarjetaPropiedad;
            DataSet inff = llenarfactura();
            CRS_factura.ReportDocument.SetDataSource(inff);
            CrystalReportViewer2.ReportSource = CRS_factura;
        }
        catch (Exception exc)
        {
            System.Console.WriteLine("error: " + exc);

        }
    }
    protected DataSet llenartarjeta()
    {
        tarjeta_Propiedad reporte = new tarjeta_Propiedad();
        DataRow fila;
        DataTable informacion = reporte.datosPersonales;
        Eusuarios user = (Eusuarios)Session["usuario"];
        Ecatalogo producto = ((Ecatalogo)Session["producto"]);
        fila = informacion.NewRow();
        fila["Propietario"] = user.Nombre;
        fila["Documento"] = user.Telefono;
        fila["Marca"] = producto.Marca;
        fila["Referencia"] = producto.Referencia;
        fila["Modelo"] = producto.Anio.Year;
        Color color = ColorTranslator.FromHtml(producto.Color);
        Color colorfin = Color.FromArgb(color.R,color.G,color.B);
        fila["Color"] = colorfin.Name;
        fila["Serie"] = "LM2647LK15";
        informacion.Rows.Add(fila);
        
        return reporte;
    }
    protected DataSet llenarfactura()
    {
        factura reporte = new factura();
        DataRow fila;
        DataTable informacion = reporte._factura;
        Eusuarios user = (Eusuarios)Session["usuario"];
        Ecatalogo producto = ((Ecatalogo)Session["producto"]);
        string banco=Session["banco"].ToString();
        string cuenta= Session["numcuenta"].ToString();
        fila = informacion.NewRow();
        fila["Nombrecliente"] = user.Nombre.ToString();
        fila["PrecioProducto"] = producto.Precio.ToString();
        fila["PagoCuenta"] = cuenta.ToString();
        fila["PagoBanco"] = banco.ToString();
        informacion.Rows.Add(fila);

        return reporte;
    }

    protected void Button1_Click(object sender, EventArgs e)
    {
        Response.Redirect("catalogo.aspx");
    }
}