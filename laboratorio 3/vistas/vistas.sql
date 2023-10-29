-- Realizar la normalización, creación de tablas, relaciones y restricciones a partir del siguiente enunciado.

-- El Sistema Único de Boleto Electrónico (SUBE) desea realizar la base de datos que permitirá a sus usuarios utilizar el sistema.
-- La forma de pago en los colectivos se realiza mediante una tarjeta magnética que contiene el saldo de la misma, cuando se paga el ticket automáticamente se registra la información en la base de datos centralizada, por lo que, tarjeta y sistema tienen exactamente la misma información de manera sincrónica. Esto quiere decir que este sistema y todas sus terminales están constantemente en línea siendo así extremadamente eficiente y ficticio.

-- Se solicita desarrollar la base de datos que permitirá almacenar la información y, en una próxima etapa, desarrollarle módulos que permitan garantizar la consistencia de la misma.

-- Se deberán registrar los usuarios que utilizarán las tarjetas. De cada usuario se debe poder obtener: el Apellido, nombre, número de DNI, fecha de su primera tarjeta SUBE, saldo de su última tarjeta SUBE, cantidad de viajes realizados, domicilio y edad.

-- Las tarjetas, necesarias para poder realizar cualquier viaje, registran la siguiente información: Número identificatorio de tarjeta, Apellido y nombre del usuario, número de DNI,  fecha de alta de la tarjeta SUBE y saldo.

-- Otro elemento que se registra son los viajes. Cada viaje debe tiene: un código único de viaje, una fecha y hora de viaje, el número de interno del colectivo, la línea de colectivo, el número de tarjeta SUBE que abona el viaje, el importe del ticket y el usuario que viaja.

-- Para esto también es necesario almacenar las líneas de colectivos, cada línea registra el código de línea, el nombre de la empresa y el domicilio legal.

-- Por último, otro elemento a registrar en la base de datos son los movimientos que sufren las tarjetas. Es decir, todos los débitos y créditos que se le practican. Para cada movimiento se registra: número de movimiento, fecha y hora, número de tarjeta SUBE, importe, tipo de movimiento ('C' - Crédito y 'D' - Débito).



-- Atención:

-- Las entidades de usuario y tarjeta deberán contener un campo estado para poder realizar baja lógica.
use master

create database vistas

use vistas

CREATE TABLE USUARIOS(
    dni int primary key IDENTITY(1,1),
    apellido varchar(255),
    nombre varchar(255),
    primeraSube DATETIME,
    saldoUltSube DECIMAL,
    cantViajes INT,
    domicilio varchar(255),
    edad int,
    activo bit
)

CREATE TABLE TARJETAS(
    idTarjeta int PRIMARY key IDENTITY(1,1),
    apellidoUsuario varchar(255),
    nombreUsuario varchar(255),
    dniUsuario int,
    altaSube DATETIME,
    saldo decimal,
    activo bit
)

CREATE TABLE COLECTIVOS(
    codigoLinea int PRIMARY KEY IDENTITY(1,1),
    nombreEmpresa varchar(255),
    domicilioLegal varchar(255)
)

CREATE TABLE VIAJES(
    idViaje int PRIMARY KEY IDENTITY(1,1),
    cuandoFue DATETIME,
    codigoLinea int,
    idTarjeta int,
    importe decimal,
    dni INT

    FOREIGN KEY (codigoLinea) REFERENCES COLECTIVOS(codigoLinea),
    FOREIGN KEY (idTarjeta) REFERENCES TARJETAS(idTarjeta),
    FOREIGN KEY (dni) REFERENCES USUARIOS(dni)
)

CREATE TABLE MOVIMIENTOS(
    idMovimiento int PRIMARY KEY IDENTITY(1,1),
    fecha DATETIME,
    idTarjeta int,
    importe DECIMAL,
    tipoMovimiento varchar(1)

    FOREIGN KEY (idTarjeta) REFERENCES TARJETAS(idTarjeta)
)

INSERT INTO TARJETAS (apellidoUsuario, nombreUsuario, dniUsuario, altaSube, saldo, activo)
VALUES
('López', 'Juan', 1, '2023-10-26 08:00:00', 100.00, 1),
('Gómez', 'María', 2, '2023-10-25 14:30:00', 50.00, 1),
('Pérez', 'Carlos', 3, '2023-10-24 10:15:00', 75.00, 0);



INSERT INTO USUARIOS (apellido, nombre, primeraSube, saldoUltSube, cantViajes, domicilio, edad, activo)
VALUES
('López', 'Juan', '2023-10-26 08:00:00', 100.00, 5, 'Calle A, Ciudad', 30, 1),
('Gómez', 'María', '2023-10-25 14:30:00', 50.00, 3, 'Calle B, Ciudad', 25, 1),
('Pérez', 'Carlos', '2023-10-24 10:15:00', 75.00, 4, 'Calle C, Ciudad', 40, 0);


