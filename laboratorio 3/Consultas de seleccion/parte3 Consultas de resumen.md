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
Funciona igual que el min, pero trae los numeros maximos