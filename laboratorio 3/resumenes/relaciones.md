Tipos de relaciones entre tablas:
1 a 1
1 a N
N a N

Para crear relaciones entre bases de datos necesito:
Por lo menos 2 tablas (a menos de una relación reflexiva)
Restricciones (primarykey, foreignkey)

1 a 1:
Solo un registro de una tabla A puede relacionarse con un registro de la tabla B, y solo un registro de la tabla B puede relacionarse con un registro de la tabla A.
Ejemplo: Una persona con un DNI (ignorando duplicados) una persona puede tener solo un DNI y un DNI solo puede estar asignado a una persona
Aquí, en ambas tablas A y B, su primarykey y su foreignkey son el mismo id
Este tipo de relación no es común, porque la mayoria de la información que esta relacionada de esta manera podría estar en una sola tabla. Se puede considerar una relación uno a uno para los siguientes escenarios:
* Dividir una tabla con muchas columnas o de gran tamaño.
* Aislar parte de una tabla por motivos de seguridad.
* Almacenar datos que serán de corta duración
* Almacenar datos que sólo aplican a un subconjunto de la tabla relacionada.
* Incorporar datos nuevos a una tabla existente sin alterar la estructura original.

1 a N:
Un registro de la tabla A puede relacionarse con varios registros de la tabla B pero solo un registro de la tabla B puede relacionarse con un registro de la tabla A.
Ejemplo: una galaxia puede tener muchos planetas, pero un planeta puede tener solamente una galaxia.
Aquí, la galaxia tiene como primarykey un id, pero el planeta, tiene como primarykey su id de planeta, y un idgalaxia, que es una foreignkey.
Otro tipo de ejemplo puede ser país continente (ignorando los pocos paises que estan en dos continentes).


N a N
Muchos registros de la tabla A pueden relacionarse con varios registros de la tabla B y viceversa. Para hacer esta relación, se necesita de una tercera tabla nueva
Por ejemplo: Programadores y Lenguajes, donde un programador puede saber muchos lenguajes, y un lenguaje puede ser programado por muchos programadores, ambos ids de estas tablas son primarykey, pero debemos tener una tabla para relacionar las dos, llamemosla "Programadores_x_Lenguajes" que debe tener como primarykey y foreign key a la vez, tanto al idProgramador, como al idLenguaje, y cada registro de estas representara una union entre ambas.
