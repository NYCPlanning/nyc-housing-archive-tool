--The following query ties the Housing points data to the
--Year Range and Building Size parameters, which allows user input 
--to impact what point data is included in the data visualizations.


SELECT *
FROM `INSERT_DATASET_NAME.housing_points`
WHERE completeyear >= {{start_year}}
  AND completeyear <= {{end_year}}
  AND units >= {{min_units}}
  AND units <= {{max_units}}