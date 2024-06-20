-- CONSULTA 3 --
-- ¿Cuál es el medicamento más recetado por el médico de cabecera de PAMI con matrícula nacional 126345 durante el período dic2023 - feb2024? 
-- ¿Es genérico o de algún laboratorio en particular? ¿Los afiliados tienen descuento total o parcial sobre el mismo?
-- NOTA: En nuestro esquema, generico es atributo de receta, no propio de medicamento (es decir, depende de cómo se recetó -> para un medicamento podemos tener una receta genérica y otra no)

SELECT 	Pr.Nombre_producto as Nombre_Medicamento, 
		DP.Porcentaje as Descuento, 
        COUNT(*) as Cant_Recetas
FROM Producto Pr
JOIN Receta_has_medicamento RHM ON Pr.idProducto = RHM.Medicamento_Producto_idProducto
JOIN Receta R ON R.Id_receta = RHM.receta_Id_receta
JOIN Médico M ON M.Num_matrícula = R.Médico_numMatrícula
JOIN Pami P1 ON P1.ObraSocial_Id_obra_social = M.PAMI_ObraSocial_Id_obra_social
JOIN Carnet Car ON Car.Cliente_DNI_cliente = R.cliente_DNI_cliente
JOIN Plan Pl ON Pl.Id_plan = Car.plan_Id_plan
JOIN Pami P2 ON P2.ObraSocial_Id_obra_social = Pl.ObraSocial_Id_obra_social -- de PAMI
LEFT JOIN descuento_planobrasocial DP ON DP.Plan_Id_Plan = Car.Plan_Id_Plan 
									  AND DP.Medicamento_Producto_idProducto = Pr.idProducto
WHERE R.Fecha_emision_receta BETWEEN '2023-12-01 00:00:00' AND '2024-02-29 23:59:59' -- período dic2023 - feb2024
	  AND M.Num_matrícula = 126345
GROUP BY Pr.Nombre_producto, DP.Porcentaje
ORDER BY cant_recetas DESC, Pr.Nombre_producto DESC
LIMIT 1;