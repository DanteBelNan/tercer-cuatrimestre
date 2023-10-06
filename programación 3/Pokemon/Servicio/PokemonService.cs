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
                command.CommandText = "SELECT P.Id, P.Numero, P.Nombre, P.Descripcion, ISNULL(P.UrlImagen,'') as UrlImagen, ISNULL(T.Nombre, 'Sin Tipo') as Tipo, ISNULL(D.Nombre, 'Sin Debilidad') as Debilidad, P.idTipo, P.idDebilidad FROM Pokemons as P LEFT JOIN Tipos as T ON T.id = P.idTipo LEFT JOIN Tipos as D ON D.id = P.idDebilidad ORDER BY P.Numero ASC\r\n";
                command.Connection = connection;
                connection.Open();

                reader = command.ExecuteReader();

                while (reader.Read())
                {
                    Pkmn aux = new Pkmn();
                    aux.Id = (int)reader["Id"];
                    aux.Numero = (int)reader["Numero"];
                    aux.Nombre = (string)reader["Nombre"];
                    aux.Descripcion = (string)reader["Descripcion"];
                    aux.urlImagen = (string)reader["UrlImagen"];
                    aux.Tipo.Id = (int)reader["IdTipo"];
                    aux.Tipo.Nombre = (string)reader["Tipo"];
                    aux.Debilidad.Id = (int)reader["IdDebilidad"];
                    aux.Debilidad.Nombre = (string)reader["Debilidad"];

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
                accesoDatos.setQuery("Insert into Pokemons (Numero,Nombre,Descripcion, UrlImagen, idTipo,idDebilidad,Activo)values(" + pkmn.Numero + ", '" + pkmn.Nombre + "', '"+ pkmn.Descripcion+"' , '"+pkmn.urlImagen+ "' , " + pkmn.Tipo.Id+" , "+pkmn.Debilidad.Id+" ,1)");
                accesoDatos.executeAction();
            }catch(Exception ex)
            {
                throw ex;
            }
            finally
            {
                accesoDatos.closeConnection();
            }
        }
    
        public void modify(Pkmn pkmn)
        {
            AccesoDatos accesoDatos = new AccesoDatos();
            try
            {
                accesoDatos.setQuery("update Pokemons set Numero = @Numero, Nombre = @Nombre, Descripcion = @Descripcion, UrlImagen = @img, idTipo = @idTipo, idDebilidad = @idDebilidad where Id = @Id");
                accesoDatos.setParam("Id", pkmn.Id);
                accesoDatos.setParam("Numero", pkmn.Numero);
                accesoDatos.setParam("Nombre", pkmn.Nombre);
                accesoDatos.setParam("Descripcion", pkmn.Descripcion);
                accesoDatos.setParam("img", pkmn.urlImagen);
                accesoDatos.setParam("idTipo", pkmn.Tipo.Id);
                accesoDatos.setParam("idDebilidad",pkmn.Debilidad.Id);
                accesoDatos.executeAction();
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                accesoDatos.closeConnection();
            }
        }
    }
}
