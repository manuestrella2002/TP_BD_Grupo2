-- CONSULTA 6 --
-- Ordene de más usada a menos usada, las cinco opciones de pago para medicamentos de los últimos cinco meses y las cinco opciones de pago de perfumería (excluyendo bebés y pañales de adultos). 

-- Para medicamentos de los últimos cinco meses:
SELECT	c.Metodo_pago,
		COUNT(*) AS Uso
FROM Compra c
JOIN Compra_has_Producto CHP ON C.idCompra = CHP.Compra_idCompra
JOIN Medicamento M ON CHP.Producto_idProducto = M.Producto_idProducto
WHERE C.Fecha >= DATE_SUB(NOW(), INTERVAL 5 MONTH)
GROUP BY C.Metodo_pago
ORDER BY Uso DESC
LIMIT 5;

-- De perfumería (excluyendo bebés y pañales de adultos)
SELECT	c.Metodo_pago,
		COUNT(*) AS Uso
FROM Compra c
JOIN Compra_has_Producto CHP ON C.idCompra = CHP.Compra_idCompra
JOIN ArtículoPerfumería AP ON CHP.Producto_idProducto = AP.Producto_idProducto
JOIN Producto P ON P.idProducto = AP.Producto_IdProducto
JOIN Sector S ON AP.Sector_Id_sector = S.Id_sector
WHERE S.Nombre_sector <>'Bebes y Mamas'
    AND P.Nombre_producto <>'Paniales'
GROUP BY C.Metodo_pago
ORDER BY Uso DESC
LIMIT 5;
