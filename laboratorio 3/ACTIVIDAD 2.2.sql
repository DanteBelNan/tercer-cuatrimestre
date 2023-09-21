use master

drop database dos_dos

create database dos_dos

use dos_dos


CREATE TABLE Provincia (
    id INT PRIMARY KEY IDENTITY(1, 1),
    nombre VARCHAR(255)
);

CREATE TABLE Localidad (
    id INT PRIMARY KEY IDENTITY(1, 1),
    idProvincia int,
    nombre VARCHAR(255)
    FOREIGN KEY (idProvincia) REFERENCES Provincia(id),
);
CREATE TABLE usuarios (
    id INT PRIMARY KEY IDENTITY(1,1),
    codigo VARCHAR(255) UNIQUE,
    nombre VARCHAR(255),
    apellido VARCHAR(255),
    dni bigint UNIQUE,
    genero VARCHAR(255),
    edad INT,
    nacimiento DATETIME,
    domicilio VARCHAR(255),
    idlocalidad INT,
    idprovincia INT,
    celular bigint,
    telefono bigint,
    mail VARCHAR(255) NOT NULL,
    situacion_crediticia INT CHECK (situacion_crediticia >= 1 AND situacion_crediticia <= 5),
    FOREIGN KEY (idlocalidad) REFERENCES Localidad(id),
    FOREIGN KEY (idprovincia) REFERENCES Provincia(id)
);

CREATE TABLE BilleteraVirtual (
    idBilleteraVirtual INT PRIMARY KEY IDENTITY(10001, 1),
    idPersona INT UNIQUE,
    apellido VARCHAR(255),
    nombre VARCHAR(255),
    edad INT,
    creacioncuenta DATETIME,
    alias VARCHAR(255),
    saldo INT,
    FOREIGN KEY (idPersona) REFERENCES usuarios(id)
);

CREATE TABLE Banco (
    id INT PRIMARY KEY IDENTITY(1, 1),
    nombre varchar(255)
);

CREATE TABLE Marca (
    id INT PRIMARY KEY IDENTITY(1, 1),
    nombre varchar(255)
);


CREATE TABLE Tarjeta (
    id INT PRIMARY KEY IDENTITY(1, 1),
    numTarjeta VARCHAR(16) UNIQUE,
    numSeguridad VARCHAR(4),
    emision DATE,
    vencimiento DATE,
    idBanco int,
    idMarca int
    FOREIGN KEY (idBanco) REFERENCES banco(id),
    FOREIGN KEY (idMarca) REFERENCES marca(id)
);

CREATE TABLE BilleteraVirtualXTarjeta (
    id INT PRIMARY KEY IDENTITY(1, 1),
    idTarjeta INT,
    idBilletera INT,
    FOREIGN KEY (idTarjeta) REFERENCES Tarjeta(id),
    FOREIGN KEY (idBilletera) REFERENCES BilleteraVirtual(idBilleteraVirtual)
);


-- Insertar datos en la tabla Provincia
INSERT INTO Provincia (nombre) VALUES
    ('Rio Negro'),
    ('Cordoba'),
    ('Tierra del Fuego'),
    ('Misiones'),
    ('Buenos Aires');

-- Insertar datos en la tabla Localidad
INSERT INTO Localidad (nombre) VALUES
    ('Bariloche'),
    ('Cordoba'),
    ('Ushuaia'),
    ('Posadas'),
    ('Vicente Lopez');

-- Insertar datos en la tabla usuarios
INSERT INTO usuarios (codigo, nombre, apellido, dni, genero, edad, nacimiento, domicilio, idlocalidad, idprovincia, celular, telefono, mail, situacion_crediticia) VALUES
    ('U001', 'Usuario1', 'Apellido1', 1234567891, 'Masculino', 30, '1992-01-15', 'Dirección1', 1, 1, 123456789, NULL, 'usuario1@example.com', 3),
    ('U002', 'Usuario2', 'Apellido2', 2345678912, 'Femenino', 25, '1997-05-20', 'Dirección2', 2, 2, 987654321, 9876543210, 'usuario2@example.com', 2),
    ('U003', 'Usuario3', 'Apellido3', 3456789123, 'Masculino', 40, '1982-11-10', 'Dirección3', 3, 3, NULL, 123123123, 'usuario3@example.com', 4),
    ('U004', 'Usuario4', 'Apellido4', 4567891234, 'Femenino', 28, '1995-08-05', 'Dirección4', 4, 4, 555555555, NULL, 'usuario4@example.com', 1),
    ('U005', 'Usuario5', 'Apellido5', 5678912345, 'Masculino', 35, '1987-03-25', 'Dirección5', 5, 5, 777777777, NULL, 'usuario5@example.com', 5),
    ('U006', 'Usuario6', 'Apellido6', 6789123456, 'Femenino', 22, '2000-07-12', 'Dirección6', 1, 1, 666666666, 1231231230, 'usuario6@example.com', 3),
    ('U007', 'Usuario7', 'Apellido7', 7891234567, 'Masculino', 32, '1989-12-30', 'Dirección7', 2, 2, 888888888, NULL, 'usuario7@example.com', 2),
    ('U008', 'Usuario8', 'Apellido8', 8912345678, 'Femenino', 27, '1996-06-15', 'Dirección8', 3, 3, NULL, 4444444444, 'usuario8@example.com', 1),
    ('U009', 'Usuario9', 'Apellido9', 9123456789, 'Masculino', 45, '1977-09-08', 'Dirección9', 4, 4, 999999999, 9999999999, 'usuario9@example.com', 4),
    ('U010', 'Usuario10', 'Apellido10', 1234567890, 'Femenino', 29, '1994-04-03', 'Dirección10', 5, 5, 123123123, NULL, 'usuario10@example.com', 2),
    ('notarj', 'NOTARJ', 'NOTARJ', 12341234, 'Masculino', 45, '1977-09-08', 'Dirección9', 4, 4, 999999999, 9999999999, 'usuario9@example.com', 4);

