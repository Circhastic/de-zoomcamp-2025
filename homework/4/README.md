# Homework 4: Analytics Engineering using DBT
[Questions](https://github.com/DataTalksClub/data-engineering-zoomcamp/blob/main/cohorts/2025/04-analytics-engineering/homework.md)

## Question 1: Understanding dbt model resolution
From the `schema: "{{ env_var('DBT_BIGQUERY_SOURCE_DATASET', 'raw_nyc_tripdata') }}"`, it uses `DBT_BIGQUERY_SOURCE_DATASET`, instead of the defined environment variable `DBT_BIGQUERY_DATASET`, so it uses the fallback value "raw_nyc_tripdata"

Answer: `select * from myproject.raw_nyc_tripdata.ext_green_taxi`

## Question 2: dbt Variables & Dynamic Models
`var()` comes from the cli or can be defined in the `dbt_project.yml`

meanwhile, `env_var()` is in the environment variable of the system.

Answer: `Update the WHERE clause to pickup_datetime >= CURRENT_DATE - INTERVAL '{{ var("days_back", env_var("DAYS_BACK", "30")) }}' DAY`

## Question 3: dbt Data Lineage and Execution
This only materializes everything included in staging and its downstream dependencies (which in this case is up until only `dim_taxi_trips`), and why it would not include `fct_taxi_monthly_zone_revenue`, since it depends only on core models, not from staging.

Answer: `dbt run --select models/staging/+`

## Question 4: dbt Macros and Jinja

Answers: 
```
- Setting a value for DBT_BIGQUERY_TARGET_DATASET env var is mandatory, or it'll fail to compile
- When using core, it materializes in the dataset defined in DBT_BIGQUERY_TARGET_DATASET
- When using stg, it materializes in the dataset defined in DBT_BIGQUERY_STAGING_DATASET, or defaults to DBT_BIGQUERY_TARGET_DATASET
- When using staging, it materializes in the dataset defined in DBT_BIGQUERY_STAGING_DATASET, or defaults to DBT_BIGQUERY_TARGET_DATASET
```

this is assuming if `DBT_BIGQUERY_TARGET_DATASET` is defined for option 2 and `DBT_BIGQUERY_STAGING_DATASET` is also defined for options 3 & 4, since they essentially fall in the same condition and logic, otherwise would be false.

## Question 5: Taxi Quarterly Revenue Growth

**Using the new dimensions from fact trips, we make a new model:** `fct_trips_quarterly_revenue`
```sql
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
```

For green quarterly revenues:
```sql
SELECT 
  quarter,
  ROUND (((SUM(CASE WHEN year = 2020 THEN total_revenue ELSE 0 END) - 
  SUM(CASE WHEN year = 2019 THEN total_revenue ELSE 0 END)) /
  SUM(CASE WHEN year = 2019 THEN total_revenue ELSE 0 END)) * 100, 2) AS yoy_percent_difference
FROM
  `ny-taxi-rides-447209.de_zoomcamp_dbt.fct_trips_quarterly_revenue`
WHERE
  year IN (2019, 2020)
  AND service_type = 'Green'
GROUP BY
  quarter
ORDER BY
  quarter;
```

Query Output: Q1 Best, Q2 Worst
| Quarter | Value  |
|---------|--------|
| Q1      | -55.96 |
| Q2      | -92.68 |
| Q3      | -86.44 |
| Q4      | -84.25 |


For yellow quarterly revenues:
```sql
SELECT ...
  AND service_type = 'Yellow'
FROM
  `ny-taxi-rides-447209.de_zoomcamp_dbt.fct_trips_quarterly_revenue`
...

```

Query Output: Q1 Best, Q2 Worst
| Quarter | Value  |
|---------|--------|
| Q1      | -20.23 |
| Q2      | -92.23 |
| Q3      | -78.04 |
| Q4      | -70.30 |

Answer: `green: {best: 2020/Q1, worst: 2020/Q2}, yellow: {best: 2020/Q1, worst: 2020/Q2}`

## Question 6: P97/P95/P90 Taxi Monthly Fare
[Using Percentail Cont](https://cloud.google.com/bigquery/docs/reference/standard-sql/navigation_functions#percentile_cont)

```sql
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
```

Query Output:
| service_type | p97  | p95  | p90  |
|-------------|------|------|------|
| Green       | 55.0 | 45.0 | 26.5 |
| Yellow      | 32.0 | 26.0 | 19.5 |

Answer: `green: {p97: 55.0, p95: 45.0, p90: 26.5}, yellow: {p97: 31.5, p95: 25.5, p90: 19.0}`


## Question 7: Top #Nth longest P90 travel time Location for FHV

continue this