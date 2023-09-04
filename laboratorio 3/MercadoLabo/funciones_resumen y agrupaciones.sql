Use Cine
Go
--Cantidad de clientes
Select Count(*) as 'Cant_clientes'
from Clientes
--Tambien podriamos con el ID, ya que ninguno es nulo
Select Count(ID) as 'Cant_clientes' from clientes


--Cantidad de clientes con celular
Select count(*) as CantCliCel From Clientes Where Celular is not null

--Esta forma es mas efectiva, ya que agarra exclusivamente de el celular y no de otro lado.
Select count(Celular) As CantCliCel From Clientes


--La capacidad total de todas las salas de todo el complejo de cine
Select sum(capacidad) as CapacidadTotal from Salas


--La capacidad total de todas las salas 3d del cine
Select sum(s.capacidad) as CapacidadTotal from Salas s
inner join TiposSalas ts on ts.ID = S.IDTipo
where ts.nombre Like '%3D%'


--Por cada tipo de sala,la cantidad de salas, la capacidad total y el promedio de capacidad
Select 
TS.nombre,
Count(*) as CantSalas, 
sum(s.capacidad) as CapacidadTotal,
AVG(Cast(s.capacidad as Decimal(5,2))) as PromedioCapacidad 
from Salas s
inner join TiposSalas ts on ts.ID = s.IDTipo
group by(ts.Nombre)


--Por cada tipo de sala, la capacidad individual mas grande
Select TS.nombre, max(s.capacidad) as maxTam 
from Salas s
inner join TiposSalas ts on ts.ID = s.IDTipo
group by(ts.Nombre)

--Por cada pelicula, el nombre de la pelicula y la cantidad total de funciones, contabilizando las que no tengan funciones
Select P.ID, p.nombre, count(f.ID) as funciones
from Peliculas p
left join Funciones f on f.IDPelicula = p.ID
group by P.ID, p.Nombre


-- Por cada pelicula, el nombre de la pelicula, y la cantidad de salas en las que se proyecto.
Select P.ID, P.Nombre, Count(Distinct S.ID) as SalasPresento
From Peliculas P
Inner join funciones f on P.ID = F.IDPelicula
Inner join Salas S on F.IDSala = S.ID
Group by P.ID, P.NOMBRE

--Nombres de peliculas que se hayan proyectado unicamente en una sala
Select P.ID, P.Nombre, Count(Distinct S.ID) as SalasPresento
From Peliculas P
Inner join funciones f on P.ID = F.IDPelicula
Inner join Salas S on F.IDSala = S.ID
Group by P.ID, P.NOMBRE
Having count(Distinct S.ID)=1