-- Insertar datos en la tabla BilleteraVirtual
INSERT INTO BilleteraVirtual (idPersona, apellido, nombre, edad, creacioncuenta, alias, saldo) VALUES
    (1, 'Apellido1', 'Usuario1', 30, '2023-01-15', 'Alias1', 1000),
    (2, 'Apellido2', 'Usuario2', 25, '2023-02-20', 'Alias2', 1500),
    (3, 'Apellido3', 'Usuario3', 40, '2023-03-10', 'Alias3', 2000),
    (4, 'Apellido4', 'Usuario4', 28, '2023-04-05', 'Alias4', 800),
    (5, 'Apellido5', 'Usuario5', 35, '2023-05-25', 'Alias5', 1200),
    (6, 'Apellido6', 'Usuario6', 22, '2023-06-12', 'Alias6', 600),
    (7, 'Apellido7', 'Usuario7', 32, '2023-07-30', 'Alias7', 1700),
    (8, 'Apellido8', 'Usuario8', 27, '2023-08-15', 'Alias8', 300),
    (9, 'Apellido9', 'Usuario9', 45, '2023-09-08', 'Alias9', 2400),
    (10, 'Apellido10', 'Usuario10', 29, '2023-10-03', 'Alias10', 900);

-- Insertar datos en la tabla Banco
INSERT INTO Banco (nombre) VALUES
    ('Galicia') , ('Santander'), ('HCBC'), ('BBVA');


-- Insertar datos en la tabla Marca
INSERT INTO Marca (nombre) VALUES
    ('VISA') , ('MASTERCARD'), ('UALA'), ('LEMON'), ('PEPITOS');

    

-- Insertar datos en la tabla Tarjeta
INSERT INTO Tarjeta (numTarjeta, numSeguridad, emision, vencimiento, idBanco, idMarca) VALUES
    ('1111111111111111', '123', '2023-01-01', '2025-12-31', 1, 1),
    ('2222222222222222', '456', '2023-02-01', '2026-01-31', 2, 2),
    ('3333333333333333', '789', '2023-03-01', '2027-02-28', 3, 3),
    ('4444444444444444', '012', '2023-04-01', '2027-03-31', 4, 4),
    ('5555555555555555', '345', '2023-05-01', '2028-04-30', 1, 1),
    ('6666666666666666', '678', '2023-06-01', '2028-05-31', 2, 2),
    ('7777777777777777', '901', '2023-07-01', '2029-06-30', 3, 3),
    ('8888888888888888', '234', '2023-08-01', '2029-07-31', 4, 4),
    ('9999999999999999', '567', '2023-09-01', '2030-08-31', 1, 1),
    ('1010101010101010', '890', '2023-10-01', '2030-09-30', 2, 2);

-- Insertar datos en la tabla BilleteraVirtualXTarjeta (relación entre billetera y tarjeta)
-- Asignación aleatoria de tarjetas a billeteras
INSERT INTO BilleteraVirtualXTarjeta (idTarjeta, idBilletera)
SELECT TOP 10 id, idBilleteraVirtual
FROM Tarjeta, BilleteraVirtual
ORDER BY NEWID();




-- 1 Por cada tarjeta obtener el número, la fecha de emisión, el nombre del banco y la marca de la tarjeta. Incluir al listado la cantidad de días restantes para el vencimiento de la tarjeta.
SELECT T.numTarjeta, T.emision, B.nombre, M.nombre, DATEDIFF(DAY, GETDATE(), T.vencimiento) as diasRestantes
FROM Tarjeta as T
LEFT JOIN Banco as B
ON T.idBanco = B.id
LEFT JOIN Marca as M
ON T.idMarca = M.id

