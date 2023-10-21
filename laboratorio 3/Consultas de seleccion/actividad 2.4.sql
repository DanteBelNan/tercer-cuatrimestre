use dos_tres

--1 Apellidos y nombres, alias, fecha de creación y saldo de aquellas cuentas que tengan un saldo mayor al saldo promedio.
SELECT apellido, nombre, alias, creacioncuenta, saldo
FROM BilleteraVirtual
WHERE saldo > (SELECT AVG(saldo) FROM BilleteraVirtual)

--2 Marca de las tarjetas y límite de compras de aquellas tarjetas que tengan un límite mayor al de cualquier tarjeta del 'Banco Santander Rio'
SELECT M.nombre, T.limiteCompra
FROM Tarjeta as T
INNER JOIN Marca as M on M.id = T.idMarca
WHERE T.limiteCompra > (
    SELECT MAX(limiteCompra) FROM Tarjeta
    WHERE idBanco = (
        select id from banco where nombre = 'Santander'
    )
) 


--3 Marca de las tarjetas y límite de compras de aquellas tarjetas que tengan un límite mayor al de alguna tarjeta del 'Banco HSBC'
SELECT M.nombre, T.limiteCompra
FROM Tarjeta as T
INNER JOIN Marca as M on M.id = T.idMarca
WHERE T.limiteCompra > ANY (
    SELECT limiteCompra FROM Tarjeta
    WHERE idBanco = (
        select id from banco where nombre = 'HSBC'
    )
) 

--4 Los apellidos y nombres y alias de las billeteras que no hayan registrado movimientos en la segunda quincena de Agosto de 2023.
SELECT BV.apellido, BV.nombre, BV.alias
FROM BilleteraVirtual as BV
WHERE
    bv.idBilleteraVirtual not in (
        SELECT M.emisor
        FROM Movimientos as M
        WHERE fecha >= '2023-08-16' AND fecha <= '2023-08-31'
    )

--5 Los apellidos y nombres de clientes que no tengan registrada ninguna tarjeta de la marca 'LEMON'
SELECT BV.apellido, BV.nombre
FROM BilleteraVirtual as BV
WHERE bv.idPersona NOT IN (
    SELECT idPersona
    FROM BilleteraVirtualXTarjeta as BVXT
    INNER JOIN Tarjeta as T on BVXT.idTarjeta = T.id
    INNER JOIN Marca as M on T.idMarca = M.id
    WHERE M.nombre LIKE 'LEMON'
)


--6 Los nombres de bancos que no hayan entregado tarjetas a ningún cliente con nivel de situación crediticia Mala, Muy Mala o No Confiable.

--7 Por cada marca de tarjeta listar el nombre, la cantidad de clientes con situación crediticia favorable (de Excelente a Buena) y situación crediticia desfavorable (de Regular a No Confiable)

--8 Por cada billetera, listar el alias y la cantidad total de dinero operado en el mes de agosto de 2023 y la cantidad total de dinero operado en el mes de septiembre de 2023. Si no registró movimientos debe totalizar 0.

--9 El banco decidió cobrar en el mes de Agosto el monto de $50 a cada movimiento de débito realizado en un fin de semana y $10 a los movimientos de crédito realizados. Listar para cada billetera, el alias y la cantidad a abonar por este disparatado recargo. Si no registra recargos debe totalizar 0.
--NOTA: Sólo aplica a los movimientos registrados en el mes de Agosto de 2023.

--10 El total acumulado en concepto de recargo (ver Punto 9)

