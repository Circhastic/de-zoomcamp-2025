{{
    config(
        materialized='table'
    )
}}

WITH fhv_tripdata AS (
  SELECT * 
  FROM {{ ref('stg_fhv_tripdata') }}
),

dim_zones AS (
    SELECT * FROM {{ ref('dim_zones') }}
    WHERE borough != 'Unknown'
),

fhv_trips AS (SELECT
  fhv_tripdata.dispatching_base_num,

  fhv_tripdata.pickup_locationid,
  pickup_zone.borough as pickup_borough, 
  pickup_zone.zone as pickup_zone, 
  fhv_tripdata.pickup_datetime,

  fhv_tripdata.dropoff_locationid,
  dropoff_zone.borough as dropoff_borough, 
  dropoff_zone.zone as dropoff_zone,  
  fhv_tripdata.dropoff_datetime,

  fhv_tripdata.sr_flag,
  fhv_tripdata.affiliated_base_number

FROM fhv_tripdata
JOIN dim_zones AS pickup_zone
  ON fhv_tripdata.pickup_locationid = pickup_zone.locationid
JOIN dim_zones AS dropoff_zone
  on fhv_tripdata.dropoff_locationid = dropoff_zone.locationid
)

SELECT
  *,
  EXTRACT(YEAR FROM pickup_datetime) as year,
  EXTRACT(MONTH FROM pickup_datetime) as month
FROM 
  fhv_trips