using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Metodos
{
    internal class Persona
    {
        public Persona(string nombre) { 
            this.nombre = nombre;
        }
        private int edad;
        private float sueldo;
        private string nombre;

        public void setEdad(int e)
        {
            edad = e;
        }

        public int getEdad()
        {
            return edad;
        }

        public string saludar()
        {
            return "Hola soy " + nombre;
        }

        //Sobrecarga
        public string saludar(string personaje)
        {
            return "Hola " + personaje + " soy " + nombre;
        }
    }
}
