-- CONSULTA 21: Responsables ahora --
-- Farmacéuticos responsables de turno en este momento

WITH dia_actual AS (
    SELECT 
        CASE LOWER(DAYNAME(NOW()))
            WHEN 'sunday' THEN 'domingo'
            WHEN 'monday' THEN 'lunes'
            WHEN 'tuesday' THEN 'martes'
            WHEN 'wednesday' THEN 'miercoles'
            WHEN 'thursday' THEN 'jueves'
            WHEN 'friday' THEN 'viernes'
            WHEN 'saturday' THEN 'sabado'
        END AS dia_de_semana
)
SELECT e.DNI_empleado, e.Nombre_empleado, e.Apellido_empleado, e.Farmacia_Id_farmacia, t.hora_inicio, t.hora_fin, t.dia_semana
FROM empleado AS e
JOIN farmacéutico AS f ON f.Empleado_DNI_empleado = e.DNI_empleado
JOIN turno AS t ON t.Empleado_DNI_empleado = f.Empleado_DNI_empleado
JOIN dia_actual AS da ON LOWER(da.dia_de_semana) = LOWER(t.dia_semana) -- comparación del día de la semana actual en minúsculas y sin acentos
WHERE f.Responsable = '1' 
	AND LOWER(da.dia_de_semana) = LOWER(t.dia_semana)
	AND CAST(REPLACE(TIME_FORMAT(NOW(), '%H%i'), ':', '') AS UNSIGNED) BETWEEN t.hora_inicio AND t.hora_fin
ORDER BY e.Farmacia_Id_farmacia;