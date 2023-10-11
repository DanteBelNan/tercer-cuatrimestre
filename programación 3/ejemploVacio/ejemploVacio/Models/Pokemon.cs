using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ejemploVacio.Models
{
    public class Pokemon
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public string Tipo { get; set; }
        public DateTime Captura { get; set; }
        public bool esShiny {  get; set; }
    }


    public class PokemonService
    {
        public List<Pokemon> listar()
        {
            List<Pokemon> list = new List<Pokemon>();
            Pokemon p = new Pokemon();
            p.Id = 1;
            p.Name = "Bulbasaur";
            p.Description = "Rana de planta";
            p.Tipo = "Planta";
            p.Captura = DateTime.Now;
            p.esShiny = false;

            list.Add(p);

            Pokemon pokemon = new Pokemon();
            pokemon.Id = 26;
            pokemon.Name = "Pikachu";
            pokemon.Description = "Rata de electricidad";
            pokemon.Tipo = "Electrico";
            pokemon.Captura = DateTime.Now;
            pokemon.esShiny = true;

            list.Add(pokemon);

            return list;
        }
    }
}