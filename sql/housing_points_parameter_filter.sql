--The following query ties the Housing points data to the
--Year Range and Building Size parameters, which allows user input 
--to impact what point data is included in the data visualizations.

--borough is aliased explicitly so its column name is lowercase, matching the CD polygon
--source; widget filters with multiple-source scope only reach sources with the same column name.
SELECT
  * EXCEPT(cd, borough),
  borough AS borough, --explicitly alias borough to lowercase to match the CD polygon source
  CAST(cd AS STRING) AS cd,
  CONCAT(
    CASE DIV(CAST(cd AS INT64), 100)
      WHEN 1 THEN 'Manhattan'
      WHEN 2 THEN 'Bronx'
      WHEN 3 THEN 'Brooklyn'
      WHEN 4 THEN 'Queens'
      WHEN 5 THEN 'Staten Island'
    END,
    ' CD ',
    CAST(MOD(CAST(cd AS INT64), 100) AS STRING)
  ) AS cd_name
FROM `carto-qualified-code.shared.housing_archive_points`
WHERE completeyear >= {{start_year}}
  AND completeyear <= {{end_year}}
  AND units >= {{min_units}}
  AND units <= {{max_units}}