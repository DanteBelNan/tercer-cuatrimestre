1. Funciones de resumen
Permiten que información que se encuentra desagregada se resuma

COUNT: Cuenta la cantidad de elementos no nulos de la columna que se recibe como parametro
SUM: Suma la cantidad de elementos no nulos de la columna que se recibe como parametro.
AVG: Realiza el promedio de los valores no nulos de la columna que se recibe como parametro
MAX: Devuelve el valor maximo de la columna que se recibe como parametro.
MIN: Devuelve el valor minimo de la columna que se recibe como parametro.

Estas funciones permiten que la información que se encuentra desagregada se resuma
Un sinonimo de información resumida es el de "Datos agregados". Por eso, las funciones de resumen son conocidas tambien como Funciones de agregado
Todas son funciones que trabajan con información numerica, a excepción de MAX, MIN y COUNT, que aceptan texto, fechas, etc.
De no tener datos a evaluar todas devuelven NULL, a excepción de COUNT, que devuelve 0.

Ejemplo, en una tabla de mediciones donde tenemos ciudad, pais, fecha, grados y lluvia.
Suponiendo que tenemos un set de datos, donde null representa que el medidor no puede registrar información.
Si lluvia es 0, no llovio durante la estación
pero si lluvia es null, no se puede determinar si llovio o no llovio.

Las consultas de resumen nos permitirian obtener estos tipos de información:
* Cantidad de mediciones con lluvia
* Cantidad de mediciones con temperatura mayor a 25 grados
etc

Ejemplo count:
Cantidad de mediciones de lluvia que se realizaron correctamente.

select count(lluvia) from Mediciones
(cuenta todos los datos de lluvia que no sean null)
o

select count(*) from Mediciones
where Lluvia is not null
(cuenta todas las filas de mediciones, sin el where, trae absolutamente todo, pero con el where, trae todas las que no tengan nulo en lluvias, lo que seria lo mismo que el otro ejemplo)


Ejemplo SUM:
Acumula la cuenta de valores numericos y devuelve esta acumulacion

select sum(Lluvia) from Mediciones
Where Ciudad like 'Seul'
and year(Fecha) = 2020

Suma toda la lluvia ocurrida en Seul en el 2020

Si por ejemplo, pusiese una ciudad no existente, no tendria de donde contar, y devolveria null

Avg
Igual que el sum, pero calcula el promedio en lugar de la sumatoria

select Avg(Lluvia) from Mediciones
Where Ciudad like 'Seul'
and year(Fecha) = 2020

Max:
select max(grados) from Mediciones
Devuelve el mayor valor en grados

Min:
funciona exactamente igual que Max
select min(Fecha) from mediciones

Tanto min como max devuelven datos escalares (un valor que puede entrar en una variable simple)



2. Agrupamiento

Group By
Permiten que información se presente agrupada
Por ejemplo:
select Pais, count(*)
from mediciones
group by Pais

Esto nos da esta cantidad de registros por pais que cuenta

Otro ejemplo es
select year(fecha), max (grados)
from mediciones
group by year (fecha)

De esta manera, agrupa entre todas las fechas, y trae su maxima temperatura

Having
Permiten que información que se encuentra... este resumida

Cantidad de mediciones por país y ciudad con más de dos mediciones

select Pais, Ciudad, count(*)
from mediciones
group by Pais, Ciudad
having count(*) > 2