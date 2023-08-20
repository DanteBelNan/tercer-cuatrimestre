using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ejemplo1
{
    internal class Persona
    {
        //Atributos
        private int edad;
        private float sueldo;
        private string nombre;
        public Persona(int edad, float sueldo, string nombre) {
            this.edad = edad;
            this.sueldo = sueldo;
            this.nombre = nombre;
        }

        public int getEdad() { return edad; }
        public float getSueldo() {  return sueldo; }
        public string getNombre() {  return nombre; }

        public void setEdad(int edad) {  this.edad = edad; }
        public void setSueldo(float sueldo) {  this.sueldo = sueldo; }
        public void setNombre(string nombre) { this.nombre = nombre; }
    }
}
