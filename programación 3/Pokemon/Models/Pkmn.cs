using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Models
{
    public class Pkmn
    {
        public Pkmn() {
            Tipo = new Tipo();
            Debilidad = new Tipo();
        }
        [DisplayName("Número")]
        public int Numero { get; set; }
        public string Nombre { get; set; }
        [DisplayName("Descripción")]
        public string Descripcion { get; set; }
        public string urlImagen { get; set; }
        public Tipo Tipo { get; set; }
        public Tipo Debilidad { get; set; }
        public string Evolucion { get; set; }
        public bool Activo { get; set; }
    }
}
