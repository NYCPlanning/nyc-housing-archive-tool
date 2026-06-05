--The following query creates a Community District summary table directly from the housing point data.
--The data is tied to the Year Range and Building Size parameters, which allows user input 
--to impact what point data is included in the data visualizations.

SELECT 
  cd.borocd,
  CAST(COALESCE(SUM(points.units), 0) AS INT64) as total_units,
  ANY_VALUE(cd.geom) as geom
FROM `INSERT_DATASET_NAME.community_districts` cd
LEFT JOIN `INSERT_DATASET_NAME.housing_points` points
  ON ST_CONTAINS(cd.geom, points.geom)
  AND points.completeyear >= {{start_year}}
  AND points.completeyear <= {{end_year}}
  AND points.units >= {{min_units}}
  AND points.units <= {{max_units}}
GROUP BY cd.borocd