# Fifty Years of Housing Application
## Description:


## Annual Update Requirements: 
### CARTO

### Update Steps: 
#### Data publishing:
1. In Carto Data Explorer, upload `housing_fifty_years_points.csv`, overwriting the Carto feature of the same name. **NOTE:** Unselect "Auto-define-the schema" and be sure to define the schemas in alignment with the schema descriptions below.
2. Go to the `housing_fifty_years_points` Data Explorer page, and select the option to geocode the table in Carto using latitutde and longitude.
3. Open housing_archive_map in edit mode and select Refresh data sources within the Sources pane.
4. Publish the map updates.

<details>
    <summary>Schema Details</summary>

***housing_fifty_years_points.csv*** (csv input) [Must be geocoded once uploaded to Carto]
|excel field|carto field|type|example|field description|
|-|-|-|-|-|
|UID|uid|string|DCP1011|Unique ID conisisting of {source_agency}_{cd}__{id/jobid}|
|Address|address|string|123 Alphabet Ave|-|
|CompleteYear|completeyear|number (int64)|1972|-|
|Borough|borough|string|Manhattan|-|
|CD|cd|number (int64)|101|-|
|CDName|cdname|string|Financial District-Tribeca|-|
|Units|units|number (int64)|96|-|
|Latitude|latitude|number (float64) -> geocode to geom|40.71|-|
|Longitude|longitude|number (float64) -> geocode to geom|-74.005|-|

***dcp_community_districts*** (zipped shp input)
|carto field|type|example|field description|
|-|-|-|-|
|geom|geometry|Polygon/Multipolygon|-|
|borocd|number (int64)|101|-|
|shape_leng|number (float64)|-|-|
|shape_area|number (float64)|-|-|

</details>

#### Parameters:
- **Year Range**: Update {{start_year}} and {{end_year}} min and max values to capture the full range of the latest dataset
- **Building Size**: Update {{min_units}} and {{max_units}} min and max values to capture the full range of the latest dataset

## Configuration: 
### CARTO
Datasets:
|Name|Type|Source|Notes|
|-|-|-|-|
|housing_fifty_years_points|points|Housing Division (uploaded as csv)|Geocoded in Carto from lat/lon|
|dcp_community_districts|polygon|GIS Team (uploaded)|Version 26B|

Map: 
- Sources:

    |Name|Dataset|Query|Notes|
    |-|-|-|-|
    |community_districts_point_driven|housing_fifty_years_points & dcp_community_districts|[Query Link](/sql/community_districts_driven_by_housing_points.sql)|-|
    |hosuing_points_parameter_filter|housing_fifty_years_points|[Query Link](/sql/housing_points_parameter_filter.sql)|-|
    |Widget - Borough Aggregator|housing_fifty_years_points|[Query Link](/sql/widget_queries.sql)|-|
    |Widget - CD Aggregator|housing_fifty_years_points|[Query Link](/sql/widget_queries.sql)|-|

- Layers
    |Layer Name|Source|Notes|Interaction Settings|Symbology|
    |-|-|-|-|-|
    |Community District Labels|housing_fifty_years_nycd_centroid|drives cd labels|none|transparency: 100%; labels: double, main-borough, secondary, cd_label, size 12, placement centered|
    |Housing|housing_points_parameter_filter|-|Click Pop-up; Light; Fields [address, complete year, units, borough, community district, neighborhood(s)]|TBD|
    |Housing|housing_points_parameter_filter|-|Click Pop-up; Light; Fields [address, complete year, units, borough, community district, neighborhood(s)]|radius driven by units field; 1-20px; color and transparency TBD|
    |Community Districts|community_districts_annual_housing_summary|-|Hover Pop-up; Light; [cd:community district; cdname:name; total_units:total units (format with commas)]|80% Opacity; Zoom Level 0-13|


- Parameters:
    - Year Range slider
        - Numeric > Range slider > Set Min./Max values
        - Scale: Continuous
        - Display name: Time Slider
        - Min SQL name: {{start_year}}
        - Max SQL name: {{end_year}}
    - Building Size slider
        - Numeric > Range slider > Set Min./Max values
        - Scale: Continuous
        - Display name: Building Size slider
        - Min SQL name: {{min_units}}
        - Max SQL name: {{max_units}}
- Widgets
    |Type|Name|[Source](/sql/widget_queries.sql)|Configuration|
    |-|-|-|-|
    |Table|Community District Summary|[community_districts_point_driven](/sql/community_districts_driven_by_housing_points.sql)|[cd_name:community district, total_unit:total units]; collapsible; global|
    |Table|Building Info|[housing_points_parameter_filter](/sql/community_districts_driven_by_housing_points.sql)|[address, borough, cd:community district, cdname:neighborhood(s), complete_year:complete year, units:units]; collapsible; global|
    |Category|Aggregate Units by Borough|[Widget - Borough Aggregator](/sql/widget_queries.sql)|by borough, SUM, aggregated by total_units, formatted as commas, order by values decending, cross filtering: multiple sources, collapsible| 
    |Category|Aggregate Units by CD|[Widget - CD Aggregator]((/sql/widget_queries.sql))|-|


- Interactions
  - Housing (both zoom levels)
    - On-click popup: [address, completeyear:complete year, units, borough, cd, cdname:neighborhood(s)]
  - Community Districts
    - Hover popup: [cd_name:community districts, total_units: total units]