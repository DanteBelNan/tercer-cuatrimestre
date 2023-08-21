using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.ExceptionServices;
using System.Text;
using System.Threading.Tasks;

namespace ejemplo_2
{
    internal class Program
    {
        static void Main(string[] args)
        {
            Articulo[] articulos = new Articulo[3];

            for(int x = 0; x < articulos.Length; x++)
            {
                articulos[x] = new Articulo();
                Console.WriteLine("Articulo: " + x);
                Console.WriteLine("Codigo: ");
                articulos[x].CodigoArticulo = int.Parse(Console.ReadLine());
                Console.WriteLine("Precio: ");
                articulos[x].Precio = float.Parse(Console.ReadLine());
                Console.WriteLine("Codigo de Marca (1 al 10): ");
                articulos[x].CodigoMarca = int.Parse(Console.ReadLine());
            }


            for(int x = 0;x < articulos.Length; x++)
            {
                articulos[x].Mostrar();
            }
            Console.ReadKey();
        }
    }
}
