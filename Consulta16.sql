-- CONSULTA 16: top empleados --
-- Hallar nombre, DNI y CBU de los empleados que recibieron puntaje 10 en todas las encuestas de satisfacción que en las que fueron calificados

SELECT 	CONCAT(e.Nombre_empleado, " ", e.Apellido_empleado) as Nombre_Empleado,
		e.DNI_Empleado, 
		e.CBU_Empleado
FROM Empleado AS e
JOIN Farmacia AS f ON f.Id_farmacia = e.Farmacia_Id_farmacia
WHERE e.DNI_empleado IN (
    SELECT es.Empleado_DNI_empleado
    FROM EncuestaSatisfaccion AS es
    WHERE es.Puntaje = 10
    GROUP BY es.Empleado_DNI_empleado
    HAVING COUNT(*) = ( -- para que el número de encuestas con puntaje 10 sea igual al número total de encuestas realizadas al empleado
        SELECT COUNT(*)
        FROM EncuestaSatisfaccion es2
        WHERE es2.Empleado_DNI_empleado = es.Empleado_DNI_empleado
    )
);
