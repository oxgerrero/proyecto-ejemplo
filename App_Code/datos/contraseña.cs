using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Mail;
using System.Security.Cryptography;
using System.Text;
using System.Web;

/// <summary>
/// Descripción breve de contraseña
/// </summary>
public class contraseña
{

    public token validartoken(string token, int id)
    {
        return new mapeo().Db_token.Where(x => x.Tactivo == token && x.Id_user == id).FirstOrDefault();
    }

    public string encriptar(string input)
    {
        SHA256CryptoServiceProvider provider = new SHA256CryptoServiceProvider();
        byte[] inputBytes = Encoding.UTF8.GetBytes(input);
        byte[] hashedBytes = provider.ComputeHash(inputBytes);
        StringBuilder output = new StringBuilder();

        for (int i = 0; i < hashedBytes.Length; i++)
        {
            output.Append(hashedBytes[i].ToString("x2").ToLower());
        }
        return output.ToString();
    }

    internal void enviarmailPQRS(string correo, EPQRS pqrs)
    {
        //mail
        string correol = "<body>"
+ "<table class='es-wrapper' width='100%' cellspacing='0' cellpadding='0'>"
+ "<tr>"
+ "<td class='esd-block-banner' style='position: relative;' align='center' esdev-config='h1'><a target='_blank'><img class='adapt-img esdev-stretch-width esdev-banner-rendered' src='https://www.nicepng.com/png/full/414-4144393_en-virtud-de-su-misin-2015-se-busca.png' alt title style='display: block;' width='100%'></a>"
+ "</td>"
+ "</tr>"
+ "<tr>"
+ "<tr>"
+ "<td class='esd-block-text es-p15t es-p15b es-p20r es-p20l' bgcolor='transparent' align='center'>"
+ "<h2 style='color: #333333;'>" + "Señor Administrador \n</h2>"
+ "</td>"
+ "</tr>"
+ "<tr>"
+ "<td class='esd-block-text es-p15b es-p30r es-p30l' bgcolor='transparent' align='center'>"
+ "<h3 style='line-height: 150%;'><em>El usuario " + pqrs.Id_cliente_reporto + " reporto la publicacion " + pqrs.Id_publicacion + " \npor que " + pqrs.Descripcion + " ingrese para revisar</em></h3>"
+ "</td>"
+ "</tr>"
+ "</tr>"
+ "<tr>"
+ "<tr>"
+ "<td class='esd-block-image' align='center' style='font-size:0'><a target='_blank'><img class='adapt-img' src='http://catdelune.files.wordpress.com/2013/06/18226884-conjunto-de-elementos-decorativos-bordes-y-el-marco-de-pagina-de-las-reglas.png' alt style='display: block;' width='600'></a>"
+ "</td>"
+ "</tr>"
+ "</tr>"
+ "</table>"
+ "</body>";
        MailMessage mail = new MailMessage();
        SmtpClient SmtpSever = new SmtpClient("smtp.gmail.com");
        mail.IsBodyHtml = true;
        mail.From = new MailAddress("dg1342732@gmail.com", "PQRS");//correo que envia, diplay name
        SmtpSever.Host = "smtp.gmail.com";//servidor gmail
        mail.Subject = "PQRS";//asunto
        mail.Body = correol;
        mail.To.Add(correo);//destino del correo
        mail.Priority = MailPriority.High;

        //Configuracion del SMTP
        SmtpSever.Port = 587;
        SmtpSever.Credentials = new System.Net.NetworkCredential("dg1342732@gmail.com", "oxgerrero");//correo origen, contra*
        SmtpSever.EnableSsl = true;
        SmtpSever.Send(mail);//eviar
                             //mail
    }

