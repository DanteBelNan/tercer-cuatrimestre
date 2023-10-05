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
    public partial class Main : Form
    {
        private List<Pkmn> list = new List<Pkmn>();
        public Main()
        {
            InitializeComponent();
        }

        private void Main_Load(object sender, EventArgs e)
        {
            loadPokemons();
            
        }

        private void loadPokemons()
        {
            PokemonService PokemonService = new PokemonService();

            try
            {
                list = PokemonService.getAllPokemons();

                dgvPokemons.DataSource = list;
                cargarImagen(list[0].urlImagen);

            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        private void dgvPokemons_SelectionChanged(object sender, EventArgs e)
        {
            dgvPokemons.Columns["UrlImagen"].Visible = false;
            dgvPokemons.Columns["Activo"].Visible = false;
            dgvPokemons.Columns["Evolucion"].Visible = false;
            Pkmn pokemon = (Pkmn)dgvPokemons.CurrentRow.DataBoundItem;
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
                pbxPokemon.Load("https://imgs.search.brave.com/FgYR2pvWy0QGmcFY_FjYDMtY9__j8lVBktoYCfYm830/rs:fit:860:0:0/g:ce/aHR0cHM6Ly9zbWFs/bGltZy5wbmdrZXku/Y29tL3BuZy9zbWFs/bC8xOC0xODIwMjlf/b3Blbi1wb2tlYmFs/bC1wbmctcG9rZW1v/bi1iYWxsLW9wZW4t/cG5nLnBuZw");
            }
        }

        private void btnAdd_Click(object sender, EventArgs e)
        {
            frmAddPokemon frmAddPokemon = new frmAddPokemon();
            frmAddPokemon.ShowDialog();
            loadPokemons();
        }
    }
}
