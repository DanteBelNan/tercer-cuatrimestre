Elaborar una base de datos para una app que sugiere recetas de cocina
La base debe poder registrar los distintos platillos de los cuales se necesita guardar:
* El nombre
* tiempo de cocción
* calorias por porción
* dificultad del platillo (0 al 5 + expresion decimal de un digito)
* si es vegano, vegetariano y si es apto celiaco
Y por ultimo, se deben poder registrar las recetas, cada receta es la composición de un platillo y sus distintos ingredientes, es necesario saber la cantidad y unidad de medida de cada ingrediente en el platillo


<h2> Resolución </h2>
Nombres de entidades:
Platillos
Recetas
Ingredientes
Dificultad 
Nombre
Tiempos_de_Coccion
Ingredientes
etc

Tabla: Recetas
IDPlatillo      IDIngrediente      Nombre       Cantidad

Tabla Ingredientes:
IDIngrediente      Nombre      Tiempo_coccion      Calorias_porcion    Dificultad      Vegano      Vegetariano     Celiaco

Tabla: Platillo
IDPlatillo   Nombre 
