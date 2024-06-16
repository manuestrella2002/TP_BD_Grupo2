-- ¿Quién es el responsable de perfumería que más ventas generó en eventos en los meses de enero a mayo del año 2024?
SELECT
    emp.Nombre_empleado AS Nombre_responsable,
    emp.Apellido_empleado AS Apellido_responsable,
    SUM(chp.Cantidad * chp.PrecioUnitario * (100 - chp.Descuento) / 100) AS Ventas_generadas
FROM
    compra c
    JOIN compra_has_producto chp ON c.idCompra = chp.Compra_idCompra
    JOIN evento e ON DATE(c.Fecha) = DATE(e.Fecha_evento)
    JOIN evento_muestra_artículoperfumería ema ON e.Id_evento = ema.Evento_Id_evento
    JOIN empleado emp ON emp.Farmacia_Id_farmacia = e.Farmacia_Id_farmacia
WHERE
    YEAR(c.Fecha) = 2024 AND MONTH(c.Fecha) BETWEEN 1 AND 5
GROUP BY
    emp.DNI_empleado
ORDER BY
    Ventas_generadas DESC
LIMIT 1;