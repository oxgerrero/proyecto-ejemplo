using NUnit.Framework;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Web;

/// <summary>
/// Descripción breve de usuarios
/// </summary>
public class usuarios
{
    public List<Eusuarios> datos_usuarios()
    {
        List<Eusuarios> usuarios;
        using (var db = new mapeo())
        {
            usuarios=db.Db_usuarios.OrderBy(x => x.Id).ToList();
        }
        foreach (Eusuarios user in usuarios)
        {
            user.Contraseña = DesEncriptar(user.Contraseña);
        }
        return usuarios;
    }
    public void insertarUsuario(Eusuarios usuarios)
    {
        usuarios.Id_rol = 3;
        if (usuarios.Session == null)
        {
            usuarios.Session = "web";
        }
        usuarios.Activo = 1;
        usuarios.Contraseña = Encriptar(usuarios.Contraseña);
        using (var db = new mapeo())
        {
            db.Db_usuarios.Add(usuarios);
            db.SaveChanges();
        }
    }
    public Eusuarios login(string usuario, string contraseña)
    {
        
        contraseña = Encriptar(contraseña);
        using (var db = new mapeo())
        {
            Eusuarios eusuario = db.Db_usuarios.Where(u => u.Usuario == usuario).Where(c => c.Contraseña == contraseña).FirstOrDefault();
            if (eusuario == null) {
                return null;
            }
            else
            {
                eusuario.Contraseña = DesEncriptar(eusuario.Contraseña);
                return eusuario;
            }
            
        }
    }
    public string Encriptar(string clave)
    {
        string result = string.Empty;
        byte[] encryted = System.Text.Encoding.Unicode.GetBytes(clave);
        result = Convert.ToBase64String(encryted);
        Console.WriteLine("clave encriptada"+result);
        return result;
    }
    public string DesEncriptar(string claveE)
    {
        try
        {
            string result = string.Empty;
            byte[] decryted = Convert.FromBase64String(claveE);
            //result = System.Text.Encoding.Unicode.GetString(decryted, 0, decryted.ToArray().Length);
            result = System.Text.Encoding.Unicode.GetString(decryted);
            Console.WriteLine("clave desencriptada" + result);
            return result;
        }
        catch(Exception ex)
        {
            return claveE;
        }
        
    }

    public Eusuarios contraseña(string usuario)
    {
        using (var db = new mapeo())
        {
            Eusuarios eusuario = db.Db_usuarios.Where(u => u.Usuario == usuario).FirstOrDefault();
            return eusuario;
        }
    }
    public void insertarRusuario(token Rtoken)
    {
        using (var db = new mapeo())
        {
            db.Db_token.Add(Rtoken);
            db.SaveChanges();
        }
    }
    public void Ac_User(Eusuarios usuario)
    {
        usuario.Contraseña = Encriptar(usuario.Contraseña);
        usuario.Session = "admin";
        using (var db = new mapeo())
        {
            db.Db_usuarios.Attach(usuario);
            var entry = db.Entry(usuario);
            entry.State = EntityState.Modified;
            db.SaveChanges();
        }
    }
    public token token_id_us(string token)
    {
        using (var db = new mapeo())
        {
            token tk = db.Db_token.Where(u => u.Tactivo == token).FirstOrDefault();
            return tk;
        }
    }
    public Eusuarios id_us_usuario(int id)
    {
        using (var db = new mapeo())
        {
            Eusuarios eusuario = db.Db_usuarios.Where(u => u.Id == id).FirstOrDefault();
            return eusuario;
        }
    }
    public Eusuarios datos_usuario_log(int id)
    {
        Eusuarios usuarios;
        using (var db = new mapeo())
        {
            usuarios = db.Db_usuarios.Where(x=> x.Id==id).FirstOrDefault();
        }
            usuarios.Contraseña = DesEncriptar(usuarios.Contraseña);
        return usuarios;
    }

    public Eusuarios comprovar_usuario(Eusuarios user)
    {
        using (var db = new mapeo())
        {
            return (Eusuarios)db.Db_usuarios.Where(x => x.Usuario.Equals(user.Usuario)).FirstOrDefault();
        }
    }
    public Eusuarios comprovar_email(Eusuarios user)
    {
        using (var db = new mapeo())
        {
            return (Eusuarios)db.Db_usuarios.Where(x => x.Email.Equals(user.Email)).FirstOrDefault();
        }
    }
}