use master

drop database dos_tres

create database dos_tres

use dos_tres


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
    ('Galicia') , ('Santander'), ('HSBC'), ('BBVA');


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

-- 1 Listado con la cantidad de usuarios que tienen una situación crediticia con ID menor a 3.
    SELECT COUNT(*) AS CantSitCredBaja FROM usuarios WHERE situacion_crediticia >= 3

-- 2 Listado con el saldo promedio de las billeteras
    SELECT AVG(saldo) as PromedioSaldo FROM BilleteraVirtual

-- 3 Listado con el saldo acumulado de las billeteras que hayan sido creadas luego del 15 de Enero de 2022.
    SELECT SUM(saldo) as saldoTotal FROM BilleteraVirtual WHERE creacioncuenta > '2022-01-15'

-- 4 Listado con la cantidad de tarjetas que se vencen en el año actual y que sean del Banco HSBC.
    SELECT COUNT(*) as cantTarjetas FROM Tarjeta as T
    INNER JOIN Banco as B ON T.idBanco = B.id
    where YEAR(T.vencimiento) = YEAR(GETDATE()) and B.nombre = 'HSBC'

-- 5 Listado con el promedio de antigüedad expresado en días de las billeteras
    SELECT AVG(DATEDIFF(DAY,creacioncuenta ,GETDATE())) as promAntiguedad FROM BilleteraVirtual as BV


-- 6 Listado con el promedio de días que restan para el vencimiento de las tarjetas no vencidas.
    SELECT AVG(DATEDIFF(DAY,GETDATE(),vencimiento)) as promVencimiento FROM Tarjeta
    where GETDATE() < vencimiento
-- 7 Listado con la fecha de nacimiento de la persona más joven en tener una billeter
    
-- 8 Listado con el total de dinero acreditado mediante movimientos.. 

-- 9 Por cada cliente, apellidos, nombres, alias de la billetera y cantidad de movimientos registrados.

-- 10 Listar los clientes que hayan registrado débitos por más de $15000

-- 11 Listar el total debitado discriminado por nivel de situación crediticia

-- 12 Listar el nombre y apellido del usuario que haya realizado más depósitos.

-- 13 Listar la cantidad de usuarios que hayan registrado movimientos de tipo débito.

-- 14 Listar por cada billetera el alias y la cantidad de transferencias realizadas (la billetera es el origen de la transferencia). Si hay billeteras que no tienen transferencias realizadas deben figurar en el listado contabilizando 0.

-- 15 Listar los apellidos y nombres y el alias de billeteras de aquellos clientes que hayan movilizado más de $40000 durante el mes de agosto de 2023.





