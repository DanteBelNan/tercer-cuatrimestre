1. Inner join
Combina la tabla de la izquierda con la tabla de la derecha siempre y cuando se cumpla una condicion dada
(Es el tipo UNION DE A cno B)

Por ejemplo
select Personas.Nombre, Equipos.Equipo from Personas
inner join Equipos on Personas.IDEquipo = Equipos.ID

Esto nos trae el nombre de las personas de la db, y donde tienen el id de su equipo, trae el nombre del propio equipo.


2. Left Join (left outer join)
Combina la tabla de la izquierda con la tabla de la derecha siempre y cuando se cumpla una condición dada. Al resultado, le suma todos los registros "sobrantes"


3. Right Join
Combina la tabla de la izquierda con la tabla de la derecha siempre y cuando se cumpla una condición dada. Al resultado se le suman todos los registros sobrantes

4. Full Join
Es la mezcla de los 3 anteriores, trae todos

5. Cross Join
No lleva condiciones, arma todas las combinaciones posibles entre las dos tablas relacionadas.