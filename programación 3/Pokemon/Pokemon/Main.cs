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
        public Main()
        {
            InitializeComponent();
        }

        private void Main_Load(object sender, EventArgs e)
        {
            PokemonService PokemonService = new PokemonService();
            List<Pokemon> list = new List<Pokemon>();
            list = PokemonService.getAllPokemons();

            dgvPokemons.DataSource = list;
        }
    }
}
