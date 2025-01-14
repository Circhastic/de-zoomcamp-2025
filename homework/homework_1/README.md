## Homework 1: Docker, SQL and Terraform for Data Engineering Zoomcamp 2025
### Question 1 - Docker subcommands

Answer: `rm`

### Question 2 - Version of pip
`docker run -it python:3.12.8 bash`

Answer: `24.3.1`

### Question 3 - Count records

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