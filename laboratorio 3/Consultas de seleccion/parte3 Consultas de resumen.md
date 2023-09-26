1. Consultas de resumen

Las consultas de resumen se pueden definir como el tipo de consultas cuyas filas resultantes son el resumen de las filas de la tabla de origen.
Las mismas pueden ser sobre la tabla en su totalidad o sobre un grupo de campos. Entre los resumenes que se pueden realizar tenemos minimo, maximo, suma, promedio y contabilización de registros.

Este tipo de consultas son muy utiles cuando queremos hacer reportes con datos sumarizados ya que no será necesario obtener todos los datos de las tablas correspondientes y luego realizar los calculos con algun lenguajes de programación en particular, sino, lo realiza la misma base de datos, para ejemplificar, comencemos con el siguiente tipo de tablas:

ALUMNOS: LEGAJO, APELLIDO, NOMBRE
CARRERAS: IDCARRERA, CARRERA
MATERIAS: IDMATERIA, MATERIA, IDCARRERA
CALIFICACIONES: FECHA, IDMATERIA, LEGAJO, NOTA

COUNT:

Si realizamos un select de todos los registros de calificaciones nos trae el tipo resultado de toda la db, pero en cambio, podemos hacer por ejemplo, un count, que hace un conteo de resultados:
SELECT COUNT(*) AS CANTIDAD_APROBADOS FROM CALIFICACIONES WHERE NOTA >= 4

O un directo
SELECT COUNT(*) AS CANTIDAD_TOTAL FROM CALIFICACIONES

Como podemos observar, la función de agregado COUNT se utiliza para contar registros, la misma puede ser utilizada en conjunto con la clausula WHERE para filtar los registros que contara


SUM:
Esta función se utiliza para sumar una columnta entre una serie de registros.

SELECT SUM(NOTA) AS SUMA_NOTAS FROM CALIFICACIONES
Esta, sumara todas las notas de todos los alumnos

SELECT SUM(NOTA)/COUNT(*)  AS PROMEDIO_NOTAS FROM CALIFICACIONES
En cambio este, nos dara el promedio de todas las notas, pero no es lo mas optimo, ya que tenemos directamente la funcion AVG

AVG:
Obtiene el promedio de las celdas obtenidas
SELECT AVG(NOTA) AS PROMEDIO_NOTAS FROM CALIFICACIONES

Si el tipo de dato que se trae el promedio es int, no traera su promedio con decimales, para hacer que sea con decimales, debemos hacerlo así:
SELECT AVG(NOTA * 1.0) AS PROMEDIO_NOTAS FROM CALIFICACIONES

MIN:
Esta función se utiliza para obtener el minimo valor de todos los resultados traidos, funciona tanto en fechas como en numeros

MAX:
Funciona igual que el min, pero trae los numeros maximos de la query.


La clausula GROUP BY
En los ejemplos anteriorres hicimos consultas en las que solo obteniamos una columna al utilizar estas funciones de agregado, sin embargo, es normal que, ademas del valor que obtenemos con la función de agregado, necesitemos otros valores provenientes de otras columnas. En este caso, la naturaleza de las funciones de agregado es la misma, a diferencia de que ahora debemos entenderlo en el contexto de un agrupamiento de información. A continuación, veremos una serie de ejemplos para dejarlo más claro:

-La cantidad de examenes rendidos por alumno (se necesita el nombre y el apellido).

Para realizar esta consulta, primero debemos comprender que tipo de funcion de sumarización necesitaremos y luego que tipo de agrupamiento hay que aplicar. Esta claro que tenemos que obtener el nombre de cada alumno, y el contador de materias rendidas, por lo que las columnas podrian llamarse Apellido y Nombre, y Cantidad de materias rendidas, de modo que tendremos que utilizar la función COUNT para realizarla, la consulta quedaria:

SELECT A.APELLIDO + ', ' + A.NOMBRE AS Apenom, COUNT(*) AS 'Cantidad de materias' FROM ALUMNOS A INNER JOIN CALIFICACIONES C ON A.LEGAJO = C.LEGAJO
GROUP BY A.APELLIDO + ', ' + A.NOMBRE
ORDER BY COUNT(*) DESC


