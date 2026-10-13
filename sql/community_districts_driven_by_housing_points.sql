--The following query creates a Community District summary table directly from the housing point data.
--The data is tied to the Year Range and Building Size parameters, which allows user input 
--to impact what point data is included in the data visualizations.

SELECT 
  nycd.borocd,
  CAST(nycd.borocd AS STRING) as cd,
  nycd.borough,
  CONCAT(nycd.borough, ' CD ', CAST(MOD(nycd.borocd, 100) AS STRING)) as cd_name,
  CAST(ROUND(COALESCE(SUM(points.units), 0), -2) AS INT64) as total_units,
  ANY_VALUE(nycd.geom) as geom
FROM (
  SELECT
    borocd,
    geom,
    CASE DIV(borocd, 100)
      WHEN 1 THEN 'Manhattan'
      WHEN 2 THEN 'Bronx'
      WHEN 3 THEN 'Brooklyn'
      WHEN 4 THEN 'Queens'
      WHEN 5 THEN 'Staten Island'
    END as borough
  FROM `carto-qualified-code.shared.dcp_community_districts`
  --Exclude Joint Interest Areas (large parks, airports, etc., e.g. 164 Central Park, 355 Prospect Park, 480 LaGuardia).
  --Per DCP metadata, actual community districts are numbered 1-18 within each borough; JIAs use higher district numbers.
  WHERE MOD(borocd, 100) <= 18
) nycd
LEFT JOIN `carto-qualified-code.shared.housing_archive_points` points
  ON ST_CONTAINS(nycd.geom, points.geom)
  AND points.completeyear >= {{start_year}}
  AND points.completeyear <= {{end_year}}
  AND points.units >= {{min_units}}
  AND points.units <= {{max_units}}
GROUP BY nycd.borocd, nycd.borough