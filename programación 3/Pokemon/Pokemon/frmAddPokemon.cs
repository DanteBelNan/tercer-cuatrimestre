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

            pbxPokemon.Load("https://imgs.search.brave.com/FgYR2pvWy0QGmcFY_FjYDMtY9__j8lVBktoYCfYm830/rs:fit:860:0:0/g:ce/aHR0cHM6Ly9zbWFs/bGltZy5wbmdrZXku/Y29tL3BuZy9zbWFs/bC8xOC0xODIwMjlf/b3Blbi1wb2tlYmFs/bC1wbmctcG9rZW1v/bi1iYWxsLW9wZW4t/cG5nLnBuZw");
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
                pokemon.urlImagen = txbImagen.Text;
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
            finally
            {
                this.Close();
            }
        }

        private void btnCancelar_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void textBox1_Leave(object sender, EventArgs e)
        {
            try
            {
                pbxPokemon.Load(txbImagen.Text);
            }catch(Exception ex)
            {
                pbxPokemon.Load("https://imgs.search.brave.com/FgYR2pvWy0QGmcFY_FjYDMtY9__j8lVBktoYCfYm830/rs:fit:860:0:0/g:ce/aHR0cHM6Ly9zbWFs/bGltZy5wbmdrZXku/Y29tL3BuZy9zbWFs/bC8xOC0xODIwMjlf/b3Blbi1wb2tlYmFs/bC1wbmctcG9rZW1v/bi1iYWxsLW9wZW4t/cG5nLnBuZw");
            }
        }
    }
}
