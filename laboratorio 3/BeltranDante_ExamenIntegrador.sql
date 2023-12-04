--1) Realizar el código SQL que genere la base de datos con sus tablas y columnas. Agregar todas las restricciones necesarias.
Create DATABASE DanteBeltran
Use DanteBeltran

CREATE TABLE Carreras(
    IDCarrera bigint not null primary key identity (1, 1),
    Nombre varchar(50) not null
)

CREATE TABLE Materias(
    IDMateria bigint not null primary key identity (1, 1),
    IDCarrera bigint not null foreign key references Carreras(IDCarrera),
    Nombre varchar(50) not null,
    Año smallint not null CHECK (Año > 0) not null,
    Cuatrimestre bit
)

CREATE TABLE Alumnos (
    Legajo bigint not null PRIMARY KEY,
    Nombres varchar(50) not null,
    Apellidos varchar(50) not null
)

CREATE TABLE Examenes(
    IDExamen bigint not null primary key identity (1, 1),
    IDMateria bigint not null FOREIGN KEY REFERENCES Materias(IDMateria),
    Legajo bigint not null FOREIGN KEY REFERENCES Alumnos(Legajo),
    Fecha datetime not null,
    Nota decimal(4, 2) CHECK (Nota >= 0 AND Nota <= 10)
)

CREATE TABLE Sanciones(
    IDSancion bigint not null primary key identity (1, 1),
    Legajo bigint not null FOREIGN KEY REFERENCES Alumnos(Legajo),
    Fecha datetime not null,
    Observacion varchar(500)
)


--2) Listar los mejores 5 estudiantes entre las carreras "Tecnicatura en Programación" e "Ingeniería Mecánica" para otorgarles una beca. Para seleccionarlos a la beca, el criterio de aceptación es el promedio general de los últimos dos años (es decir, el año actual y el anterior) y no haber registrado nunca una sanción.

SELECT TOP 5
    A.Legajo as Legajo,
    A.Nombres AS Nombre,
    A.Apellidos AS Apellido, 
    (SELECT AVG(Ex.Nota)
     FROM Examenes AS Ex 
     WHERE Ex.Legajo = A.Legajo
       AND YEAR(GETDATE()) - YEAR(Ex.Fecha) <= 1) AS Promedio
FROM Alumnos AS A
INNER JOIN Examenes AS E ON E.Legajo = A.Legajo
INNER JOIN Materias AS M ON M.IDMateria = E.IDMateria
INNER JOIN Carreras AS C ON C.IDCarrera = M.IDCarrera
WHERE A.Legajo NOT IN (SELECT Legajo FROM Sanciones) -- No entiendo en que cambiaria un distinct (talvez se ahorra vueltas haciendolo mas eficiente)
AND C.Nombre IN ('Ingeniería Mecánica', 'Tecnicatura en Programación')
GROUP BY A.Legajo, A.Nombres, A.Apellidos
ORDER BY Promedio DESC



-- 3 Realizar un listado con legajo, nombre y apellidos de alumnos que no hayan registrado aplazos (nota menor a 6) en ningún examen. El listado también debe indicar la cantidad de sanciones que el alumno registra.
SELECT A.Legajo, A.Nombres, A.Apellidos,
(
    SELECT COUNT(*) FROM Sanciones
    WHERE Legajo = A.Legajo
) as cantSanciones
FROM Alumnos as A
LEFT JOIN Examenes as E on E.Legajo = A.Legajo
WHERE (
    SELECT MIN(Nota) From Examenes Where Legajo = A.Legajo
) >= 6
GROUP BY A.Legajo, A.Nombres, A.Apellidos


-- 4 Hacer un listado con nombre de carrera, nombre de materia y año de aquellas materias que tengan un promedio general mayor a 8. No se deben promediar los aplazos.


