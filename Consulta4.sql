-- ¿Cuántos de los clientes invitados al último evento asistieron? 

WITH EventoReciente AS (
    SELECT Id_evento, Fecha_evento
    FROM Evento
    WHERE Fecha_evento >= CURRENT_DATE
    ORDER BY Fecha_evento ASC
    LIMIT 1
),
Asistentes AS (
    SELECT DISTINCT Cliente_DNI_cliente
    FROM Cliente_asiste_a_Evento
    WHERE Evento_Id_evento = (SELECT Id_evento FROM EventoReciente) -- el último evento es el más reciente, no el de mayor id
)
SELECT COUNT(DISTINCT Cliente_DNI_cliente) as Cant_Asistentes FROM Asistentes;

-- De los asistentes, ¿cuántos compraron los productos mostrados en el evento y cuál fue el promedio de gasto? 

WITH EventoReciente AS (
    SELECT Id_evento, Fecha_evento
    FROM Evento
    WHERE Fecha_evento >= CURRENT_DATE
    ORDER BY Fecha_evento ASC
    LIMIT 1
),
Asistentes AS (
    SELECT DISTINCT Cliente_DNI_cliente
    FROM Cliente_asiste_a_Evento
    WHERE Evento_Id_evento = (SELECT Id_evento FROM EventoReciente) -- el último evento es el más reciente, no el de mayor id
),
ProductosMostrados AS (
    SELECT ArtículoPerfumería_Producto_idProducto
    FROM Evento_muestra_ArtículoPerfumería
    WHERE Evento_Id_evento = (SELECT Id_evento FROM EventoReciente)
),
ComprasAsistentes AS (
    SELECT c.Cliente_DNI_cliente, SUM(cp.Cantidad * cp.PrecioUnitario) AS total_gasto
    FROM Compra_has_Producto AS cp
    JOIN Compra c ON c.idCompra = cp.Compra_idCompra
    JOIN Asistentes a ON c.Cliente_DNI_cliente = a.Cliente_DNI_cliente
    WHERE cp.Producto_idProducto IN (SELECT ArtículoPerfumería_Producto_idProducto FROM ProductosMostrados)
								AND c.Fecha > (SELECT Fecha_Evento FROM EventoReciente)
								AND DATE(c.Fecha) = DATE((SELECT Fecha_Evento FROM EventoReciente))
    GROUP BY c.Cliente_DNI_cliente
)

SELECT COUNT(DISTINCT cae.Cliente_DNI_cliente) AS Compradores,
       AVG(ca.total_gasto) AS Promedio_Gasto
FROM Cliente_asiste_a_Evento AS cae
JOIN ComprasAsistentes AS ca ON cae.Cliente_DNI_cliente = ca.Cliente_DNI_cliente
WHERE cae.Evento_Id_evento = (SELECT Id_evento FROM EventoReciente);

