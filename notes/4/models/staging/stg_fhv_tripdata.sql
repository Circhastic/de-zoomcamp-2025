{{ config(materialized='view') }}

-- just filter out the entries where where dispatching_base_num is not null

SELECT
  dispatching_base_num,

  {{ dbt.safe_cast("pulocationid", api.Column.translate_type("integer")) }} as pickup_locationid,
  {{ dbt.safe_cast("dolocationid", api.Column.translate_type("integer")) }} as dropoff_locationid,
  
  -- timestamps
  cast(pickup_datetime as timestamp) as pickup_datetime,
  cast(dropoff_datetime as timestamp) as dropoff_datetime,

  sr_flag,
  affiliated_base_number
FROM {{ source('staging', 'fhv_tripdata') }}
WHERE dispatching_base_num IS NOT NULL

