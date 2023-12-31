-- Legajo: 2634
-- Apellido y nombre: Beltrán, Dante

use ModeloExamen

-- 1) Se pide agregar una modificación a la base de datos para que permita registrar la calificación (de 1 a 10) que el Cliente le otorga al Chofer en un viaje y además una observación opcional. Lo mismo debe poder registrar el Chofer del Cliente.
--  Importante:
--  No se puede modificar la estructura de la tabla de Viajes.
--  Sólo se puede realizar una calificación por viaje del Cliente al Chofer.
--  Sólo se puede realizar una calificación por viaje del Chofer al Cliente.
--  Puede haber viajes que no registren calificación por parte del Chofer o del Cliente.
CREATE TABLE Clasificaciones(
    IDViaje BIGINT NOT NULL PRIMARY KEY FOREIGN KEY REFERENCES Viajes(id),
    CalificacionAlChofer TINYINT not null check (CalificacionAlChofer BETWEEN 1 AND 10),
    ObservacionesAlChofer text null,
    CalificacionAlCliente TINYINT not null check (CalificacionAlCliente BETWEEN 1 AND 10),
    ObservacionesAlCliente text null
)


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


-- 4) Realizar un trigger que al borrar un cliente, primero le quite todos los puntos (baja física) y establecer a NULL todos los viajes de ese cliente. Luego, eliminar físicamente el cliente de la base de datos.
CREATE TRIGGER TR_EliminarCliente On Clientes
Instead of DELETE
AS 
BEGIN
    BEGIN TRY
        BEGIN TRAN
             --Borramos fisicamente todos los puntos del cliente
            Declare @ID bigint
            SET @id = (select id from deleted)

            DELETE FROM PUNTOS WHERE IDCliente = @ID
            UPDATE VIAJES SET IDCliente = NULL WHERE IDCLIENTE = @ID
            DELETE FROM CLIENTES WHERE ID = @ID

        COMMIT
    END TRY
    BEGIN CATCH
        ROLLBACK
        RAISERROR('Error al eliminar cliente', 16,1)
    END CATCH

END


SELECT * FROM Clientes WHERE ID = 41
SELECT * FROM Viajes WHERE IDCliente = 41
SELECT * FROM Puntos WHERE IDCliente = 41

SELECT * FROM Viajes WHERE ID = 493 OR ID = 1253

DELETE FROM Clientes WHERE ID = 41


-- 5) Realizar un trigger que garantice que el Cliente sólo pueda calificar al Chofer si el viaje se encuentra pagado. Caso contrario indicarlo con un mensaje aclaratorio.
CREATE TRIGGER TR_InsertarCalificacionAlChofer ON Clasificaciones
AFTER INSERT
AS
BEGIN
    BEGIN TRANSACTION
        Declare @IDVIAJE BIGINT
        Declare @PAGADO BIT

        SET @IDVIAJE = (SELECT IDViaje from inserted)
        SET @PAGADO = (SELECT PAGADO FROM VIAJES WHERE ID = @IDVIAJE)

        IF @PAGADO = 0 BEGIN
            ROLLBACK
            RAISERROR('Viaje no pagado, por lo tanto no se clasifica', 16, 1)
        END
    COMMIT TRANSACTION
END