    public void enviarmail(string correodestino, string usertoken, string linkacceso)
    {
        //mail
        string correol = "<body>"
+ "<table class='es-wrapper' width='100%' cellspacing='0' cellpadding='0'>"
+ "<tr>"
+ "<td class='esd-block-banner' style='position: relative;' align='center' esdev-config='h1'><a target='_blank'><img class='adapt-img esdev-stretch-width esdev-banner-rendered' src='https://www.nicepng.com/png/full/414-4144393_en-virtud-de-su-misin-2015-se-busca.png' alt title style='display: block;' width='100%'></a>"
+ "</td>"
+ "</tr>"
+ "<tr>"
+ "<tr>"
+ "<td class='esd-block-text es-p15t es-p15b es-p20r es-p20l' bgcolor='transparent' align='center'>"
+ "<h2 style='color: #333333;'>" + "Señor Usuario \n</h2>"
+ "</td>"
+ "</tr>"
+ "<tr>"
+ "<td class='esd-block-text es-p15b es-p30r es-p30l' bgcolor='transparent' align='center'>"
+ "<h3 style='line-height: 150%;'><em>Usted a solicitado un recuperacion de contraseña, utilice este codigo para recuperar su contraseña ahoramismo.\n" +
        "Cuenta con diez (10) minutos para hacer valida la recuperacion.\n" + "su codigo de acceso es \n" + " <a href='http://localhost:58812/vista/Rcontraseña.aspx?tk=" + linkacceso + "'>" + "RECUPERAR" + "</a></em></h3>"
+ "</td>"
+ "</tr>"
+ "</tr>"
+ "<tr>"
+ "<tr>"
+ "<td class='esd-block-image' align='center' style='font-size:0'><a target='_blank'><img class='adapt-img' src='http://catdelune.files.wordpress.com/2013/06/18226884-conjunto-de-elementos-decorativos-bordes-y-el-marco-de-pagina-de-las-reglas.png' alt style='display: block;' width='600'></a>"
+ "</td>"
+ "</tr>"
+ "</tr>"
+ "</table>"
+ "</body>";
        MailMessage mail = new MailMessage();
        SmtpClient SmtpSever = new SmtpClient("smtp.gmail.com");
        mail.IsBodyHtml = true;
        mail.From = new MailAddress("dg1342732@gmail.com", "Recuperacion contrasena");//correo que envia, diplay name
        SmtpSever.Host = "smtp.gmail.com";//servidor gmail
        mail.Subject = "Recupere su contraseña";//asunto
        mail.Body = correol;
        mail.To.Add(correodestino);//destino del correo
        mail.Priority = MailPriority.Normal;

        //Configuracion del SMTP
        SmtpSever.Port = 587;
        SmtpSever.Credentials = new System.Net.NetworkCredential("dg1342732@gmail.com", "oxgerrero");//correo origen, contra*
        SmtpSever.EnableSsl = true;
        SmtpSever.Send(mail);//eviar
                             //mail

    }

    public void enviarmail_compra2(Ecatalogo producto)
    {
        Eusuarios usuario = new usuarios().datos_usuario_log(producto.IdVendedor);
        //mail comprador subasta comprada
        string correol = "<body>"
+ "<table class='es-wrapper' width='100%' cellspacing='0' cellpadding='0'>"
+ "<tr>"
+ "<td class='esd-block-banner' style='position: relative;' align='center' esdev-config='h1'><a target='_blank'><img class='adapt-img esdev-stretch-width esdev-banner-rendered' src='https://www.nicepng.com/png/full/414-4144393_en-virtud-de-su-misin-2015-se-busca.png' alt title style='display: block;' width='100%'></a>"
+ "</td>"
+ "</tr>"
+ "<tr>"
+ "<tr>"
+ "<td class='esd-block-text es-p15t es-p15b es-p20r es-p20l' bgcolor='transparent' align='center'>"
+ "<h2 style='color: #333333;'>Señor usuario \t" + usuario.Nombre + "\n</h2>"
+ "</td>"
+ "</tr>"
+ "<tr>"
+ "<td class='esd-block-text es-p15b es-p30r es-p30l' bgcolor='transparent' align='center'>"
+ "<h3 style='line-height: 150%;'><em>su bicicleta " + producto.Referencia + " a sido vendida exitosamente por favor enviar</a></em></h3>"
+ "</td>"
+ "</tr>"
+ "</tr>"
+ "<tr>"
+ "<tr>"
+ "<td class='esd-block-image' align='center' style='font-size:0'><a target='_blank'><img class='adapt-img' src='http://catdelune.files.wordpress.com/2013/06/18226884-conjunto-de-elementos-decorativos-bordes-y-el-marco-de-pagina-de-las-reglas.png' alt style='display: block;' width='600'></a>"
+ "</td>"
+ "</tr>"
+ "</tr>"
+ "</table>"
+ "</body>";
        MailMessage mail = new MailMessage();
        SmtpClient SmtpSever = new SmtpClient("smtp.gmail.com");
        mail.IsBodyHtml = true;
        mail.From = new MailAddress("dg1342732@gmail.com", "Compra de bicicleta");//correo que envia, diplay name
        SmtpSever.Host = "smtp.gmail.com";//servidor gmail
        mail.Subject = "Pago realizado";//asunto
        mail.Body = correol;
        mail.To.Add(usuario.Email);//destino del correo
        mail.Priority = MailPriority.Normal;

        //Configuracion del SMTP
        SmtpSever.Port = 587;
        SmtpSever.Credentials = new System.Net.NetworkCredential("dg1342732@gmail.com", "oxgerrero");//correo origen, contra*
        SmtpSever.EnableSsl = true;
        SmtpSever.Send(mail);//eviar
                             //mail
    }