SELECT C.Nombre, M.Nombre, M.Año
FROM Materias AS M
INNER JOIN Carreras as C on C.IDCarrera = M.IDCarrera
WHERE (
        SELECT AVG(E.Nota)
        FROM Examenes as E
        WHERE E.IDMateria = M.IDMateria and E.Nota >= 6
) > 8
ORDER BY C.IDCarrera


-- 5 Realizar un trigger que permita modificar el tipo de cuenta de un usuario si la capacidad de la cuenta del usuario es superada cuando este sube un archivo. En ese caso, debe modificar su tipo de cuenta a la siguiente disponible y registrar el cambio con su respectiva fecha en la tabla de CambiosDeCuenta. En cualquier caso se debe registrar el archivo al usuario.

CREATE TRIGGER tr_SubirArchivo ON Archivos
INSTEAD OF INSERT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
            DECLARE @IDUsuario bigint = (SELECT IDUsuario from inserted)
            DECLARE @TipoCuenta bigint = (SELECT IDTipoCuenta from Usuarios where IDUsuario = @IDUsuario)
            DECLARE @MBArchivo int = (SELECT TamañoEnMB from inserted)

            IF @MBArchivo > (SELECT CapacidadEnMB FROM TiposCuentas WHERE IDTipoCuenta = @TipoCuenta) AND (SELECT IDTipoCuenta FROM TiposCuentas WHERE IDTipoCuenta = @TipoCuenta) NOT LIKE 'Ilimitada'
            BEGIN
                UPDATE Usuarios SET IDTipoCuenta = @TipoCuenta + 1
                WHERE IDUsuario = @IDUsuario
                INSERT INTO CambiosDeCuenta (IDUsuario, IDTipoCuentaAnterior, IDTipoCuentaActual, Fecha)
                VALUES (@IDUsuario, @TipoCuenta, @TipoCuenta + 1, GETDATE());
            END

            INSERT INTO Archivos (IDUsuario, NombreArchivo, Descripcion, Extension, TamañoEnMB, FechaPublicacion)
            SELECT IDUsuario, NombreArchivo, Descripcion, Extension, TamañoEnMB, GETDATE()
            FROM inserted;
            
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        PRINT ERROR_MESSAGE()
        ROLLBACK TRANSACTION
    END CATCH
END

CREATE TRIGGER tr_SubirArchivo ON Archivos
INSTEAD OF INSERT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
            DECLARE @IDUsuario bigint = (SELECT IDUsuario from inserted)
            DECLARE @TipoCuenta bigint = (SELECT IDTipoCuenta from Usuarios where IDUsuario = @IDUsuario)
            DECLARE @MBArchivo int = (SELECT TamañoEnMB from inserted)

            IF @MBArchivo + (SELECT SUM(TamañoEnMB) FROM Archivos WHERE IDUsuario = @IDUsuario) > (SELECT CapacidadEnMB FROM TiposCuentas WHERE IDTipoCuenta = @TipoCuenta) AND (SELECT Nombre FROM TiposCuentas WHERE IDTipoCuenta = @TipoCuenta) NOT LIKE 'Ilimitada'
            BEGIN
                UPDATE Usuarios SET IDTipoCuenta = @TipoCuenta + 1
                WHERE IDUsuario = @IDUsuario
                INSERT INTO CambiosDeCuenta (IDUsuario, IDTipoCuentaAnterior, IDTipoCuentaActual, Fecha)
                VALUES (@IDUsuario, @TipoCuenta, @TipoCuenta + 1, GETDATE());
            END

            INSERT INTO Archivos (IDUsuario, NombreArchivo, Descripcion, Extension, TamañoEnMB, FechaPublicacion)
            SELECT IDUsuario, NombreArchivo, Descripcion, Extension, TamañoEnMB, GETDATE()
            FROM inserted;
            
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        PRINT ERROR_MESSAGE()
        ROLLBACK TRANSACTION
    END CATCH
END

select * from TiposCuentas