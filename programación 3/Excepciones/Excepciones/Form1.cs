using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Excepciones
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void calcular_Click(object sender, EventArgs e)
        {
            int num1, num2, res;
            try
            {
                num1 = int.Parse(tb1.Text);
                num2 = int.Parse(tb2.Text);
                res = num1 / num2;
                lblResultado.Text = "= " + res;

            }
            catch (FormatException ex)
            {
                MessageBox.Show("Datos erroneos");
            }
            catch (DivideByZeroException ex)
            {
                MessageBox.Show("No se puede dividir por 0");
            }
            catch (OverflowException ex)
            {
                MessageBox.Show("Numero muy grande...");
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error no conocido...");
            }
            finally
            {
                //Aca por ejemplo, se pueden poner cierres de conecciones
                //Con la DB, evitando que no se cierre si entra al catch
            }
        }

        private int calcula()
        {
            try
            {

            }
            catch(Exception ex)
            {
                throw ex;
                //si llamo este metodo en otra función, el throw
                //representa una devolución de error, lo que hace 
                //que al ejecutarse este throw, en el metodo que se llamo
                //se entre al catch
            }
            finally
            {

            }
            return 0;
        }
    }
}
