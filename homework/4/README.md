# Homework 4: Analytics Engineering using DBT
https://github.com/DataTalksClub/data-engineering-zoomcamp/blob/main/cohorts/2025/04-analytics-engineering/homework.md

## Question 1: Understanding dbt model resolution
From the `schema: "{{ env_var('DBT_BIGQUERY_SOURCE_DATASET', 'raw_nyc_tripdata') }}"`, it uses "DBT_BIGQUERY_SOURCE_DATASET", instead of the defined environment variable "DBT_BIGQUERY_DATASET", so it uses the fallback value "raw_nyc_tripdata"

Answer: `select * from myproject.raw_nyc_tripdata.ext_green_taxi`

## Question 2: dbt Variables & Dynamic Models
`var()` comes from the cli or can be defined in the `dbt_project.yml`

meanwhile, `env_var()` is in the environment variable of the system.

Answer: `Update the WHERE clause to pickup_datetime >= CURRENT_DATE - INTERVAL '{{ var("days_back", env_var("DAYS_BACK", "30")) }}' DAY`

## Question 3: dbt Data Lineage and Execution
This only materializes everything included in staging and its downstream dependencies (which in this case is up until only `dim_taxi_trips`), and why it would not include `fct_taxi_monthly_zone_revenue`, since it depends only on core models, not from staging.

Answer: `dbt run --select models/staging/+`

## Question 4: dbt Macros and Jinja
Continue this

## Question 5: Taxi Quarterly Revenue Growth

## Question 6: P97/P95/P90 Taxi Monthly Fare

## Question 7: Top #Nth longest P90 travel time Location for FHV