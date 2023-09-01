using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace ejemplo2
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void btnAgregar_Click(object sender, EventArgs e)
        {
            string elem = txtElemento.Text;
            lvElementos.Items.Add(elem);
            txtElemento.Text = "";
            MessageBox.Show("Item creado");
        }

        private void gbRadioButtons_Enter(object sender, EventArgs e)
        {

        }

        private void Form1_Load(object sender, EventArgs e)
        {
            cboEstudios.Items.Add("Universitario");
            cboEstudios.Items.Add("Secundario");
            cboEstudios.Items.Add("Primario");
            cboEstudios.Items.Add("Ninguno");
        }

        private void btnVerPerfil_Click(object sender, EventArgs e)
        {
            string nombre = txtElemento.Text;
            DateTime fecha = dtpFechaNacimiento.Value;
            //Operador ternario
            string participa = ckbParticipar.Checked ? "Quiere participar!" : "No quiere participar";
            string genero;
            if(rbtMasculino.Checked) {
                genero = "Masculino";
            }else if(rbtFemenino.Checked)
            {
                genero = "Femenino";
            }
            else
            {
                genero = "Otro";
            }

            string estudios = cboEstudios.SelectedItem.ToString();
            string sueldo = numSueldoAnual.Value.ToString();

            string msj = "Nombre: " + nombre + " Fecha: " + fecha;
            string msj2 = " " + participa + " Genero: " + genero;
            string msj3 = " Estudios: " + estudios + " Sueldo: " + sueldo;
            MessageBox.Show(msj + msj2 + msj3);
        }
    }
}
