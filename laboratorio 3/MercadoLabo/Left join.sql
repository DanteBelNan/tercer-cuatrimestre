/*
    Lista los nombres y apellidos de los clientes que no posean tarjeta
*/

select U.Nombres, U.Apellidos From Usuarios U
Left Join Billeteras B on U.ID_Usuario = B.ID_Usuario
LEFT JOIN Tarjetas T ON B.ID_BILLETERA = T.ID_BILLETERA
WHERE T.ID_Tarjeta Is NULL