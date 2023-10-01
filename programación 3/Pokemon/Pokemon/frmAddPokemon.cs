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
            List<Tipo> tipos = new List<Tipo>();
            TipoService tipoService = new TipoService();
            tipos = tipoService.getAllTypes();
            foreach(var tipo in tipos)
            {
                cmbDebilidad.Items.Add(tipo.Nombre);
                cmbTipo.Items.Add(tipo.Nombre);
            }
        }

        private void btnAceptar_Click(object sender, EventArgs e)
        {
            Pkmn pokemon = new Pkmn();
            PokemonService pokemonService = new PokemonService();
            TipoService tipoService = new TipoService();
            try
            {
                pokemon.Numero = int.Parse(txbNumero.Text);
                pokemon.Nombre = txbNombre.Text;
                pokemon.Descripcion = txbDesc.Text;
                pokemon.Tipo.Nombre = cmbTipo.Text;
                pokemon.Tipo.Id = tipoService.getId(pokemon.Tipo.Nombre);
                pokemon.Debilidad.Nombre = cmbDebilidad.Text;
                pokemon.Debilidad.Id = tipoService.getId(pokemon.Debilidad.Nombre);

                pokemonService.add(pokemon);
                MessageBox.Show("Pokemon agregado exitosamente");
                this.Close();
                
            }catch(Exception ex)
            {
                MessageBox.Show(ex.ToString());
            }
        }

        private void btnCancelar_Click(object sender, EventArgs e)
        {
            this.Close();
        }
    }
}
