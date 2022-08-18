using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class vista_insertar : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        
    }

    protected void B_guardar_Click(object sender, EventArgs e)
    {
        try
        {
            ClientScriptManager cm = this.ClientScript;
            Ecatalogo guardar = new Ecatalogo();
            guardar.IdVendedor = (((Eusuarios)Session["usuario"]).Id);
            //guardar.IdComprador
            guardar.Precio = int.Parse(TB_precio.Text);
            guardar.Marca = TB_marca.Text;
            guardar.Referencia = TB_referencia.Text;
            guardar.Anio = DateTime.Parse(TB_anio.Text);
            guardar.TipoBicicleta = DDL_TBicla.Text;
            guardar.TipoFrenos = DDL_TFrenos.Text;
            guardar.N_piñones = DDL_piniones.Text;
            guardar.Color = TB_color.Text;
            guardar.FechaRevicion = DateTime.Parse(TB_fechaRevicion.Text);
            guardar.Ciudad = TB_ciudad.Text;
            guardar.Talla = DDL_talla.Text;
            guardar.Estado = 1;
            guardar.Session = (((Eusuarios)Session["usuario"]).Id).ToString();
            guardar.Modified_by = DateTime.Now;
            var guid = Guid.NewGuid();
            string saveLocation;
            //1
            string name = System.IO.Path.GetFileName(FU_imagenes0.PostedFile.FileName);
            string extension1 = System.IO.Path.GetExtension(FU_imagenes0.PostedFile.FileName);
            saveLocation = Server.MapPath("~\\publicaciones") + "\\" + guid + extension1;
            guardar.Imagen1 = "~\\publicaciones" + "\\" + guid + extension1;
            if (!(extension1.Equals(".jpg") || extension1.Equals(".jpeg") || extension1.Equals(".png") ))
            {
                cm.RegisterClientScriptBlock(this.GetType(), "", "<script type='text/javascript'>alert('Tipo de archivo no valido');</script>");
                return;
            }

            if (System.IO.File.Exists(saveLocation))
            {
                cm.RegisterClientScriptBlock(this.GetType(), "", "<script type='text/javascript'>alert('Ya existe un archivo en el servidor con ese nombre (imagen 1)');</script>");
                return;
            }
            FU_imagenes0.PostedFile.SaveAs(saveLocation);
            //2
            guid = Guid.NewGuid();
            string extension2 = System.IO.Path.GetExtension(FU_imagenes1.PostedFile.FileName);
            saveLocation = Server.MapPath("~\\publicaciones") + "\\" + guid + extension2;
            guardar.Imagen2 = "~\\publicaciones" + "\\" + guid + extension2;

            if (!(extension2.Equals(".jpg") || extension2.Equals(".jpeg") || extension2.Equals(".png")))
            {
                cm.RegisterClientScriptBlock(this.GetType(), "", "<script type='text/javascript'>alert('Tipo de archivo no valido');</script>");
                return;
            }
            if (System.IO.File.Exists(saveLocation))
            {
                cm.RegisterClientScriptBlock(this.GetType(), "", "<script type='text/javascript'>alert('Ya existe un archivo en el servidor con ese nombre (imagen 2)');</script>");
                return;
            }
            FU_imagenes1.PostedFile.SaveAs(saveLocation);
            //3
            guid = Guid.NewGuid();
            string extension3 = System.IO.Path.GetExtension(FU_imagenes2.PostedFile.FileName);
            saveLocation = Server.MapPath("~\\publicaciones") + "\\" + guid + extension3;
            guardar.Imagen3 = "~\\publicaciones" + "\\" + guid + extension3;

            if (!(extension3.Equals(".jpg") || extension3.Equals(".jpeg") || extension3.Equals(".png")))
            {
                cm.RegisterClientScriptBlock(this.GetType(), "", "<script type='text/javascript'>alert('Tipo de archivo no valido');</script>");
                return;
            }
            if (System.IO.File.Exists(saveLocation))
            {
                cm.RegisterClientScriptBlock(this.GetType(), "", "<script type='text/javascript'>alert('Ya existe un archivo en el servidor con ese nombre (imagen 3)');</script>");
                return;
            }
            FU_imagenes2.PostedFile.SaveAs(saveLocation);

            try
            {
                new catalogo().insertarArchivo(guardar);
                Response.Write("<script>alert('Archivo guardado');window.location = 'catalogo.aspx';</script>");
            }
            catch (Exception exc)
            {
                System.Diagnostics.Debug.WriteLine("aqui ." + exc);
                cm.RegisterClientScriptBlock(this.GetType(), "", "<script type='text/javascript'>alert('Error: ');</script>");
            }
        }
        catch(Exception eyt)
        {
            System.Diagnostics.Debug.WriteLine("aqui ." + eyt);
        }
        
    }

    protected void B_Atras_Click(object sender, EventArgs e)
    {
        Response.Redirect("catalogo.aspx");
    }
}