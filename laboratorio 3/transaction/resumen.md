1. Transacciones

Es muy comun que al normalizar nuestra base de datos queramos representar un objeto de la vida real en una tabla.
El problema, es que en ocasiones con una sola tabla no es suficiente para representar a una entidad, y debemos realizarlo en dos o más
Sea cual sea el caso, puede ocurrir que una operación en nuestra base de datos requiera modificar más de un registro a la vez.
Aquí ocurre una situación muy critica en la estructura de la base de datos, obviamente las consultas que se ejecutan en un proceso batch T-SQL deberán ejecutarse una a una. De modo que es posible que nuestra base de datos quede en un estado inconsistente.
Esto se debe a que un conjunto de operaciones que representan una sola operación más grande o general debe ser ejecutada como un todo. Esto se basa en el principio de atomicidad, es decir, debe ser una unidad atomica de trabajo, por lo que se ejecutan todas las operaciones definidas en el proceso o no se ejecuta nada.

Veamos unos ejemplos prácticos donde las consultas deben ser ejecutadas como una transacción

cuentas{
    nroCuenta,
    idCliente,
    idTipoCuenta,
    saldom
    limite_descubierto,
    fecha_alta,
    fecha_baja,
    estado
}

tiposCuenta{
    idTipoCuenta,
    descripcion
}

transferencias{
    idTransferencia,
    fecha,
    idCuentaOrigen,
    idCuentaDestino
    importe
    referencia
    beneficiario
}

movimientos{
    idMovimiento,
    fecha,
    nroCuenta,
    tipoMovimiento,
    descripción,
    importe
}

clientes{
    idCliente,
    nombre,
    apellido,
    sexo,
    idSucursal,
    estado
}

tarjetas{
    idTarjeta,
    nroTarjeta,
    idCliente,
    tipoTarjeta,
    estado
}


sucursales{
    idSucursal,
    dirección,
    codPostal,
    estado
}

ciudades{
    codPostal,
    idProvincia,
    nombre
}

provincias{
    idProvincia,
    nombre
}


Cuando se realiza un movimiento sobre la cuenta, por ejemplo, un deposito, se debe asentar el movimiento ysu posterior actualización del saldo en la cuenta.
Será necesario insertar un registro sobre la tabla de Movimientos indicando la fecha, nro de cuenta, tipo de movimiento, descripción e importe. Este registro permitira, por ejemplo, elaborar el reporte detallado del estado de cuenta mes a mes.
También, será necesario realizar una modificación sobre la tabla Cuentas, actualizando el saldo a su nuevo valor. En el caso del deposito se debera sumar el importe del mismo al saldo.
La gravedad de ejecutar estas dos consultas como comandos aislados es que permitira por ejemplo, registrar un movimiento pero no actualizar el saldo.

Por ejemplo, supongamos que una persona tiene en una cuenta un saldo de $200. Luego realiza un deposito por $10.000 y nuestro procedimiento almacenado que registra esa operación, genera el registro en la tabla de movimientos y en ese momento se corta el suministro eléctrico, sin que se actualice el saldo en la cuenta. Lo que ocurriría es que la base de datos se encontraría en un estado inconsistente y nuestro cliente contaría con $10000 menos en la cuenta.
Esto es un claro ejemplo que esta operación debe realizarse completamente o no realizarse.


1. Estructura de una transacción
Las transacciones en SQLServer pueden ser de dos formas, explicitas o implicitas. La forma implicita es la que estuvimos utilizando hasta ahora, donde cada consulta individual es confirmada o desecha ni bien finaliza.
La transacción explicita se diferencia porque se especifica en el proceso por lotes de inicio y fin de la misma:

BEGIN TRANSACTION: Indica comienzo de la transacción

COMMIT TRANSACTION: Indica la finalización de la transacción, la misma sentencia intenta hacer permanentes los cambios en la base de datos, asentando todas las sentencias que formen parte de la transacción.

