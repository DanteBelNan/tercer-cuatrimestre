using ejemploVacio.Models;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ejemploVacio
{
    public partial class PokemonForm : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                ddlTipo.Items.Add("Planta");
                ddlTipo.Items.Add("Fuego");
                ddlTipo.Items.Add("Agua");
                ddlTipo.Items.Add("Electrico");
            }

        }


        protected void btnAceptar_Click(object sender, EventArgs e)
        {
                Pokemon pokemon = new Pokemon();
                pokemon.Name = txbNombre.Text;
                pokemon.Description = txbNombre.Text;
                pokemon.Tipo = ddlTipo.SelectedValue;
                pokemon.Captura = DateTime.Parse(txbCaptura.Text);
                pokemon.esShiny = chkbxShiny.Checked;
                pokemon.Id = int.Parse(txbId.Text);

                ((List<Pokemon>)Session["listaPokemons"]).Add(pokemon);
                Response.Redirect("WebForm1.aspx");
            
        }
    }

}