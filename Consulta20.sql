-- CONSULTA 20: RECOMENDACIONES - Otros clientes también compraron...
-- Qué otros 5 productos más compraron las personas que compraron 'paniales'

WITH ProductoReferencia AS (
    SELECT idProducto
    FROM Producto
    WHERE Nombre_producto = 'paniales'
),
ClientesQueCompraron AS (
    SELECT DISTINCT c.Cliente_DNI_cliente
    FROM Compra AS c
    JOIN Compra_has_Producto AS chp ON c.idCompra = chp.Compra_idCompra
    WHERE chp.Producto_idProducto = (SELECT idProducto FROM ProductoReferencia)
),
OtrosProductosComprados AS (
    SELECT ap.Producto_idProducto, COUNT(*) AS veces_comprado
    FROM Compra_has_Producto AS chp
    JOIN Compra AS c ON c.idCompra = chp.Compra_idCompra
    JOIN artículoperfumería ap ON ap.Producto_idProducto = chp.Producto_idProducto
    WHERE c.Cliente_DNI_cliente IN (SELECT Cliente_DNI_cliente FROM ClientesQueCompraron)
    AND ap.Producto_idProducto != (SELECT idProducto FROM ProductoReferencia)
    GROUP BY ap.Producto_idProducto
    ORDER BY veces_comprado DESC
    LIMIT 5
)
SELECT p.Nombre_producto as Productos_Recomendados
FROM OtrosProductosComprados AS op
JOIN Producto AS p ON p.idProducto = op.Producto_idProducto;
