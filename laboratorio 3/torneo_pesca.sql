CREATE DATABASE TORNEO_PESCA
GO
USE TORNEO_PESCA
GO
-- TORNEO_PESCA.dbo.ESPECIES definition

-- Drop table

-- DROP TABLE TORNEO_PESCA.dbo.ESPECIES;

CREATE TABLE ESPECIES (
	IDESPECIE bigint NOT NULL,
	ESPECIE varchar(50) NOT NULL,
	PESO_MINIMO decimal(10,2) NULL,
	CONSTRAINT PK__ESPECIES__AB0171BB03309837 PRIMARY KEY (IDESPECIE)
);


-- TORNEO_PESCA.dbo.PARTICIPANTES definition

-- Drop table

-- DROP TABLE TORNEO_PESCA.dbo.PARTICIPANTES;

CREATE TABLE PARTICIPANTES (
	IDPARTICIPANTE bigint NOT NULL,
	APELLIDO varchar(50) NOT NULL,
	NOMBRE varchar(50) NOT NULL,
	GENERO char(1) NOT NULL,
	FECHA_NACIMIENTO smalldatetime NOT NULL,
	CONSTRAINT PK__PARTICIP__E58073B16C63F6F0 PRIMARY KEY (IDPARTICIPANTE)
);


-- TORNEO_PESCA.dbo.CAPTURAS definition

-- Drop table

-- DROP TABLE TORNEO_PESCA.dbo.CAPTURAS;

CREATE TABLE CAPTURAS (
	IDCAPTURA bigint NOT NULL,
	IDPARTICIPANTE bigint NOT NULL,
	IDESPECIE bigint NULL,
	PESO decimal(10,2) NOT NULL,
	FECHA_HORA smalldatetime NOT NULL,
	CONSTRAINT PK__CAPTURAS__BEDF5764438E78A9 PRIMARY KEY (IDCAPTURA),
	CONSTRAINT FK__CAPTURAS__IDESPE__29572725 FOREIGN KEY (IDESPECIE) REFERENCES ESPECIES(IDESPECIE),
	CONSTRAINT FK__CAPTURAS__IDPART__286302EC FOREIGN KEY (IDPARTICIPANTE) REFERENCES PARTICIPANTES(IDPARTICIPANTE)
);

SET DATEFORMAT YMD

INSERT INTO PARTICIPANTES (IDPARTICIPANTE,APELLIDO,NOMBRE,GENERO,FECHA_NACIMIENTO) VALUES
	 (1,N'SEINFELD',N'JERRY',N'M','1980-01-01 00:00:00.0'),
	 (2,N'COSTANZA',N'GEORGE',N'M','1984-01-01 00:00:00.0'),
	 (3,N'BENES',N'ELAINE',N'F','1986-01-01 00:00:00.0'),
	 (4,N'KRAMER',N'COSMO',N'M','1975-01-01 00:00:00.0');

INSERT INTO ESPECIES (IDESPECIE,ESPECIE,PESO_MINIMO) VALUES
	 (1,N'CARPA',4.00),
	 (2,N'DORADO',4.00),
	 (3,N'BAGRE BLANCO',5.00),
	 (4,N'BAGRE AMARILLO',2.00),
	 (5,N'BAGRE MUTANTE',10.00),
	 (6,N'MOJARRITA',0.10);

INSERT INTO CAPTURAS (IDCAPTURA,IDPARTICIPANTE,IDESPECIE,PESO,FECHA_HORA) VALUES
	 (1,1,1,30.25,'2023-04-01 22:00:00.0'),
	 (2,1,2,25.30,'2023-04-01 08:15:00.0'),
	 (3,1,3,4.50,'2023-04-01 23:30:00.0'),
	 (4,2,4,55.00,'2023-04-01 23:45:00.0'),
	 (5,2,NULL,25.00,'2023-04-01 22:00:00.0'),
	 (6,2,NULL,25.00,'2023-04-01 22:10:00.0'),
	 (7,2,3,3.50,'2023-04-01 09:30:00.0'),
	 (8,3,NULL,85.00,'2023-04-01 00:40:00.0'),
	 (9,3,5,20.00,'2023-04-01 00:55:00.0'),
	 (10,3,1,30.00,'2023-04-01 10:00:00.0'),
	 (11,4,1,15.00,'2023-04-01 09:00:00.0'),
	 (12,4,1,15.00,'2023-04-01 21:15:00.0');


