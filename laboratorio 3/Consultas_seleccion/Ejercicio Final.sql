Select F.Horario, P.Nombre as Titulo, S.Nombre as Sala, P.Duracion, CAT.Nombre as Categoria  
From Funciones F
Inner Join Salas S ON S.ID = F.IDSala
Inner Join Peliculas P ON P.ID = F.IDPelicula
Inner Join Categorias CAT ON CAT.ID = P.IDCategoria
Order by P.Nombre ASC, F.Horario DESC