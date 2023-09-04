Normalización

Hay una serie de reglas que organizacn la información de una base de datos de manera correcta. Deben ser tenidas en cuenta desde el diseño de la base de datos y dependen del contexto del problema a representar.

Primera forma normal (1FN): Todos los dominios subyacentes de los atributos deben contener valores atomicos.
2FN: Todos los atributos que no son clave tienenq ue depender por completo de la clave primaria.
3FN: Todos los atributos no clave dependen de manera no transitiva de la clave primaria.

Valor atomico significa que esta en su minima expresión

Un ejemplo de una tabla podria ser:
<h1>Actores:</h1>
<ol>

* Legajo: 12345
* Nombre: Seinfeld, Jerry
* Contacto: jerryseinfeld@gmail.com, 44 1234523, 129 West 81 Street, Apartment 5A
* Localidad: San Fernando, 1645
* Provincia: Buenos Aires (140), Argentina (54)
* Idiomas: Ingles(nativo), Castellano (basico), Italiano (avanzado), Francés (avanzado), Chino (básico)
* Fecha de nacimiento: 29/04/1959
* Edad: 67 años
* Premios: Globo de Oro (1994), Emmy (1993), Shorty Award (2014)
* Ultimo premio: Shorty Award (2014)
</ol>

Esta tabla puede ser dividida en multiples tablas, como:
* Premios
* Domicilios
* Idiomas
* Actores
* Telefonos
* Contactos
* Localidades
* Provincias

Entonces, un arbol de tablas seria
Personas dirige a domicilios, la cual dirige a localidades, la cual dirige a provincias, la cual dirige a paises
a su vez, personas tambien dirige a premios. pero al ser esta una N a N, tenemos que tener en el medio un "Premios_x_Persona"
Lo mismo con los idiomas, que debemos tener en medio un "Idiomas_x_Persona"
Tambien, Personas se ramifica en mails y telefonos.


<h2>Situación problematica: Primer Forma Normal</h2>
Todos los diminios subyacentes de los atributos contendrán valores atomicos <br>

Tabla: Contactos <br>
DNI	    APELLIDO	NOMBRES	TELEFONOS <br>
1000	Fernandez	Martin	1111, 2222 <br>
2000	Lopez	    Juliana	3333, 4444, 5555 <br>
3000	Freire	    Dalmiro	null <br>
4000	Villalba	Julieta	6666, 6666 <br>
5000	Perrone	    Candela	7777, 1111 <br>

¿Como procedemos para eliminar el telefono 4444 del contacto de Juliana?
¿Como contabilizamos cuantos telefonos tiene cada contacto?
¿De que tamaño debera ser telefonos para almacenar todos los telefonos necesarios?

<h3>Comenzar a resolver...</h3>
Podemos identificar que, telefonos es la unica tabla no atomizada, encima, hay casos que se repiten, o que comparten telefonos, etc.

Debemos saber cuantos telefonos por persona queremos, en lugar de tener todos en una tabla, supongamos que queremos tener 3 opciones de telefono, por lo que la tabla ahora seria <br>

Tabla: Contactos <br>
DNI	    APELLIDO	NOMBRES	TELEFONO 1  TELEFONO 2  TELEFONO 3 <br>
1000	Fernandez	Martin	1111        2222        null <br>
2000	Lopez	    Juliana	3333        4444        5555 <br>
3000	Freire	    Dalmiro	null        null        null <br>
4000	Villalba	Julieta	6666        6666        null <br>
5000	Perrone	    Candela	7777        1111        null <br>

Ahora, para saber por ejemplo, cuantos telefonos tiene Martin, debemos contar cuantos campos cargados hay en telefonos, y ademas, encargarnos de que no esten repetidos (como en el caso de Julieta).
Otro problema, como en el caso de Dalmiro, que no tiene telefonos, estamos desperdiciando 3 espacios, u en otro caso,  que querramos tener mas de 3 telefonos, no podremos, por lo que, seria mejor dividrlo en dos tablas, una para DNI apellido y nombres, y otra para telefonos, que tenga como PK Y FK el DNI, de la siguiente manera: <br>

