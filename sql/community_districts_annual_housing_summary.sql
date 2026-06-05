--The following query ties the Community District polygons 
--to the Year Range parameter which allows user input to impact the data.

SELECT 
  cd,
  cdname,
  borough,
  SUM(completedunits) as total_units,
  ANY_VALUE(geom) as geom
FROM `INSERT_DATASET_NAME.summarized_housing_community_districts`
WHERE year >= {{start_year}}
  AND year <= {{end_year}}
GROUP BY cd, cdname, borough