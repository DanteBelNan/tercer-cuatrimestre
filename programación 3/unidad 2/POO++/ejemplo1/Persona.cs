using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ejemplo1
{
    abstract internal class Persona
    {//es una clase abstracta, no permite que se creen, solo sus hijos
        //por contraparte, existe sealed, que hace que no se pueda heredar
        //de la clase Persona
        //Tambien, puede estar una clase estatica, que no pueden instanciarse
        //pero pueden utilizarse directamente, solo funciona con metodos, como para
        //las clases de Archivos que usaba en Progra2 (un helper)
        public string Nombre { get; set; }
        public string Apellido { get; set; }
        public int Legajo { get; set; }
    }
}
