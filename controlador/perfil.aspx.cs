using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class vista_perfil : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Eusuarios user = (Eusuarios)Session["usuario"];
        string datos = user.Id.ToString();
        Session["perfil"] = datos;
        if (!IsPostBack)
        {
            TB_editarNombre.Text = user.Nombre;
            TB_editarApellido.Text = user.Apellido;
            TB_editarEmail.Text = user.Email;
            TB_editarTelefono.Text = user.Telefono;
            TB_editarUsuario.Text = user.Usuario;
            TB_editarContraseña.Text = "********";
            TB_editarNombref.Text = user.Nombre;
            TB_editarApellidof.Text = user.Apellido;
            TB_editarEmailf.Text = user.Email;
            TB_editarTelefonof.Text = user.Telefono;
            TB_editarUsuariof.Text = user.Usuario;
            TB_editarContraseñaf.Text = user.Contraseña;
        }
        
    }

    protected void IB_Productos_Command(object sender, CommandEventArgs e)
    {
        
    }

    protected void B_Editar_Command(object sender, CommandEventArgs e)
    {
        Ecatalogo producto = new catalogo().producto_click(e.CommandArgument.ToString());
        Session["producto"] = producto;
        Response.Redirect("editar.aspx");
    }
    protected void B_Subastar_Command(object sender, CommandEventArgs e)
    {
        string comando = e.CommandArgument.ToString();
        Ecatalogo producto = new catalogo().OB_producto_id(int.Parse(comando));
        producto.Estado = 3;//en tabla catalogo pasa a estado subasta
        Esubasta psubasta = new Esubasta();
        psubasta.Id_cliente = producto.IdVendedor;
        psubasta.Id_producto = producto.Id;
        psubasta.Valor_inicial = producto.Precio;
        psubasta.Puja_alta = psubasta.Valor_inicial;
        Eusuarios user = (Eusuarios)Session["usuario"];
        string datos = user.Id.ToString();
        psubasta.Session = datos;
        psubasta.Estado = 1;
        psubasta.Fecha_inicio = DateTime.Now;
        psubasta.Fecha_fin = DateTime.Now.AddMinutes(5);
        //resubastar
        Esubasta resubasta = new Esubasta();
        resubasta = new catalogo().resubasta(producto.Id);
        if (resubasta.Estado == 3)
        {
            Esubasta antiguo = resubasta;
            Esubasta nuevo = antiguo;
            nuevo.Id_cliente = producto.IdVendedor;
            nuevo.Id_producto = producto.Id;

            Double x = producto.Precio - ((Double)producto.Precio * 0.13);
            String x2 = x.ToString();
            nuevo.Valor_inicial = int.Parse(x2);
            nuevo.Puja_alta = int.Parse(x2);
            nuevo.Estado = 1;
            datos = user.Id.ToString();
            nuevo.Session = datos;
            nuevo.Fecha_inicio = DateTime.Now;
            nuevo.Fecha_fin = DateTime.Now.AddMinutes(5);
            new catalogo().insertarSubasta(nuevo);
            new catalogo().Ac_Catalogo(producto);
            Response.Write("<script>alert('su publicacion inicio una re-subasta');window.location = 'catalogo.aspx';</script>");
        }
        else
        {
            new catalogo().insertarSubasta(psubasta);
            new catalogo().Ac_Catalogo(producto);
            Response.Write("<script>alert('su publicacion inicio a subastar');window.location = 'catalogo.aspx';</script>");
        }
        

    }


    protected void B_editarInformacion_Click(object sender, EventArgs e)
    {
        TB_editarNombre.Visible = false;
        TB_editarApellido.Visible = false;
        TB_editarEmail.Visible = false;
        TB_editarTelefono.Visible = false;
        TB_editarUsuario.Visible = false;
        TB_editarContraseña.Visible = false;
        TB_editarNombref.Visible = true;
        TB_editarApellidof.Visible = true;
        TB_editarEmailf.Visible = true;
        TB_editarTelefonof.Visible = true;
        TB_editarUsuariof.Visible = true;
        TB_editarContraseñaf.Visible = true;
        B_guardarinfoeditada.Visible = true;
        B_cancelaredicion.Visible = true;
        B_editarInformacion.Visible = false;
    }

    protected void B_cancelaredicion_Click(object sender, EventArgs e)
    {
        TB_editarNombre.Visible = true;
        TB_editarApellido.Visible = true;
        TB_editarEmail.Visible = true;
        TB_editarTelefono.Visible = true;
        TB_editarUsuario.Visible = true;
        TB_editarContraseña.Visible = true;
        TB_editarNombref.Visible = false;
        TB_editarApellidof.Visible = false;
        TB_editarEmailf.Visible = false;
        TB_editarTelefonof.Visible = false;
        TB_editarUsuariof.Visible = false;
        TB_editarContraseñaf.Visible = false;
        B_guardarinfoeditada.Visible = false;
        B_cancelaredicion.Visible = false;
        B_editarInformacion.Visible = true;
    }

    protected void B_guardarinfoeditada_Click(object sender, EventArgs e)
    {
        Eusuarios antiguo= (Eusuarios)Session["usuario"];
        Eusuarios nuevo = antiguo;
        nuevo.Nombre = TB_editarNombref.Text;
        nuevo.Apellido = TB_editarApellidof.Text;
        nuevo.Email = TB_editarEmailf.Text;
        nuevo.Telefono = TB_editarTelefonof.Text;
        nuevo.Usuario = TB_editarUsuariof.Text;
        nuevo.Contraseña = TB_editarContraseñaf.Text;
        nuevo.Session = antiguo.Id.ToString();
        new contraseña().enviarmail_actualizarUsuario(antiguo.Email, nuevo);
        new usuarios().Ac_User(nuevo);
        Response.Write("<script>alert('usuario actualizado exitosamente');window.location = 'perfil.aspx';</script>");
    }

}