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
        private Pkmn pokemon = null;
        public frmAddPokemon()
        {
            InitializeComponent();
        }

        public frmAddPokemon(Pkmn pokemon)
        {
            InitializeComponent();
            this.pokemon = pokemon;
            Text = "Modificar Pokemon";
        }


        private void frmAddPokemon_Load(object sender, EventArgs e)
        {
            List<Tipo> tipos = new List<Tipo>();
            List<Tipo> debilidades = new List<Tipo>();
            TipoService tipoService = new TipoService();
            tipos = tipoService.getAllTypes();
            debilidades = tipoService.getAllTypes();
            try
            {
                cmbTipo.DataSource = tipos;
                cmbTipo.ValueMember = "Id";
                cmbTipo.DisplayMember = "Nombre";
                cmbDebilidad.DataSource = debilidades;
                cmbDebilidad.ValueMember = "Id";
                cmbDebilidad.DisplayMember = "Nombre";
                if (pokemon != null)
                {
                    txbNumero.Text = pokemon.Numero.ToString();
                    txbNombre.Text = pokemon.Nombre;
                    txbDesc.Text = pokemon.Descripcion;
                    txbImagen.Text = pokemon.urlImagen;
                    cmbTipo.SelectedValue = pokemon.Tipo.Id;
                    cmbDebilidad.SelectedValue = pokemon.Debilidad.Id;
                    cargarImagen(txbImagen.Text);
                }
                else
                {
                    pbxPokemon.Load("https://imgs.search.brave.com/FgYR2pvWy0QGmcFY_FjYDMtY9__j8lVBktoYCfYm830/rs:fit:860:0:0/g:ce/aHR0cHM6Ly9zbWFs/bGltZy5wbmdrZXku/Y29tL3BuZy9zbWFs/bC8xOC0xODIwMjlf/b3Blbi1wb2tlYmFs/bC1wbmctcG9rZW1v/bi1iYWxsLW9wZW4t/cG5nLnBuZw");
                }
            }
            catch(Exception ex)
            {
                throw ex;
            }
        }

        private void btnAceptar_Click(object sender, EventArgs e)
        {
            PokemonService pokemonService = new PokemonService();
            TipoService tipoService = new TipoService();
            try
            {
                if(pokemon == null)
                {
                    pokemon = new Pkmn();
                }
                pokemon.Numero = int.Parse(txbNumero.Text);
                pokemon.Nombre = txbNombre.Text;
                pokemon.Descripcion = txbDesc.Text;
                pokemon.urlImagen = txbImagen.Text;
                pokemon.Tipo.Nombre = cmbTipo.Text;
                pokemon.Tipo.Id = tipoService.getId(pokemon.Tipo.Nombre);
                pokemon.Debilidad.Nombre = cmbDebilidad.Text;
                pokemon.Debilidad.Id = tipoService.getId(pokemon.Debilidad.Nombre);

                if(pokemon.Id == 0)
                {
                    pokemonService.add(pokemon);
                    MessageBox.Show("Pokemon agregado exitosamente");
                }
                else
                {
                    pokemonService.modify(pokemon);
                    MessageBox.Show("Pokemon modificado exitosamente");
                }


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

        private void cargarImagen(string text)
        {
            try
            {
                pbxPokemon.Load(text);
            }
            catch (Exception ex)
            {
                pbxPokemon.Load("https://imgs.search.brave.com/FgYR2pvWy0QGmcFY_FjYDMtY9__j8lVBktoYCfYm830/rs:fit:860:0:0/g:ce/aHR0cHM6Ly9zbWFs/bGltZy5wbmdrZXku/Y29tL3BuZy9zbWFs/bC8xOC0xODIwMjlf/b3Blbi1wb2tlYmFs/bC1wbmctcG9rZW1v/bi1iYWxsLW9wZW4t/cG5nLnBuZw");
            }
        }

        private void textBox1_Leave(object sender, EventArgs e)
        {
            cargarImagen(txbImagen.Text);
        }
    }
}
