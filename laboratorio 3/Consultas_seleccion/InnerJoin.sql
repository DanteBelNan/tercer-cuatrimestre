Use Cine
go
Select * From Peliculas
Select * From Categorias

Select P.Nombre, P.Duracion, CAT.Nombre as Categoria From Peliculas P
Inner Join Categorias CAT ON P.IDCategoria = CAT.ID
Where CAT.Nombre = 'Not Rated'

Select * from Peliculas P
Inner Join Categorias Cat on P.IDCategoria = CAT.ID