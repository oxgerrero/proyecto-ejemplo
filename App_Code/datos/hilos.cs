using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Web;


public class hilos
{
  public void enviar_correo1()
    {
        //no se vendio la subasta
        while (true)
        {
            List<Esubasta> datos = new catalogo().OB_subasta();
            foreach(var item in datos)
            {
                if (item.Correo == false)
                {
                    if (item.Estado == 3)
                    {
                        contraseña rec = new contraseña();
                        rec.enviarmailhilo(item);
                        item.Correo = true;
                        new catalogo().Ac_Subasta(item);
                        Ecatalogo producto = new catalogo().OB_producto_id(item.Id_producto);
                        producto.Estado = 1;
                        new catalogo().Ac_Catalogo(producto);
                    }
                    
                }
            }
            Thread.Sleep(1000);
        }    
    }
    public void enviar_correo2()
    {
        //se vendio en subasta
        while (true)
        {
            List<Esubasta> datos = new catalogo().OB_subasta();
            foreach (var item in datos)
            {
                if (item.Correo == false)
                {
                    if (item.Estado == 2)
                    {
                        contraseña rec = new contraseña();
                        rec.enviarmailhilo2(item);
                        rec.enviarmailhilo21(item);
                        item.Correo = true;
                        new catalogo().Ac_Subasta(item);
                    }

                }
            }
            Thread.Sleep(1000);
        }
    }
    

}