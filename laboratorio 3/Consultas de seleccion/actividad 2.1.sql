
Use UNO_UNO
--Punto 1 pellido, nombres y fecha de nacimiento de todos los usuarios

SELECT U.apellido, u.nombre, U.nacimiento
FROM usuarios U

-- 2 Apellido, nombres y edad de todos los usuarios
SELECT
    U.apellido,
    U.nombre,
    DATEDIFF(YEAR, U.nacimiento, GETDATE()) AS Edad
FROM usuarios U;

-- 3 Apellido y nombres de aquellos colaboradores cuyo género no sea masculino (letra 'M')
SELECT U.apellido, U.nombre
FROM usuarios U
WHERE U.genero != 'M'; 

-- 4 Todos los datos de los usuarios que hayan nacido en el primer semestre (indistintamente de qué año fue).
SELECT * FROM usuarios
WHERE MONTH(nacimiento) >= 1 AND MONTH(nacimiento) <= 6;

-- 5 Apellidos, nombres y DNI  de aquellos usuarios cuya situación crediticia sea 1, 3 o 5
SELECT U.apellido, U.nombre, U.dni
FROM usuarios U
WHERE u.situacion_crediticia % 2 = 1

-- 6 Todos los datos de los usuarios que hayan nacido entre los años 1990 y 1995 (ambos inclusive) o 2000 y 2005 (ambos inclusive)
SELECT * FROM usuarios
WHERE (YEAR(nacimiento) >= 1990 and YEAR(nacimiento) < 1995) or (YEAR(nacimiento) >= 2000 and YEAR(nacimiento) < 2005)


-- 7 Apellidos y nombres concatenados en una misma columna llamada "Apenom" y el teléfono, celular y mail. Si no tiene teléfono o celular modificar el valor NULL por el texto "No tiene".

SELECT
    CONCAT(apellido, ', ', nombre) AS Apenom,
    COALESCE(telefono, 'No tiene') AS Telefono,
    COALESCE(celular, 'No tiene') AS Celular,
    COALESCE(mail, 'No tiene') AS Mail
FROM
    usuarios;

-- 8 Todos los datos de todos los usuarios que tengan celular pero no teléfono.
SELECT * FROM usuarios
WHERE celular is not null and telefono is null

-- 9 Apellidos y nombres de los usuarios y una columna llamada Contacto. En ella debe figurar primero el celular, si el usuario no tiene celular, debe figurar el teléfono y si el usuario no tiene teléfono debe figurar el mail.
SELECT
    apellido,
    nombre,
    COALESCE(celular, telefono, mail) AS Contacto
FROM
    usuarios;

-- 10 Apellidos y nombres de los usuarios y una columna llamada FormaContacto. En ella debe figurar "Celular" si el usuario tiene celular, si el usuario no tiene celular, debe figurar el "Teléfono" si el usuario tiene teléfono, de lo contrario debe figurar "Mail".
SELECT
    apellido,
    nombre,
    CASE
        WHEN celular IS NOT NULL THEN 'Celular'
        WHEN telefono IS NOT NULL THEN 'Teléfono'
        ELSE 'Mail'
    END AS FormaContacto
FROM
    usuarios;

-- 11 Los ID_Localidad, sin repeticiones, de los usuarios
SELECT DISTINCT localidad FROM usuarios;

-- 12 Todos los datos de los usuarios que tengan en un su nombre la letra 'A' o la letra 'O'.
SELECT * FROM USUARIOS
where nombre LIKE '%A' or nombre LIKE ' %0%'
 
-- 13 Todos los datos de los usuarios que tengan un mail con subdominio ".org"
SELECT * FROM USUARIOS
where mail LIKE '%.org';

-- 14 Todos los datos de los usuarios que hayan nacido un martes}
SELECT * FROM USUARIOS
where DAYOFWEEK(nacimiento) = 3

-- 15 Todos los datos de los usuarios que no hayan nacido martes, jueves ni domingo.
SELECT * FROM USUARIOS
where DAYOFWEEK(nacimiento) != 3 and DAYOFWEEK(nacimiento) != 5 and DAYOFWEEK(nacimiento) != 1







