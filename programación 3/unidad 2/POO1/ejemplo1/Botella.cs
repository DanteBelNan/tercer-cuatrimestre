using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ejemplo1
{
    internal class Botella
    {
        //Atributos
        private int capacidad;
        private string color;
        private string material;

        //Propiedad
        public int Capacidad
        {
            get { return capacidad; }
            set { capacidad = value; }
        }
        public string Color
        {
            get { return color; }
            set { color = value; }
        }
        public string Material
        {
            get { return material; }
            set { material = value; }
        }
    }
}
