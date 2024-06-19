-- CONSULTA 19: Medicamentos equivalentes --
-- Búsqueda de medicamentos con las mismas drogas

with MedicamentosEquivalentes as (
SELECT m1.Medicamento_Producto_idProducto AS Medicamento1, 
		m2.Medicamento_Producto_idProducto AS Medicamento2
FROM medicamento_has_droga m1
JOIN medicamento_has_droga m2 ON m1.droga_Id_droga = m2.droga_Id_droga
WHERE m1.Medicamento_Producto_idProducto < m2.Medicamento_Producto_idProducto
GROUP BY m1.Medicamento_Producto_idProducto, m2.Medicamento_Producto_idProducto
HAVING COUNT(*) = (
    SELECT COUNT(*)
    FROM medicamento_has_droga m3
    WHERE m3.Medicamento_Producto_idProducto = m1.Medicamento_Producto_idProducto
)
AND COUNT(*) = (
    SELECT COUNT(*)
    FROM medicamento_has_droga m4
    WHERE m4.Medicamento_Producto_idProducto = m2.Medicamento_Producto_idProducto
)
AND COUNT(*) = (
    SELECT COUNT(DISTINCT m5.droga_Id_droga)
    FROM medicamento_has_droga m5
    WHERE m5.Medicamento_Producto_idProducto = m1.Medicamento_Producto_idProducto
)
AND COUNT(*) = (
    SELECT COUNT(DISTINCT m6.droga_Id_droga)
    FROM medicamento_has_droga m6
    WHERE m6.Medicamento_Producto_idProducto = m2.Medicamento_Producto_idProducto
))

SELECT P1.Nombre_producto as Medicamento1, P2.Nombre_producto as Medicamento2,
		GROUP_CONCAT(DISTINCT d.Nombre_droga ORDER BY d.Nombre_droga SEPARATOR ', ') AS Drogas
from MedicamentosEquivalentes ME
JOIN Producto P1 on P1.idProducto = ME.Medicamento1 
JOIN Producto P2 on P2.idProducto = ME.Medicamento2
JOIN medicamento_has_droga MHD ON MHD.Medicamento_Producto_idProducto = ME.Medicamento1
JOIN Droga D on D.Id_droga = MHD.droga_Id_droga
GROUP BY P1.Nombre_producto, P2.Nombre_producto