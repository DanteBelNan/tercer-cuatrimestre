--UNION
SELECT P.Nombre, P.Duracion, 'Largometraje' as Clasificacion
From Peliculas P
Where P.Duracion > 280
Union
SELECT P.Nombre, P.Duracion, 'Mediometraje' as Clasificacion
From Peliculas P
Where P.Duracion BETWEEN 91 and 280
Union
SELECT P.Nombre, P.Duracion, 'Cortometraje' as Clasificacion
From Peliculas P
Where P.Duracion < 90

