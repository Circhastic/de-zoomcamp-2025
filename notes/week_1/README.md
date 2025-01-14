## Week 1 Notes : PostgreSQL, GCP, Docker Containerization, Terraform

### Exploring NY Taxi Data

Create a docker container for our database.
```bash
docker run -it \
  -e POSTGRES_USER="root" \
  -e POSTGRES_PASSWORD="root" \
  -e POSTGRES_DB="ny_taxi" \
  -v $(pwd)/ny_taxi_postgres_data:/var/lib/postgresql/data \
  -p 5431:5432 \
  --network=pg-network \
  --name=pg-database \
  postgres:13
```

> [!NOTE]
> If your container is already running, you can use `docker stop container_id/name` **to stop** the container from running. You could also **delete containers** using `docker rm cont_id/name`.


Use this pgcli command to interact with the database 
```bash
pgcli -h localhost -p 5431 -U root -d ny_taxi
```

Get sample data from here: [NYC Data Source](https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page) 
*(since these are parquet, DTC provided an alternative link, see terminal command below)*
```bash
wget https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2021-01.csv.gz
```
Then do `gzip -d yellow_tripdata_2021-01.csv.gz ` to unzip the csv.

Once your initial code is done, in terminal you can convert your notebook to a script using:
```bash
jupyter nbconvert --to=script upload-data.ipynb
```

Test your python script locally
```bash
URL='https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2021-01.csv.gz'

python ingest-data.py \
	--user=root \
	--password=root \
	--host=localhost \
	--port=5431 \
	--db=ny_taxi \
	--table_name=yellow_taxi_trips \
	--url=${URL}
```

### Dockerizing Ingestion Script

Dockerize your python script
```bash
docker build -t taxi_ingest:1 .
```
Then run the container you built

> [!NOTE]
> *The host and port database here (previously localhost) was changed to connect to the dockerized sql container's name*

```bash
URL='https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2021-01.csv.gz'

docker run -it \
	--network=week_1_default \
	--name=taxi-ingestion-script \
	taxi_ingest:1 \
		--user=root \
		--password=root \
		--host=pg-database \ # adjust as needed
		--port=5431 \ # adjust as needed
		--db=ny_taxi \
		--table_name=yellow_taxi_trips \
		--url=${URL}
```

### Setting Up Terraform with GCP
Create a service account in **Service Accounts** tab with the ff permissions:
- Compute Engine - Admin
- BigQuery - Admin
- Cloud Storage - Admin

> **Note**: You can edit these account roles in the IAM tab.

Go back to **Service Accounts** and click the ellipse > **Create New Key** to create a key for your account.

> [!WARNING]
> Always save your keys in a secure way. A good practice is to keep your repo private. But if you want to publish your repo as public, `.gitignore` is your friend.

[Terraform gitignore](https://github.com/github/gitignore/blob/main/Terraform.gitignore)

Create main.tf file
[Boilerplate for Terraform with Google Provider](https://registry.terraform.io/providers/hashicorp/google/latest/docs)
[Check the best region for your location](https://www.gcping.com/)

`terraform init` after creating your main tf file
`terraform plan` stage changes
`terraform apply` commit changes
`terraform destroy` delete all resources

### Deploying in the Cloud (GCP)

Add ssh-keys in metadata (all instances in project inherits the keys). It can be found in **METADATA** > **SSH KEYS**.
```bash
ssh-keygen -t rsa -f gcp -C charles -b 2048
```
Put the keys in the `config` file (similar to below) in the same folder as your created ssh to easily ssh into.
```config
Host de-zoomcamp
  HostName 34.142.249.35
  User charles
  IdentityFile ~/.ssh/gcp
```

> [!NOTE]
> When using WSL, copy your `.ssh` folder to your Windows `.ssh`.

Create a Compute Engine VM Instance to be used: ec2-standard with 4vCPU and 16GB ram with Ubuntu 20.04 LTS.
https://docs.docker.com/engine/install/linux-postinstall/

To use docker build for your ny_taxi_data, put the taxi folder to `data/`.
