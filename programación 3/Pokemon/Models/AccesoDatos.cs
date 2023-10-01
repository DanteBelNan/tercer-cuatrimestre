using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.SqlClient;

namespace Models
{
    public class AccesoDatos
    {
        private SqlConnection connection;
        private SqlCommand command;
        private SqlDataReader reader;
        public SqlDataReader Reader
        {
            get { return reader; }
        }

        public AccesoDatos()
        {
            connection = new SqlConnection();
            connection.ConnectionString = "server=.\\SQLEXPRESS; database=PokedexDB; integrated security=true";
            command = new SqlCommand();
        }   

        public void setQuery(string query)
        {
            command.CommandType = System.Data.CommandType.Text;
            command.CommandText = query;
        }

        public void executeQuery()
        {
            command.Connection = connection;
            try
            {
                connection.Open();
                reader = command.ExecuteReader();

            }catch (Exception ex)
            {
                throw ex;
            }
        }

        public void executeAction()
        {
            command.Connection = connection;
            try
            {
                connection.Open();
                command.ExecuteNonQuery();
            }catch (Exception ex)
            {
                throw ex;
            }
        }

        public void closeConnection()
        {
            if(reader != null)
            {
                reader.Close();
            }
            connection.Close();
        }
    }
}
