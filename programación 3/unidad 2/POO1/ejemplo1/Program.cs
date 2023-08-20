using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ejemplo1
{
    internal class Program
    {
        static void Main(string[] args)
        {
            Persona p1 = new Persona(19,14000f,"Dante");
            Console.WriteLine(p1.getEdad());
            p1.setEdad(20);
            Console.WriteLine(p1.getEdad());

            Console.ReadKey();
        }
    }
}
