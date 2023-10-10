﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ejemplo1
{
    public partial class About : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Title = "ACA HAY UN TITULO";
            if(txbNombre == null)
            {
                txbNombre = new TextBox();
            }
            if (!IsPostBack)
            {
                txbNombre.Text = "test";
            }
            
            
        }

        protected void btnAceptar_Click(object sender, EventArgs e)
        {
            string nombre = txbNombre.Text;
            lblSaludo.Text = nombre;
        }

        protected void btnAceptar_Click1(object sender, EventArgs e)
        {
            lblSaludo.Text = "Hola " + txbNombre.Text;
            //Response.Redirect("Default.aspx");
        }

        protected void txbNombre_TextChanged(object sender, EventArgs e)
        {
            lblSecundario.Text += txbNombre.Text;
        }
    }
}