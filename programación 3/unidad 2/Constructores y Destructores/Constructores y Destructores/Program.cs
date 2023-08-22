using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Constructores_y_Destructores
{
    internal class Program
    {
        static void Main(string[] args)
        {
            Botella b1 = new Botella("Rojo" , "Plastico");
            b1.Capacidad = 10;

            Console.ReadKey();
        }
    }
}
