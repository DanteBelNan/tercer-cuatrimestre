﻿using System;
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
    public partial class frmPrincipal : Form
    {
        public frmPrincipal()
        {
            InitializeComponent();
        }

        private void perfilPersonaToolStripMenuItem_Click(object sender, EventArgs e)
        {
            foreach (var item in Application.OpenForms)
            {
                if (item.GetType() == typeof(Form1))
                {
                    MessageBox.Show("Esta ventana ya esta abierta...");
                    return;
                }
            }

           Form1 ventana = new Form1();
            ventana.MdiParent = this;
            ventana.Show();
        }

        private void tsbPerfilPersona_Click(object sender, EventArgs e)
        {
            perfilPersonaToolStripMenuItem_Click((object) sender, e);
        }
    }
}
