1. Triggers
Los Triggers nos permiten ejecutar una serie decomandos de manera desatendida. Con esto nos referimos a que se ejecutará de manera automatica cuando ocurra algun tipo de acción en la base de datos.

También son conocidos como desencadenadores, ya que el codigo o procedimiento almacenado que se ejecuta surge tras las desencadenación de un evento. En SQL-Server, los desencadenadores pueden ser del tipo DML (Data Manipulation) y DDL (Data Definition).
Los desencadenadores pueden ser 'en lugar de' o 'luego' de una acción en una tabla en particular para los del tipo DML; o bien, 'para' una acción sobre una base de datos para los tipos DDL.

Desencadenadores DML
Estos desencadenadores se ejecutan cuando un usuario ejecuta alguna acción sobre los datos de una tabla. Las acciones que desencadenan el trigger son específicamente INSER, UPDATE o DELTE.
Existen tres tipos de desencadenadores DML, estudiaremos dos:
-AFTER: Las acciones que conforman el trigger se ejecutan despues de que la acción se haya ejecutado
-INSTEAD OF: Las acciones que conforman el trigger se ejecutan en lugar de la acción solicitada

-.NET: Estos desencadenadores pueden ser del tipo AFTER o INSTEAD OF, pero en lugar de ejecutar sentencias T-SQL ejecutan codigo desarrollado en C#


Por ejemplo, podremos ejecutar una serie de acciones si un dato en particular figura en nuestra consulta de INSERT, realizar una baja logica en lugar de un DELETE, que realizaria una fisica.
Tambien, una tabla de LOG que permita conocer ciertos cambios cuando se ejecuta un UPDATE. En resumen, podemos ejecutar codigo amedida que ocurran ciertos sucesos en la DB

Las tablas inserted y deleted
Dos tablas especiales intervienen dentro del codigo de un trigger, inserted y deleted. La gestión de estas tablas son responsabilidad del motor de datos de SQL Server. Las mismas tienen como objetivo contener los datos intermedios que surgen con el manejo de los desencadenadores.

Cuando se ejecuta una consulta del tipo DELETE, se almacenará una copia de los datos que se verán afectados por la eliminación dentro de la tabla deleted. Esto quiere decir que podremos realizar una consulta de selección a la misma para poder conocer cuales son (entre otras cosas) los id de los registros a eliminar, cuantos son, etc.

Cuando se ejecuta una consulta del tipo INSER, se almacenará una copia de los datos que se insertarán dentro de la tabla inserted.
Por ultimo, cuando se ejecuta una consulta de UPDATE, se almacenara una copia de la información en ambas tablas, los datos nuevos que estarán por modificarse por la consulta de update permaneceran en la tabla inserted, mientras que los viejos en la tabla deleted.

Utilicemos la base de datos del apunte de procedimientos almacenados para ejemplificar los desencadenadores

Ejemplos:

Queremos que solo se pueda realizar baja logica de nuestra tabla Sucursales.
Esto quiere decir, que tenemos que modificar el DELETE, haciendo que cada vez que se ejecute, cambie el Estado a 0, para eso, podemos crear un storedProcedure llamado spEliminarSucursal y que realice la baja logica, pero siempre quedaria la psobilidad de que se ejecute un delete en lugar del storedProcedure, por lo que, podemos directamente modificar el DELETE con este trigger, de la siguiente manera

CREATE TRIGGER tr_Eliminar_Sucursal ON Sucursales
INSTEAD OF DELETE
AS
BEGIN
    UPDATE Sucursales SET estado = 0
    WHERE idsucursal (SELECT idsucursal FROM deleted)
END

Ahora, al ejecutar un DELETE FROM SUCURSALES WHERE ID = 5
Simplemente cambiara su estado a 0, en lugar de borrarla fisicamente.


Tambien, supongamos que el banco quiere impedir que un cliente tenga mas de una tarjeta de debito, esto quiere decir que cuando insertemos un registro de tarjeta que es de debito, solo hacer el insert si el cliente no posee otra registrada:

CREATE TRIGGER tr_TarjetaDebito ON Tarjetas
INSTEAD OF INSERT
AS
BEGIN
    IF(SELECT tipoTarjeta FROM inserted) = 'D' 
        BEGIN
            IF (SELECT COUNT(*) FROM TARJETAS WHERE tipoTarjeta = 'D' AND idCliente IN (SELECT idCliente FROM inserted)) = 1
            BEGIN
                ROLLBACK TRANSACTION
                RETURN
            END
        END
        INSERT INTO Tarjetas (nrotarjeta, idcliente, tipotarjeta, estado) 
        SELECT nrotarjeta, idcliente, tipotarjeta, estado FROM inserted
    END