    public void enviarmail_compra1(Eusuarios usuario, Ecatalogo producto)
    {
        string correo = "<body>"
+ "<table class='es-wrapper' width='100%' cellspacing='0' cellpadding='0'>"
+ "<tr>"
+ "<td class='esd-block-banner' style='position: relative;' align='center' esdev-config='h1'><a target='_blank'><img class='adapt-img esdev-stretch-width esdev-banner-rendered' src='https://www.nicepng.com/png/full/414-4144393_en-virtud-de-su-misin-2015-se-busca.png' alt title style='display: block;' width='100%'></a>"
+ "</td>"
+ "</tr>"
+ "<tr>"
+ "<tr>"
+ "<td class='esd-block-text es-p15t es-p15b es-p20r es-p20l' bgcolor='transparent' align='center'>"
+ "<h2 style='color: #333333;'>" + "Señor usuario \t" + usuario.Nombre + "\n</h2>"
+ "<h2 style='color: #333333;'>asunto</h2>"
+ "</td>"
+ "</tr>"
+ "<tr>"
+ "<td class='esd-block-text es-p15b es-p30r es-p30l' bgcolor='transparent' align='center'>"
+ "<h3 style='line-height: 150%;'><em>su pago a sido exitoso muy pronto recibira su bicicleta " + producto.Referencia + "</em></h3>"
+ "</td>"
+ "</tr>"
+ "</tr>"
+ "<tr>"
+ "<tr>"
+ "<td class='esd-block-image' align='center' style='font-size:0'><a target='_blank'><img class='adapt-img' src='http://catdelune.files.wordpress.com/2013/06/18226884-conjunto-de-elementos-decorativos-bordes-y-el-marco-de-pagina-de-las-reglas.png' alt style='display: block;' width='600'></a>"
+ "</td>"
+ "</tr>"
+ "</tr>"
+ "</table>"
+ "</body>";
        MailMessage mail = new MailMessage();
        SmtpClient SmtpSever = new SmtpClient("smtp.gmail.com");
        mail.IsBodyHtml = true;
        mail.From = new MailAddress("dg1342732@gmail.com", "Compra de bicicleta");//correo que envia, diplay name
        SmtpSever.Host = "smtp.gmail.com";//servidor gmail
        mail.Subject = "Pago realizado";//asunto
        mail.Body = correo; 
        mail.To.Add(usuario.Email);//destino del correo
        mail.Priority = MailPriority.Normal;

        //Configuracion del SMTP
        SmtpSever.Port = 587;
        SmtpSever.Credentials = new System.Net.NetworkCredential("dg1342732@gmail.com", "oxgerrero");//correo origen, contra*
        SmtpSever.EnableSsl = true;
        SmtpSever.Send(mail);//eviar
                             //mail
    }

