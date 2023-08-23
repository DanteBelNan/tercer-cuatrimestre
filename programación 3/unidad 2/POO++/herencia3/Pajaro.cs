using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace herencia3
{
    internal class Pajaro : AnimalSalvaje, Flyable
    {
        public string volar()
        {
            //Sobreescribimos el metodo
            return "VOLANDO";
        }
    }
}
