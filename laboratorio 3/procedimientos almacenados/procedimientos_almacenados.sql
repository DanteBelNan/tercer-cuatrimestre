use dos_dos

-- A) Realizar un procedimiento almacenado llamado sp_Agregar_Usuario que permita registrar un usuario en el sistema. El procedimiento debe recibir como parámetro DNI, Apellido, Nombre, Fecha de nacimiento y los datos del domicilio del usuario.

CREATE PROCEDURE sp_Agregar_Usuario(
    @DNI INT,
    @Apellido VARCHAR(50),
    @Nombre VARCHAR(50),
    @nacimiento DATETIME,
    @domicilio VARCHAR(50),
    @idLocalidad INT,
    @idProvincia INT
)
AS
BEGIN
INSERT INTO usuarios (dni, apellido, nombre, nacimiento, domicilio, idlocalidad, idprovincia) VALUES(@DNI, @Apellido, @Nombre, @nacimiento, @domicilio, @idLocalidad, @idProvincia)
END

-- B) Realizar un procedimiento almacenado llamado sp_Agregar_Tarjeta que dé de alta una tarjeta. El procedimiento solo debe recibir el DNI del usuario.    Como el sistema sólo permite una tarjeta activa por usuario, el procedimiento debe:
--Dar de baja la última tarjeta del usuario (si corresponde).
--Dar de alta la nueva tarjeta del usuario
--Traspasar el saldo de la vieja tarjeta a la nueva tarjeta (si corresponde)

CREATE PROCEDURE sp_Agregar_Tarjeta(
    @dni BIGINT
)
AS
BEGIN
    --Declaramos variables
    DECLARE @idUsuario INT
    DECLARE @idBilleteraVieja INT
    DECLARE @idTarjetaVieja INT
    DECLARE @saldoViejo INT
    DECLARE @idBancoNuevo INT
    DECLARE @idMarcaNueva INT

    --Obtenemos el usuario
    SELECT @idUsuario = id
    FROM usuarios
    WHERE dni = @dni;

    --Traemos su ult tarjeta (si no existe trae nulo)
    SELECT TOP 1 @idBilleteraVieja = BV.idBilleteraVirtual, @idTarjetaVieja = BT.id, @saldoViejo = BV.saldo
    FROM BilleteraVirtualXTarjeta AS BVT
    INNER JOIN BilleteraVirtual AS BV ON BVT.idBilletera = BV.idBilleteraVirtual
    INNER JOIN Tarjeta AS BT ON BVT.idTarjeta = BT.id
    WHERE BV.idPersona = @idUsuario
    ORDER BY BT.id DESC;
    --Damos de baja la tarjeta
    IF @idTarjetaVieja IS NOT NULL
    BEGIN
        UPDATE Tarjeta
        SET activo = 0
        WHERE id = @idTarjetaVieja;
    END;

    --Cargamos nueva tarjeta
    INSERT INTO Tarjeta (numTarjeta, numSeguridad, emision, vencimiento, idBanco, idMarca)
    VALUES ('nuevo_numero', 'nuevo_codigo_seguridad', GETDATE(), DATEADD(year, 3, GETDATE()), @idBancoNuevo, @idMarcaNueva);

    DECLARE @idNuevaTarjeta INT
    SET @idNuevaTarjeta = SCOPE_IDENTITY(); -- Obtener el ID de la nueva tarjeta insertada

    --Pasamos el saldo de la tarjeta vieja a la nueva
    IF @saldoViejo > 0
    BEGIN
        UPDATE BilleteraVirtual
        SET saldo = saldo + @saldoViejo
        WHERE idBilleteraVirtual = @idNuevaTarjeta;
    END;
END


--C) Realizar un procedimiento almacenado llamado sp_Agregar_Viaje que registre un viaje a una tarjeta en particular. El procedimiento debe recibir: Número de tarjeta, importe del viaje, nro de interno y nro de línea.
--El procedimiento deberá:
--Descontar el saldo
--Registrar el viaje
--Registrar el movimiento de débito

--NOTA: Una tarjeta no puede tener una deuda que supere los $2000.