Tabla: Contactos <br>
DNI	    APELLIDO	NOMBRES <br>
1000	Fernandez	Martin <br>
2000	Lopez	    Juliana <br>
3000	Freire	    Dalmiro <br>
4000	Villalba	Julieta <br>
5000	Perrone	    Candela <br>

Tabla: Telefonos_x_Contacto <br>
DNI     TELEFONO <br>
1000    1111 <br>
2000    3333 <br>
4000    6666 <br>
5000    7777 <br>
1000    2222 <br>
2000    4444 <br>
5000    1111 <br>
2000    5555 <br>

De esta manera, evitamos todos los nulls, y encima, nos ahorramos el hecho de repetir el de Julieta.
Ya pudimos solucionar de primera forma normal la normalización.

<h2> Situación problematica: Segunda forma normal </h2>
Tenemos la siguiente tabla: <br>

Tabla: empleados <br>
Legajo  nombre  AñoIngreso  IDArea  Area <br>
1       Pepe    1990        1       Desarrollo <br>
2       Juan    1991        1       Programación <br>
3       Clara   1990        1       Dev <br>
4       Lola    1998        2       Testing <br>
5       Fred    1990        3       Mensajeria <br>
6       Valen   1990        4       Impo & Expo <br>

Ahora, cada vez que entre al legajo 1, debo llegar a esta tabla.
El nombre del Area deberia depender del IDArea, pero esto no esta sucediendo, ya que hay 3 diferentes casos para IDArea
Esto podriamos cambiarlo creando una nueva tabla para el area, y en la tabla empleados mantener solo el IDArea <br>

Tabla: empleados <br>
Legajo  nombre  AñoIngreso  IDArea <br>
1       Pepe    1990        1   <br>
2       Juan    1991        1   <br>
3       Clara   1990        1   <br>
4       Lola    1998        2   <br>
5       Fred    1990        3   <br>
6       Valen   1990        4   <br>

Tabla: areas <br>
ID  NOMBRE <br>
1   Desarrollo <br>
2   Testing <br>
3   Mensajeria <br>
4   Impo & Expo <br>

De esta manera, el nombre de la tabla (la totalidad de atributos) depende enteramente del PK


<h2> Situación problematica: Tercera forma normal </h2>

Todos los atributos no clave dependen de manera no transitiva de la clave primaria <br>


Tabla: Empleados <br>
Legajo  Nombres Ingreso IDArea  JefeArea <br>
1       Pepe    1990    1       1 <br>
2       Coty    1991    1       1 <br>
3       Pato    1990    1       1 <br>
4       Eren    1998    2       2 <br>
5       Juan    1990    3       3 <br>

Tabla: Areas <br>
ID  Nombre  <br>
1   Desarrollo <br>
2   Testing <br>
3   Mensajeria <br>

Tabla: Jefes de area <br>
ID  Apellidos   Nombres <br>
1   Perez       Juan <br>
2   Rodriguez   Laura <br>
3   Delorenzi   Mariano <br>

Esta tabla parece bien, pero es erronea, ya que aunque ahora es consistente, podria dejar de ser consistente en cualquier momento, ya que, IDArea y JefeArea siempre deberian mantener al mismo jefe de area, pero puede ser que yo tenga IDArea 1 y Jefe Area 2, lo que haria que no sea consistente.

Para arreglar esto, a cada Area, podriamos ponerle un IDJefeArea, y de esta manera arreglarlo, a su vez, eliminar el JefeArea de la tabla empleados <br>

Tabla: Empleados <br>
Legajo  Nombres Ingreso IDArea <br>
1       Pepe    1990    1      <br>
2       Coty    1991    1      <br>
3       Pato    1990    1      <br>
4       Eren    1998    2      <br>
5       Juan    1990    3      <br>

Tabla: Areas <br>
ID  Nombre      ID  <br>
1   Desarrollo  1 <br>
2   Testing     2 <br>
3   Mensajeria  3 <br>

Tabla: Jefes de area <br>
ID  Apellidos   Nombres <br>
1   Perez       Juan <br>
2   Rodriguez   Laura <br>
3   Delorenzi   Mariano <br>










