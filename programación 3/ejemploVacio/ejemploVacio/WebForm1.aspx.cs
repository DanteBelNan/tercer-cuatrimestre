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
            if(Session["listaPokemons"] == null)
            {
              PokemonService pokemonService = new PokemonService();
                Session.Add("listaPokemons", pokemonService.listar());

            }
            dgvPokemones.DataSource = Session["listaPokemons"];
            dgvPokemones.DataBind();
        }

        protected void dgvPokemones_SelectedIndexChanged(object sender, EventArgs e)
        {
            if(dgvPokemones.SelectedRow != null && IsPostBack)
            {
                var test = dgvPokemones.SelectedRow.Cells[0].Text;

            }
        }
    }
}