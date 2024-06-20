DROP VIEW IF EXISTS `Medicos_PAMI`;
CREATE VIEW `Medicos_PAMI` AS
(
	SELECT 	M.Num_matrícula,
			CONCAT(M.Nombre_médico, " ", M.Apellido_médico) AS Nombre_Medico
	FROM Médico M
    JOIN PAMI P ON P.ObraSocial_Id_obra_social = M.PAMI_ObraSocial_Id_obra_social
    ORDER BY M.Num_matrícula ASC
);