-- ¿Cuál es el medicamento de venta libre más vendido en los meses de verano de los últimos tres años? 
WITH Id_Medicamento_Mas_Vendido AS (
	SELECT m.Producto_idProducto, COUNT(cp.Producto_idProducto) cant_ventas
	FROM Medicamento AS m
	JOIN Producto AS p ON p.idProducto = m.Producto_idProducto
	JOIN Compra_has_Producto AS cp ON p.idProducto = cp.Producto_idProducto
	JOIN Compra AS c ON cp.Compra_idCompra = c.idCompra
	WHERE m.Venta_libre_medicamento = true 
		AND (MONTH(c.Fecha) IN (12, 1, 2, 3)) 
		AND (c.Fecha BETWEEN DATE_SUB(CURRENT_TIMESTAMP(), INTERVAL 3 YEAR) AND CURRENT_TIMESTAMP())
	GROUP BY m.Producto_idProducto
	ORDER BY cant_ventas DESC
	LIMIT 1 )
SELECT p.Nombre_Producto FROM Id_Medicamento_Mas_Vendido IDMV
JOIN Producto AS p ON p.idProducto = IDMV.Producto_idProducto;