DROP VIEW IF EXISTS `PuntajeProm_Empleados`;
CREATE VIEW `PuntajeProm_Empleados` AS
(
	SELECT 	E.DNI_empleado AS DNI_Empleado,
            CONCAT(E.Nombre_empleado, " ", E.Apellido_empleado) AS Nombre_Empleado,
            E.Farmacia_Id_farmacia AS Farmacia,
            AVG(ES.Puntaje) AS PuntajeProm
	FROM Empleado E
    JOIN EncuestaSatisfaccion ES ON ES.Empleado_DNI_empleado = E.DNI_empleado
    GROUP BY E.DNI_empleado, E.Nombre_empleado, E.Apellido_empleado, E.Farmacia_Id_farmacia
    ORDER BY PuntajeProm DESC
);

DROP VIEW IF EXISTS `PuntajeProm_EmpleadosPerfumería`;
CREATE VIEW `PuntajeProm_EmpleadosPerfumería` AS
(
	SELECT 	PPEP.DNI_Empleado,
			PPEP.Nombre_Empleado,
			PPEP.Farmacia,
            S.Nombre_Sector as Asesora,
			PPEP.PuntajeProm
	FROM (SELECT DNI_Empleado,
				Nombre_Empleado,
				Farmacia,
				PuntajeProm
            FROM PuntajeProm_Empleado PPE
			JOIN empleadoperfumería EP ON PPE.DNI_Empleado = EP.Empleado_DNI_empleado
    ) PPEP
    LEFT OUTER JOIN empleadoperfumería_asesora_sector EPAS ON EPAS.EmpleadoPerfumería_Empleado_DNI_empleado = PPEP.DNI_Empleado
    LEFT OUTER JOIN Sector S ON S.Id_sector = EPAS.Sector_Id_sector
	ORDER BY PPEP.PuntajeProm DESC
);

DROP VIEW IF EXISTS `PuntajeProm_Farmacéuticos`;
CREATE VIEW `PuntajeProm_Farmacéuticos` AS
(
	SELECT 	PPE.DNI_Empleado,
			PPE.Nombre_Empleado,
            CASE 
				WHEN F.Responsable = 1 THEN 'Sí'
				WHEN F.Responsable = 0 THEN 'No'
			END AS Responsable,
			PPE.Farmacia,
			PPE.PuntajeProm
	FROM PuntajeProm_Empleado PPE
	JOIN Farmacéutico F ON PPE.DNI_Empleado = F.Empleado_DNI_empleado
	ORDER BY PPE.PuntajeProm DESC
);

DROP VIEW IF EXISTS `HorasTrabajadas_PorEmpleado`;
CREATE VIEW `HorasTrabajadas_PorEmpleado` AS
(
	SELECT 	E.DNI_empleado AS DNI_Empleado,
            CONCAT(E.Nombre_empleado, " ", E.Apellido_empleado) AS Nombre_Empleado,
            E.Farmacia_Id_farmacia AS Farmacia,
            SUM(T.hora_fin - T.hora_inicio) AS HorasTrabajadas
	FROM Empleado E
    JOIN Turno T ON T.Empleado_DNI_empleado = E.DNI_empleado
    GROUP BY E.DNI_empleado, E.Nombre_empleado, E.Apellido_empleado, E.Farmacia_Id_farmacia
    ORDER BY HorasTrabajadas DESC
);

