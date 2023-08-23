using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ejemplo2
{
    internal class Program
    {
        static void Main(string[] args)
        {
            Vehiculo v1 = new Vehiculo();
            v1.Motor = "EA";

            Vehiculo v2;
            v2 = new Camioneta();
            //Al ser parte de la misma familia, y ser vehiculo padre de camioneta
            //Podemos hacer que un Vehiculo sea camioneta (PERO NO PUEDE SER ALREVES)

            Vehiculo v3;
            v3 = new AutoDeportivo();
            //Denuevo, es nieto, no hijo e igual se puede

            Camioneta c1 = new Camioneta();
            Camioneta c2 = new Camioneta();
            Camioneta c3 = new Camioneta();

            List<Camioneta> listaCamionetas = new List<Camioneta>();
            listaCamionetas.Add(c1);
            listaCamionetas.Add(c2);
            listaCamionetas.Add(c3);

            Console.WriteLine(listaCamionetas.Count);

            listaCamionetas[0].Color = "Rojo";
            listaCamionetas[1].Color = "Azul";
            listaCamionetas[2].Color = "Amarillo";
            c1.Color = "Verde"; //sobreescribe el de la lista, porque son varios objetos
            //que hacen referencia al valor
            Console.WriteLine(listaCamionetas[0].Color);

            listaCamionetas.Remove(c3);
            Console.WriteLine(listaCamionetas.Count);

            foreach (Camioneta camioneta in listaCamionetas)
            { 
                Console.WriteLine(camioneta.Color);
            }


            Console.ReadKey();
        }
    }
}
