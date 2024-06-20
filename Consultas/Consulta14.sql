-- CONSULTA 14: Mejores empleados --
-- Mejores empleados del mes segun las encuestas y por farmacia, el mejor empleado del mes tiene que tener puntaje promedio mayor o igual a 8.

WITH MesActual AS (
    SELECT YEAR(CURDATE()) AS Anio, MONTH(CURDATE()) AS Mes
),
PromedioPuntaje AS (
    SELECT 
        e.Farmacia_Id_farmacia,
        es.Empleado_DNI_empleado,
        AVG(es.Puntaje) AS PromedioPuntaje
    FROM encuestasatisfaccion es
    JOIN empleado e ON es.Empleado_DNI_empleado = e.DNI_empleado
    JOIN MesActual ma ON YEAR(es.Fecha) = ma.Anio AND MONTH(es.Fecha) = ma.Mes
    GROUP BY e.Farmacia_Id_farmacia, es.Empleado_DNI_empleado
),
MejorEmpleadoPorFarmacia AS (
    SELECT
        Farmacia_Id_farmacia,
        Empleado_DNI_empleado,
        PromedioPuntaje,
        RANK() OVER (PARTITION BY Farmacia_Id_farmacia ORDER BY PromedioPuntaje DESC) AS Rango
    FROM PromedioPuntaje
)

SELECT me.Farmacia_Id_farmacia AS Farmacia,
 me.Empleado_DNI_empleado AS DNI_Empleado,
 CONCAT(e.Nombre_empleado, " ", e.Apellido_empleado) AS Nombre_Empleado,
 me.PromedioPuntaje AS Puntaje_Promedio
FROM MejorEmpleadoPorFarmacia AS me
JOIN empleado e ON me.Empleado_DNI_empleado = e.DNI_empleado
WHERE me.Rango = 1 AND me.PromedioPuntaje >= 8
ORDER BY me.PromedioPuntaje DESC;