ROLLBACK TRANSACTION: Indica que hay que deshacer los cambios sobre los datos ya que ha ocurrido un error y se deberá dejar la base de datos en el estado previo a la ejecución de la transacción.

Veamos el ejemplo que definimos anteriormente, para ello, utilizaremos el procedimiento almacenado que figura en el apunte anterior.

CREATE PROCEDURE spRegistrarMovimiento(
@nroCuenta VARCHAR(20),
@tipoMovimiento CHAR,
@descripcion VARCHAR(50),
@importe DECIMAL(10, 2)
)
AS
BEGIN
    --Comenzamos con el manejo de errores
    BEGIN TRY
        --Comienza la transacción
        BEGIN TRANSACTION
            --Verificamos si el tipo de movimiento es Extracción
            IF @tipoMovimiento = 'E' OR @tipoMovimiento ='e'
            BEGIN
                --Declaramos las variables
                DECLARE @saldo DECIMAL(10, 2)
                DECLARE @tipoCuenta INT
                DECLARE @descubierto DECIMAL(10, 2)
                --Le asignamos valores que provienen de una consulta SQL
                IF (SELECT COUNT(*) FROM cuentas WHERE nroCuenta = @nroCuenta) = 1
                BEGIN
                    SELECT @saldo = C.saldo, @tipoCuenta = C.idTipoCuenta, @descubierto =  C.limite_descubierto FROM cuentas C WHERE C.nroCuenta = @nroCuenta
                END
                ELSE
                BEGIN
                    RAISERROR('NO EXISTE LA CUENTA', 16, 1)
                END

                --Verificamos si se puede hacer la Extracción
                IF @saldo - @importe < 0 AND @tipoCuenta = 1
                BEGIN
                    RAISERROR ('NO SE PUEDE REALIZAR EL MOVIMIENTO, SALDO ES INSUFICIENTE', 16, 1)
                END
                IF @saldo - @importe < (0 - @descubierto) AND @tipoCuenta = 2
                BEGIN
                    RAISERROR ('NO SE PUEDE REALIZAR EL MOVIMIENTO, SALDO ES INSUFICIENTE', 16, 1)
                END
            END

            --Registramos el movimiento en la tabla de Movimientos
            INSERT INTO movimientos (fecha, nrocuenta, descripcion, tipomovimiento, importe) VALUES(GETDATE(), @nroCuenta, @descripcion, @tipoMovimiento, @importe)

            --Si es Extracción el importe debe restarse
            IF @tipoMovimiento = 'E' OR @tipoMovimiento = 'e'
            BEGIN
                SET @importe = @importe * -1
            END

            --Actualizamos el saldo de la cuenta
            UPDATE cuentas SET saldo = saldo + @importe WHERE nroCuenta = @nroCuenta
            -- Si no actualizó ninguna fila
            IF @@ROWCOUNT = 0
            BEGIN
                RAISERROR('OCURRIO UN ERROR', 16, 1)
            END

        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        PRINT ERROR_MESSAGE()
        ROLLBACK TRANSACTION
    END CATCH
    --Finaliza el manejo de errores
END

Ahora sí, con esta consulta podemos estar seguros de que nuestro procedimiento almacenado spRegistrarMovimiento podrá encargarse de la gestión de un depósito o una extracción y tendrá un manejo de errores adecuado en caso de que ocurriera algún imprevisto.
Se observa que la estructura de la transacción es la que nos asegura dicho funcionamiento.
Se caracteriza por tener la siguiente forma

BEGIN TRANSACTION
-- instrucción T-SQL 1
-- instrucción T-SQL 2
-- instrucción T-SQL 3
COMMIT TRANSACTION
ó
ROLLBACK TRANSACTION /* Si ocurrió algún error */


Estra estructura tiene mas sentido acompañada de un bloque try catch, que se encarga de la gestión de errores. Hay que tener en cuenta que TRY CATCH no captura los siguientes erroes:
    -Typos
    -Advertencias
    -Errores que finalizan el proceso por lotes o el procedimiento por parte del motor de SQL Server.
    -Errores por la cancelación de la conexión por parte de la aplicación

