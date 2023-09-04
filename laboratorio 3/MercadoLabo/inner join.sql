/*
    Por cada usuario indicar Apellidos, Nombres, Edad, Alias de la billetera, 
    la antiguedad de la billetera en días y el also de la misma
*/

Select U.Apellidos,
 U.Nombres,
 B.Alias,
    --Antiguedad
Datediff(DAY,B.FechaCreacion, GETDATE())
 As Antiguedad, B.Saldo
From Usuarios U
Inner Join Billeteras B ON U.ID_Usuario = B.ID_Usuario
WHERE Datediff(DAY,B.FechaCreacion, GETDATE()) > 300
Order By Antiguedad ASC