INSERT INTO COLECTIVOS (nombreEmpresa, domicilioLegal)
VALUES
('Empresa A', 'Calle X, Ciudad A'),
('Empresa B', 'Calle Y, Ciudad B'),
('Empresa C', 'Calle Z, Ciudad C');

INSERT INTO VIAJES (cuandoFue, codigoLinea, idTarjeta, importe, dni)
VALUES
('2023-10-26 08:30:00', 1, 1, 10.00, 1),
('2023-10-26 09:00:00', 2, 2, 5.00, 2),
('2023-10-25 15:00:00', 3, 3, 7.50, 3);

INSERT INTO MOVIMIENTOS (fecha, idTarjeta, importe, tipoMovimiento)
VALUES
('2023-10-26 09:30:00', 1, 5.00, 'C'),
('2023-10-25 16:00:00', 2, 2.50, 'D'),
('2023-10-24 11:30:00', 3, 5.00, 'C');



--Realizar las siguientes vistas:

-- A) Realizar una vista que permita conocer los datos de los usuarios y sus respectivas tarjetas. La misma debe contener: Apellido y nombre del usuario, número de tarjeta SUBE, estado de la tarjeta y saldo.
CREATE VIEW VistaUsuariosTarjetas AS
SELECT
    U.apellido AS ApellidoUsuario,
    U.nombre AS NombreUsuario,
    T.idTarjeta AS NumeroTarjetaSUBE,
    CASE
        WHEN T.activo = 1 THEN 'Activa'
        ELSE 'Inactiva'
    END AS EstadoTarjeta,
    T.saldo AS Saldo
FROM USUARIOS AS U
INNER JOIN TARJETAS AS T ON U.dni = T.dniUsuario;


SELECT * FROM VistaUsuariosTarjetas


-- B) Realizar una vista que permita conocer los datos de los usuarios y sus respectivos viajes. La misma debe contener: Apellido y nombre del usuario, número de tarjeta SUBE, fecha del viaje, importe del viaje, número de interno y nombre de la línea.
CREATE VIEW VistaUsuariosViajes AS
SELECT
    U.apellido AS ApellidoUsuario,
    U.nombre AS NombreUsuario,
    T.idTarjeta AS NumeroTarjetaSUBE,
    V.cuandoFue AS FechaViaje,
    V.importe AS ImporteViaje,
    V.codigoLinea AS NumeroInterno,
    C.nombreEmpresa AS NombreLinea
FROM USUARIOS AS U
INNER JOIN TARJETAS AS T ON U.dni = T.dniUsuario
INNER JOIN VIAJES AS V ON T.idTarjeta = V.idTarjeta
INNER JOIN COLECTIVOS AS C ON V.codigoLinea = C.codigoLinea;


-- C) Realizar una vista que permita conocer los datos estadísticos de cada tarjeta. La misma debe contener: Apellido y nombre del usuario, número de tarjeta SUBE, cantidad de viajes realizados, total de dinero acreditado (históricamente), cantidad de recargas, importe de recarga promedio (en pesos), estado de la tarjeta.

-- C) Realizar una vista que permita conocer los datos estadísticos de cada tarjeta. La misma debe contener: Apellido y nombre del usuario, número de tarjeta SUBE, cantidad de viajes realizados, total de dinero acreditado (históricamente), cantidad de recargas, importe de recarga promedio (en pesos), estado de la tarjeta.
-- C) Realizar una vista que permita conocer los datos estadísticos de cada tarjeta. La misma debe contener: Apellido y nombre del usuario, número de tarjeta SUBE, cantidad de viajes realizados, total de dinero acreditado (históricamente), cantidad de recargas, importe de recarga promedio (en pesos), estado de la tarjeta.
CREATE VIEW VistaDatosTarjeta AS
SELECT
    T.apellidoUsuario AS ApellidoUsuario,
    T.nombreUsuario AS NombreUsuario,
    T.idTarjeta AS NumeroTarjeta,
    (SELECT COUNT(idViaje) FROM VIAJES WHERE idTarjeta = T.idTarjeta) AS CantViajes,
    (SELECT SUM(importe) FROM VIAJES WHERE idTarjeta = T.idTarjeta) AS TotalAcreditado,
    (SELECT COUNT(idMovimiento) FROM MOVIMIENTOS WHERE idTarjeta = T.idTarjeta AND tipoMovimiento = 'C') AS CantRecargas,
    (SELECT AVG(importe) FROM MOVIMIENTOS WHERE idTarjeta = T.idTarjeta AND tipoMovimiento = 'C') AS PromedioRecarga,
    CASE
        WHEN T.activo = 1 THEN 'Activa'
        ELSE 'Inactiva'
    END AS EstadoTarjeta
FROM TARJETAS AS T;



SELECT * FROM VistaDatosTarjeta

SELECT * FROM Tarjetas
