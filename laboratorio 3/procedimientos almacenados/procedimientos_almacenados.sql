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

SELECT * FROM usuarios