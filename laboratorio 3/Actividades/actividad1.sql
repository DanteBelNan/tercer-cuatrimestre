Go
CREATE TABLE Usuarios(
    id smallint primary key identity(1,1),
    nombre varchar(50) NOT NULL,
    apellido varchar(50) NOT NULL,
    calle varchar(50) NOT NULL,
    numero smallint NOT NULL,
    localidad varchar(50) NOT NULL,
    provincia varchar(50) NOT NULL,
    situacion_crediticia smallint NOT NULL,
    genero bit NOT NULL,
    telefono varchar(25) null,
    celular varchar(25) null,
    mail varchar(80) NOT NULL
);

Go
create table cuentas(
    id smallint PRIMARY KEY IDENTITY(1,1),
    user_id smallint FOREIGN KEY REFERENCES Usuarios(id) unique,
    edad DATETIME not null,
    fecha_creacion DATETIME not null,
    alias varchar(50) unique not null,
    num_tarjeta varchar(16) unique not null,
    fecha_vencimiento DATETIME not null,
    clave varchar(4) not null,
    banco varchar(50) not null,
    marca varchar(50) not null
);