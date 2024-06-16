DROP VIEW IF EXISTS `Articulos_Disponibles`;
CREATE VIEW `Articulos_Disponibles` AS
( -- en todas las farmacias
	SELECT 	P.idProducto as Id_Articulo, 
            P.Nombre_Producto as Articulo_Perfumeria, 
            S.Nombre_sector as Sector, 
            SUM(FVAP.Stock) as Stock
    FROM Producto P
    JOIN ArtículoPerfumería AP ON AP.Producto_idProducto = P.idProducto
    JOIN Farmacia_Vende_ArtículoPerfumería FVAP ON FVAP.ArtículoPerfumería_Producto_idProducto = AP.Producto_idProducto
    JOIN Sector S ON S.Id_Sector = AP.Sector_Id_Sector
    WHERE FVAP.Stock > 0
	GROUP BY P.idProducto, P.Nombre_Producto, S.Nombre_sector
    ORDER BY S.Nombre_sector ASC, P.idProducto ASC
);

DROP VIEW IF EXISTS `Articulos_Disponibles_PorFarmacia`;
CREATE VIEW `Articulos_Disponibles_PorFarmacia` AS
( -- stock por farmacia de los artículos disponibles 
	SELECT 	FVAP.farmacia_Id_farmacia as Id_Farmacia, 
			CONCAT(F.Direccion_calle, " ", CONVERT(F.Direccion_número, CHAR(10)), ", CP ", F.Direccion_codigopostal, ", ", F.Direccion_localidad, ", ", F.Direccion_provincia) as Direccion_Farmacia,
			P.idProducto as Id_Articulo, 
            P.Nombre_Producto as Articulo_Perfumeria, 
            S.Nombre_sector as Sector, 
            FVAP.Stock
    FROM Producto P
    JOIN ArtículoPerfumería AP ON AP.Producto_idProducto = P.idProducto
    JOIN Sector S ON S.Id_Sector = AP.Sector_Id_Sector
    JOIN Farmacia_Vende_ArtículoPerfumería FVAP ON FVAP.ArtículoPerfumería_Producto_idProducto = AP.Producto_idProducto
	JOIN Farmacia F ON F.Id_farmacia = FVAP.farmacia_Id_farmacia
    WHERE FVAP.Stock > 0
    ORDER BY FVAP.farmacia_Id_farmacia ASC, S.Nombre_sector ASC, P.idProducto ASC
);

DROP VIEW IF EXISTS `Articulos_ParaReponer_PorFarmacia`;
CREATE VIEW `Articulos_ParaReponer_PorFarmacia` AS
( -- reposición cuando stock < 50
	SELECT 	FVAP.farmacia_Id_farmacia as Id_Farmacia, 
			CONCAT(F.Direccion_calle, " ", CONVERT(F.Direccion_número, CHAR(10)), ", CP ", F.Direccion_codigopostal, ", ", F.Direccion_localidad, ", ", F.Direccion_provincia) as Direccion_Farmacia,
			P.idProducto as Id_Articulo, 
            P.Nombre_Producto as Articulo_Perfumeria, 
            S.Nombre_sector as Sector, 
            AP.ProveedorPerfumería_Id_proveedor as Id_Proveedor,
            FVAP.Stock
    FROM Producto P
	JOIN ArtículoPerfumería AP ON AP.Producto_idProducto = P.idProducto
    JOIN Sector S ON S.Id_Sector = AP.Sector_Id_Sector
    JOIN Farmacia_Vende_ArtículoPerfumería FVAP ON FVAP.ArtículoPerfumería_Producto_idProducto = AP.Producto_idProducto
	JOIN Farmacia F ON F.Id_farmacia = FVAP.farmacia_Id_farmacia
    WHERE FVAP.Stock < 50
    ORDER BY FVAP.farmacia_Id_farmacia ASC, FVAP.Stock ASC
);

DROP VIEW IF EXISTS `Proveedores_ParaContactar`;
CREATE VIEW `Proveedores_ParaContactar` AS
( -- proveedores que proveen alguno de los articulos que necesitan reposición
    SELECT 
        P.Nombre_proveedor,
        P.Telefono_proveedor,
        GROUP_CONCAT(DISTINCT PR.Articulo_Perfumeria ORDER BY PR.Articulo_Perfumeria ASC SEPARATOR ', ') AS Articulos_para_reponer
    FROM (
        SELECT DISTINCT 
            PR.Id_Farmacia,
            PR.Articulo_Perfumeria,
            PR.Id_Proveedor
        FROM Articulos_ParaReponer_PorFarmacia PR
    ) PR
    JOIN ProveedorPerfumería P ON P.Id_proveedor = PR.Id_Proveedor
    GROUP BY P.Nombre_proveedor, P.Telefono_proveedor
    ORDER BY P.Nombre_proveedor ASC
);