using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Descripción breve de PQRS
/// </summary>
public class PQRS
{
    public void In_PQRS(EPQRS PQRS)
    {
        using (var db = new mapeo())
        {
            db.Db_PQRS.Add(PQRS);
            db.SaveChanges();
        }
    }
    public List<EPQRS> OB_PQRS()
    {
        using (var db = new mapeo())
        {
            return (List<EPQRS>)db.Db_PQRS.Where(x => x.Status !=1).ToList();
        }
    }
    public void enviar_correo(EPQRS pqrs) 
    { 
            new contraseña().enviarmailPQRS("bojacasa@gmail.com",pqrs);
    }
}