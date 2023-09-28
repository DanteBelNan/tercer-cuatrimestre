using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.SqlClient;
using System.Net;
using Models;

namespace Servicio
{
    public class PokemonService
    {
        public List<Pkmn> getAllPokemons()
        {
            List<Pkmn> pokemons = new List<Pkmn>();
            SqlConnection connection = new SqlConnection();
            SqlCommand command = new SqlCommand();
            SqlDataReader reader;



            try
            {
                
                connection.ConnectionString = "server=.\\SQLEXPRESS; database=PokedexDB; integrated security=true";
                command.CommandType = System.Data.CommandType.Text;
                command.CommandText = "Select P.Numero, P.Nombre, P.Descripcion, P.UrlImagen, t.Nombre as Tipo, d.Nombre as Debilidad\r\nFROM Pokemons as P\r\nINNER JOIN Tipos as T On T.id = P.idTipo\r\nINNER JOIN Tipos as D on D.id = P.idDebilidad";
                command.Connection = connection;
                connection.Open();

                reader = command.ExecuteReader();

                while (reader.Read())
                {
                    Pkmn aux = new Pkmn();
                    aux.Numero = (int)reader["Numero"];
                    aux.Nombre = (string)reader["Nombre"];
                    aux.Descripcion = (string)reader["Descripcion"];
                    aux.urlImagen = (string)reader["UrlImagen"];
                    aux.Tipo = (string)reader["Tipo"];
                    aux.Debilidad = (string)reader["Debilidad"];

                    pokemons.Add(aux);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                connection.Close();
            }

            return pokemons;
        }
    }
}
