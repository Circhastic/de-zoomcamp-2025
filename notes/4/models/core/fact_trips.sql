{{
    config(
        materialized='table'
    )
}}

with green_tripdata as (
    select *, 
        'Green' as service_type
    from {{ ref('stg_green_tripdata') }}
), 
yellow_tripdata as (
    select *, 
        'Yellow' as service_type
    from {{ ref('stg_yellow_tripdata') }}
), 
trips_unioned as (
    select * from green_tripdata
    union all 
    select * from yellow_tripdata
), 
dim_zones as (
    select * from {{ ref('dim_zones') }}
    where borough != 'Unknown'
),

all_tripdata as (
    select trips_unioned.tripid, 
        trips_unioned.vendorid, 
        trips_unioned.service_type,
        trips_unioned.ratecodeid, 
        trips_unioned.pickup_locationid, 
        pickup_zone.borough as pickup_borough, 
        pickup_zone.zone as pickup_zone, 
        trips_unioned.dropoff_locationid,
        dropoff_zone.borough as dropoff_borough, 
        dropoff_zone.zone as dropoff_zone,  
        trips_unioned.pickup_datetime, 
        trips_unioned.dropoff_datetime, 
        trips_unioned.store_and_fwd_flag, 
        trips_unioned.passenger_count, 
        trips_unioned.trip_distance, 
        trips_unioned.trip_type, 
        trips_unioned.fare_amount, 
        trips_unioned.extra, 
        trips_unioned.mta_tax, 
        trips_unioned.tip_amount, 
        trips_unioned.tolls_amount, 
        trips_unioned.ehail_fee, 
        trips_unioned.improvement_surcharge, 
        trips_unioned.total_amount, 
        trips_unioned.payment_type, 
        trips_unioned.payment_type_description
    from trips_unioned
    inner join dim_zones as pickup_zone
    on trips_unioned.pickup_locationid = pickup_zone.locationid
    inner join dim_zones as dropoff_zone
    on trips_unioned.dropoff_locationid = dropoff_zone.locationid

    where
        EXTRACT(YEAR FROM pickup_datetime) >= 2019
        AND EXTRACT(YEAR FROM dropoff_datetime) >= 2019
        AND EXTRACT(YEAR FROM pickup_datetime) <= 2020
        AND EXTRACT(YEAR FROM dropoff_datetime) <= 2020
),

extract_date AS (
  SELECT
    *,
    EXTRACT(YEAR FROM pickup_datetime) as year,
    EXTRACT(MONTH FROM pickup_datetime) as month,
    CASE
      WHEN EXTRACT(MONTH FROM pickup_datetime) IN (1, 2, 3) THEN 'Q1'
      WHEN EXTRACT(MONTH FROM pickup_datetime) IN (4, 5, 6) THEN 'Q2'
      WHEN EXTRACT(MONTH FROM pickup_datetime) IN (7, 8, 9) THEN 'Q3'
      WHEN EXTRACT(MONTH FROM pickup_datetime) IN (10, 11, 12) THEN 'Q4'
    END AS quarter
  FROM 
    all_tripdata
)

SELECT
  *,
  CONCAT(year, '/', quarter) AS year_quarter
FROM extract_date