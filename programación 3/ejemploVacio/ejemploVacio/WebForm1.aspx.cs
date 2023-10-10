using ejemploVacio.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ejemploVacio
{
    public partial class WebForm1 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            PokemonService pokemonService = new PokemonService();
            dgvPokemones.DataSource = pokemonService.listar();
            dgvPokemones.DataBind();
        }
    }
}