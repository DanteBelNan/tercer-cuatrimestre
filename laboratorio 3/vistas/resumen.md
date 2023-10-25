1. Vistas
Una vista consiste en una tabla virtual definida mediante una consulta del tipo SELECT.
De esta manera se obtiene dinamicamente el conjunto de columnas y filas de una tabla o de dos o más tablas relacionadas
Las vistas ayudan a abstraer la complejidad de una consulta, simplificando la visión de la base de datos que tiene un usuario.

Las vistas nos ofrecen la posibilidad de:

1- Reutilizar instrucciones SELECT complejas
Supongamos que debemos obtener los datos empleados, junto con su cargo, la antiguedad en el mismo, el domiciolio y el sueldo actual a cobrar. Tengamos en cuenta que el calculo de dicha información puede resultar un poco compleja y rebuscada. Si necesitaramos en muchos reportes y listados obtener estos registros, sería más sencillo crear una vista que se encargue de obtener estos datos y luego cada vez que se necesite acceder a ellos realizar una consulta de selección a la vista.

Por ejemplo, nosotros tenemos
una cantidad N de tablas, estas pueden recurrir a una vista, que nos devolvera una N cantidad de reportes.
Mediante el uso de la vista lo que conseguimos es abstraer la complejidad, ya que al momento de elaborar los reportes se solicitarán los datos directamente de nuestra vista sin preocuparnos por el calculo de las columnas, por otra parte, si en alguna emperesa, se decidiera modificar algun tipo de calculo, solo necesitamos modificar la vista para que quede actualizado el proceso.

2- Denormalizar datos
Si bien la estructura de nuestra base de datos permanece normalizada, al momento de utilizar vistas, no sera necesario que estas se encuentren normalizadas, por ejemplo, podria obtener el apellido, nombre, edad, domicilio y ciudad de residencia, nombre de la obra social y cantidad de ventas realizadas de un empleado. Este conjunto de datos proviene de diversas tablas que se encontrarán relacionadas mediante claves. Algunas de las columnas de la vista provienen de estas tablas y otras provienen de conexiones entre tablas.
Quien utilice la vista no debera preocuparse por recorrer las conexiones o realizar los calculos.

3- Aplicar filtros:
Como las vistas permiten que se les realicen consultas de SELECT. se pueden utilizar las mismas clausulas que se utilizan en las consultas de selección tradicionales conmo ordenamientos y filtros
De esta manera, las vistas se transforman en una herramienta muy poderosa.


2. Codigo SQL y ejemplos

Se puede obtener un conjunto de datos desnormalizado de unae structura normalizada, simplificando la tarea de manipulación de datos por parte de quien utilice la vista.

A continuación, veremos el código que permite generar la vista que obtiene los datos de los jguadores.

Para crear una vista, se necesitará crear un objeto de la base de datos, el mismo debera tener un nombre válido que no se repita, y que no sea una palabra reservada. La sentencia utilizada para crear vistas es CREATE VIEW nombre_vista AS
Por ejemplo, si quisiera generar una vista que traiga todos los jugadores, deberia hacer:

CREATE VIEW vw_ListadoJugadores AS SELECT * FROM JUGADORES

Aquí tenemos una vista que obtendrá los mismos datos que SELECT * FROM JUGADORES, vale aclarar que podemos aplicarle consultas de selección a nuestra vista, permitiendo ejecutar, por ejemplo, SELECT LJ. * FROM vw_ListadoJugadores as LJ where LJ.Apellido LIKE '%EZ'

Aqui, estamos trayendo todos los datos de todos los jugadores que su apellido termine con EZ

Ahora, mezclemos con subconsultas.

Supongamos que deseamos obtener además del apellido y nombre, el equipo donde el jugador se desempeña, la cantidad de partidos jugados, la cantidad de tarjetas, la cantidad de goles y el promedio de goles por partido. Para ello, debemos incluir a la consulta principal un grupo de subconsultas.

SELECT J.APELLIDO, J.NOMBRE, E.EQUIPO,
(SELECT COUNT(IDPARTIDO) FROM PARTIDOS_X_JUGADOR WHERE IDJUGADOR = J.IDJUGADOR) AS CANT_PARTIDOS,
(SELECT SUM(T_AMARILLA + T_ROJA) FROM PARTIDOS_X_JUGADOR WHERE ID_JUGADOR = J.IDJUGADOR) AS TOTAL_TARJETAS,
(SELECT SUM(GOLES_FAVOR) FROM PARTIDOS_X_JUGADOR WHERE ID_JUGADOR = J.IDJUGADOR) AS TOTAL_GOLES,
(SELECT AVG(GOLES_FAVOR * 1.00) FROM PARTIDOS_X_JUGADOR WHERE IDJUGADOR = J.JUGADOR) AS PROMEDIO_GOLES
FROM JUGADORES AS J
INNER JOIN EQUIPOS E ON E.IDEQUIPO = J.IDEQUIPO

