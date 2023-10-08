using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.SqlClient;
using System.Net;
using Models;
using System.Linq.Expressions;
using System.Runtime.Remoting.Messaging;

namespace Servicio
{
    public class PokemonService
    {
        List<Pkmn> pokemons = new List<Pkmn>();
        public List<Pkmn> getAllPokemons()
        {
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

        public void delete(int id)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setQuery("delete from pokemons where id = @id");
                datos.setParam("Id", id);

                datos.executeAction();
            }catch(Exception ex)
            {

            }finally {
                datos.closeConnection();
            }
        }

        public List<Pkmn> filter(string campo,string criterio, string valor)
        {
            List<Pkmn> list = new List<Pkmn>();
            AccesoDatos accesoDatos = new AccesoDatos();

            try {
                string query = "SELECT P.Id, P.Numero, P.Nombre, P.Descripcion, ISNULL(P.UrlImagen,'') as UrlImagen, ISNULL(T.Nombre, 'Sin Tipo') as Tipo, ISNULL(D.Nombre, 'Sin Debilidad') as Debilidad, P.idTipo, P.idDebilidad " +
                    "FROM Pokemons as P " +
                    "LEFT JOIN Tipos as T ON T.id = P.idTipo " +
                    "LEFT JOIN Tipos as D ON D.id = P.idDebilidad " +
                    "WHERE ";
            
                if (campo == "Número")
                {
                    switch (criterio)
                    {
                        case "Mayor a":
                            query += "P.Numero > " + valor;
                            break;
                        case "Menor a":
                            query += "P.Numero < " + valor;
                            break;
                        case "Igual a":
                            query += "P.Numero = " + valor;
                            break;
                    }
                }
                else if(campo == "Nombre")
                {
                    switch (criterio)
                    {
                        case "Comienza con":
                            query += "P.Nombre like  '" + valor + "%'";
                            break;
                        case "Termina con":
                            query += "P.Nombre like  '%" + valor + "'";
                            break;
                        case "Contiene":
                            query += "P.Nombre like '%" + valor + "%'";
                            break;
                    }
                }
                else if(campo == "Descripción")
                {
                    switch (criterio)
                    {
                        case "Comienza con":
                            query += "P.Descripcion like  '" + valor + "%'";
                            break;
                        case "Termina con":
                            query += "P.Descripcion like  '%" + valor + "'";
                            break;
                        case "Contiene":
                            query += "P.Descripcion like '%" + valor + "%'";
                            break;
                    }
                }

                query += " ORDER BY P.Numero ASC";
                accesoDatos.setQuery(query);
                accesoDatos.executeQuery();

                while (accesoDatos.Reader.Read())
                {
                    Pkmn aux = new Pkmn();
                    aux.Id = (int)accesoDatos.Reader["Id"];
                    aux.Numero = (int)accesoDatos.Reader["Numero"];
                    aux.Nombre = (string)accesoDatos.Reader["Nombre"];
                    aux.Descripcion = (string)accesoDatos.Reader["Descripcion"];
                    aux.urlImagen = (string)accesoDatos.Reader["UrlImagen"];
                    aux.Tipo.Id = (int)accesoDatos.Reader["IdTipo"];
                    aux.Tipo.Nombre = (string)accesoDatos.Reader["Tipo"];
                    aux.Debilidad.Id = (int)accesoDatos.Reader["IdDebilidad"];
                    aux.Debilidad.Nombre = (string)accesoDatos.Reader["Debilidad"];

                    list.Add(aux);
                }
                //throw new Exception(query);
                return list;
            }catch(Exception ex)
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
