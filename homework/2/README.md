## Homework 2: Kestra Worflow Orchestration
[Questions](https://github.com/DataTalksClub/data-engineering-zoomcamp/blob/main/cohorts/2025/02-workflow-orchestration/homework.md)

### Question 1
Within the execution for Yellow Taxi data for the year 2020 and month 12: what is the uncompressed file size (i.e. the output file yellow_tripdata_2020-12.csv of the extract task)?

Answer: `128.3 MB`

### Question 2
What is the value of the variable file when the inputs taxi is set to green, year is set to 2020, and month is set to 04 during execution?

Answer: `green_tripdata_2020-04.csv`

### Question 3
How many rows are there for the Yellow Taxi data for all CSV files in the year 2020?

```sql
SELECT 
  COUNT(*) 
FROM
  `ny-taxi-rides-447209.de_zoomcamp.yellow_tripdata`
WHERE 
  EXTRACT(YEAR FROM tpep_pickup_datetime) = 2020
  AND EXTRACT(YEAR FROM tpep_dropoff_datetime) = 2020;
```

Answer: `24,648,499`

### Question 4
How many rows are there for the Green Taxi data for all CSV files in the year 2020?

```sql
SELECT 
  COUNT(*) 
FROM
  `ny-taxi-rides-447209.de_zoomcamp.green_tripdata`
WHERE 
  EXTRACT(YEAR FROM lpep_pickup_datetime) = 2020
  AND EXTRACT(YEAR FROM lpep_dropoff_datetime) = 2020;
```

Answer: `1,734,051`

### Question 5
How many rows are there for the Yellow Taxi data for the March 2021 CSV file?

```sql
SELECT 
  COUNT(*) 
FROM
  `ny-taxi-rides-447209.de_zoomcamp.yellow_tripdata`
WHERE 
  EXTRACT(YEAR FROM tpep_pickup_datetime) = 2021
  AND EXTRACT(MONTH FROM tpep_pickup_datetime) = 03;
```

Answer: `1,925,152`

### Question 6
How would you configure the timezone to New York in a Schedule trigger?

[List of Timezones](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#List)

Answer: `Add a timezone property set to UTC-5 in the Schedule trigger configuration`