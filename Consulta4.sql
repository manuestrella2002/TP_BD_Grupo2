-- CONSULTA 4 --
-- ¿Cuántos de los clientes invitados al último evento asistieron? De los asistentes, ¿cuántos compraron los productos mostrados en el evento y cuál fue el promedio de gasto? 

WITH EventoReciente AS (
-- Último evento (el más reciente)
    SELECT Id_evento, Fecha_evento
    FROM Evento
    WHERE Fecha_evento <= CURRENT_DATE  
    ORDER BY Fecha_evento DESC
    LIMIT 1
),
Asistentes AS (
-- Clientes que asistieron al último evento
    SELECT DISTINCT Cliente_DNI_cliente
    FROM Cliente_asiste_a_Evento
    WHERE Evento_Id_evento = (SELECT Id_evento FROM EventoReciente)
),
Invitados AS (
-- Clientes que fueron invitados al último evento
    SELECT DISTINCT tfae.tarjeta_fidelidad_Id_tarjeta_fidelidad
    FROM tarjeta_fidelidad_accede_evento tfae
    JOIN EventoReciente er ON tfae.evento_Id_evento = er.Id_evento
),
AsistentesInvitados AS (
-- Clientes que fueron invitados y asistieron al último evento
    SELECT a.Cliente_DNI_cliente
    FROM Asistentes a
    JOIN tarjeta_fidelidad tf ON a.Cliente_DNI_cliente = tf.Cliente_DNI_cliente
    JOIN Invitados i ON tf.Id_tarjeta_fidelidad = i.tarjeta_fidelidad_Id_tarjeta_fidelidad
)
-- ¿Cuántos de los clientes invitados al último evento asistieron?
SELECT COUNT(DISTINCT Cliente_DNI_cliente) AS Cant_Asistentes_Invitados
FROM AsistentesInvitados;


WITH EventoReciente AS (
-- Último evento (el más reciente)
    SELECT Id_evento, Fecha_evento
    FROM Evento
    WHERE Fecha_evento <= CURRENT_DATE
    ORDER BY Fecha_evento DESC
    LIMIT 1
),
Asistentes AS (
-- Clientes que asistieron al último evento
    SELECT DISTINCT Cliente_DNI_cliente
    FROM Cliente_asiste_a_Evento
    WHERE Evento_Id_evento = (SELECT Id_evento FROM EventoReciente) -- el último evento es el más reciente, no el de mayor id
),
ProductosMostrados AS (
-- Productos mostrados en el último evento
    SELECT ArtículoPerfumería_Producto_idProducto
    FROM Evento_muestra_ArtículoPerfumería
    WHERE Evento_Id_evento = (SELECT Id_evento FROM EventoReciente)
),
ComprasAsistentes AS (
-- Compras que hicieron asistentes de productos mostrados en el evento
    SELECT c.Cliente_DNI_cliente, SUM(cp.Cantidad * cp.PrecioUnitario) AS total_gasto
    FROM Compra_has_Producto AS cp
    JOIN Compra c ON c.idCompra = cp.Compra_idCompra
    JOIN Asistentes a ON c.Cliente_DNI_cliente = a.Cliente_DNI_cliente
    WHERE cp.Producto_idProducto IN (SELECT ArtículoPerfumería_Producto_idProducto FROM ProductosMostrados)
								AND c.Fecha > (SELECT Fecha_Evento FROM EventoReciente) -- en un horario posterior al inicio del evento
								AND DATE(c.Fecha) = DATE((SELECT Fecha_Evento FROM EventoReciente)) -- el día del evento
    GROUP BY c.Cliente_DNI_cliente
)
-- De los asistentes, ¿cuántos compraron los productos mostrados en el evento y cuál fue el promedio de gasto? 
SELECT COUNT(DISTINCT cae.Cliente_DNI_cliente) AS Compradores,
       AVG(ca.total_gasto) AS Promedio_Gasto
FROM Cliente_asiste_a_Evento AS cae
JOIN ComprasAsistentes AS ca ON cae.Cliente_DNI_cliente = ca.Cliente_DNI_cliente
WHERE cae.Evento_Id_evento = (SELECT Id_evento FROM EventoReciente);