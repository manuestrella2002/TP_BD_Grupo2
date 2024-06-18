-- Indicar si las recetas de los antibióticos y psicotrópicos deben ser: duplicada, duplicada archivada o triplicada
-- Devuelve el id de la receta para antibiótico o psicotrópico y el tipo de réplica de esta misma
SELECT Id_receta, Replica_receta
FROM Receta
WHERE Tipo_tratamiento_receta = 'Antibiotico' OR Tipo_tratamiento_receta = 'Psicotrópico'