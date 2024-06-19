-- CONSULTA 7: PERFIL ETARIO --  
-- El sector que más compran por rango etario (cada 20 años) y cuánta plata gastan en promedio

WITH Rango_Etario_Sector AS (
-- totales de compras y el gasto promedio por sector y rango etario
    SELECT 
        CASE 
            WHEN TIMESTAMPDIFF(YEAR, cli.Fecha_nacimiento, CURDATE()) BETWEEN 0 AND 19 THEN '0-19'
            WHEN TIMESTAMPDIFF(YEAR, cli.Fecha_nacimiento, CURDATE()) BETWEEN 20 AND 39 THEN '20-39'
            WHEN TIMESTAMPDIFF(YEAR, cli.Fecha_nacimiento, CURDATE()) BETWEEN 40 AND 59 THEN '40-59'
            ELSE '60+'
        END AS Rango_Etario,
        AP.Sector_Id_sector,
        COUNT(*) AS Total_Compras,
        AVG(CHP.PrecioUnitario * CHP.Cantidad * (1 - CHP.Descuento / 100)) AS Gasto_Promedio
    FROM Compra Com
    JOIN Compra_has_Producto CHP ON Com.idCompra = CHP.Compra_idCompra
    JOIN ArtículoPerfumería AP ON CHP.Producto_idProducto = AP.Producto_idProducto
    JOIN Cliente Cli ON Com.Cliente_DNI_cliente = Cli.DNI_cliente
    GROUP BY Rango_Etario, AP.Sector_Id_sector
),
Ranked_Sectors AS (
-- para asignar un número de fila a cada combinación de rango etario y sector
    SELECT 
        Rango_Etario,
        Sector_Id_sector,
        Total_Compras,
        ROUND(Gasto_Promedio, 2) AS Gasto_Promedio,
        ROW_NUMBER() OVER (PARTITION BY Rango_Etario ORDER BY Total_Compras DESC) AS rn -- número de fila ordenado por total de compras en cada grupo de rango etario
    FROM Rango_Etario_Sector
)
SELECT 
    RS.Rango_Etario,
    S.Nombre_sector AS Nombre_Sector,
    RS.Total_Compras,
    RS.Gasto_Promedio
FROM Ranked_Sectors RS
JOIN Sector S ON rs.Sector_Id_sector = S.Id_sector
WHERE RS.rn = 1 -- para obtener solo la fila con el mayor número de compras por rango etario
ORDER BY RS.Rango_Etario;
