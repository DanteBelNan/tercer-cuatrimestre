1. Clausulas JOIN

Hasta el momento, sólo estuvimos obteniendo datos de nuestra base de datos provenientes de una sola tabla. Sin embargo, es muy común querer obtened radtos de más de una tabla y asi poder elaborar un listado más descriptivo. Por ejemplo, es usual querer obtener la descripción principal de cada campo en lugar de su clave principal.

Utilizaremos la misma base de datos que en el apunte 'Parte 1' para ejemplificar el objetivo y los tipos de join con los que trabajamos:

PAIS: IDPAIS (int not null), NOMBRE(varchar not null)
PROVINCIAS: IDPROVINCIA(INT NOT NULL) IDPAIS (int not null), NOMBRE(varchar not null)
CIUDADES: IDCIUDAD(INT NOT NULL), IDPROVINCIA(INT NOT NULL), NOMBRE(varchar not null)

ALUMNOS: LEGAJO(INT NOT NULL), APELLIDO (VARCHAR NOT NULL), NOMBRE (VARCHAR NOT NULL), NACIMIENTO (DATETIME), DIRECCION (VARCHAR NOT NULL), IDCIUDAD(INT NOT NULL), TELEFONO(VARCHAR), EMAIL(VARCHAR),SEXO(CHAR)


Antes de cinebzar a utilizar las clausulas del tipo JOIN, veamos que ocurre cuando no las utilizamos y queremos obtener datos de diferentes tablas, supongamos que queremos obtener Apellido, nombre y nombre de la ciudad de nacimiento de cada alumno, 

Algo que podriamos hacer seria

SELECT ALUMNOS.apellido, ALUMNOS.nombre, CIUDADES.ciudad FROM ALUMNOS, CIUDADES

Pero, esto no funciona, esto trae el resultado de la multiplicacion de todas las tablas, lo cual no es la información que buscams (por cada registro de alumnos, da cada combinación de ciudades)

Este problema radica en el uso de mas de una tabla dentro del FROM, precisamente porque no especificamos que queremos todos los registros de alumnos pero solo un registro de ciudad que se encuentre relacionada a cada registro de alumno en particular.

Para lograr esto es necesario indicar mediante un WHERE, de la siguiente manera

SELECT A.apellido, A.nombre, C.ciudad FROM ALUMNOS AS A, CIUDADES AS C WHERE A.idciudad_nacimiento = C.idciudad

Aqui vemos, primero que se pueden crear alias para las tablas, ademas, podemos obtener los registros de manera limitada, en lugar de obtener el producto de todo.



2. Inner Join

Como vimos en el ejemplo anterior, se pueden obtener los resultados esperados, pero necesitando utilizar la clausula where obligatoriamente, aunque este funcionamiento es correcto, se recomienda usar INNER JOIN, cuyo objetivo es especificamente relacionar dos tablas mediante un campo que sirve de nexo, una posible solución seria:

SELECT A.apellido, A.nombre, C.ciudad FROM ALUMNOS AS A
INNER JOIN CIUDADES AS C
ON A.idciudad_nacimiento = C.idciudad

A diferencia de la consulta anterior, aqui solo traemos una tabla con el from, yluego le indicamos que esa tendra una relación con ciudades, especificamente con su id

Un problema, es que, si hay un id de ciudad que este vacio en algun alumno, este no sera traido directamente en el resultado de esta query, para solucionar este problema, veremos LEFT y JOIN

3. Left Join

La clausula LEFT JOIN, al igual que el INNER, es utilizada para indicar la relación existente entre dos tablas mediante dos columnas que sirven como nexo. Sin embargo, LEFT JOIN no exige que exista el valor de la columna de la tabla de la izquierda en el de la tabla de la derecha para obtener los dos datos.

Suponiendo que queremos obtener Apellido, nombre y nombre de la ciudad de nacimiento, mediante LEFT JOIN obtendremos todos los registros de alumnos, si existe el codigo de la ciudad en la tabla de ciudades obtendfra el nombre de la ciudad relacionada, pero si no existe, traera null, el codigo seria el siguiente:

SELECT A.apellido, A.nombre, C.ciudad FROM ALUMNOS AS A
LEFT JOIN CIUDADES AS C
ON A.idciudad_nacimiento = C.idciudad


4. RIGHT JOIN
Esta clausula, es igual a las dos anteriores, esta es utilizada para relacionar dos tablas mediante dos columnas utilizadas como nexo, RIGHT JOIN no exige que exista el valor de la tabla de la columna del FROM en el de la otra tabla.

Es decir, traeria todas las ciudades, y un alumno si lo tiene relacionado, pero si una ciudad no tiene alumno, la trae con campos null en los datos del alumno, una query seria así:

SELECT A.apellido, A.nombre, C.ciudad FROM ALUMNOS AS A
RIGHT JOIN CIUDADES AS C
ON A.idciudad_nacimiento = C.idciudad


5. FULL JOIN
Por ultimo, existe full join, que como lo indica su nombre, es el listado completo, comprendiendo la combinación entre left join y right join, un ejemplo seria:

SELECT A.apellido, A.nombre, C.ciudad FROM ALUMNOS AS A
FULL JOIN CIUDADES AS C
ON A.idciudad_nacimiento = C.idciudad



