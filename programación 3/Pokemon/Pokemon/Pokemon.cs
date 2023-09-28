using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Pokemon
{
    internal class Pokemon
    {
        public int Numero { get; set; }
        public string Nombre { get; set; }
        public string Descripcion { get; set; }
        public string urlImagen { get; set; }
        public string Tipo { get; set; }
        public string Debilidad { get; set; }
        public string Evolucion { get; set; }
        public bool Activo { get; set; }
    }
}
