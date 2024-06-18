-- Clientes que compran en farmacias de localidades distintas a su domicilio: para saber dónde abrir sucursales (no sabemos dónde se hace la compra):
-- Encuentro las localidades de todos los clientes
WITH Localidades AS(
	SELECT Direccion_localidad
	FROM Cliente
),
-- Localidades de los clientes que no tienen farmacias en su localidad
Localidades_sinFarmacia AS(
	SELECT Direccion_localidad
	FROM Cliente
	WHERE Direccion_localidad NOT IN (SELECT f.Direccion_localidad FROM Farmacia AS f)
),
-- Número de clientes que viven en Localidades_sinFarmacia
NumeroClientes AS(
	SELECT c.Direccion_localidad AS proximaLocalidad, COUNT(DISTINCT c.DNI_cliente) AS cantClientes
	FROM Cliente AS c
	WHERE c.Direccion_localidad = (SELECT Direccion_localidad FROM Localidades_sinFarmacia)
	GROUP BY proximaLocalidad
)
-- Agarro la localidad donde proximamente pondremos una farmacia, determinada por el MAX de cantClientes, que es la mayor cant de clientes que viven en una localidad donde no hay farmachichi
SELECT proximaLocalidad
FROM NumeroClientes
ORDER BY cantClientes DESC
LIMIT 1;