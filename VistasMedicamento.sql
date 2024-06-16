DROP VIEW IF EXISTS `Medicamentos_Disponibles`;
CREATE VIEW `Medicamentos_Disponibles` AS
( -- en todas las farmacias
	SELECT 	P.idProducto as Id_Medicamento, 
            P.Nombre_Producto as Medicamento, 
            L.Nombre_Laboratorio as Laboratorio, 
            CASE 
				WHEN M.Venta_libre_medicamento = 1 THEN 'Sí'
				WHEN M.Venta_libre_medicamento = 0 THEN 'No'
			END AS Venta_libre,
            SUM(FVM.Stock) as Stock
    FROM Producto P
    JOIN Medicamento M ON M.Producto_idProducto = P.idProducto
    JOIN laboratorio L ON L.Id_Laboratorio = M.Laboratorio_Id_Laboratorio
    JOIN Farmacia_Vende_Medicamento FVM ON FVM.Medicamento_Producto_idProducto = M.Producto_idProducto
    WHERE FVM.Stock > 0
	GROUP BY P.idProducto, P.Nombre_Producto, L.Nombre_Laboratorio, M.Venta_libre_medicamento
    ORDER BY P.idProducto ASC
);

DROP VIEW IF EXISTS `Medicamentos_Disponibles_PorFarmacia`;
CREATE VIEW `Medicamentos_Disponibles_PorFarmacia` AS
( -- stock por farmacia de los medicamentos disponibles 
	SELECT 	FVM.farmacia_Id_farmacia as Id_Farmacia, 
			CONCAT(F.Direccion_calle, " ", CONVERT(F.Direccion_número, CHAR(10)), ", CP ", F.Direccion_codigopostal, ", ", F.Direccion_localidad, ", ", F.Direccion_provincia) as Direccion_Farmacia,
			P.idProducto as Id_Medicamento, 
            P.Nombre_Producto as Medicamento, 
            L.Nombre_Laboratorio as Laboratorio, 
            CASE 
				WHEN M.Venta_libre_medicamento = 1 THEN 'Sí'
				WHEN M.Venta_libre_medicamento = 0 THEN 'No'
			END AS Venta_libre,
            FVM.Stock
    FROM Producto P
    JOIN Medicamento M ON M.Producto_idProducto = P.idProducto
    JOIN laboratorio L ON L.Id_Laboratorio = M.Laboratorio_Id_Laboratorio
    JOIN Farmacia_Vende_Medicamento FVM ON FVM.Medicamento_Producto_idProducto = M.Producto_idProducto
	JOIN Farmacia F ON F.Id_farmacia = FVM.farmacia_Id_farmacia
    WHERE FVM.Stock > 0
    ORDER BY FVM.farmacia_Id_farmacia ASC, P.idProducto ASC
);

DROP VIEW IF EXISTS `Medicamentos_ParaReponer_PorFarmacia`;
CREATE VIEW `Medicamentos_ParaReponer_PorFarmacia` AS
( -- reposición cuando stock < 5
	SELECT 	FVM.farmacia_Id_farmacia as Id_Farmacia, 
			CONCAT(F.Direccion_calle, " ", CONVERT(F.Direccion_número, CHAR(10)), ", CP ", F.Direccion_codigopostal, ", ", F.Direccion_localidad, ", ", F.Direccion_provincia) as Direccion_Farmacia,
			P.idProducto as Id_Medicamento, 
            P.Nombre_Producto as Medicamento, 
            L.Nombre_Laboratorio as Laboratorio, 
            FVM.Stock
    FROM Producto P
    JOIN Medicamento M ON M.Producto_idProducto = P.idProducto
    JOIN Laboratorio L ON L.Id_Laboratorio = M.Laboratorio_Id_Laboratorio
    JOIN Farmacia_Vende_Medicamento FVM ON FVM.Medicamento_Producto_idProducto = M.Producto_idProducto
    JOIN Farmacia F ON F.Id_farmacia = FVM.farmacia_Id_farmacia
    WHERE FVM.Stock < 5
    ORDER BY FVM.farmacia_Id_farmacia ASC, FVM.Stock ASC
);

DROP VIEW IF EXISTS `Laboratorios_ParaContactar`;
CREATE VIEW `Laboratorios_ParaContactar` AS
( -- laboratorios que proveen alguno de los medicamentos que necesitan reposición
    SELECT 	L.Nombre_Laboratorio,
			L.Telefono_laboratorio,
			GROUP_CONCAT(DISTINCT MR.Medicamento ORDER BY MR.Medicamento ASC SEPARATOR ', ') AS Medicamentos_para_reponer
    FROM (
        SELECT DISTINCT 
            MP.Id_Farmacia,
            MP.Medicamento,
            MP.Laboratorio
        FROM Medicamentos_ParaReponer_PorFarmacia MP
    ) MR
    JOIN Laboratorio L ON L.Nombre_Laboratorio = MR.Laboratorio
    GROUP BY L.Nombre_Laboratorio, L.Telefono_laboratorio
    ORDER BY L.Nombre_Laboratorio ASC
);

DROP VIEW IF EXISTS `Lotes_PorVencer`;
CREATE VIEW `Lotes_PorVencer` AS
(
    SELECT
        L.Id_lote,
        P.Nombre_Producto as Medicamento,
        DATE(L.Fecha_vencimiento_lote) as Fecha_Vencimiento
    FROM Lote L
    JOIN Producto P ON P.IdProducto = L.Medicamento_Producto_idProducto
    WHERE L.Fecha_vencimiento_lote <= DATE_ADD(CURDATE(), INTERVAL 2 MONTH)
    ORDER BY L.Fecha_vencimiento_lote ASC
);