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