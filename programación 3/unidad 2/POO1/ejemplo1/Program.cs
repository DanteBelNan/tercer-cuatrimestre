using System;
using System.Collections.Generic;
using System.Diagnostics.SymbolStore;
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

            Botella b1 = new Botella();
            b1.Capacidad = 200;

            int capacidad = b1.Capacidad; 
            
            Console.ReadKey();
        }
    }
}
