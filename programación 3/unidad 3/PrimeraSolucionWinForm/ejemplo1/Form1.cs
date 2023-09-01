using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace ejemplo1
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            //MessageBox.Show("Programa cargado");
        }

        private void btnSaludar_Click(object sender, EventArgs e)
        {
            //MessageBox.Show("Hola mundo");
            string texto = txtNombre.Text;
            labelSaludo.Text = "Hola" + texto;
        }

        private void Form1_FormClosing(object sender, FormClosingEventArgs e)
        {
            //MessageBox.Show("Programa cerrado");
        }


    }
}
