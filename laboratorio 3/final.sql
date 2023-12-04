use master

CREATE DATABASE dante_beltran_final_labo3

USE dante_beltran_final_labo3

CREATE TABLE Clientes (
    dni VARCHAR(8) PRIMARY KEY,
    apellidos VARCHAR(50) NOT NULL,
    nombres VARCHAR(50) NOT NULL
);

CREATE TABLE TiposDeTicket (
    idTipoTicket INT PRIMARY KEY IDENTITY(1,1),
    cantViajes INT DEFAULT 0,
    vigenciaDias INT DEFAULT 0,
    importe INT NOT NULL
);

CREATE TABLE Tickets (
    numeroTicket INT PRIMARY KEY IDENTITY(1,1),
    dni VARCHAR(8) REFERENCES Clientes(dni) NOT NULL,
    idtipoTicket INT REFERENCES TiposDeTicket(idTipoTicket) NOT NULL,
    FechaCompra DATETIME NOT NULL,
    fechavigencia DATETIME,
    cantidadviajes INT,
    importe INT NOT NULL,
    utilizado BIT default 0 
);

CREATE TABLE Viajes (
    idViaje INT PRIMARY KEY IDENTITY(1,1),
    fechaHora DATETIME NOT NULL,
    numeroTicket INT REFERENCES Tickets(numeroTicket) NOT NULL
);


INSERT INTO TiposDeTicket (cantViajes, vigenciaDias, importe) VALUES
(1, NULL, 500),
(NULL, 0, 1500),
(5, NULL, 2000),
(30,10,10000);

SELECT * FROM TiposDeTicket

-- Hacer un procedimiento almacenado llamado SP_Agregar_Ticket que reciba el DNI, la fecha de compra y el IDTipoTicket. Debe calcular la cantidad de viajes, la fecha de vigencia y el importe. Debe marcarse como No Utilizado.
CREATE PROCEDURE sp_Agregar_Ticket(
    @dni  VARCHAR(8),
    @fechaCompra DATETIME,
    @idTipoTicket INT
)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
            DECLARE @cantViajes INT;
            DECLARE @fechaVigencia DATETIME;
            DECLARE @importe INT;
            SELECT @cantViajes = cantViajes, @fechaVigencia = DATEADD(DAY, vigenciaDias, @fechaCompra), @importe = importe
            FROM TiposDeTicket
            WHERE idTipoTicket = @idTipoTicket

            INSERT INTO Tickets (dni, idtipoTicket, FechaCompra, fechavigencia, cantidadviajes, importe, utilizado)
            VALUES (@dni, @idTipoTicket, @fechaCompra, @fechaVigencia, @cantViajes, @importe, 0);
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        SELECT ERROR_MESSAGE() AS ErrorMessage;
        ROLLBACK TRANSACTION;
    END CATCH;
END

-- Hacer un trigger que al agregar un viaje permita o no la registración del mismo. Si el ticket del viaje ya se encuentra utilizado el viaje no puede registrarse. Prestar especial atención a que si el ticket puede utilizarse pero, por su cantidad de viajes, es el último de los viajes que puede realizar debe ser marcado como Utilizado. Se debe insertar el registro de viaje según corresponda o mostrar un mensaje aclaratorio si no se inserta el viaje.

CREATE TRIGGER tr_AgregarViaje ON Viajes
INSTEAD OF INSERT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
            DECLARE @idViaje INT = (SELECT idViaje from inserted)
            DECLARE @fechaHora DATETIME = (SELECT fechaHora from inserted)
            DECLARE @numeroTicket INT = (SELECT numeroTicket from inserted)      

            IF (SELECT utilizado FROM Tickets WHERE numeroTicket = @numeroTicket) = 1
            BEGIN
                RAISERROR('El ticket ya utilizado',16,1)
            END



            DECLARE @cantidadViajes INT
            SELECT @cantidadViajes = cantidadViajes FROM Tickets WHERE numeroTicket = @numeroTicket

            DECLARE @idTipoTicket INT
            SELECT @idTipoTicket = idTipoTicket FROM Tickets WHERE numeroTicket = @numeroTicket

            DECLARE @vigenciaDias INT
            SELECT @vigenciaDias = vigenciaDias FROM TiposDeTicket WHERE idTipoTicket = @idTipoTicket

            
            IF (SELECT cantViajes FROM TiposDeTicket WHERE idTipoTicket = @idTipoTicket) IS NOT NULL --Tiene viajes limitados
            BEGIN
                IF (@cantidadViajes) = 1
                BEGIN
                    UPDATE Tickets SET utilizado = 1 WHERE numeroTicket = @numeroTicket --Asumimos que los que tienen viajes ilimitados nunca seran utilizados
                END
                UPDATE Tickets
                SET cantidadviajes = cantidadviajes - 1
                WHERE numeroTicket = @numeroTicket
            END

            IF (@vigenciaDias IS NOT NULL)
            BEGIN
                IF (DATEADD(DAY, @vigenciaDias, @fechaHora) > GETDATE())
                BEGIN
                    RAISERROR('El ticket esta vencido',16,1)
                END
            END

            INSERT INTO Viajes (idViaje, fechaHora, numeroTicket)
            VALUES (@idViaje, @fechaHora, @numeroTicket);

        COMMIT TRANSACTION
    END TRY

    BEGIN CATCH
        PRINT 'El viaje no pudo insertarse por la siguiente razon:'
        PRINT ERROR_MESSAGE()
        ROLLBACK TRANSACTION
    END CATCH
END


SELECT C.Apellidos, C.Nombres
FROM Clientes as C
WHERE C.DNI NOT IN (
    SELECT DISTINCT DNI
    FROM Clientes
    INNER JOIN Tickets as T on T.dni = C.dni
    INNER JOIN Viajes as V on V.numeroTicket = T.numeroTicket
    WHERE (
        MONTH(V.fechaHora) = MONTH(GETDATE()) AND YEAR(V.fechaHora) = YEAR(GETDATE())
    )
)