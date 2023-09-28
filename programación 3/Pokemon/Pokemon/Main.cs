using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Pokemon
{
    public partial class Main : Form
    {
        private List<Pokemon> list = new List<Pokemon>();
        public Main()
        {
            InitializeComponent();
        }

        private void Main_Load(object sender, EventArgs e)
        {
            PokemonService PokemonService = new PokemonService();
            
            list = PokemonService.getAllPokemons();

            dgvPokemons.DataSource = list;
            cargarImagen(list[0].urlImagen);
        }

        private void dgvPokemons_SelectionChanged(object sender, EventArgs e)
        {
            Pokemon pokemon = (Pokemon)dgvPokemons.CurrentRow.DataBoundItem;
            cargarImagen(pokemon.urlImagen);
        }

        private void cargarImagen(string imagen)
        {
            try
            {
                pbxPokemon.Load(imagen);
            }
            catch (Exception ex)
            {
                //Esto debera luego ser reemplazado por una imagen local de not found
                pbxPokemon.Load("https://imgs.search.brave.com/U1TE-AlcEz1nZ1Skz1I5IOx7wuD12s1DY-I2Z1ISE-8/rs:fit:860:0:0/g:ce/aHR0cHM6Ly9jZG4u/dmVjdG9yc3RvY2su/Y29tL2kvcHJldmll/dy0xeC8xOC82MC80/MDQtZXJyb3ItcGFn/ZS1ub3QtZm91bmQt/dmVjdG9yLTMxNjcx/ODYwLmpwZw");
            }
        }
    }
}
