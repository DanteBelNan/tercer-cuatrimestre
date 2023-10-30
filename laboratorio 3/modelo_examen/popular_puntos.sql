INSERT INTO Puntos
Select ID,null,GETDATE(),100, dateadd(day,10,getdate()) from Clientes
--WGERE ID <= 100 --Lo ejecutamos algunas veces con condicional, para añadir extra puntos a varios clientes

Select * from Puntos


---- 4) Realizar un trigger que al borrar un cliente, primero le quite todos los puntos (baja física) y establecer a NULL todos los viajes de ese cliente. Luego, eliminar físicamente el cliente de la base de datos.