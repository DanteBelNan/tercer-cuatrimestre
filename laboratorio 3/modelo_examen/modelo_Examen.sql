-- Legajo: 2634
-- Apellido y nombre: Beltrán, Dante

use master
go
Create Database ModeloExamen
go
Use ModeloExamen
go
Create Table Clientes(
    ID bigint not null primary key identity (1, 1),
    Apellidos varchar(100) not null,
    Nombres varchar(100) not null,
    Telefono varchar(30) null,
    Email varchar(120) null,
    TelefonoVerificado bit not null,
    EmailVerificado bit not null
)
go
Create Table Vehiculos(
    ID bigint not null primary key identity (1, 1),
    Patente varchar(8) not null unique,
    AñoPatentamiento smallint not null,
    Marca varchar(50) not null,
    Modelo varchar(50) not null 
)
go
Create Table Choferes(
    ID bigint not null primary key identity (1, 1),
    Apellidos varchar(100) not null,
    Nombres varchar(100) not null,
    FechaRegistro date not null,
    FechaNacimiento date not null,
    IDVehiculo bigint not null foreign key references Vehiculos(ID),
    Suspendido bit not null default(0)
)
go
Create Table FormasPago(
    ID int not null primary key identity (1, 1),
    Nombre varchar(50) not null
)
go
Create Table Viajes(
    ID bigint not null primary key identity(1, 1),
    IDCliente bigint null foreign key references Clientes(ID),
    IDChofer bigint not null foreign key references Choferes(ID),
    FormaPago int null foreign key references FormasPago(ID),
    Inicio datetime null,
    Fin datetime null,
    Kms decimal(10, 2) not null,
    Importe money not null,
    Pagado bit not null
)
go
Create Table Puntos(
    ID bigint not null primary key identity (1, 1),
    IDCliente bigint not null foreign key references Clientes(ID),
    IDViaje bigint null foreign key references Viajes(ID),
    Fecha datetime not null default(getdate()),
    PuntosObtenidos int not null,
    FechaVencimiento date not null
)

use ModeloExamen

-- 1) Se pide agregar una modificación a la base de datos para que permita registrar la calificación (de 1 a 10) que el Cliente le otorga al Chofer en un viaje y además una observación opcional. Lo mismo debe poder registrar el Chofer del Cliente.
--  Importante:
--  No se puede modificar la estructura de la tabla de Viajes.
--  Sólo se puede realizar una calificación por viaje del Cliente al Chofer.
--  Sólo se puede realizar una calificación por viaje del Chofer al Cliente.
--  Puede haber viajes que no registren calificación por parte del Chofer o del Cliente.



-- 2) Realizar una vista llamada VW_ClientesDeudores que permita listar: Apellidos, Nombres, Contacto (indica el email de contacto, si no lo tiene el teléfono y de lo contrario "Sin datos de contacto"), cantidad de viajes totales, cantidad de viajes no abonados y total adeudado. Sólo listar aquellos clientes cuya cantidad de viajes no abonados sea superior a la mitad de viajes totales realizados.
CREATE VIEW VW_ClientesDeudores
AS
SELECT Punto2.* FROM (
    SELECT C.Apellidos, C.Nombres, COALESCE(C.Email, C.Telefono, 'Sin datos de contacto') as Contacto,
    COUNT(*) AS CantidadViajesTotales,
    (
        SELECT COUNT(*) FROM VIAJES WHERE IDCLIENTE = C.ID AND Pagado = 0
    ) As CantidadViajesNoAbonados,
    (
        SELECT COALESCE(SUM(Importe),0) FROM VIAJES WHERE IDCLIENTE = C.ID AND Pagado = 0
    ) AS TotalAdeudado
    FROM Clientes as C

    INNER JOIN Viajes as V on C.id = V.idCliente
    GROUP BY C.ID, C.APELLIDOS, C.NOMBRES, COALESCE(C.Email, C.Telefono, 'Sin datos de contacto')

) as Punto2
WHERE PUNTO2.CantidadViajesNoAbonados > Punto2.CantidadViajesTotales/2

-- 3) Realizar un procedimiento almacenado llamado SP_ChoferesEfectivo que reciba un año como parámetro y permita lista apellidos y nombres de los choferes que en ese año únicamente realizaron viajes que fueron abonados con la forma de pago 'Efectivo'.
-- NOTA: Es indistinto si el viaje fue pagado o no. Utilizar la fecha de inicio del viaje para determinar el año del mismo.
CREATE PROCEDURE SP_ChoferesEfectivo(
    @ANIO SMALLINT
)
as begin
    SELECT  Punto3.Apellidos, PUNTO3.Nombres From (
        SELECT C.ID, C.APELLIDOS, C.NOMBRES,
        (
            SELECT Count(*) From Viajes as V Where V.IDChofer = C.ID and Year(V.Inicio) = @ANIO
        ) as CantViajesAnio,
        (
            SELECT COUNT(*) FROM VIAJES as V
            INNER JOIN FormasPago FP on FP.ID = V.FormaPago
            Where V.IDChofer = C.id and year(v.Inicio) = @ANIO and FP.Nombre Like 'Efectivo'
        ) as CantViajesEfectivoAnio
        FROM Choferes as C
    ) as Punto3
    Where Punto3.CantViajesEfectivoAnio = Punto3.CantViajesAnio and Punto3.CantViajesAnio > 0
end