-- 1 El trofeo de oro del torneo es para aquel que haya capturado el pez más pesado entre todos los peces. Puede haber más de un ganador del trofeo. Listar Apellido y nombre, especie de pez que capturó y el pesaje del mismo.
SELECT P.APELLIDO, P.NOMBRE, E.ESPECIE, C.PESO
FROM PARTICIPANTES as P
LEFT JOIN CAPTURAS as C ON P.IDPARTICIPANTE = C.IDPARTICIPANTE
LEFT JOIN ESPECIES as E ON E.IDESPECIE = C.IDESPECIE
WHERE C.PESO = (SELECT MAX(PESO) FROM CAPTURAS)


-- 2 Listar todos los participantes que no hayan pescado ningún tipo de bagre.
SELECT DISTINCT P.APELLIDO, P.NOMBRE
FROM PARTICIPANTES AS P
WHERE P.IDPARTICIPANTE NOT IN (
	SELECT C.IDPARTICIPANTE
	FROM CAPTURAS AS C
	INNER JOIN ESPECIES AS E ON C.IDESPECIE = E.IDESPECIE
	WHERE E.ESPECIE LIKE 'BAGRE%'
)

-- 3 Listar los participantes cuyo promedio de pesca (en kilos) sea mayor a 30. Listar apellido, nombre y promedio de kilos. 
SELECT P.NOMBRE, P.APELLIDO, AVG(C.PESO) AS PromedioDeKilos
FROM PARTICIPANTES AS P
LEFT JOIN CAPTURAS AS C ON C.IDPARTICIPANTE = P.IDPARTICIPANTE
LEFT JOIN ESPECIES AS E ON E.IDESPECIE = C.IDESPECIE
GROUP BY P.IDPARTICIPANTE, P.NOMBRE, P.APELLIDO
HAVING AVG(C.PESO) > 30;

-- 4 Por cada especie, listar la cantidad de participantes que la han capturado.
SELECT E.ESPECIE, COUNT(DISTINCT C.IDPARTICIPANTE) AS CantidadDeParticipantes
FROM ESPECIES AS E
LEFT JOIN CAPTURAS AS C ON E.IDESPECIE = C.IDESPECIE
GROUP BY E.ESPECIE

-- 5 Listar apellido y nombre del participante y nombre de la especie de cada pez que haya capturado el pescador/a. Si alguna especie de pez no ha sido pescado nunca entonces deberá aparecer en el listado de todas formas pero sin relacionarse con ningún pescador. El listado debe aparecer ordenado por nombre de especie de manera creciente. La combinación apellido y nombre y nombre de la especie debe aparecer sólo una vez este listado.


SELECT DISTINCT P.APELLIDO, P.NOMBRE, E.ESPECIE
FROM CAPTURAS AS C
RIGHT JOIN PARTICIPANTES AS P ON P.IDPARTICIPANTE = C.IDPARTICIPANTE
RIGHT JOIN ESPECIES AS E ON E.IDESPECIE = C.IDESPECIE
ORDER BY E.ESPECIE

-- 6 El trofeo de plata de la competencia se lo adjudica quien haya capturado la mayor cantidad de kilos en total y nunca haya capturado un pez por debajo del peso mínimo de la especie.
SELECT TOP 1 P.APELLIDO, P.NOMBRE, SUM(C.PESO) AS PESO_TOTAL
FROM PARTICIPANTES AS P
INNER JOIN CAPTURAS AS C ON C.IDPARTICIPANTE = P.IDPARTICIPANTE
WHERE P.IDPARTICIPANTE NOT IN (
	SELECT P.IDPARTICIPANTE
	FROM PARTICIPANTES AS P
	INNER JOIN CAPTURAS AS C ON C.IDPARTICIPANTE = P.IDPARTICIPANTE
	INNER JOIN ESPECIES AS E ON E.IDESPECIE = C.IDESPECIE
	WHERE C.PESO < E.PESO_MINIMO
)
GROUP BY P.APELLIDO, P.NOMBRE
ORDER BY PESO_TOTAL DESC;




