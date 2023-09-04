Use Actividad_11_Fragmento

go
Select 
    U.Apellidos, 
    U.Nombres, 
    U.FechaNacimiento,
    Case
        When U.Apellidos != 'Fernandez' then 'no es un Fernandez'
        Else 'es unFernandez'
    End as esFernandez,

    Year(Getdate()) - Year(U.FechaNacimiento) As EdadMargenError,

    Case
    When --Ya cumplio este año,
        MONTH(getdate()) > Month(U.FechaNacimiento) then Year(Getdate()) - Year(U.FechaNacimiento)
    When -- Cumplio este año, pero en mes actual
        Month(getdate()) = month(u.FechaNacimiento) And Day(getDate()) >= day(u.FechaNacimiento) then Year(Getdate()) - Year(U.FechaNacimiento)
    Else --No cumplio este año
        Year(Getdate()) - Year(U.FechaNacimiento) - 1
    End as Edad,

    Year(getDate()) - Year(U.FechaNacimiento) - Case
        When --Ya cumplio este año,
        MONTH(getdate()) > Month(U.FechaNacimiento) then 0
    When -- Cumplio este año, pero en mes actual
        Month(getdate()) = month(u.FechaNacimiento) And Day(getDate()) >= day(u.FechaNacimiento) then 0
    Else --No cumplio este año
        1
    End as Edad2
    
    From Usuarios U