Como resultado obtenemos un listado que cuenta la cantidad de materias rendidas por cada alumno y que se encuentra agrupado por apellido y nombre, ademas, se puede ver como el listado no puede ser ordenado por la cantidad de registros que conto, en este caso de mayor a menor.
La clave aquíi se encuentra en la clausula GROUP BBY, sin ella no podria llevarse a cabo el agrupamiento de registros, y por lo tanto no se podria contar las filas aplicando dicho criterio. Esto quiere decir que en una consulta de agrupamiento, todas las columnas no calculables (que no hayan sido resumidas mediante COUNT,SUM,AVG o MAX) deben de aparecer en la clausula GROUP BY.

Para completar este ejemplo en particular, nos restaria preguntarnos, ¿Y si hay alumnos que no hayan rendido materias? ¿Como hacemos que aparezcan¡
Estos no se estan trayendo, debido al tipo de JOIN, como tenemos inner join, que busca la union, los que son nulos, no aparecen, por lo que debemos reemplazarlo por un left join, pero este no es el unico cambio.


SELECT A.APELLIDO + ', ' + A.NOMBRE AS Apenom, COUNT(*) AS 'Cantidad de materias' FROM ALUMNOS A LEFT JOIN CALIFICACIONES C ON A.LEGAJO = C.LEGAJO
GROUP BY A.APELLIDO + ', ' + A.NOMBRE
ORDER BY COUNT(*) DESC

Pero esto, contiene un error, ya que, los que traiga que no tengan materias, les aparecera como 1, porque al leerle el null, lo suma al contador y queda en uno.

SELECT A.APELLIDO + ', ' + A.NOMBRE AS Apenom, COUNT(C.NOTA) AS 'Cantidad de materias' FROM ALUMNOS A LEFT JOIN CALIFICACIONES C ON A.LEGAJO = C.LEGAJO
GROUP BY A.APELLIDO + ', ' + A.NOMBRE
ORDER BY COUNT(C.NOTA) DESC

Esto lo arregla bien.


Veamos un ejeemplo para obtener un promedio de notas por materia

Necesitaremos
AVG y agrupar nombre de materia.

SELECT M.MATERIA, AVG(C.NOTA*1.0) AS 'Promedio notas' 
FROM MATERIAS M 
LEFT JOIN CALIFICACIONES C ON C.IDMATERIA = M.IDMATERIA
GROUP BY M.MATERIA

Esto nos la tarea, trayendo las materias que no tengan nota, y multiplicando con 1.0 para que sea un dato decimal el que vuelve.



Clausula Having

Ahora que podemos obtener listados con valores sumarizados o calculados ya sea agrupando datos o utilizando toda la tabla, también sería interesante poder ponerle condiciones a dichos cálculos.

En el primero de los ejemplos, habiamos contabilizado todas las calificaciones que sean >= 4. Este tipo de restriccion es simple, ya que se realiza sobre uno de los campos no sumarizados y se lleva a cabo mediante la clausula where, pero distinto seria si quisieramos obtener un listado de materias y sus promedios, pero solo incluirlos al listado si tienen un promedio mayor a 6.1, notese que no se quiere calcular el promedio solo de las notas que superen el valor 6.1, sino que quiere calcular el promedio de todas las calificaciones agrupado por materia, y luego determinar si debe incluirse al listado o no si este supera el valor deseado. Ese tipo de restriccion se realiza con HAVING

SELECT M.MATERIA, AVG(C.NOTA*1.0) AS 'Promedio notas' FROM MATERIAS M LEFT JOIN CALIFICACIONES C ON C.IDMATERIA = M.IDMATERIA
GROUP BY M.MATERIA
HAVING AVG(C.NOTA*1.0) > 6.1


Quedando así, funcional.

Ahora, veamos un ultimo ejemplo:

SELECT A.LEGAJO, A.APELLIDO + ', ' + A.NOMBRE AS APENOM, MAX(C.NOTA) AS 'NOTA MAXIMA' FROM ALUMNOS A
INNER JOIN CALIFICACIONES C ON C.LEGAJO = A.LEGAJO
GROUP BY A.LEGAJO, A.APELLIDO + ', ' + A.NOMBRE


Esta consulta nos trae el legajo, nombre, y nota maxima obtenida, sin embargo, solo obteniamos la nota maxima cuando no aplicamos agrupamiento, en ese caso, obteniamos la calificación maxima de la tabla. en cambio, y como podemos ver en esta query, nos trae la de cada uno de los alumnos.
