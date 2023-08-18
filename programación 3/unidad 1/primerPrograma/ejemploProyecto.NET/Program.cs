using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Text;
using System.Threading.Tasks;



namespace ejemploProyecto.NET
{
    internal class Program
    {
        static void lecturaVariables(bool seHace)
        {
            if (seHace)
            {
                int a, b, c;
                float d, f;

                Console.WriteLine("Ingrese un numero: ");
                a = int.Parse(Console.ReadLine());
                b = 10;
                c = a + b;
                d = 0.5f;
                f = d * d / 2;

                Console.WriteLine("El Resultado es: " + c);
                Console.ReadKey();
            }
        }

        static void condicionales(bool seHace)
        {
            if (seHace)
            {
                int a, b, c;
                a = 12;
                b = 10;
                if (a == b)
                {
                    Console.WriteLine("SON IGUALES");
                }
            }
        }

        static void Main(string[] args)
        {
            lecturaVariables(false);
        }
    }
}
