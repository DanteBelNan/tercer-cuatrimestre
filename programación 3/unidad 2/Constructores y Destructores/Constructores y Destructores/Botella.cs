using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Constructores_y_Destructores
{
    internal class Botella
    {
        public Botella(string color, string material) {
            this.color = color;
            this.material = material;
            capacidad = 100;
            cantidadActual = 0;
        } //El constructor puede ser sobrecargado

        public Botella()
        {
            Console.WriteLine("Constructor sin parametros");
        }

        ~Botella()
        {
            //Logica para un destructor, no es public ni private
        }
        private int capacidad;
        private string color;
        private string material;
        private int cantidadActual;


        public int Capacidad
        {
            get { return capacidad; }
        }

        public string Material
        {
            get { return material; }
        }


        public float recargar()
        {
            if(cantidadActual >= 0)
            {
                int dif = 100 - cantidadActual;
                float monto = dif * 50 / 100;
                cantidadActual += dif;
                return monto;
            }
            else
            {
                return 0;
            }
        }

        public float recargar(int cantidad)
        {
            cantidadActual += cantidad;
            if(cantidadActual >= capacidad)
            {
                cantidadActual = capacidad;
            }
            return cantidad * 50 / 100;
        }
    }
}
