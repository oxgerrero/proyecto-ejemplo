using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Twilio;
using Twilio.Rest.Api.V2010.Account;
using Twilio.Types;

public partial class vista_pago : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        { 
            try
            {
                string pr = new usuarios().DesEncriptar(Request.QueryString["pr"].ToString());
                string us = new usuarios().DesEncriptar(Request.QueryString["us"].ToString());
                Session["idpr"] = pr;
                Session["idus"] = us;
                int idpr = int.Parse(Session["idpr"].ToString());
                Ecatalogo producto = new catalogo().OB_producto_id(idpr);
                if (producto.Estado == 2)
                {
                    Response.Write("<script>alert('este pago ya se realizo');window.location ='catalogo.aspx';</script>");
                }
            }catch(Exception ex)
            {
                Response.Write("<script>window.location ='catalogo.aspx';</script>");
            }

        }
    }

    protected void Button1_Click(object sender, EventArgs e)
    {
        try
        {
            int idpr = int.Parse(Session["idpr"].ToString());
            int idus= int.Parse(Session["idus"].ToString());
            
            Ecatalogo producto = new catalogo().OB_producto_id(idpr);
            Eusuarios usuario = new usuarios().id_us_usuario(idus);
            Session["producto"] = producto;
            Session["usuario"] = usuario;
            Session["banco"] = TB_banco.Text;
            Session["numcuenta"] = TB_numeroCuenta.Text;
            var accountSid = "AC437e94ebb159ee933e85996bd356ce88";
            var authToken = "d2f04f3e9020e8cc7b598a6a92101fc7";
            TwilioClient.Init(accountSid, authToken);

            var messageOptions = new CreateMessageOptions(
            new PhoneNumber("+57"+usuario.Telefono));
            messageOptions.MessagingServiceSid = "MG26a1e66f416ef7b8ba4f437f14efb730";
            messageOptions.Body = "su codigo de verificacion para el pago es " + "691174" + " el valor del pago es de $" + producto.Precio + " realizado a la cuenta bancaria de " + TB_banco.Text + " numero " + TB_numeroCuenta.Text;

            var message = MessageResource.Create(messageOptions);
            Console.WriteLine(message.Body);
            Panel2.Visible = true;
            Panel1.Visible = false;
        }
        catch
        {
            Panel2.Visible = true;
            Panel1.Visible = false;
        }
    }

    protected void Button2_Click(object sender, EventArgs e)
    {
        if (TB_codigo.Text.Equals("691174"))
        {
            Ecatalogo producto = ((Ecatalogo)Session["producto"]);
            Eusuarios usuario = ((Eusuarios)Session["usuario"]);
            producto.IdComprador = usuario.Id;
            producto.Estado = 2;
            new catalogo().Ac_Catalogo(producto);
            new contraseña().enviarmail_compra1(usuario,producto);
            new contraseña().enviarmail_compra2(producto);
            Response.Write("<script>alert('su pago se realizo exitosamente');window.location = 'tarjeta.aspx';</script>");
        }
        else
        {
            Response.Write("<script>alert('codigo de verificacion erroneo');window.location = 'catalogo.aspx';</script>");

        }

    }
}