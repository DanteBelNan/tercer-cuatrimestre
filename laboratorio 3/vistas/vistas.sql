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

--Realizar las siguientes vistas:

-- A) Realizar una vista que permita conocer los datos de los usuarios y sus respectivas tarjetas. La misma debe contener: Apellido y nombre del usuario, número de tarjeta SUBE, estado de la tarjeta y saldo.
CREATE VIEW vw_Usuarios_Tarjetas
AS
SELECT U.apellido, U.nombre, T.idTarjeta, T.activo, T.saldo
FROM USUARIOS AS U
INNER JOIN TARJETAS ON T.dniUsuario = U.dni