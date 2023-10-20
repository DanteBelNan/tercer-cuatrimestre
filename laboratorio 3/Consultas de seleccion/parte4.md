1. Consultas anidadas
En los apuntes de consultas anteriores fuimos aumentando la dificultad de las consultas de manera progresiva. Al principio comenzamos obteniendo todos los registros de una tabla, luego filtrando o agregando columnas de la tabla, despues aprendimos a filtrar la cantidad de filas que se obtienen mediante condiciones.
Luego se explico como obtener datos de más de una tabla mediante el uso de las consultas JOIN y por ultimo, como resumir los datos de una tabla mediante el uso de las funciones de agregado y la clausula GROUP BY.

En la ultima parte del apunte de consultas de selecciones veremos el uso de consultas anidadas o comunmente llamadas subconsultas. La idea principal aquí es que los datos de la consulta principal se obtienen de una o más consultas secundarias

Estas consultas secundarias podrian entenderse como "tablas virtuales" en el sentido de que el listado de datos que se obtiene es elaborado en el momento.

La mayoria de las veces, las subconsultas son utilizadas para evitar el uso de JOINS o intentar simplificar una consulta que de otra manera sería muy compleja. En otros casos, es la única manera de obtener un grupo de datos sin la necesidad de procesarlos con elementos de programación.

Veamos estos ejemplos:

Con la siguiente tabla:
EMPLEADOS: IDEMPLEADO, APELLIDO, NOMBRE, IDJEFE

La columna IDJefe tiene una FK a otro empleado, esta puede ser nula.

Si se ingresa un valor en idjefe se indica cual es el jefe de dicho empleado. El jefe debe ser un empleado registrado en la tabla empleados, sin embargo, en caso de no ingresarse, representa que el empleado no tiene un jefe

Supongamos que queremos obtener todos los jefes de la empresa.

Para saber esto, podriamos pensar que hay que buscar todos los empleados cuyo IDJEFE sea nulo, pero no es así, habria que buscar todos los empleados, que su idempleado sea igual al idjefe de otro empleado.

Veamos los siguientes pasos:

Obtenemos el listado completo sin filtrar
SELECT * FROM EMPLEADOS

Obtenemos todos los codigos de jefe
SELECT DISTINC IDJEFE FROM EMPLEADOS

Obtenemos mediante una subconsulta, los datos de los empleados que sean jefes.

SELECT * FROM EMPLEADOS E
WHERE E.IDEMPLEADO IN (SELECT DISTINCT IDJEFE FROM EMPLEADOS)

Aqui, podemos obserbar, como, hace uso de la primer tabla que obtuvimos, y lo relaciona con la segunda, para dar como resultado todos los jefes

Supongamos ahora, que queremos obtener para cada empleado, el apellido y nombre de su jefe

SELECT E.IDEMPLEADO,E.APELLIDO + ', ' + E.NOMBRE AS 'fullName', (SELECT AUX.APELLIDO + ', ' + AUX.NOMBRE FROM EMPLEADOS AS AUX WHERE AUX.IDEMPLEADO = E.IDJEFE) AS 'Jefe fullName' FROM EMPLEADOS AS E

Este, podemos ver como usa la subconsulta para traer una columna nueva a la tabla

Veamos un ultimo ejemplo:
Obtener el apellido y nombre del empleado que tenga mayor cantidad de empleados a cargo
SELECT apellido, nombre
FROM empleados WHERE COUNT(*) = ( SELECT COUNT(*) FROM empleados WHERE idjefe = empleados.idjefe )