END

Analizando este codigo, podemos notar que el mismo se ejecuta en lugar de un insert, de esta manera, capturamos la inserción del registro y lo podemos reescribir.
En principio vemos que si la tarjeta ingresada es de tipo Debito, debemos verificar que la cantidad de tarjetas de debito que posee el cliente sea 1. En caso de ser asi, estaremos insertando una tarjeta para un cliente que ya posee una, por lo tanto, ejecutamos un rollback, y se corta el proceso, en caso de no ser así, sigue ejecutando e inserta una tarjeta.


Veamos otro ejemplo:
Necesitamos actualizar la regla de negocio que se sugirió en el apunte de Transacciones y que cada vez que se ingrese un cliente se le genere automáticamente una tarjeta de débito y una cuenta de tipo Caja de Ahorro.

Esto quiere decir que en este caso, no vamos a querer impedir la inserción del registro de cliente sino que después de insertar dicho registro, se procederá a ingresar una tarjeta y una cuenta.
El trigger se realizará sobre la tabla Clientes y se realizará despues de realizar el insert

CREATE TRIGGER tr_AgregarCliente ON Clientes
AFTER INSERT
AS
BEGIN
    DECLARE @idCliente BIGINT
    SELECT @idCliente = idcliente FROM inserted
    INSERT INTO Tarjetas(nrotarjeta, idcliente, tipotarjeta, estado) VALUES('D-'+CAST(@idCliente AS VARCHAR(10)+'-1', @idCliente, 'D', 1)

    DECLARE @nroCuenta VARCHAR(10)
    SELECT @nroCuenta = MAX(nroCuenta) FROM cuentas
    INSERT INTO Cuentas(nrocuenta, idcliente, idtipocuenta, saldo, limite_descubierto, fecha_alta, fecha_baja, estado)
    VALUES(CAST(@nroCuenta) AS BIGINT) + 1, @idCliente, 1, 0, 0, GETDATE(), NULL, 1)
END

Si ejecutamos este Trigger, podremos ver como luego de realizar un insert en clientes, tambien se realiza uno en tarjetas, y otro en cuentas, estos fueron creados dentro del trigger, los datos relacionados al cliente se encontraban en la tabla temporal inserted por lo que para evitar acceder constantemente a esta tabla se creo una variable llamada @idCliente a la cual se le asigna el valor que se necesitaba.


Desencadenadores DDL

Los desencadenadores DDL, a diferencia de los DML tienen alcance a base de datos o de servidor. Reaccionan ante ciertos eventos que se disparan en dichos ámbitos.
Por ejemplo:
CREATE TRIGGER tr_Alterar_Tabla
ON DATABASE
FOR DROP_TABLE, ALTER_TABLE
AS
    PRINT 'No se puede modificar la tabla. Deshabilitá el trigger tr_Alterar_Tabla'
    ROLLBACK
BEGIN

El siguiente desencadenador se activará cuando querramos hacer una modificación en nuestras tablas de la base de datos. Por lo que, en este caso en particular, no permitirá realizar un DROP o ALTER a una tabla.

Eliminar y modificar triggers
Una vez funcionando un trigger, es posible modificar su comportamiento o bien eliminarlo por completo, para ello utilizaremos las sentencias T-SQL: ALTER TRIGGER Y DROP TRIGGER

La sintaxis general es:
ALTER TRIGGER nombre_trigger
ON nombre_tabla
{ AFTER | INSTEAD OF }
{ INSERT | UPDATE | DELETE }
AS
BEGIN
  sentencia_sql_1
  sentencia_sql_2
  sentencia_sql_N
END


Para eliminarlo la sintaxis es:
DROP TRIGGER nombre_trigger


Habilitar y deshabilitar triggers
Es posible que en algunos casos querramos deshabilitar momentaneamente nuestros triggers.
Sería muy tedioso tener que eliminarlos y luego crearlos nuevamente en caso de necesitarlos, por lo que SQL nos ofrece deshabilitarlos y luego dejarlos habilitados.
La sintaxis para deshabilitar es la siguiente:

DISABLE TRIGGER nombre_trigger ON nombre_objeto

Y para habilitar es:
ENABLE TRIGGER nombre_trigger ON nombre_objeto
