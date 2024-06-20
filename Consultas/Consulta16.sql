-- CONSULTA 16 --
-- Cual es el plan de OSDE que tiene mas clientes de entre 18-30 años que cuentan con su tarjeta de fidelidad para un descuento en artículos de perfumeria

WITH planes_osde AS (
    SELECT Id_plan 
    FROM plan
    JOIN obrasocial ON obrasocial.Id_obra_social = plan.obrasocial_Id_obra_social
    WHERE obrasocial.Nombre_obra_social = 'OSDE'
)

SELECT 	CONCAT("OSDE", p.Nombre_plan) as Plan, 
		count(*) as Cant_Clientes
FROM carnet AS car
JOIN cliente AS c ON car.Cliente_DNI_cliente = c.DNI_cliente 
JOIN tarjeta_fidelidad as tf on tf.cliente_DNI_cliente = c.DNI_cliente
JOIN tarjeta_fidelidad_has_descuento as tfd on tfd.Tarjeta_fidelidad_Id_tarjeta_fidelidad= tf.Id_tarjeta_fidelidad
JOIN descuentopromocional as dp on dp.idDescuentoPromocional=tfd.Descuento_idDescuento
JOIN artículoperfumería as ap on ap.Producto_idProducto=dp.Producto_idProducto
JOIN plan p on p.Id_plan = car.plan_Id_plan
WHERE car.plan_Id_plan IN (SELECT Id_plan FROM planes_osde) 
		AND (TIMESTAMPDIFF(YEAR, c.Fecha_nacimiento, CURDATE()) between 18 AND 30)
group by car.plan_Id_plan
order by cant_clientes
limit 1;