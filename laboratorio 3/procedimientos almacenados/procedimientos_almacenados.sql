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




