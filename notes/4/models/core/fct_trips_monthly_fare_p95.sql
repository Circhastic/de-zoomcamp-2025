{{ config(materialized='table') }}

WITH trip_percentiles AS (SELECT
    service_type,
    PERCENTILE_CONT(fare_amount, 0.97) OVER(PARTITION BY service_type, year, month) AS p97,
    PERCENTILE_CONT(fare_amount, 0.95) OVER(PARTITION BY service_type, year, month) AS p95,
    PERCENTILE_CONT(fare_amount, 0.90) OVER(PARTITION BY service_type, year, month) AS p90
  FROM {{ ref('fact_trips') }}
  WHERE
      year = 2020
      AND month = 4
      AND fare_amount > 0
      AND trip_distance > 0
      AND payment_type_description IN ('Cash', 'Credit card'))

SELECT
  service_type,
  ROUND(ANY_VALUE(p97), 2) AS p97,
  ROUND(ANY_VALUE(p95), 2) AS p95,
  ROUND(ANY_VALUE(p90), 2) AS p90
FROM trip_percentiles
GROUP BY service_type
ORDER BY service_type