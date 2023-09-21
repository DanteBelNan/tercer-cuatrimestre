Clausula SELECT
mediante la sentencia select, vamos a poder obtener datos de nuestra base de datos. la misma permite no solo aplicar filtros a las columnas, sino tambien a las filas, esta tiene una serie de elementos y argumentos que se pueden incorporar para facilitar nuestro procesamiento de información al momento de realizar las consultas.

Antes de comenzar con las diferentes alternativas de como utilizar las conultas select, vamos a utilizar una base de datos de ejemplo para poder ubicarlas en el contexto de un caso practico

PAIS: IDPAIS (int not null), NOMBRE(varchar not null)
PROVINCIAS: IDPROVINCIA(INT NOT NULL) IDPAIS (int not null), NOMBRE(varchar not null)
CIUDADES: IDCIUDAD(INT NOT NULL), IDPROVINCIA(INT NOT NULL), NOMBRE(varchar not null)

ALUMNOS: LEGAJO(INT NOT NULL), APELLIDO (VARCHAR NOT NULL), NOMBRE (VARCHAR NOT NULL), NACIMIENTO (DATETIME), DIRECCION (VARCHAR NOT NULL), IDCIUDAD(INT NOT NULL), TELEFONO(VARCHAR), EMAIL(VARCHAR),SEXO(CHAR)


Una sentencia para obtener los datos de todas las ciuaddes seria
select * from ciudades

o select idciudad, idprovincia nombre from ciudades

En este ultimo ejemplo, se especifican explicitamente las columnas de las cuales se obtendrán los datos. En este caso, la tabla de ciudades está compuesta por las IDCIUDAD, IDPROVINCIA y NOMBRE.

Esto funciona con todas las tablas, tambien podriamos usar un
SELECT * FROM ALUMNOS

Pero supongamos que queremos obtener todos los registros de la tabla alumnos pero solo de las columnas legajo, apellido y fecha nacimiento, entonces, tendriamos que seleccionar solo esos valores

SELECT LEGAJO, APELLIDO, NOMBRE, NACIMIENTO FROM ALUMNOS

Con sql, tambien podemos incorporar columnas que no son propias de la tabla, como por ejemplo así:

SELECT LEGAJO, APELLIDO, NOMBRE, DATEDIFF(YEAR, 0, GETDATE()-FECHA_NACIMIENTO) AS EDAD FROM ALUMNOS

de esta manera obtenemos la edad, sin que sea necesariamente parte de la db

Otro ejemplo, seria
SELECT APELLIDO, 1 AS UNO, 'Hola mundo' AS HOLA, MONTH(FECHA_NACIMIENTO) AS MES, YEAR(FECHA_NACIMIENTO) AS ANIO FROM ALUMNOS

que nos da su año de nacimiento y mes con nombres especiales, aunque no sean parte de la tabla, ademas, de ponerle valores como hola y uno.

El ejemplo no tiene mucho sentido practico, pero sirve como muestra de herramientas.

Por ultimo, se puede observar como se pueden obtener registros sin la necesidad de que provengan de su tabla, es raro pedirlo, pero es valido



SELECT ALL, SELECT DISTINCT y SELECT TOP

SELECT ALL: Es un comando que trae todos los datos que existen en la tabla, muy similar al *

podemos pedirlo para solo un miembro, como por ejemplo

SELECT ALL YEAR(FECHA_NACIMIENTO) AS ANIO_NAC FROM ALUMNOS

SELECT DISTINCT: Si un dato esta duplicado, no lo trae por segunda vez

SELECT DISTINCT YEAR(FECHA_NACIMIENTO) AS ANIO_NAC FROM ALUMNOS

SELECT TOP: Trae un numero limitado de resultados, definiendose este como parametro, los primeros resultados son los que encuentra

SELECT TOP (3) YEAR(FECHA_NACIMIENTO) AS 'FECHA_NAC' FROM ALUMNOS



Clausula ORDER BY

En ocasiones, queremos organizar los datos que vienen de la query de formas especificas, para eso, utilizamos order by, que puede servir por ejemplo, para ordenar de manera ascendente numeros o palabras, veamoslo así:

SELECT LEGAJO, APELLIDO, NOMBRE, IDCIUDAD_NACIMIENTO FROM ALUMNOS
ORDER BY IDCIUDAD_NACIMIENTO ASC

Que ordena por numero, o así:

SELECT LEGAJO, APELLIDO, NOMBRE, IDCIUDAD_NACIMIENTO FROM ALUMNOS
ORDER BY IDCIUDAD_NACIMIENTO DESC, APELLIDO ASC


Que trae de manera descendente por numero, y en caso de empate, trae de manera ascendente por apellido




Clausula WHERE
Los where son condicionales, y nos traen inofmración exclusivamente cuando se cumplan requisitos, por ejemplo
SELECT * FROM ALUMNOS WHERE LEGAJO > 1500
Aqui pueden aplicarse varias condiciones anidadas, con AND, OR y NOT para la negación

Operador BETWEEN

Este se utiliza para buscar valores entre rangos, por ejemplo
SELECT * FROM ALUMNOS WHERE LEGAJO BETWEEN 1000 AND 1100

O por otro ejemplo:
SELECT LEGAJO, APELLIDO + ', ' + NOMBRE AS APENOM, FECHA_NACIMIENTO FROM ALUMNOS WHERE FECHA_NACIMIENTO BETWEEN '1/1/1980' AND '1/1/1990'





Operador IN

Utilizando este operador podemos determinar si un valor especifico se encuentra dentro de la lista de valores, es como un where = pero exclusivo para in, y podemos anidar varios:

SELECT LEGAJO, APELLIDO, NOMBRE FROM ALUMNOS WHERE LEGAJO IN (1000, 1100, 1101)



Operador LIKE
Mediante este operador, tererminamos si una cadena de caracteres coincide con un patron determinado, podemos aplicarle ciertos comunes para darle mas datos

% : Cualquier cadena de cero o más caracteres
WHERE nombre LIKE '%arol%' - busca todos los registros que contengan ‘arol’ en el nombre. Ej: Carol, Carolina, Carola.

_ : Cualquier caracter
WHERE nombre LIKE 'Fernand_' - busca todos los registros que contengan 'Fernand' más un caracter cualquiera. Ej: Fernando, Fernanda, Fernand9.

[ ] : Cualquier carácter individual dentro de un intervalo o conjunto que se haya especificado.
WHERE nombre LIKE '[a-m]ario' - busca todos los registros que contengan un nombre que comience con un caracter entre la 'a' y la 'm' y que luego continúe con la cadena 'ario'. Ej: Dario, Mario.

WHERE nombre LIKE '[kcmh]arina' - busca todos los registros que contengan un nombre que comience con 'k','c','m' ó 'h' y que luego continúe con la cadena 'arina'. Ej: Marina, Karina, Carina, etc.


[^] - Cualquier caracter individual que no se encuentre dentro de un intervalo o conjunto que se haya especificado.
WHERE nombre LIKE 'an[^g]%' - busca todos los registros que contengan un nombre que comience con la cadena 'an' que la tercer letra no sea una 'g' y que luego continúe con cualquier cantidad y tipo de caracter. Ej: 'Analía', 'Antonio', 'Ana' pero NO 'Angel', 'Angie'.