La consulta parecia muy dificil, pero se puede observar como a partir de la cuarta columna, todos los valores provienen de subconsultas que se encuentran relacionadas a cada uno de los jugadores.

Por ejemplo, supongamos que la primera fila es de un jugador X, que juega en Barcelona, y luego queremos obtener la cantidad de partidos jugados, por lo que se realiza una subconsulta realizando un COUNT del campo IDPARTIDO de la tabla PARTIDOS_X_JUGADOR, siempre que el IDJUGADOR de esta tabla, sea igual al idjugador del de jugadores.
Así, realizamos con todas las tablas.

De esta manera, gracias a la utilización de subconsultas, podemos obtener en el mismo grupo de datos la información estadística de todos los jugadores. Pero, a medida que queramos incorporar filtros, ordenamientos, etc. La incorporación de más y más subconsultas incorporan un nivel muy alto a la consulta, por eso, comenzamos a utilizar vistas:

Primero, transformamos nuestra consulta en una vista, de la sigueinte forma

CREATE VIEW vw_EstadisticaJugadores
AS
SELECT J.APELLIDO, J.NOMBRE, E.EQUIPO,
(SELECT COUNT(IDPARTIDO) FROM PARTIDOS_X_JUGADOR WHERE IDJUGADOR = J.IDJUGADOR) AS CANT_PARTIDOS,
(SELECT SUM(T_AMARILLA + T_ROJA) FROM PARTIDOS_X_JUGADOR WHERE ID_JUGADOR = J.IDJUGADOR) AS TOTAL_TARJETAS,
(SELECT SUM(GOLES_FAVOR) FROM PARTIDOS_X_JUGADOR WHERE ID_JUGADOR = J.IDJUGADOR) AS TOTAL_GOLES,
(SELECT AVG(GOLES_FAVOR * 1.00) FROM PARTIDOS_X_JUGADOR WHERE IDJUGADOR = J.JUGADOR) AS PROMEDIO_GOLES
FROM JUGADORES AS J
INNER JOIN EQUIPOS E ON E.IDEQUIPO = J.IDEQUIPO

Ahora, sabiendo que exist eun objeto en nuestra base de datos que nos permite traer estos datos solo con un select, un simple SELECT * FROM vw_EstadisticaJugadores, nos traera toda esta información.

Por ejemplo

SELECT * FROM vw_EstadisticaJugadores WHERE TOTAL_TARJETAS = 1 AND TOTAL_GOLES = 0

Claramente, podemos ver como la consulta compleja, es simplificada de manera enorme.

Supongamos ahora que al ejecutar la siguiente consulta, nos falta un dato importante, por ejemplo, IDJUGADOR, y queremos agregarlo a la vista, para eso, utilizamos ALTER VIEW
con la estructura
ALTER VIEW nombre_vista AS

Para este caso en particular, deberiamos ejecutar el ALTER VIEW de la vista vw_EstadisticaJugadores con la incorporación de la columna IDJUGADOR a la consulta selección.

ALTER VIEW vw_EstadisticaJugadores
AS
SELECT J.IDJUGADOR, J.APELLIDO, J.NOMBRE, E.EQUIPO,
(SELECT COUNT(IDPARTIDO) FROM PARTIDOS_X_JUGADOR WHERE IDJUGADOR = J.IDJUGADOR) AS CANT_PARTIDOS,
(SELECT SUM(T_AMARILLA + T_ROJA) FROM PARTIDOS_X_JUGADOR WHERE ID_JUGADOR = J.IDJUGADOR) AS TOTAL_TARJETAS,
(SELECT SUM(GOLES_FAVOR) FROM PARTIDOS_X_JUGADOR WHERE ID_JUGADOR = J.IDJUGADOR) AS TOTAL_GOLES,
(SELECT AVG(GOLES_FAVOR * 1.00) FROM PARTIDOS_X_JUGADOR WHERE IDJUGADOR = J.JUGADOR) AS PROMEDIO_GOLES
FROM JUGADORES AS J
INNER JOIN EQUIPOS E ON E.IDEQUIPO = J.IDEQUIPO


De esta manera, podemos actualizar la vista.
Tambien, para eliminar una vista, utilizamos

DROP VIEW nombre_vista