Anidamiento de JOINS
Es probable que uno haya normalizado lo suficiente una base de datos de manera tal para que para obtener algun valor haya que recorrer diferentes niveles de relaciones entre mas de dos tablas, esto es posible hacerlo combinando los joins correctamente. Supongamos que queremos obtener nombre,apellido y pais de nacimiento de cada alumno. Para ello, tenemos que tener en cuenta que las relaciones son
alumno -> ciudades -> provincias -> paises

Por lo que necesitamos anidar asi los joins, para obtener esta data, un ejemplo de query seria:

Ejemplo:
SELECT A.apellido, A.nombre, PA.pais FROM ALUMNOS AS A
INNER JOIN CIUDADES AS C
ON C.idciudad = A.IDCIUDAD_NACIMIENTO

INNER JOIN PROVINCIAS AS PR
ON PR.IDPROVINCIA = C.IDPROVINCIA

INNER JOIN PAISES AS PA
ON PA.IDPAIS = PR.IDPAIS


6. Clausula UNION
Esta clausula combina los resultados de dos consultas de SELECT, todos los resultados de una consulta se unen con los de la otra, no debe confundirse esta operación con JOIN, ya que JOIN se encarga de combinar las columnas de dos tablas.

Supongamos el siguiente ejemplo:

ALUMNOS: idalumno, apellido, nombre, nacimiento
EMPLEADOS: legajo, apellido,nombre, nacimiento, sueldo
GRADUADO: idgraduado, apellido, nombre, nacimiento, graduacion

Una alternativa para obtener las tres tablas en una consulta es:
SELECT * FROM ALUMNOS
SELECT * FROM GRADUADOS
SELECT * FROM EMPLEADOS


Pero esto, trae tres tablas distintas, son independientes entre sí.
Para solucionar esto, tenemos la clausula union, pero antes de desarrollarla tenemos que comprender que si vamos a unir filas estas deben compartir las mismas columnas, sino no tendria sentido.

En principio, determinemos que estructura de listado vamos a querer y luego que filtros vamos a aplicarle.

En este caso digamos que queremos obtener:
A) el código identificatorio, apellido, nombre, fecha de nacimiento, sueldo y qué tipo de rol cumple en la institución de todos los alumnos.
B) Un listado similar con apellido, nombre y fecha de nacimiento pero de quienes hayan nacido entre 1976 y 1986.

Como podemos observar, la mayoria de los campos los obtenemos de sus respectivas tablas a excepción del sueldo para los graduados y alumnos, asi como el rol que no figura en ninguna tabla, no obstante, como vimos en los primeros apuntes de selección, podemos obtener valores constantes en nuestra consulta de select que en este caso, sirven de 'placeholders' para las columnas faltantes, la consulta A quedaria así:

SELECT IDALUMNO AS ID, APELLIDO, NOMBRE, FECHA_NACIMIENTO, 0 AS SUELDO, 'ALUMNO' AS ROL FROM ALUMNOS
UNION
SELECT IDGRADUADO AS ID, APELLIDO, NOMBRE, FECHA_NACIMIENTO, 0 AS SUELDO, 'GRADUADO' AS ROL FROM GRADUADOS
UNION
SELECT LEGAJO AS ID, APELLIDO, NOMBRE, FECHA_NACIMIENTO, SUELDO, 'EMPLEADO' AS ROL FROM EMPLEADOS


Como podemos observar, obtener en un mismo listado los cinco registros que antes teniamos en tres listados. la clausula UNION se encargo de combinarlos ya que todos los números de columnas coincidian, para darle homogeneidad a los listados se uso esos placeholders en donde no habian datos.

Veamos la consulta B:

SELECT APELLIDO, NOMBRE, FECHA_NACIMIENTO FROM ALUMNOS
WHERE YEAR(FECHA_NACIMIENTO) BETWEEN 1976 AND 1986
UNION
SELECT APELLIDO, NOMBRE, FECHA_NACIMIENTO FROM GRADUADOS
WHERE YEAR(FECHA_NACIMIENTO) BETWEEN 1976 AND 1986
UNION
SELECT APELLIDO, NOMBRE, FECHA_NACIMIENTO FROM EMPLEADOS
WHERE YEAR(FECHA_NACIMIENTO) BETWEEN 1976 AND 1986

Esto trae un problema, ya que si llegasen a haber dos columnas que traen mismo resultado, pero son de diferentes tablas, solo se mostrara una, ya que hay aplicado un distinct por defecto en UNION, si queremos que esto no suceda, debemos ejecutar con un UNION ALL, así:

SELECT APELLIDO, NOMBRE, FECHA_NACIMIENTO FROM ALUMNOS
WHERE YEAR(FECHA_NACIMIENTO) BETWEEN 1976 AND 1986
UNION ALL
SELECT APELLIDO, NOMBRE, FECHA_NACIMIENTO FROM GRADUADOS
WHERE YEAR(FECHA_NACIMIENTO) BETWEEN 1976 AND 1986
UNION ALL
SELECT APELLIDO, NOMBRE, FECHA_NACIMIENTO FROM EMPLEADOS
WHERE YEAR(FECHA_NACIMIENTO) BETWEEN 1976 AND 1986