-- 2 Listado que informe el ID de la multa, el monto a abonar y los datos del agente que la realizó. Debe incluir los apellidos y nombres de los agentes. Así como también la fecha de nacimiento y la edad.
SELECT U.apellido, U.nombre, U.edad, B.alias, DATEDIFF(DAY, B.creacioncuenta, GETDATE()) as Antiguedad, 'Juan Perez' as Agente
FROM usuarios AS U
INNER JOIN BilleteraVirtual B
ON U.id = B.idPersona


-- 3 Por cada usuario indicar Apellidos, Nombre y una categorización a partir del saldo de la billetera. La categorización es:
-- 'Gold' → Más de un millón de pesos
-- 'Silver' → Más de 500 mil y hasta un millón de pesos
-- 'Bronze' → Entre 50 mil y 500 mil
-- 'Copper' → Menos de 50 mil
SELECT U.apellido, 
       U.nombre,
       CASE
        WHEN BV.saldo > 1000000 THEN 'Gold'
        WHEN BV.saldo > 500000 THEN 'Silver'
        WHEN BV.saldo >= 50000 AND BV.saldo <= 500000 THEN 'Bronze'
        ELSE 'Cooper'
       END AS Categoria

FROM usuarios U
INNER JOIN BilleteraVirtual BV
on U.ID = BV.idPersona

-- 4 Por cada usuario indicar apellidos, nombres, domicilio, nombre de la localidad y provincia.

SELECT U.apellido, U.nombre, U.domicilio, L.nombre, P.nombre
FROM USUARIOS U

INNER JOIN Localidad L ON L.id = U.idlocalidad
INNER JOIN Provincia P on P.id = U.idprovincia

-- 5 Listar los usuarios con nivel de situación crediticia Excelente y que residan en Buenos Aires.
SELECT * FROM usuarios U
INNER JOIN Provincia P ON U.idprovincia = P.id
WHERE U.situacion_crediticia = 5 AND p.nombre = 'Buenos Aires'

-- 6 Listar los nombres, apellidos y celulares de los usuarios que residan en Córdoba
SELECT U.nombre, u.apellido, u.celular FROM usuarios U
INNER JOIN Provincia P ON U.idprovincia = P.id
WHERE p.nombre = 'Cordoba'

-- 7 Listar los nombres y apellidos de los clientes que no posean tarjeta
SELECT U.nombre, u.apellido, BV.idPersona, BVXT.id, T.id
FROM usuarios u
LEFT JOIN BilleteraVirtual BV on BV.idPersona = U.id
LEFT Join BilleteraVirtualXTarjeta BVXT on BV.idBilleteraVirtual = BVXT.idBilletera
LEFT JOIN Tarjeta T on T.id = BVXT.idTarjeta
where BVXT.idTarjeta is null


-- 8 Listar los nombres, apellidos, alias de billetera, nombres de tarjetas y bancos de todos los usuarios. Si el usuario no tiene tarjetas debe figurar igualmente en el listado.
SELECT U.nombre, u.apellido, BV.alias, T.numTarjeta, B.nombre

FROM usuarios U 

LEFT JOIN BilleteraVirtual BV on BV.idPersona = U.id
LEFT JOIN BilleteraVirtualXTarjeta BVXT on BVXT.idBilletera = BV.idBilleteraVirtual
LEFT JOIN Tarjeta T on T.id = BVXT.idTarjeta
LEFT JOIN BANCO B on B.id = T.idBanco

ORDER BY u.nombre ASC
-- 9 Listar nombres y apellidos del usuario que tenga la tarjeta que más tiempo falta que llegue a su vencimiento.
SELECT TOP(1) U.nombre, U.apellido
FROM usuarios U
INNER JOIN BilleteraVirtual BV ON BV.idPersona = U.id
INNER JOIN BilleteraVirtualXTarjeta BVXT ON BVXT.idBilletera = BV.idBilleteraVirtual
INNER JOIN Tarjeta T ON T.id = BVXT.idTarjeta
WHERE T.vencimiento > GETDATE()
ORDER BY DATEDIFF(DAY, GETDATE(), T.vencimiento) ASC;

-- 10 Listar las distintas marcas de tarjeta, sin repetir, de los usuarios.
SELECT DISTINCT M.nombre
FROM USUARIOS U
INNER JOIN BilleteraVirtual BV ON BV.idPersona = U.id
INNER JOIN BilleteraVirtualXTarjeta BVXT ON BVXT.idBilletera = BV.idBilleteraVirtual
INNER JOIN Tarjeta T ON T.id = BVXT.idTarjeta
INNER JOIN Marca M on T.idMarca = M.id

-- 11 Listar todos los datos de los usuarios que tengan una situación crediticia diferente de 'Excelente', 'Regular' y 'No confiable'.
SELECT * FROM usuarios
WHERE situacion_crediticia %2 = 0
