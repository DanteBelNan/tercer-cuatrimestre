Los procedimientos almacenados son rutinas que se encuentran almacenadas en el servidor de base de datos bajo un nombre que los identifica.
Los mismos pueden devolver resultados de tablas, mensajes, lanzar excepciones o bien ejecutar sentencias de manipulación y definición de datos

La sintaxis básica para la creación de un procedimiento almacenado es la siguiente:
CREATE PROCEDURE sp_NombreProcedimiento [ (lista_parametros) ] AS
BEGIN
[ CONSULTA SQL ]
END

Ejemplo:
CREATE PROCEDURE sp_ObtenerTodosLosRegistros
AS
BEGIN
SELECT * FROM TABLA_X
END


La sintaxis para la modificación de un procedimiento almacenado existente es la siguiente:
ALTER PROCEDURE sp_NombreProcedimiento [ (lista_parametros) ] AS
BEGIN
[ CONSULTA SQL ]
END

Ejemplo:
ALTER PROCEDURE sp_ObtenerTodosLosRegistros
AS
BEGIN
SELECT * FROM TABLA_X WHERE estado = 1
END


Para eliminar un procedimiento ejecutamos la siguiente sintaxis:
DROP PROCEDURE sp_NombreProcedimiento

Por ultimo, para ejecutar una procedure, ejecutamos lo siguiente
EXEC sp_NombreProcedimiento


Como los procedimientos almacenados son muy similares a las funciones, pueden recibir parametros, en este caso, podemos ver codigo en el que creamos un procedimiento que recibe parametros para su ejecución

CREATE PROCEDURE sp_ObtenerRegistros(
 @pEstado BIT
)
AS
BEGIN
  SELECT * FROM TABLA_X WHERE estado = @pEstado	
END


CREATE PROCEDURE sp_InsertarRegistro(
 @pNombre VARCHAR(20),
 @pFecha DATETIME
)
AS
BEGIN
  INSERT INTO TABLA_X(campo1, campo2) VALUES(@pNombre, @pFecha)
END


Ventajas:
Las ventajas de utilizar procedimientos almacenados son muchas. En principio, hay que tener en cuenta que nuestro sistema desarrollado bien podría estar en otro servidor distinto al que contiene la base de datos, sin embargo, como los procedimientos almacenados se encuentran fisicamente en la base de datos posee un acceso inmediato y directo a los datos que necesita manipular de manera que sólo deberá enviar los resultados de la operación al usuario.
De esta manera se ahorra una gran cantidad de comunicaciones de datos entrantes y salientes.
Otra de las ventajas fundamentales de los procedimientos almacenados es que la lógica del procedimiento se encuentra en la base de datos, por lo que se evita tener que incorporar dicha logica embebida en el codigo de la aplicación

Por ejemplo, podemos tener muchas logicas de muchos lenguajes, como C#, Java, etc, pero si llamamos a estos metodos, no importa la sintaxis de cada lenguaje, simplemente tendremos que llamar a estos procedimientos almacenados.


Un caso practico:

Veamos las siguientes clases

cuentas{
    nroCuenta,
    idCliente,
    idTipoCuenta,
    saldo,
    limiteDescubierto,
    fechaAlta,
    fechaBaja,
    Estado
}

tiposCuenta{
    idTipoCuenta,
    Descripcion
}

movimientos{
    idMovimiento,
    fecha,
    nroCuenta,
    tipoMovimiento,
    descripción,
    importe
}

