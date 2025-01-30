## Homework 1: Docker, SQL and Terraform
### Question 1 - Understanding Docker first run

```bash
docker run -it python:3.12.8 bash
pip list
```

Answer: `24.3.1`

### Question 2 - Understanding Docker networking and docker-compose
Hostname is db as defined in the yml (not localhost) because docker uses the service names as hostnames, and the port to use is 5432, not 5433 (local docker port mapping?), for pgadmin connection since both containers exist on the same virtual network.

Answer: `db:5432`

### Preparing Postgres
[Data Dictionary](https://www.nyc.gov/assets/tlc/downloads/pdf/data_dictionary_trip_records_green.pdf)

```bash
docker build -t taxi_ingest:2 .

docker run -it \
	--network=homework_1_default \
	--name=green-taxi-ingestion-script \
	taxi_ingest:2 \
		--user=root \
		--password=root \
		--host=homework_1-pgdatabase-1 \
		--port=5432 \
		--db=ny_green_taxi \
		--table_name=green_taxi_trips \
		--table_name_lookup=nyc_taxi_lookup
```

### Question 3 - Trip segementation count
```sql
SELECT
    COUNT(CASE 
        WHEN trip_distance <= 1 THEN 1 
    END) AS trips_1,
    COUNT(CASE 
        WHEN trip_distance > 1 AND trip_distance <= 3 THEN 1 
    END) AS trips_1_to_3,
    COUNT(CASE 
        WHEN trip_distance > 3 AND trip_distance <= 7 THEN 1 
    END) AS trips_3_to_7,
    COUNT(CASE 
        WHEN trip_distance > 7 AND trip_distance <= 10 THEN 1 
    END) AS trips_7_to_10,
    COUNT(CASE 
        WHEN trip_distance > 10 THEN 1 
    END) AS trips_10_plus
FROM 
    green_taxi_trips
WHERE 
    lpep_pickup_datetime >= '2019-10-01'
    AND lpep_pickup_datetime < '2019-11-01';
```

Answer: `104,838; 199,013; 109,645; 27,688; 35,202`

**Correct Answer:** `104,802; 198,924; 109,603; 27,678; 35,189`

Note the term *"trips happened"*

```sql
SELECT
    ...
WHERE 
    lpep_pickup_datetime >= '2019-10-01'
    AND lpep_pickup_datetime < '2019-11-01'
    AND lpep_dropoff_datetime >= '2019-10-01'
    AND lpep_dropoff_datetime < '2019-11-01';
```

### Question 4 - Longest trip for each day
```sql
SELECT
	lpep_pickup_datetime::date, trip_distance 
FROM
	green_taxi_trips
ORDER BY
	trip_distance DESC
LIMIT 1;
```

Answer: `2019-10-31`

### Question 5 - Three biggest pickup zones
```sql
SELECT
	n."Zone",
	SUM(g.total_amount) AS total_amount
FROM
	green_taxi_trips g
JOIN
	nyc_taxi_lookup n
	ON g."PULocationID" = n."LocationID"
WHERE
	DATE(lpep_pickup_datetime) = '2019-10-18'
GROUP BY
	n."Zone"
ORDER BY
	total_amount DESC
LIMIT 3;
```
Answer: `East Harlem North, East Harlem South, Morningside Heights`

### Question 6 - Largest tip
```sql
SELECT
    pu_zone."Zone" AS pickup_zone,
    do_zone."Zone" AS dropoff_zone,
    g.tip_amount,
    g."DOLocationID"
FROM
    green_taxi_trips g
JOIN
    nyc_taxi_lookup pu_zone
    ON g."PULocationID" = pu_zone."LocationID"
JOIN
    nyc_taxi_lookup do_zone
    ON g."DOLocationID" = do_zone."LocationID"
WHERE
    EXTRACT(MONTH FROM lpep_pickup_datetime::date) = 10
    AND EXTRACT(YEAR FROM lpep_pickup_datetime::date) = 2019
    AND pu_zone."Zone" = 'East Harlem North'
ORDER BY
    g.tip_amount DESC
LIMIT 1;
```

Answer: `JFK Airport`

### Question 7 - Terraform Workflow
I just used the terraform config from my notes to practice and got the answers there.

Answer: `terraform init, terraform apply -auto-approve, terraform destroy`
