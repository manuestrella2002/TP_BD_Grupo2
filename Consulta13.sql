-- CONSULTA 13: NUEVO FARMACHICHI --
-- ¿En qué localidad conviene abrir un Farmachichi? ¿Dónde viven los clientes que no tienen Farmachichi?

WITH Localidades AS(
-- Localidades de todos los clientes
	SELECT DISTINCT Direccion_localidad	FROM Cliente
),
Localidades_sinFarmacia AS(
-- Localidades de los clientes que no tienen farmacias en su localidad
	SELECT DISTINCT Direccion_localidad	FROM Cliente
	WHERE Direccion_localidad NOT IN (SELECT f.Direccion_localidad FROM Farmacia AS f)
),
NumeroClientes AS(
-- Número de clientes que viven en Localidades_sinFarmacia
	SELECT c.Direccion_localidad AS proximaLocalidad, COUNT(DISTINCT c.DNI_cliente) AS cantClientes
	FROM Cliente AS c
	WHERE c.Direccion_localidad IN (SELECT Direccion_localidad FROM Localidades_sinFarmacia)
	GROUP BY proximaLocalidad
)
-- La localidad donde proximamente pondremos una farmacia está determinada por el MAX de cantClientes, que es la mayor cantidad de clientes que viven en una localidad donde no hay farmachichi
SELECT ProximaLocalidad, cantClientes as PotencialesClientes
FROM NumeroClientes
ORDER BY cantClientes DESC
LIMIT 1;
