--  Farmacias de turno en el día de la fecha en X localidad que tenga X medicamento

select f.Id_farmacia, 
		CONCAT(F.Direccion_calle, " ", CONVERT(F.Direccion_número, CHAR(10)), ", CP ", F.Direccion_codigopostal, ", ", F.Direccion_localidad, ", ", F.Direccion_provincia) as Direccion_Farmacia
from farmacia_de_turno fdt 
join farmacia f on f.Id_farmacia = fdt.Farmacia_Id_farmacia
where f.Direccion_localidad = 'Rafaela' 
	AND DATE(fdt.Fecha_Turno) = CURRENT_DATE
    AND f.Id_farmacia IN (
    SELECT DISTINCT fvm.farmacia_Id_farmacia
    FROM farmacia_vende_medicamento fvm
    JOIN producto p ON p.idProducto = fvm.Medicamento_Producto_idProducto
    WHERE p.Nombre_producto = 'Fluoxetina' and fvm.stock > 0 
)
