-- ¿Quién es el responsable de perfumería que más ventas generó en eventos en los meses de enero a mayo del año 2024?
SELECT
    Emp.Nombre_empleado AS Nombre_responsable,
    Emp.Apellido_empleado AS Apellido_responsable,
    SUM(CHP.Cantidad) AS Ventas_generadas
FROM
    Compra C
    JOIN Compra_Has_Producto CHP ON C.idCompra = CHP.Compra_idCompra
    JOIN Evento E ON DATE(C.Fecha) = DATE(E.Fecha_evento)
    JOIN Evento_Muestra_ArtículoPerfumería EMA ON E.Id_evento = EMA.Evento_Id_evento
    JOIN Empleado Emp ON Emp.Farmacia_Id_farmacia = E.Farmacia_Id_farmacia
WHERE
    YEAR(C.Fecha) = 2024 AND MONTH(C.Fecha) BETWEEN 1 AND 5
GROUP BY
    Emp.DNI_empleado
ORDER BY
    Ventas_generadas DESC
LIMIT 1;