La función global @@ROWCOUNT
Cabe destacar que en el caso de la operación de actualización de saldo no se encuentre el nro de cuenta, por alguna razon. Dicha operación no fallara, sino que se generará un UPDATE que afecta cero filas. Esto no es considerado un error, por lo que no será descartado hacia el CATCH, es por eso, que se ejecuta la función global @@ROWCOUNT, que cuenta la cantidad de filas afectadas por la query, y hace que al dar 0, tire un error

La función global @@IDENTITY
Para ver mejor aún el concepto de transacción, vamos a ver un ejemplo en el que sea necesario la modificación de más de una tabla en un mismo proceso. Supongamos que deseamos realizar un procedimiento almacenado para crear un usuario y que, como regla de negocio, el banco decida gestionarle automáticamente una cuenta del tipo caja de ahorro y una tarjeta de débito.

Los pasos a seguir serian:
--Dar de alta usuario
--Dar de alta cuenta realcionada al usuario
--Dar de alta la tarjeta de debito relacionada el usuario

El problema que tenemos aquí, es el siguiente: ya podemos solucionar que el conjunto de procesos SQL a ejecutar se ejecuten como una unidad de procesamiento, es decir, todos o ninguno
Sin embargo, el idcliente en la tabla de clientes es autogenerado y tanto la tabla cuentas como la de tarjetas necesitan dicho valor para realizar la relación FK con la tabla de clientes.

Aquí se utiliza la función global @@IDENTITY, devolviendonos el ultimo valor autonumerico generado.

Por lo tanto, el procedimiento spCrearUsuario sería así:


CREATE PROCEDURE spAgregarCliente(
    @nombre VARCHAR(50),
    @apellido VARCHAR(50),
    @sexo CHAR,
    @idsucursal INT
)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
            -- Generamos usuario
            INSERT INTO Clientes (nombre, apellido, sexo, idsucursal, estado) 
            VALUES (@nombre, @apellido, @sexo, @idsucursal, 1)
            -- Generamos la cuenta del usuario
            DECLARE @nroCuenta BIGINT
            SELECT @nroCuenta= MAX(nrocuenta FROM cuentas)
            DECLARE @idCliente BIGINT
            SET @idCliente = @@IDENTITY

            INSERT INTO Cuentas (nrocuenta, idcliente, idtipocuenta, saldo, limite_descubierto, fecha_alta, fecha_baja, estado) 
            VALUES (@nroCuenta+1, @idCliente, 1, 0, 0, GETDATE(), NULL, 1)

            --Generamos la tarjeta de debito
            INSERT INTO Tarjetas (nrotarjeta, idcliente, tipotarjeta, estado) 
            VALUES ('D-' + CONVERT(NVARCHAR(10), @idCliente) + '-1', @idCliente, 'D', 1)

        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        PRINT 'ERROR, NO FUNCIONA'
        ROLLBACK TRANSACTION
    END CATCH
END

Podemos por ejemplo, ejecutar este storedprocedure así

EXEC spAgregarCliente 'Angel', 'Simon', 'M', 1

Y esta ejecución en principio genera un cliente con codigo de cliente autonumerico, luego genera un numero de tarjeta con el formato 'tipoTarjeta-idCliente-CantTarjetasxCliente'. Donde el tipo de tarjeta, en este caso, siempre sera D por debito.
El codigo decliente surgirá del autogenerado en la consulta anterior, y la cantidad de tarjetas sera 1 porque se esta generando el cliente en el momento.
Por ultimo, se genera una cuenta del tipo caja de ahorro con saldo cero y limite descubierto cero para dicho cliente.
El número de cuenta se calcula en base al numero de cuenta maximo generado anteriormente más uno.
el idcliente lo trae denuevo del identity y los demas valores son asignados de manera constante salvo por la fecha que trae con getdate()