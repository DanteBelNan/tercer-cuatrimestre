use master

create DATABASE PokedexDB

use PokedexDB

create table Tipos (
    Id INT PRIMARY KEY IDENTITY(1, 1),
    Nombre varchar(30)
)

create table Pokemons (
    Id INT PRIMARY KEY IDENTITY(1, 1),
    Numero int,
    Nombre varchar(50),
    Descripcion varchar(255),
    UrlImagen varchar(500),
    idTipo int,
    idDebilidad int,
    idEvolucion int,
    activo BIT,
    FOREIGN KEY (idTipo) REFERENCES Tipos(id),
    FOREIGN KEY (idDebilidad) REFERENCES Tipos(id),
    FOREIGN KEY (idEvolucion) REFERENCES Pokemons(id),


)

INSERT INTO Tipos (Nombre)
VALUES
  ('Fuego'),
  ('Agua'),
  ('Planta'),
  ('Eléctrico'),
  ('Hielo'),
  ('Lucha'),
  ('Volador'),
  ('Psíquico'),
  ('Roca'),
  ('Veneno'),
  ('Tierra'),
  ('Fantasma'),
  ('Acero'),
  ('Hada');



insert into Pokemons (Numero,Nombre,Descripcion,UrlImagen,idTipo,idDebilidad,activo) VALUES
    (1,'Bulbasaur','Rana de planta', 'https://assets.pokemon.com/assets/cms2/img/psokedex/full/001.png',3,1,1),
    (4,'Charmander','Lagartija de fuego', 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/004.png',1,2,1),
    (12,'Butterfree','Mariposa', 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/012.png',3,1,1),
    (16,'Pidgey','Pajaro', 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/016.png',7,4,1);


SELECT P.Numero, P.Nombre, P.Descripcion, ISNULL(P.UrlImagen,'') as UrlImagen, ISNULL(T.Nombre, 'Sin Tipo') as Tipo, ISNULL(D.Nombre, 'Sin Debilidad') as Debilidad, P.idTipo, P.idDebilidad FROM Pokemons as P LEFT JOIN Tipos as T ON T.id = P.idTipo LEFT JOIN Tipos as D ON D.id = P.idDebilidad ORDER BY P.Numero ASC


insert into Pokemons (Numero,Nombre,Descripcion,activo) values(1,'TEST','desc',1)

SELECT * FROM Pokemons


SELECT P.Id, P.Numero, P.Nombre, P.Descripcion, ISNULL(P.UrlImagen,'') as UrlImagen, ISNULL(T.Nombre, 'Sin Tipo') as Tipo, ISNULL(D.Nombre, 'Sin Debilidad') as Debilidad, P.idTipo, P.idDebilidad 
FROM Pokemons as P 
LEFT JOIN Tipos as T ON T.id = P.idTipo 
LEFT JOIN Tipos as D ON D.id = P.idDebilidad 
WHERE P.Activo = 1
ORDER BY P.Numero ASC

SELECT P.Id, P.Numero, P.Nombre, P.Descripcion, ISNULL(P.UrlImagen,'') as UrlImagen, ISNULL(T.Nombre, 'Sin Tipo') as Tipo, ISNULL(D.Nombre, 'Sin Debilidad') as Debilidad, P.idTipo, P.idDebilidad 
FROM Pokemons as P 
LEFT JOIN Tipos as T ON T.id = P.idTipo 
LEFT JOIN Tipos as D ON D.id = P.idDebilidad 
WHERE P.Activo = 1 and p.Nombre like '%ch%'
order by p.Numero ASC


