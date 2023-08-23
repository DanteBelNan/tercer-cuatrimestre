using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ejemplo2
{
    internal class Auto : Vehiculo
    {
        public Auto() {
            BaseAuto = new BaseAuto();
        }
        public int Year {  get; set; }
        public string Modelo { get; set; }
        public string Color { get; set; }

        //Composición;
        BaseAuto BaseAuto { get; }
        //Es obligatorio que tenga un chasis, y este no puede ser mutable
        //Agregación
        public Motor Motor { get; set; }
        //Pueden ser mutable el motor, puede estar como no estar
    }
}
