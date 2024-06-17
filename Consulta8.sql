-- Cuál es la droga que se encuentra en mayor dosis en los medicamentos recetados por medicos traumatologos cabecera de PAMI a mujeres de 45 a 60 años

SELECT 	d.Nombre_droga as Droga, 
		MAX(md.dosis) as Dosis
FROM droga as d
JOIN medicamento_has_droga as md on md.droga_Id_droga = d.Id_droga
JOIN receta_has_medicamento as rm on rm.Medicamento_Producto_idProducto= md.Medicamento_Producto_idProducto
JOIN receta as r on r.Id_receta = rm.receta_Id_receta  
JOIN cliente as c on c.DNI_cliente = r.cliente_DNI_cliente
JOIN médico as m on m.Num_matrícula= r.Médico_numMatrícula
JOIN pami as p on p.ObraSocial_Id_obra_social = m.PAMI_ObraSocial_Id_obra_social
JOIN médico_has_especialidad as ms on r.Médico_numMatrícula= ms.Médico_Num_matrícula
JOIN especialidad as e on e.Id_especialidad= ms.Especialidad_Id_especialidad 
where e.Nombre_especialidad= 'Traumatologia y Ortopedia' 
	and (TIMESTAMPDIFF(YEAR, c.Fecha_nacimiento, CURDATE()) between 45 AND 60) 
    and c.genero= 'F'
GROUP by d.Nombre_droga
ORDER by d.Nombre_droga
LIMIT 1;
