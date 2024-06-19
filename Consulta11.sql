-- Cuál es la matricula del farmacéutico que atiende la farmacia que recibe más lotes de Ibuprofeno del laboratorio Dietrich, Ondricka and Harris?
-- Encuentra los id de laboratorios que vendan Ibuprofeno y el id del medicamento

WITH IbuprofenoBayer AS (
    SELECT m.Laboratorio_Id_Laboratorio, m.Producto_idProducto
    FROM Medicamento AS m
    JOIN Producto AS p ON p.idProducto = m.Producto_idProducto
    WHERE p.Nombre_producto = 'Ibuprofeno'
),
LaboratoriosBayer AS (
    SELECT l.Id_Laboratorio
    FROM Laboratorio AS l
    WHERE l.Nombre_Laboratorio LIKE '%Dietrich, Ondricka and Harris'
),
FarmaciasConIbuprofeno AS (
    SELECT fvm.farmacia_Id_farmacia
    FROM Farmacia_vende_Medicamento AS fvm
    JOIN IbuprofenoBayer AS ib ON fvm.Medicamento_Producto_idProducto = ib.Producto_idProducto
    JOIN LaboratoriosBayer AS lb ON ib.Laboratorio_Id_Laboratorio = lb.Id_Laboratorio
    GROUP BY fvm.farmacia_Id_farmacia
    ORDER BY COUNT(*) DESC
    LIMIT 1
)
SELECT f.Matrícula_nacional
FROM Farmacéutico AS f
JOIN Empleado AS e ON f.Empleado_DNI_empleado = e.DNI_empleado
JOIN FarmaciasConIbuprofeno AS fc ON e.Farmacia_Id_farmacia = fc.farmacia_Id_farmacia;