transferencias{
    idTransferencia,
    fecha,
    idCuentaOrigen,
    idCuentaDestino,
    importe,
    referencia,
    beneficiario
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

Supongamos que queremos obtener un listado de clientes de una determinada sucursal, esto quiere decir que, por ejemplo, voy a querer obtener un listado de clientes que pertenezca a la sucursal 1.

Lo primero que hay que determinar es el tipo de consulta que será nuestro procedimiento. En este caso sabemos que el procedimiento devolvera el resultado de una consulta tipo SELECT.

Luego, hay que determinar si el procedimiento recibira pramaetros, en este caso, si los necesita, ya que hay que poner el idSucursal.

hagamoslo:

CREATE PROCEDUR sp_ClientesPorSucursal(
    @idSucursal INT
)
AS
BEGIN  SELECT * FROM CLIENTES WHERE idSucursal = @idSucursal
END

Para ejecutarlo, hacemos:

EXEC sp_ClientesPorSucursal 1


Supongamos que queremos crear otro procedimiento, que inserte un cliente en la DB.

Debemos tener en cuenta la cantidad y tipo de parametros necesarios para realizar el insert, hagamos

CREATE PROCEDURE sp_IngresarCliente(
    @Apellido VARCHAR(50),
    @Nombre VARCHAR(50),
    @sexo CHAR,
    @idSucursal INT
)
AS
BEGIN
INSERT INTO clientes (apellido, nombre, sexo, idSucursal, estado) VALUES(@Apellido, @Nombre, @sexo, @idSucursal, 1)
END

Distinso ejemplos de ejecución podrian ser:
EXEC sp_IngresarCliente 'López', 'Germán', 'M', 1
EXEC sp_IngresarCliente 'Iraola', 'Silvina', 'F', 1


Creemos otro procedimiento almacenado para guardar datos en la tabla de movimientos, esta registrara los debitos y creditos de una cuenta y actualizara el saldo de la misma, Habra que tener en cuenta que si la cuenta es del tipo 'Caja de Ahorro' no se podrá realizar un débito mayor al saldo. Es decir, este no podrá quedar en negativo. En cambio, si la cuenta es del tipo 'Cuenta corriente' se podrá dejar el saldo negativo pero no podrá ser mayor al limite de descubierto que permite el banco.
Esto quiere decir que deberemos aplicar programación a nuestro procedimiento almacenado.
Particularmente necesitaremos aplicar una estructura condicional para ejecutar nuestras consultas, una estructura Try-catch para el manejo de errores y la declaración de variables auxiliares para simplificar las consultas.

Comencemos:

CREATE PROCEDURE spRegistrarMovimiento(
    @nroCuenta VARCHAR(20),
    @tipoMovimiento CHAR,
    @descripcion VARCHAR(50),
    @importe DECIMAL(10, 2)
)
AS
BEGIN
    //comenzamos try catch
    BEGIN TRY
    IF @tipoMovimiento = 'E' OR @tipoMovimiento = 'e'
    BEGIN
        //declaramos variables
        DECLARE @saldo DECIMAL(10,2)
        DECLARE @tipoCuenta INT
        DECLARE @descubierto DECIMAL(10,2)
        //le asignamos valor a las variables
        SELECT @saldo = C.Saldo, @tipoCuenta = C.idTipoCuenta, @descubierto = C.limite_descubierto 
        FROM CUENTAS AS C WHERE C.nroCuenta = @nroCuenta

        // verificamos si podemos extraer
        IF @saldo - @importe < 0 and @tipoCuenta = 1
        BEGIN
            RAISEERROR('NO SE PUEDE REALIZAR EL MOVIMIENTO, SALDO INSUFICIENTE',16,1)
        END
        IF @saldo - importe < (0 - @descubierto)
        BEGIN
            RAISERROR ('NO SE PUEDE REALIZAR EL MOVIMIENTO, SALDO ES INSUFICIENTE', 16, 1)
        END
    END
    --ACA TERMINA LA VALIDACIÓN, COMIENZA EL CODIGO REAL
    --Registramos el movimiento en la tabla movimientos
    INSERT INTO movimientos (fecha, nrocuenta, descripcion, tipomovimiento, importe) 
    VALUES(GETDATE(), @nroCuenta, @descripcion, @tipoMovimiento, @importe)

    --Si es extracción, restamos
    IF @tipoMovimiento = 'E' OR @tipoMovimiento = 'e'
    BEGIN
        SET @importe = @importe * -1
    END

    --Actualizamos el saldo de la cuenta
    UPDATE cuentas SET saldo = saldo + @importe WHERE nroCuenta = @nroCuenta

    END TRY
    BEGIN CATCH
        PRINT ERROR_MESSAGE()
    END CATCH
    --Finaliza el manejo de errores
END


Ahora, si por ejemplo, intentamos debitar $500 a una cuenta que posee $400 y es tipo caja (no tiene descubierto)
EXEC spRegistrarMovimiento '@nroCuenta', 'E', 'EXTRACCION EN CAJERO AUTOMATICO', 550
Nos arroja un mensaje de "NO SE PUEDE REALIZAR EL MOVIMIENTO, SALDO INSUFICIENTE

También, si probamos en una cuenta corriente, debitarle 1400, pero tiene 300 de saldo, con un limite descubierto de 1000
EXEC spRegistrarMovimiento '@nroCuenta', 'E', 'EXTRACCION EN SUCURSAL', 1400
Nos arroja un mensaje de "NO SE PUEDE REALIZAR EL MOVIMIENTO, SALDO INSUFICIENTE

En cambio, si ejecutamos consultas correctas, saldra bien, por ejemplo

EXEC spRegistrarMovimiento '@nroCuenta', 'D', 'DEPOSITO', 33


Veamos algunas cuestiones acerca del procedimiento almacenadoanterior, recibe los parametros para realizar el movimiento y debe de evaluar si se puede realizar  ono. En caso de ser un deposito, no habrá problemas y lo unico que debe hacer el StoredProcedure es insertar los valores en la tabla de movimientos y actualizar el saldo de la cuenta.
En caso de ser una extracción hay que determinar si se tiene el saldo suficiente, dicho proceso variará en caso de ser una cuenta corriente (permite girar en descubierto) o una caja de ahorro.
En cualquiera de los casos, si el debito es mayor al permitido, impide el proceso y finaliza el procedimiento
Ahi es donde se incorporan las nuevas estructuras, pero antes de comenzar a hablar de ellas, mencionemos las variables en SQL Server.

VARIABLES

Las variables que son declaradas en un procedimiento almacenado son locales al mismo, esto quiere decir, que solo el StoredProcedure puede ver estas variables.
Son declaradas mediante la palabra reservada DECLARE
y su sintaxis es
DECLARE @nombre_variable TIPO_DATO
Para asignarle valores se podrá hacerlo mediante el uso de la insturcción SET o bien mediante un SELECT.

En nuestro procedimiento almacenado, podemos ver como declaramos las variables @saldo, @tipoCuenta y @descubierto. Las mismas necesitan valores pero no serán establecidos manualmente por una instruccion sino que dichos datos provendran de una consulta SELECT.
descubierto de unac uenta particular, cuyo valor lo tenemos en otra variable denominada nroCuenta y que se envia como parametro al procedimiento.
Es por eso, que se ejecuta la siguiente instrucción
SELECT 
@saldo = C.saldo, 
@tipoCuenta = C.idTipoCuenta,
@descubierto =  C.limite_descubierto 
FROM cuentas AS C 
WHERE C.nroCuenta = @nroCuenta
Por otro lado, podemos ver como también se pueden asignar valores a variables mediante la instrucción SET como figura en nuestro procedimiento
SET @importe = @importe * -1.

En el procedimiento almacenado spRegistrarMovimiento figuran dos grandes estructuras, la decisión simple (if) y el try catch


Decisión simple (if)

La decisión simple en SQL se utiliza de la misma manera que en los demas lenguajes.
la estructura es la siguiente

IF condicion
BEGIN
    --INSTRUCCIONES
END
ELSE
BEGIN
    --INSTRUCCIONES
END

En nuestro procedure la utilizamos para determinar el tipo de movimiento que se desea registrar, de al siguiente manera 
IF @tipoMovimiento = 'E' OR @tipoMovimiento = 'e'
BEGIN
    SET @importe = @importe * -1
END


De manera que, si el movimiento es una extracción, el importe se convierte en negativo, para que al sumarlo al saldo, termine restando.

Try - Catch

Las estructuras utilizadas en el procedimiento almacenado es la de TRY CATCH. Esta funciona de la siguiente manera
Se indica proceso en el bloque TRY, y se establecen acciones que deben realizarse en el bloque CATCH en caso de ocurrir un error.
La estructura es la siguiente:

BEGIN TRY
 --GRUPO DE SENTENCIAS SQL
END TRY
BEGIN CATCH
 --GRUPO DE SENTENCIAS SQL EN CASO DE ERROR
END CATCH

Función RAISERROR

Esta función esta pensada como un manejo de errores, se encarga de asignar un mensaje de error, nivel de severidad y codigo de error.
Su sintaxis es
RAISERROR(cadena_mensaje, severidad, estado)

Donde
-cadena_mensaje es el mensaje de erroq eu se envia, hasta 399 caracteres
-severidad es el nivel definido por el usuario para el error, y puede tener valores entre 0 y 18.
Los valores entre 19 y 25 pueden ser creados por el admin de la abse de datos (sysadmin)
-estado es un numero entero entre 1 y 127 si el mismo tipo de error definido por el usuario se utiliza en varios lugares, se puede utilizar distintos estados para cada una de las locaciones para identificar mejor donde se ubica el error.

Sirve mayormente este raiserror para poner en el try, y que salte al catch.


    





