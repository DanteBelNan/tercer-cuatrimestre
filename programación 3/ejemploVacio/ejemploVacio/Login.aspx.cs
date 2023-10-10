using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ejemploVacio
{
    public partial class WebForm3 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string user = txbUser.Text;
            string password = txbPassword.Text;


            if(user == "dbeltran" && password == "test.123")
            {
                lblLogged.Text = "Inicio sesion correctamente";
            }
            else
            {
                lblLogged.Text = "Inicio sesion correctamente";
            }
        }
    }
}