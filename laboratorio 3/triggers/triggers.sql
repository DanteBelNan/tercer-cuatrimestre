-- 1) Realizar un trigger que al agregar un viaje:
-- Verifique que la tarjeta se encuentre activa.
-- Verifique que el saldo de la tarjeta sea suficiente para realizar el viaje.
-- Registre el viaje
-- Registre el movimiento
-- Descuente el stock de la tarjeta
use vistas

CREATE TRIGGER tr_AgregarViaje ON Viajes
INSTEAD OF INSERT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
            DECLARE @codigoLinea int = (SELECT codigoLinea FROM inserted)
            DECLARE @idTarjeta int = (SELECT idTarjeta FROM inserted)
            DECLARE @importe DECIMAL = (SELECT importe from inserted)
            DECLARE @dni int = (SELECT dni from inserted)
            IF (SELECT activo FROM Tarjetas WHERE idTarjeta = @idTarjeta) = 0
            BEGIN
                RAISERROR('Tarjeta no activa',16,1)
            END
            IF (SELECT saldo from TARJETAS where idTarjeta = @idTarjeta) - @importe < 0
            BEGIN
                RAISERROR('Saldo insuficiente',16,1)
            END

            INSERT INTO VIAJES (cuandoFue, codigoLinea, idTarjeta, importe, dni)
            VALUES(GETDATE(), @codigoLinea, @idTarjeta, @importe, @dni);

            INSERT INTO MOVIMIENTOS (fecha, idTarjeta, importe, tipoMovimiento)
            VALUES(GETDATE(), @idTarjeta, @importe, 'D');
            
            UPDATE TARJETAS 
            SET saldo = (SELECT saldo from Tarjetas where idTarjeta = @idTarjeta) - @importe
            WHERE idTarjeta = @idTarjeta

        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        PRINT ERROR_MESSAGE()
        ROLLBACK TRANSACTION
    END CATCH
    
END




-- 2) Realizar un trigger que al registrar un nuevo usuario:
-- Registre el usuario
-- Registre una tarjeta a dicho usuario

use vistas

CREATE TRIGGER tr_AgregarUsuario on Usuarios
AFTER INSERT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
            DECLARE @dni INT = (SELECT dni FROM inserted)
            DECLARE @apellido varchar(250) = (SELECT apellido FROM inserted)
            DECLARE @nombre varchar(250) = (SELECT nombre FROM inserted)

            INSERT INTO TARJETAS (apellidoUsuario, nombreUsuario, dniUsuario, altaSube, saldo, activo)
            VALUES (@apellido, @nombre, @dni, GETDATE(), 100.00, 1);
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        PRINT ERROR_MESSAGE()
        ROLLBACK TRANSACTION
    END CATCH
END



-- 3) Realizar un trigger que al registrar una nueva tarjeta:
-- Le realice baja lógica a la última tarjeta del cliente.
-- Le asigne a la nueva tarjeta el saldo de la última tarjeta del cliente.
-- Registre la nueva tarjeta para el cliente (con el saldo de la vieja tarjeta, la fecha de alta de la tarjeta deberá ser la del sistema).
CREATE TRIGGER tr_RegistrarTarjeta ON Tarjetas
INSTEAD OF INSERT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
            DECLARE @dni INT = (SELECT dniUsuario FROM inserted)
            DECLARE @nuevoSaldo DECIMAL = (SELECT TOP 1 saldo FROM TARJETAS where dniUsuario = @dni and activo = 1 ORDER BY altaSube DESC)
            DECLARE @apellido varchar(250) = (SELECT apellidoUsuario FROM inserted)
            DECLARE @nombre varchar(250) = (SELECT nombreUsuario FROM inserted)            

            UPDATE Tarjetas set activo = 0
            WHERE dniUsuario = @dni and activo = 1

            INSERT INTO TARJETAS (apellidoUsuario, nombreUsuario, dniUsuario, altaSube, saldo, activo)
            VALUES (@apellido, @nombre, @dni, GETDATE(), @nuevoSaldo, 1);

        COMMIT TRANSACTION
    END TRY

    BEGIN CATCH
        PRINT ERROR_MESSAGE()
        ROLLBACK TRANSACTION
    END CATCH
END




-- 4) Realizar un trigger que al eliminar un cliente:
-- Elimine el cliente
-- Elimine todas las tarjetas del cliente
-- Elimine todos los movimientos de sus tarjetas
-- Elimine todos los viajes de sus tarjetas
CREATE TRIGGER tr_EliminarUsuario on Usuarios
INSTEAD OF DELETE
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
            DECLARE @dni INT = (select dni from deleted)

            DELETE FROM MOVIMIENTOS WHERE idTarjeta IN (SELECT idTarjeta FROM TARJETAS WHERE dniUsuario = @dni)
            DELETE FROM TARJETAS WHERE dniUsuario = @dni
            DELETE FROM CLIENTES WHERE dni = @dni
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        PRINT ERROR_MESSAGE()
        ROLLBACK TRANSACTION
    END CATCH
END
