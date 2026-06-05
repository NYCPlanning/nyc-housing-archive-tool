-- Aggregate Units by Borough (Name: Widget - Borough Aggregaotor)
SELECT 
  borough,
  SUM(completedunits) as total_units
FROM `INSERT_DATASET_NAME.summarized_housing_community_districts`
WHERE year >= {{start_year}}
  AND year <= {{end_year}}
GROUP BY borough
ORDER BY total_units DESC

--Aggregate Units by Community District (Top 10) (Name: Widget - CD Aggregator - Top 10)
SELECT 
  cd,
  SUM(completedunits) as total_units
FROM `INSERT_DATASET_NAME.summarized_housing_community_districts`
WHERE year >= {{start_year}}
  AND year <= {{end_year}}
GROUP BY cd
ORDER BY total_units DESC
LIMIT 10

--Aggregate Units by Community District (Bottom 10) (Name: Widget - CD Aggregator - Bottom 10)
SELECT 
  cd,
  SUM(completedunits) as total_units
FROM `INSERT_DATASET_NAME.summarized_housing_community_districts`
WHERE year >= {{start_year}}
  AND year <= {{end_year}}
GROUP BY cd
ORDER BY total_units
LIMIT 10

--Aggregate Units by Community District (Name: Widget - CD Aggregator - All)
SELECT 
  cd,
  SUM(completedunits) as total_units
FROM `INSERT_DATASET_NAME.summarized_housing_community_districts`
WHERE year >= {{start_year}}
  AND year <= {{end_year}}
GROUP BY cd
ORDER BY total_units DESC