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


        public int Capacidad
        {
            get { return capacidad; }
            set { capacidad = value; }
        }

        public int Material
        {
            get { return material; }
        }
    }
}