    public void enviarmailhilo(Esubasta item)
    {
        Ecorreo_subasta f = ob_datos(item.Id,true);
        //mail vendedor subasta no vendida
        string correol = "<body>"
+ "<table class='es-wrapper' width='100%' cellspacing='0' cellpadding='0'>"
+ "<tr>"
+ "<td class='esd-block-banner' style='position: relative;' align='center' esdev-config='h1'><a target='_blank'><img class='adapt-img esdev-stretch-width esdev-banner-rendered' src='https://www.nicepng.com/png/full/414-4144393_en-virtud-de-su-misin-2015-se-busca.png' alt title style='display: block;' width='100%'></a>"
+ "</td>"
+ "</tr>"
+ "<tr>"
+ "<tr>"
+ "<td class='esd-block-text es-p15t es-p15b es-p20r es-p20l' bgcolor='transparent' align='center'>"
+ "<h2 style='color: #333333;'>Señor usuario \t" + f.Nombre + "\n</h2>"
+ "</td>"
+ "</tr>"
+ "<tr>"
+ "<td class='esd-block-text es-p15b es-p30r es-p30l' bgcolor='transparent' align='center'>"
+ "<h3 style='line-height: 150%;'><em>su subasta a terminado y no recibio oferta alguna por lo tanto su publicacion esta disponible para comprar de modo normal\n"
            + "si desea volver a subastar se le reducira un 13% \n"
            + "Detalles de la subasta\n"
            + "Referencia de la bicicleta: " + f.Referencia
            + "precio de la subasta: " + item.Puja_alta +"</a></em></h3>"
+ "</td>"
+ "</tr>"
+ "</tr>"
+ "<tr>"
+ "<tr>"
+ "<td class='esd-block-image' align='center' style='font-size:0'><a target='_blank'><img class='adapt-img' src='http://catdelune.files.wordpress.com/2013/06/18226884-conjunto-de-elementos-decorativos-bordes-y-el-marco-de-pagina-de-las-reglas.png' alt style='display: block;' width='600'></a>"
+ "</td>"
+ "</tr>"
+ "</tr>"
+ "</table>"
+ "</body>";
        MailMessage mail = new MailMessage();
        SmtpClient SmtpSever = new SmtpClient("smtp.gmail.com");
        mail.IsBodyHtml = true;
        mail.From = new MailAddress("dg1342732@gmail.com", "Subasta");//correo que envia, diplay name
        SmtpSever.Host = "smtp.gmail.com";//servidor gmail
        mail.Subject = "Subasta";//asunto
        mail.Body = correol;
        mail.To.Add(f.Correo);//destino del correo
        mail.Priority = MailPriority.Normal;

        //Configuracion del SMTP
        SmtpSever.Port = 587;
        SmtpSever.Credentials = new System.Net.NetworkCredential("dg1342732@gmail.com", "oxgerrero");//correo origen, contra*
        SmtpSever.EnableSsl = true;
        SmtpSever.Send(mail);//eviar
                             //mail

    }
    public void enviarmailhilo2(Esubasta item)
    {
        Ecorreo_subasta f = ob_datos(item.Id,true);
        //mail vendedor subasta comprada
        string correol = "<body>"
+ "<table class='es-wrapper' width='100%' cellspacing='0' cellpadding='0'>"
+ "<tr>"
+ "<td class='esd-block-banner' style='position: relative;' align='center' esdev-config='h1'><a target='_blank'><img class='adapt-img esdev-stretch-width esdev-banner-rendered' src='https://www.nicepng.com/png/full/414-4144393_en-virtud-de-su-misin-2015-se-busca.png' alt title style='display: block;' width='100%'></a>"
+ "</td>"
+ "</tr>"
+ "<tr>"
+ "<tr>"
+ "<td class='esd-block-text es-p15t es-p15b es-p20r es-p20l' bgcolor='transparent' align='center'>"
+ "<h2 style='color: #333333;'>Señor usuario \t" + f.Nombre + "\n</h2>"
+ "</td>"
+ "</tr>"
+ "<tr>"
+ "<td class='esd-block-text es-p15b es-p30r es-p30l' bgcolor='transparent' align='center'>"
+ "<h3 style='line-height: 150%;'><em>su subasta a terminado y la oferta mas alta fue de " + item.Puja_alta
            + "pronto recibira el pago \n"
            + "Detalles de la subasta\n"
            + "Referencia de la bicicleta: " + f.Referencia
            + "precio de la subasta: " + item.Puja_alta + "</a></em></h3>"
+ "</td>"
+ "</tr>"
+ "</tr>"
+ "<tr>"
+ "<tr>"
+ "<td class='esd-block-image' align='center' style='font-size:0'><a target='_blank'><img class='adapt-img' src='http://catdelune.files.wordpress.com/2013/06/18226884-conjunto-de-elementos-decorativos-bordes-y-el-marco-de-pagina-de-las-reglas.png' alt style='display: block;' width='600'></a>"
+ "</td>"
+ "</tr>"
+ "</tr>"
+ "</table>"
+ "</body>";
        MailMessage mail = new MailMessage();
        SmtpClient SmtpSever = new SmtpClient("smtp.gmail.com");
        mail.IsBodyHtml = true;
        mail.From = new MailAddress("dg1342732@gmail.com", "Subasta");//correo que envia, diplay name
        SmtpSever.Host = "smtp.gmail.com";//servidor gmail
        mail.Subject = "Subasta";//asunto
        mail.Body = correol;
        mail.To.Add(f.Correo);//destino del correo
        mail.Priority = MailPriority.Normal;

        //Configuracion del SMTP
        SmtpSever.Port = 587;
        SmtpSever.Credentials = new System.Net.NetworkCredential("dg1342732@gmail.com", "oxgerrero");//correo origen, contra*
        SmtpSever.EnableSsl = true;
        SmtpSever.Send(mail);//eviar
                             //mail

    }
    public void enviarmailhilo21(Esubasta item)
    {
        Ecorreo_subasta f = ob_datos(item.Id, false);
        Ecatalogo producto = new catalogo().OB_producto_id(item.Id_producto);
        Eusuarios usuario = new usuarios().datos_usuario_log(item.Id_comprador);
        string pr = new usuarios().Encriptar(producto.Id.ToString());
        string us = new usuarios().Encriptar(usuario.Id.ToString());
        string correo = "<body>"
+ "<table class='es-wrapper' width='100%' cellspacing='0' cellpadding='0'>"
+ "<tr>"
+ "<td class='esd-block-banner' style='position: relative;' align='center' esdev-config='h1'><a target='_blank'><img class='adapt-img esdev-stretch-width esdev-banner-rendered' src='https://www.nicepng.com/png/full/414-4144393_en-virtud-de-su-misin-2015-se-busca.png' alt title style='display: block;' width='100%'></a>"
+ "</td>"
+ "</tr>"
+ "<tr>"
+ "<tr>"
+ "<td class='esd-block-text es-p15t es-p15b es-p20r es-p20l' bgcolor='transparent' align='center'>"
+ "<h2 style='color: #333333;'>"+"Señor usuario \t" + f.Nombre + "\n</h2>"
+ "<h2 style='color: #333333;'>asunto</h2>"
+ "</td>"
+ "</tr>"
+ "<tr>"
+ "<td class='esd-block-text es-p15b es-p30r es-p30l' bgcolor='transparent' align='center'>"
+ "<h3 style='line-height: 150%;'><em>la subasta a terminado y la oferta mas alta fue la suya con un valor de " + item.Puja_alta
             + " debera <a href='http://localhost:58812/vista/pago.aspx?pr=" + pr + "&us=" + us + "'>realizar el pago</a> \n"
             + "Detalles de la subasta\n"
             + "Referencia de la bicicleta: " + f.Referencia
             + "precio de la subasta: " + item.Puja_alta +"</em></h3>"
+ "</td>"
+ "</tr>"
+ "</tr>"
+ "<tr>"
+ "<tr>"
+ "<td class='esd-block-image' align='center' style='font-size:0'><a target='_blank'><img class='adapt-img' src='http://catdelune.files.wordpress.com/2013/06/18226884-conjunto-de-elementos-decorativos-bordes-y-el-marco-de-pagina-de-las-reglas.png' alt style='display: block;' width='600'></a>"
+ "</td>"
+ "</tr>"
+ "</tr>"
+ "</table>"
+ "</body>";

        
        //mail comprador subasta comprada
        MailMessage mail = new MailMessage();
        SmtpClient SmtpSever = new SmtpClient("smtp.gmail.com");
        mail.IsBodyHtml = true;
        mail.From = new MailAddress("dg1342732@gmail.com", "Subasta");//correo que envia, diplay name
        SmtpSever.Host = "smtp.gmail.com";//servidor gmail
        mail.Subject = "Subasta";//asunto
        mail.Body = correo;
        mail.To.Add(f.Correo);//destino del correo
        mail.Priority = MailPriority.Normal;

        //Configuracion del SMTP
        SmtpSever.Port = 587;
        SmtpSever.Credentials = new System.Net.NetworkCredential("dg1342732@gmail.com", "oxgerrero");//correo origen, contra*
        SmtpSever.EnableSsl = true;
        SmtpSever.Send(mail);//eviar
                             //mail

    }
    public void enviarmail_actualizarUsuario(string correodestino, Eusuarios datos)
    {
        //mail
        string correol = "<body>"
+ "<table class='es-wrapper' width='100%' cellspacing='0' cellpadding='0'>"
+ "<tr>"
+ "<td class='esd-block-banner' style='position: relative;' align='center' esdev-config='h1'><a target='_blank'><img class='adapt-img esdev-stretch-width esdev-banner-rendered' src='https://www.nicepng.com/png/full/414-4144393_en-virtud-de-su-misin-2015-se-busca.png' alt title style='display: block;' width='100%'></a>"
+ "</td>"
+ "</tr>"
+ "<tr>"
+ "<tr>"
+ "<td class='esd-block-text es-p15t es-p15b es-p20r es-p20l' bgcolor='transparent' align='center'>"
+ "<h2 style='color: #333333;'>Señor usuario \t" + datos.Nombre + "\n</h2>"
+ "</td>"
+ "</tr>"
+ "<tr>"
+ "<td class='esd-block-text es-p15b es-p30r es-p30l' bgcolor='transparent' align='center'>"
+ "<h3 style='line-height: 150%;'><em>Sus datos se an actualizado de manera exitosa </br>"
            + "nombres: " + datos.Nombre + " </br>"
            + "apellidos: " + datos.Apellido + " </br>"
            + "email: " + datos.Email + " </br>"
            + "telefono: " + datos.Telefono + " </br>"
            + "usuario: " + datos.Usuario + " </br>"
            + "contraseña: " + datos.Contraseña + "    </br></br></br></br>"
            + "si no fue usted quien modifico estos datos acceda a su cuenta con las credenciales anteriores y modifique los datos </br>" +
            "ademas envianos un correo para verificar lo sucedido" + "<a href='http://localhost:58812/vista/inicio.aspx'>ingresar</a>" + " </a></em></h3>"
+ "</td>"
+ "</tr>"
+ "</tr>"
+ "<tr>"
+ "<tr>"
+ "<td class='esd-block-image' align='center' style='font-size:0'><a target='_blank'><img class='adapt-img' src='http://catdelune.files.wordpress.com/2013/06/18226884-conjunto-de-elementos-decorativos-bordes-y-el-marco-de-pagina-de-las-reglas.png' alt style='display: block;' width='600'></a>"
+ "</td>"
+ "</tr>"
+ "</tr>"
+ "</table>"
+ "</body>";
        MailMessage mail = new MailMessage();
        SmtpClient SmtpSever = new SmtpClient("smtp.gmail.com");
        mail.IsBodyHtml = true;
        mail.From = new MailAddress("dg1342732@gmail.com", "datos actualizados");//correo que envia, diplay name
        SmtpSever.Host = "smtp.gmail.com";//servidor gmail
        mail.Subject = "Datos actualizados";//asunto
        mail.Body = correol;
        mail.To.Add(correodestino);//destino del correo
        mail.Priority = MailPriority.Normal;

        //Configuracion del SMTP
        SmtpSever.Port = 587;
        SmtpSever.Credentials = new System.Net.NetworkCredential("dg1342732@gmail.com", "oxgerrero");//correo origen, contra*
        SmtpSever.EnableSsl = true;
        SmtpSever.Send(mail);//eviar
                             //mail

    }
    public Ecorreo_subasta ob_datos(int id,Boolean vOc)
    {
        if (vOc)
        {
            using (var db = new mapeo())
            {
                return (Ecorreo_subasta)(from subasta in db.Db_subasta
                                         join usuario in db.Db_usuarios on subasta.Id_cliente equals usuario.Id
                                         join producto in db.Db_catalogo on subasta.Id_producto equals producto.Id
                                         select new
                                         {
                                             subasta,
                                             usuario,
                                             producto,
                                         }).Where(x => x.subasta.Id == id).Select(m => new Ecorreo_subasta
                                         {
                                             Id = m.usuario.Id,
                                             Nombre = m.usuario.Nombre,
                                             Correo = m.usuario.Email,
                                             Referencia = m.producto.Referencia
                                         }).FirstOrDefault();
            }
        }
        else
        {
            using (var db = new mapeo())
            {
                return (Ecorreo_subasta)(from subasta in db.Db_subasta
                                         join usuario in db.Db_usuarios on subasta.Id_comprador equals usuario.Id
                                         join producto in db.Db_catalogo on subasta.Id_producto equals producto.Id
                                         select new
                                         {
                                             subasta,
                                             usuario,
                                             producto,
                                         }).Where(x => x.subasta.Id == id).Select(m => new Ecorreo_subasta
                                         {
                                             Id = m.usuario.Id,
                                             Nombre = m.usuario.Nombre,
                                             Correo = m.usuario.Email,
                                             Referencia = m.producto.Referencia
                                         }).FirstOrDefault();
            }
        }
        
    }
}