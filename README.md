# Fifty Years of Housing Application
## Description:


## Annual Update Requirements: 
### CARTO

### Update Steps: 
#### Data publishing:
1. In Carto Data Explorer, upload `housing_fifty_years_community_districts_annual.csv` and `housing_fifty_years_points.csv`, overwriting the Carto features of the same name. **NOTE:** Unselect "Auto-define-the schema" and be sure to define the schemas in alignment with the schema descriptions below.
2. Go to the `housing_fifty_years_points` Data Explorer page, and select the option to geocode the table in Carto using latitutde and longitude.
3. In Carto Workflows, run housing_fifty_years_cd_spatalizer
4. Open housing_fifty_years_map in edit mode and select Refresh data sources within the Sources pane.

<details>
    <summary>Schema Details</summary>

***housing_fifty_years_community_districts_annual*** (csv input)
|excel field|carto field|type|example|field description|
|-|-|-|-|-|
|CDAnnualHousingID|cdannualhousingid|string|101_1972|Unique ID conisting of {cd}_{year}|
|CD|cd|number (int64)|101|Community District number, where the first digit indicates borough. MH=1, BX=2, BK=3, QN=4, SI=5|
|CDName|cdname|string|Financial District-Tribeca|-|
|Borough|borough|string|Manhattan|-|
|Year|year|number (int64)|1972|-|
|CompletedUnits|completedunits|number (int64)|96|-|

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

***housing_fifty_years_community_districts_annual_spatial*** (workflow output)
|carto field|type|example|field description|
|-|-|-|-|
|geom|geometry|multipolygon|-|
|cdannualhousingid|string|101_1972|Unique ID conisting of {cd}_{year}|
|cd|string|101|-|
|cdname|string|Financial District-Tribeca|-|
|borough|string|Manhattan|-|
|year|number (int64)|1972|-|
|completedunits|number (int64)|96|-|

***housing_fifity_years_nycd_centroid*** (workflow output)
|carto field|type|example|field description|
|-|-|-|-|
|geom_centroid|geometry|point|-|
|cd|string|101|-|
</details>

#### Parameters:
- **Year Range**: Update {{start_year}} and {{end_year}} min and max values to capture the full range of the latest dataset
- **Building Size**: Update {{min_units}} and {{max_units}} min and max values to capture the full range of the latest dataset

### ESRI

## Configuration: 
### CARTO
Datasets:
|Name|Type|Source|Notes|
|-|-|-|-|
|housing_fifty_years_points|points|Housing Division (uploaded as csv)|Geocoded in Carto from lat/lon|
|housing_fifty_years_community_districts_annual|csv|Housing Division (uploaded)|-|
|dcp_community_districts|polygon|GIS Team (uploaded)|Version 26B|
|housing_fifty_years_community_districts_spatial|polygon|Workflow output (housing_fifty_years_cd_spatalizer)|Spatial join output of housing_fifty_years_community_districts_annual and nycd|
|housing_fifty_years_nycd_centroid|points|Workflow output (housing_fifty_years_cd_spatalizer)|Serves as labeling asset|

Workflows: 
|Name|Inputs|Outputs|Notes|
|-|-|-|-|
|housing_fifty_years_cd_spatalizer|housing_fifty_years_community_districts_annual; nycd_24a|housing_fifty_years_community_districts_spatial; housing_fifty_years_nycd_centroid|Join and ST_Centroid actions create two seperate outputs|

Map: 
- Sources:

    |Name|Dataset|Query|Notes|
    |-|-|-|-|
    |community_districts_annual_housing_summary|housing_fifty_years_community_districts_annual_spatial|[Query Link](sql\community_districts_annual_housing_summary.sql)|-|
    |hosuing_points_parameter_filter|husing_fifty_years_points|[Query Link](sql\community_districts_driven_by_housing_points.sql)|-|
    |housing_fifty_years_nycd_centroid|housing_fifty_years_nycd_centroid|No Query|-|
    |Widget - Borough Aggregator|housing_fifty_years_community_districts_annual_spatial|[Query Link](sql\widget_queries.sql)|-|
    |Widget - CD Aggregator (Top 10)|housing_fifty_years_community_districts_annual_spatial|[Query Link](sql\widget_queries.sql)|-|
    |Widget - CD Aggregator (Bottom 10)|housing_fifty_years_community_districts_annual_spatial|[Query Link](sql\widget_queries.sql)|-|
    |Widget - CD Aggregator (All)|housing_fifty_years_community_districts_annual_spatial|[Query Link](sql\widget_queries.sql)|-|

- Layers
    |Layer Name|Source|Notes|Interaction Settings|Symbology|
    |-|-|-|-|-|
    |Community Districts|community_districts_annual_housing_summary|-|Hover Pop-up; Light; [cd:community district; cdname:name; total_units:total units (format with commas)]|75% Opacity; Zoom Level 0-12|
    |Community Districts|community_districts_annual_housing_summary|-|Hover Pop-up; Light; [cd:community district; cdname:name; total_units:total units (format with commas)]|30% Opacity; Zoom Level 12-21|
    |Housing Points|housing_points_parameter_filter|-|Click Pop-up; Light; Fields TBD|TBD|
    |Community District Labels|housing_fifty_years_nycd_centroid|drives cd labels|none|TBD|

- Parameters:
    - Year Range
        - Numeric > Range slider > Set Min./Max values
        - Scale: Continuous
        - Display name: Year Range
        - Min SQL name: {{start_year}}
        - Max SQL name: {{end_year}}
    - Building Size
        - Numeric > Range slider > Set Min./Max values
        - Scale: Continuous
        - Display name: Building Size (points only)
        - Min SQL name: {{min_units}}
        - Max SQL name: {{max_units}}
- Widgets
    |Type|Name|[Source](/sql/widget_queries.sql)|Configuration|
    |-|-|-|-|
    |Table|Community District Summary|[community_districts_annual_housing_summary](sql\community_districts_annual_housing_summary.sql)|[cd:community district, cdname:name, borough, total_unit:total units]; collapsible; global|
    |Table|Building Info|[housing_points_parameter_filter](sql\community_districts_driven_by_housing_points.sql)|[address, borough, cd:community district, cdname:name, complete_year:complete year, units:units]; collapsible; global|
    |Pie Chart|Aggregate Units by Borough|Widget - Borough Aggregator|by borough, SUM, aggregated by total_units, formatted as commas, cross filtering: multiple sources|
    |Category|Aggregate Units by Borough|Widget - Borough Aggregator|by borough, SUM, aggregated by total_units, formatted as commas, order by values decending, cross filtering: multiple sources, collapsible| 
    |Category|Top Contributing CDs|Widget - CD Aggregator - Top 10|by cd, SUM, aggregated by total_units, formatted as commas, order by values decending, cross filtering: multiple sources, collapsible|
    |Category|Bottom Contributing CDs|Widget - CD Aggregator - Bottom 10|by cd, SUM, aggregated by total_units, formatted as commas, order by values ascending, cross filtering: multiple sources, collapsible|
    |Category|Aggregate Units by CD|Widget - CD Aggregator - All|-|


- Interactions

