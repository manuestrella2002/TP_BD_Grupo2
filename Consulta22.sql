-- ¿HACER PROMOCIONES ONLINE?
-- Hallar incidencia compras online sobre total de las ventas y top 3 artículos en carritos que no se concretaron.

-- Subconsulta para determinar las compras online (realizadas)
WITH ComprasOnline AS (
    SELECT chp.Producto_idProducto, SUM(chp.Cantidad) AS cantOnline
    FROM Compra AS c
    JOIN Compra_has_producto AS chp ON c.idcompra = chp.Compra_idCompra
    WHERE c.online = 1
    GROUP BY chp.Producto_idProducto
),

-- Subconsulta para calcular el total de ventas (compras realizadas)
TotalCompras AS (
    SELECT chp.Producto_idProducto, SUM(chp.Cantidad) AS cantTotal
    FROM Compra AS c
    JOIN Compra_has_producto AS chp ON c.idcompra = chp.Compra_idCompra
    GROUP BY chp.Producto_idProducto
)

SELECT
    (SELECT SUM(cantOnline) FROM ComprasOnline) AS CantidadOnline,
    (SELECT SUM(cantTotal) FROM TotalCompras) AS CantidadTotal,
    (SELECT SUM(cantOnline) FROM ComprasOnline) / (SELECT SUM(cantTotal) FROM TotalCompras) * 100 AS IncidenciaPorcentual;

-- Subconsulta para encontrar los artículos en carritos no concretados
WITH ArticulosNoConcretados AS (
    SELECT co.ArtículoPerfumería_Producto_idproducto AS Producto_idProducto, SUM(co.cantidad) AS CantidadNoConcretada
    FROM CarritoOnline AS co
    LEFT JOIN Compra_has_producto AS chp ON co.ArtículoPerfumería_Producto_idproducto = chp.Producto_idProducto
    LEFT JOIN Compra AS c ON chp.Compra_idCompra = c.idcompra AND c.online = 1
    WHERE chp.Producto_idProducto IS NULL OR c.idcompra IS NULL
    GROUP BY co.ArtículoPerfumería_Producto_idproducto
)
SELECT
    an.Producto_idProducto, p.Nombre_producto, an.CantidadNoConcretada
FROM ArticulosNoConcretados AS an
JOIN ArtículoPerfumería AS ap ON an.Producto_idProducto = ap.Producto_idProducto
JOIN producto AS p ON p.idProducto = ap.Producto_idProducto
ORDER BY an.CantidadNoConcretada DESC
LIMIT 5;
