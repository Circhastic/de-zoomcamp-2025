## Homework 1: Docker, SQL and Terraform for Data Engineering Zoomcamp 2025
### Question 1 - Understanding Docker first run

Answer: `24.3.1`

### Question 2 - Understanding Docker networking and docker-compose

Answer: `db:5432`

### Preparing Postgres
```bash
docker build -t taxi_ingest:2 .
URL='https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/green_tripdata_2019-10.csv.gz'

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
		--url=${URL}
```

### Question 3 - Trip segemntation count
```sql
hey man
```

Answer: `In Progress`

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

### Question 6 - Largest tip
need taxi lookup table for this

### Question 7 - Terraform Workflow