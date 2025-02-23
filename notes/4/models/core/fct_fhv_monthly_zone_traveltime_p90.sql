{{ config(materialized='table') }}

WITH trips_duration AS (SELECT
  pickup_locationid,
  pickup_zone,
  dropoff_locationid,
  dropoff_zone,
  year,
  month,
  TIMESTAMP_DIFF(dropoff_datetime, pickup_datetime, SECOND) AS trip_duration
FROM
  {{ ref('dim_fhv_trips') }}
),

p90_duration AS (
    SELECT
    pickup_zone,
    dropoff_zone,
    PERCENTILE_CONT(trip_duration, 0.9) OVER(PARTITION BY year, month, pickup_locationid, dropoff_locationid) AS p90
  FROM trips_duration
  WHERE
    year = 2019
    AND month = 11
    AND pickup_zone IN ('Newark Airport', 'SoHo', 'Yorkville East')
  ORDER BY
    pickup_zone,
    p90 DESC
),

deduplicated_p90_duration AS (
  SELECT
    pickup_zone,
    dropoff_zone,
    ANY_VALUE(p90) AS p90,
    RANK() OVER(PARTITION BY pickup_zone ORDER BY ANY_VALUE(p90) DESC) AS p90_rank
  FROM
    p90_duration
  GROUP BY
    pickup_zone,
    dropoff_zone
  ORDER BY
    pickup_zone,
    p90_rank
)

SELECT
  pickup_zone,
  dropoff_zone,
  p90
FROM deduplicated_p90_duration
WHERE p90_rank = 2