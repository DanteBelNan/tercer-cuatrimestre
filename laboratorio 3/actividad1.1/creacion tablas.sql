use master
go
create database UNO_UNO

go
use UNO_UNO

CREATE TABLE usuarios (
    id INT PRIMARY KEY IDENTITY(1,1),
    codigo VARCHAR(255) UNIQUE,
    nombre VARCHAR(255),
    apellido VARCHAR(255),
    dni INT UNIQUE,
    genero VARCHAR(255),
    edad INT,
    nacimiento DATETIME,
    domicilio VARCHAR(255),
    localidad VARCHAR(255),
    provincia VARCHAR(255),
    celular INT,
    telefono INT,
    mail VARCHAR(255) NOT NULL,
    situacion_crediticia INT CHECK (situacion_crediticia >= 1 AND situacion_crediticia <= 5)
);

CREATE TABLE BilleteraVirtual (
    idBilleteraVirtual INT PRIMARY KEY IDENTITY(10001, 1),
    idPersona INT UNIQUE,
    apellido VARCHAR(255),
    nombre VARCHAR(255),
    edad INT,
    creacioncuenta DATETIME,
    alias VARCHAR(255),
    saldo INT
);

CREATE TABLE Tarjeta (
    idTarjeta INT PRIMARY KEY,
    numTarjeta VARCHAR(16) UNIQUE,
    numSeguridad VARCHAR(4),
    emision DATE,
    vencimiento DATE,
    banco VARCHAR(255),
    marca VARCHAR(255)
);

CREATE TABLE BilleteraVirtualXTarjeta (
    id INT PRIMARY KEY,
    idTarjeta INT,
    idBilletera INT
);


