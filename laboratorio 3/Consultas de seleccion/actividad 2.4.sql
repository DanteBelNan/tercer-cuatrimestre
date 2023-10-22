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
SELECT DISTINCT u.apellido, u.nombre
FROM usuarios as u
WHERE u.id NOT IN (
    SELECT DISTINCT u.id
    FROM usuarios as u
    INNER JOIN BilleteraVirtual as BV on BV.idPersona = u.id
    INNER JOIN BilleteraVirtualXTarjeta as BVXT on BVXT.idBilletera = bv.idPersona
    INNER JOIN Tarjeta as T on T.id = BVXT.idTarjeta
    INNER JOIN Marca as M on M.nombre = T.idMarca
    WHERE m.nombre = 'LEMON'
)


--6 Los nombres de bancos que no hayan entregado tarjetas a ningún cliente con nivel de situación crediticia Mala, Muy Mala o No Confiable.
SELECT B.nombre
FROM Banco as B
WHERE B.id NOT IN (
    SELECT T.idBanco
    FROM Tarjeta AS T
    INNER JOIN BilleteraVirtualXTarjeta BVXT ON BVXT.idTarjeta = T.id
    INNER JOIN BilleteraVirtual AS BV on BV.idBilleteraVirtual = BVXT.idBilletera
    INNER JOIN USUARIOS as U on U.id = BV.idPersona
    WHERE U.situacion_crediticia <= 3
)


--7 Por cada marca de tarjeta listar el nombre, la cantidad de clientes con situación crediticia favorable (de Excelente a Buena) y situación crediticia desfavorable (de Regular a No Confiable)
SELECT M.nombre AS Nombre_Marca, 
       (
           SELECT COUNT(*)
           FROM usuarios U
           INNER JOIN BilleteraVirtual BV ON U.id = BV.idPersona
           INNER JOIN BilleteraVirtualXTarjeta BVXT ON BV.idBilleteraVirtual = BVXT.idBilletera
           INNER JOIN Tarjeta T ON BVXT.idTarjeta = T.id
           WHERE T.idMarca = M.id AND U.situacion_crediticia > 3
       ) AS Cantidad_Clientes_Favorable,
              (
           SELECT COUNT(*)
           FROM usuarios U
           INNER JOIN BilleteraVirtual BV ON U.id = BV.idPersona
           INNER JOIN BilleteraVirtualXTarjeta BVXT ON BV.idBilleteraVirtual = BVXT.idBilletera
           INNER JOIN Tarjeta T ON BVXT.idTarjeta = T.id
           WHERE T.idMarca = M.id AND U.situacion_crediticia <= 3
       ) AS Cantidad_Clientes_Desfavortable
FROM Marca M;

--8 Por cada billetera, listar el alias y la cantidad total de dinero operado en el mes de enero de 2023. Si no registró movimientos debe totalizar 0.
SELECT BV.alias, COALESCE((
    SELECT SUM(M.monto)
    FROM Movimientos as M
    WHERE M.emisor = BV.idBilleteraVirtual AND MONTH(M.fecha) = 1 AND YEAR(m.fecha) = 2023),
    0) as total
FROM BilleteraVirtual as BV


--9 El banco decidió cobrar en el mes de enero el monto de $50 a cada movimiento de débito realizado en un fin de semana y $10 a los movimientos de crédito realizados. Listar para cada billetera, el alias y la cantidad a abonar por este disparatado recargo. Si no registra recargos debe totalizar 0.
--NOTA: Sólo aplica a los movimientos registrados en el mes de enero de 2023.
SELECT BV.alias, COALESCE(
    (SELECT SUM(
        CASE
            WHEN MONTH(M.Fecha) = 1 AND YEAR(M.fecha) = 2023 THEN
                CASE
                    WHEN DATENAME(dw, M.fecha) IN ('Saturday', 'Sunday') AND M.monto < 0 THEN 50
                    WHEN M.monto > 0 THEN 10
                    ELSE 0
                END
            ELSE 0
    END)
    FROM Movimientos as M
    Where M.emisor = BV.idBilleteraVirtual),
    0) as Total_Recargos
FROM BilleteraVirtual as BV


--10 El total acumulado en concepto de recargo (ver Punto 9)
SELECT COALESCE(SUM(
    (SELECT SUM(
        CASE
            WHEN MONTH(M.fecha) = 8 AND YEAR(M.fecha) = 2023 THEN
                CASE
                    WHEN DATENAME(dw, M.fecha) IN ('Saturday', 'Sunday') AND M.monto < 0 THEN 50
                    WHEN M.monto > 0 THEN 10
                    ELSE 0
                END
            ELSE 0
        END)
    FROM Movimientos AS M
    WHERE M.emisor = BV.idBilleteraVirtual)
))

