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
        
        static void Main(string[] args)
        {
            lecturaVariables(false);
            condicionales(false);
            ciclos(false);
            vectores(false);
            int x = 3;
            pasajeReferencia(ref x);
            Console.WriteLine(x);

            Console.ReadKey();

        }

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

            }
        }
        static void condicionales(bool seHace)
        {
            if (seHace)
            {
                int a, b, c;
                a = 12;
                b = 10;
                c = 11;
                if (a == b)
                {
                    Console.WriteLine("SON IGUALES");
                }
                else if (a == c)
                {
                    Console.WriteLine("UNO ES IGUAL");
                }
                else
                {
                    Console.WriteLine("Nada es igual");
                }

                switch (a)
                {
                    case 1:

                        break;

                    case 2:

                        break;

                    case 3:

                        break;

                    case 12:
                        Console.WriteLine("Se activa el switch");
                        break;
                    default:

                        break;

                }
            }
        }
        static void ciclos(bool seHace)
        {
            if (seHace)
            {
                Console.WriteLine("For");
                for (int x = 0; x < 10; x++)
                {
                    Console.WriteLine(x);
                }

                Console.WriteLine("While");
                int y = 5;
                while (y > 0)
                {
                    Console.WriteLine(y);
                    y--;
                }

                Console.WriteLine("Do While");
                do
                {
                    Console.WriteLine(y);
                    y++;
                } while (y < 5);

            }
        }
        static void vectores(bool seHace)
        {
            if (seHace)
            {
                int[] vector = new int[10];

                int x = 3;
                for (int i = 0; i < 10; i++)
                {
                    x *= i + 1;
                    vector[i] = x;
                }

                for (int i = 0; i < 10; i++)
                {
                    Console.WriteLine(vector[i]);
                }
            }
        }

        static void pasajeReferencia(ref int a)
        {
            a += 1;
        }
    }
}
