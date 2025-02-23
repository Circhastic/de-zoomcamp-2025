{{
    config(
        materialized='table'
    )
}}

SELECT
  service_type,
  year_quarter,
  quarter,
  year,
  SUM(total_amount) AS total_revenue
FROM {{ ref('fact_trips') }}
GROUP BY
  service_type,
  year_quarter,
  quarter,
  year
ORDER BY
  service_type,
  year_quarter