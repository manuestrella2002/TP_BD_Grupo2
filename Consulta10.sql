-- Que empleado se encarga del sector de perfumeria que tiene mayor cantidad de articulos con  descuentos por farmacia
WITH sector_mas_descuentos as(
	Select s.Id_sector, COUNT(s.Id_sector) as Cant_art_con_desc from sector as s
    join artículoperfumería as ap on ap.Sector_Id_sector=s.Id_sector
    join descuentopromocional as dp on dp.Producto_idProducto=ap.Producto_idProducto
    group by s.Id_sector
    order by Cant_art_con_desc desc
    limit 1
)


Select s.Nombre_sector AS SECTOR, epas.EmpleadoPerfumería_Empleado_DNI_empleado as DNI_EMPLEADO,f.Id_farmacia AS ID_FARMACIA from empleadoperfumería_asesora_sector as epas 
join sector_mas_descuentos on epas.Sector_Id_sector=sector_mas_descuentos.Id_sector
join sector as s on s.Id_sector=epas.Sector_Id_sector
join empleadoperfumería as ep on ep.Empleado_DNI_empleado= epas.EmpleadoPerfumería_Empleado_DNI_empleado
join empleado as e  on e.DNI_empleado = ep.Empleado_DNI_empleado
join farmacia as f on f.Id_farmacia=e.Farmacia_Id_farmacia
