using Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Servicio
{
    public class TipoService
    {
        AccesoDatos data = new AccesoDatos();
        public List<Tipo> getAllTypes()
        {
            List<Tipo> Types = new List<Tipo>();
            try
            {
                data.setQuery("SELECT * FROM TIPOS");
                data.executeQuery();

                while(data.Reader.Read())
                {
                    Tipo tipo = new Tipo();
                    tipo.Id = (int)data.Reader["Id"];
                    tipo.Nombre = (string)data.Reader["Nombre"];

                    Types.Add(tipo);
                }
            }catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                data.closeConnection();
            }
            return Types;
        }
    }
}
