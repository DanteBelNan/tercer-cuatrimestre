using Models;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using Servicio;

namespace Pokemon
{
    public partial class frmAddPokemon : Form
    {
        public frmAddPokemon()
        {
            InitializeComponent();
        }

        private void frmAddPokemon_Load(object sender, EventArgs e)
        {

        }

        private void btnAceptar_Click(object sender, EventArgs e)
        {
            Pkmn pokemon = new Pkmn();
            PokemonService pokemonService = new PokemonService();
            try
            {
                pokemon.Numero = int.Parse(txbNumero.Text);
                pokemon.Nombre = txbNombre.Text;
                pokemon.Descripcion = txbDesc.Text;

                pokemonService.add(pokemon);
                MessageBox.Show("Pokemon agregado exitosamente");
                this.Close();
                
            }catch(Exception ex)
            {
                MessageBox.Show(ex.ToString());
            }
        }
    }
}
