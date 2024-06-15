-- ¿Cuál es el producto de perfumería preferido por las mujeres del segmento 35-45 años? ¿Lo llevan solo o en combinación con otro producto? 
WITH ProductosPreferidos(idProducto, veces_comprado,productos_combinados)  AS (
	SELECT ap.Producto_idProducto, 
			COUNT(cp.Compra_idCompra) AS veces_comprado, 
			GROUP_CONCAT(DISTINCT p2.nombre_Producto SEPARATOR ', ') AS productos_combinados
	FROM ArtículoPerfumería AS ap
	JOIN Producto AS p ON p.idProducto = ap.Producto_idProducto
	JOIN Compra_has_Producto AS cp ON p.idProducto = cp.Producto_idProducto
	JOIN Compra AS c ON cp.Compra_idCompra = c.idCompra
	JOIN Cliente AS cli ON c.Cliente_DNI_cliente = cli.DNI_cliente
	LEFT JOIN Compra_has_Producto AS cp2 ON c.idCompra = cp2.Compra_idCompra AND cp2.Producto_idProducto <> cp.Producto_idProducto 
	LEFT JOIN ArtículoPerfumería AS ap2 ON cp2.Producto_idProducto = ap2.Producto_idProducto
    LEFT JOIN Producto AS p2 ON ap2.Producto_idProducto = p2.idProducto
	WHERE cli.genero = 'F' AND TIMESTAMPDIFF(YEAR, cli.Fecha_nacimiento, c.Fecha) BETWEEN 35 AND 45
	GROUP BY ap.Producto_idProducto
	ORDER BY veces_comprado DESC, Producto_idProducto DESC
)

SELECT idProducto, veces_comprado, productos_combinados
FROM ProductosPreferidos 
WHERE veces_comprado IN (
	SELECT MAX(veces_comprado)
	FROM ProductosPreferidos 
);