using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace Metodos
{
    internal class Program
    {
        static void Main(string[] args)
        {
            Persona p1 = new Persona("Dante");
            p1.setEdad(20);
            Console.WriteLine(p1.saludar("Lolo"));

            Console.ReadKey();
        }
    }
}
