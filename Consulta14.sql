-- ¿Cuáles son los clientes hombres con obra social Swiss Medical que se realizaron, por receta, un tratamiento de 'acupuntura' en el año 2024? ¿Qué plan tienen?

WITH HombresSM AS(
	SELECT c.DNI_cliente, c.Nombre_cliente, c.Apellido_cliente, p.Id_plan, p.Nombre_plan
	FROM Cliente AS c
	JOIN Carnet AS ca ON ca.Cliente_DNI_cliente = c.DNI_cliente
	JOIN Plan AS p ON p.Id_plan = ca.plan_Id_plan 
	JOIN ObraSocial AS os ON os.Id_obra_social = p.obrasocial_Id_obra_social
	WHERE c.genero = 'M' AND os.Nombre_obra_social = 'Swiss Medical' 
)

SELECT hsm.DNI_cliente, CONCAT(hsm.Nombre_cliente, " ", hsm.Apellido_cliente) as Nombre_cliente, CONCAT("Swiss Medical ", hsm.Nombre_plan) as Plan
FROM HombresSM AS hsm
JOIN Receta AS r ON r.cliente_DNI_cliente = hsm.DNI_cliente
WHERE r.Tipo_tratamiento_receta = 'acupuntura' AND YEAR(r.Fecha_emision_receta) = 2024;