use vistas

CREATE PROCEDURE sp_Agregar_Viaje(
    @nroTarjeta int,
    @importeViaje decimal,
    @codigoLinea int,
    @nroLinea int
)
AS
BEGIN
    DECLARE @saldoActual DECIMAL;
    DECLARE @nuevoSaldo DECIMAL;

    BEGIN TRY
        --Obtenemos saldo actual
        SELECT @saldoActual = saldo
        from TARJETAS
        WHERE idTarjeta = @nroTarjeta


        --Verificamos que el importe del viaje no exceda los $2000 de deuda
        IF (@saldoActual - @importeViaje) < -2000
        BEGIN
            RAISEERROR('NO SE PUEDE REALIZAR EL MOVIMIENTO, SALDO INSUFICIENTE',16,1)
        END

        --Actualizamos saldo
        SET @nuevoSaldo = @saldoActual - @importeViaje;
        UPDATE TARJETAS
        SET saldo = @nuevoSaldo
        WHERE idTarjeta = @nroTarjeta;

        --Registramos movimiento
        INSERT INTO MOVIMIENTOS (fecha, idTarjeta, importe, tipoMovimiento)
        VALUES (GETDATE(), @nroTarjeta, @importeViaje, 'D');

    END TRY
    BEGIN CATCH
        SELECT ERROR_MESSAGE() AS ErrorMessage;
    END CATCH;
END


--D) Realizar un procedimiento almacenado llamado sp_Agregar_Saldo que registre un movimiento de crédito a una tarjeta en particular. El procedimiento debe recibir: El número de tarjeta y el importe a recargar. Modificar el saldo de la tarjeta.
CREATE PROCEDURE sp_Agregar_Saldo
    @nroTarjeta INT,
    @importeRecarga DECIMAL
AS
BEGIN
    DECLARE @saldoActual DECIMAL;
    DECLARE @nuevoSaldo DECIMAL;

    SELECT @saldoActual = saldo
    FROM TARJETAS
    WHERE idTarjeta = @nroTarjeta

    SET @nuevoSaldo = @saldoActual + @importeRecarga

    UPDATE TARJETAS
    SET SALDO = @nuevoSaldo
    WHERE idTarjeta = @nroTarjeta

    INSERT INTO MOVIMIENTOS (fecha, idTarjeta, importe, tipoMovimiento)
    VALUES (GETDATE(), @nroTarjeta, @importeRecarga, 'C')
END

--E)  Realizar un procedimiento almacenado llamado sp_Baja_Fisica_Usuario que elimine un usuario del sistema. La eliminación deberá ser 'en cascada'. Esto quiere decir que para cada usuario primero deberán eliminarse todos los viajes y recargas de sus respectivas tarjetas. Luego, todas sus tarjetas y por último su registro de usuario.
CREATE PROCEDURE sp_Baja_Fisica_Usuario
    @dni INT
AS
BEGIN
    SET NOCOUNT ON

    BEGIN TRY
        BEGIN TRANSACTION
            DELETE FROM VIAJES
            WHERE dni = @dni

            DELETE FROM MOVIMIENTOS
            WHERE idTarjeta IN (SELECT idTarjeta FROM TARJETAS WHERE dniUsuario = @dni)

            DELETE FROM TARJETAS
            WHERE dniUsuario = @dni

            DELETE FROM USUARIOS
            WHERE dni = @dni

        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION

        PRINT ERROR_MESSAGE()
    END CATCH
END

--Para practicar, hice un baja_Logica
CREATE PROCEDURE sp_Baja_Logica_Usuario
    @dni INT
AS
BEGIN

    UPDATE MOVIMIENTOS
    SET ACTIVO = 0
    WHERE idTarjeta IN (SELECT idTarjeta FROM TARJETAS WHERE dniUsuario = @dni)

    UPDATE VIAJES
    SET ACTIVO = 0
    WHERE dni = @dni

    UPDATE TARJETAS
    SET ACTIVO = 0
    WHERE dniUsuario = @dni

    UPDATE USUARIOS
    SET activo = 0
    WHERE dni = @dni

END

