-- Aggregate Units by Borough (Name: Widget - Aggregate Units by Borough)
SELECT 
  borough,
  SUM(units) as total_units
FROM `carto-qualified-code.shared.housing_archive_points`
WHERE completeyear >= {{start_year}}
  AND completeyear <= {{end_year}}
  AND units >= {{min_units}}
  AND units <= {{max_units}}
GROUP BY borough
ORDER BY total_units DESC


--Aggregate Units by Community District (Name: Widget - Aggregate Units by CD)
SELECT
  CONCAT(borough, ' CD ', CAST(MOD(cd_num, 100) AS STRING)) AS cd_name,
  borough,
  SUM(units) AS total_units
FROM (
  SELECT
    CAST(cd AS INT64) AS cd_num,
    CASE DIV(CAST(cd AS INT64), 100)
      WHEN 1 THEN 'Manhattan'
      WHEN 2 THEN 'Bronx'
      WHEN 3 THEN 'Brooklyn'
      WHEN 4 THEN 'Queens'
      WHEN 5 THEN 'Staten Island'
    END AS borough,
    units
  FROM `carto-qualified-code.shared.housing_archive_points`
  WHERE completeyear >= {{start_year}}
    AND completeyear <= {{end_year}}
    AND units >= {{min_units}}
    AND units <= {{max_units}}
)
GROUP BY cd_name, borough
ORDER BY total_units DESC