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
using System.Runtime.Remoting.Messaging;

namespace Pokemon
{
    public partial class Main : Form
    {
        private List<Pkmn> list = new List<Pkmn>();
        PokemonService pokemonService = new PokemonService();
        public Main()
        {
            InitializeComponent();
        }

        private void Main_Load(object sender, EventArgs e)
        {
            loadPokemons();
            cmbCampo.Items.Add("Número");
            cmbCampo.Items.Add("Nombre");
            cmbCampo.Items.Add("Descripción");
        }

        private void loadPokemons()
        {
            try
            {
                list.Clear();
                list = pokemonService.getAllPokemons();

                dgvPokemons.DataSource = list;
                hideColumns();
                cargarImagen(list[0].urlImagen);

            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        private void hideColumns()
        {
            dgvPokemons.Columns["Id"].Visible = false;
            dgvPokemons.Columns["UrlImagen"].Visible = false;
            dgvPokemons.Columns["Activo"].Visible = false;
            dgvPokemons.Columns["Evolucion"].Visible = false;
        }

        private void dgvPokemons_SelectionChanged(object sender, EventArgs e)
        {
            if(dgvPokemons.CurrentRow != null)
            {
                Pkmn pokemon = (Pkmn)dgvPokemons.CurrentRow.DataBoundItem;
                cargarImagen(pokemon.urlImagen);
            }
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

        private void btnModify_Click(object sender, EventArgs e)
        {
            Pkmn selected;
            selected = (Pkmn)dgvPokemons.CurrentRow.DataBoundItem;
            frmAddPokemon frmAddPokemon = new frmAddPokemon(selected);
            frmAddPokemon.ShowDialog();
            loadPokemons();
        }

        private void btnDelete_Click(object sender, EventArgs e)
        {

            Pkmn selected;
            try
            {
                DialogResult respuesta = MessageBox.Show("Estas seguro de que lo queres eliminar?", "Eliminando", MessageBoxButtons.YesNo, MessageBoxIcon.Warning);
                if(respuesta == DialogResult.Yes)
                {
                    selected = (Pkmn)dgvPokemons.CurrentRow.DataBoundItem;
                    pokemonService.delete(selected.Id);
                    MessageBox.Show(selected.Nombre + " eliminado.");
                    loadPokemons();
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }


        private void filterPokemons(object sender, EventArgs e)
        {
            List<Pkmn> filteredList;
            string filtro = txbFiltro.Text;
            if (filtro.Length > 0)
            {
                filteredList = list.FindAll(x => x.Nombre.ToUpper().Contains(filtro.ToUpper()) || x.Descripcion.ToUpper().Contains(filtro.ToUpper()));
                dgvPokemons.DataSource = null;
                dgvPokemons.DataSource = filteredList;
                hideColumns();
            }
            else
            {
                loadPokemons();
            }
        }

        private void cmbCampo_SelectedIndexChanged(object sender, EventArgs e)
        {
            cmbCriterio.Items.Clear();
            string opcion = cmbCampo.SelectedItem.ToString();
            if(opcion == "Número")
            {
                cmbCriterio.Items.Add("Mayor a");
                cmbCriterio.Items.Add("Menor a");
                cmbCriterio.Items.Add("Igual a");
            }
            else
            {
                cmbCriterio.Items.Add("Comienza con");
                cmbCriterio.Items.Add("Termina con");
                cmbCriterio.Items.Add("Contiene");
            }

        }

        private void btnBuscar_Click(object sender, EventArgs e)
        {
            try
            {
                if (!validateFilters())
                {
                    return;
                }
                string campo = cmbCampo.SelectedItem.ToString();
                string criterio = cmbCriterio.SelectedItem.ToString();
                string valor = txbFiltro2.Text;
                dgvPokemons.DataSource = pokemonService.filter(campo, criterio, valor);
                

            }catch(Exception ex)
            {
                MessageBox.Show(ex.ToString());
            }

        }

        private bool validateFilters()
        {
            if(cmbCampo.SelectedIndex < 0)
            {
                MessageBox.Show("No hay un campo seleccionado");
                return false;
            }
            if(cmbCriterio.SelectedIndex < 0)
            {
                MessageBox.Show("No hay un criterio seleccionado");
                return false;
            }
            if (cmbCampo.Text == "Número")
            {
                if (!onlyNumbers(txbFiltro2.Text))
                {
                    MessageBox.Show("No hay ningun numero");
                    return false;
                }
            }
            
            return true;
        }

        private bool onlyNumbers(string chain)
        {
            if (string.IsNullOrEmpty(chain))
            {
                return false;
            }
            foreach (char  c in chain)
            {
                if (!(char.IsNumber(c)))
                {
                    return false;
                }
            }
            return true;
        }

    }
}
