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
                command.CommandText = "\r\nSELECT P.Numero, P.Nombre, P.Descripcion, ISNULL(P.UrlImagen,'')as UrlImagen, ISNULL(T.Nombre, 'Sin Tipo') as Tipo, ISNULL(D.Nombre, 'Sin Debilidad') as Debilidad FROM Pokemons as P LEFT JOIN Tipos as T ON T.id = P.idTipo LEFT JOIN Tipos as D ON D.id = P.idDebilidad";
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
    
        public void add(Pkmn pkmn)
        {
            AccesoDatos accesoDatos = new AccesoDatos();
            try
            {
                accesoDatos.setQuery("Insert into Pokemons (Numero,Nombre,Descripcion,Activo)values(" + pkmn.Numero + ", '" + pkmn.Nombre + "', '"+ pkmn.Descripcion+"' ,1)");
                accesoDatos.executeAction();
            }catch(Exception ex)
            {

            }
            finally
            {
                accesoDatos.closeConnection();
            }
        }
    }
}
