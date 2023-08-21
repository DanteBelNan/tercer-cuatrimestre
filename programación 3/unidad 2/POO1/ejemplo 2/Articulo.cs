using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ejemplo_2
{
    internal class Articulo
    {
        //Nueva forma de declarar variables con getters y setters
        public int CodigoArticulo { get; set; }

        public float Precio { get; set; }

        //Codigo marca debe ser del 1 al 10
        //Al tener logica propia, debemos customizar el set, por lo que no podemos
        //utilizar estos nuevos setters y getters

        private int codMarca;

        public int CodigoMarca
        {
            get { return codMarca; }
            set 
            { 
                if(value > 0 && value <= 10)
                {
                    codMarca = value;
                }
                else
                {
                    codMarca = -1;
                }
            }
        }

        public void Mostrar()
        {
            Console.WriteLine("Codigo Articulo: " + CodigoArticulo.ToString());
            Console.WriteLine("Precio: " +  Precio.ToString());
            Console.WriteLine("Codigo Marca: " + CodigoMarca.ToString());
        }

    }
}
