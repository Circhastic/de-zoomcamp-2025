## Homework 3: Data Warehousing 

### Question 1: 
What is count of records for the 2024 Yellow Taxi Data?
```sql
SELECT
  COUNT(1)
FROM
  `ny-taxi-rides-447209.de_zoomcamp.yellow_taxidata_2024`
```

Answer: `20,332,093`

### Question 2:
Write a query to count the distinct number of PULocationIDs for the entire dataset on both the tables.
What is the estimated amount of data that will be read when this query is executed on the External Table and the Table?

```sql
SELECT
  count(distinct(PULocationID)) 
FROM
  `ny-taxi-rides-447209.de_zoomcamp.yellow_taxidata_2024`
-- native/materialized table

SELECT
  count(distinct(PULocationID))
FROM
  `ny-taxi-rides-447209.de_zoomcamp.yellow_taxidata_2024_ext`;
-- external table
```

Answer: `0 MB for the External Table and 155.12 MB for the Materialized Table`

### Question 3:
Write a query to retrieve the PULocationID from the table (not the external table) in BigQuery. Now write a query to retrieve the PULocationID and DOLocationID on the same table. Why are the estimated number of Bytes different?

```sql
SELECT PULocationID
FROM `ny-taxi-rides-447209.de_zoomcamp.yellow_taxidata_2024`

SELECT PULocationID, DOLocationID
FROM`ny-taxi-rides-447209.de_zoomcamp.yellow_taxidata_2024`;
```

Answer: `BigQuery is a columnar database, and it only scans the specific columns requested in the query. Querying two columns (PULocationID, DOLocationID) requires reading more data than querying one column (PULocationID), leading to a higher estimated number of bytes processed.`

### Question 4:
How many records have a fare_amount of 0?

```sql
SELECT COUNT(fare_amount)
FROM `ny-taxi-rides-447209.de_zoomcamp.yellow_taxidata_2024`
WHERE fare_amount = 0;
```

Answer: `8,333`

### Question 5:
What is the best strategy to make an optimized table in Big Query if your query will always filter based on tpep_dropoff_datetime and order the results by VendorID (Create a new table with this strategy

Answer: `Partition by tpep_dropoff_datetime and Cluster on VendorID`


### Question 6:
Write a query to retrieve the distinct VendorIDs between tpep_dropoff_datetime 03/01/2024 and 03/15/2024 (inclusive)

Use the materialized table you created earlier in your from clause and note the estimated bytes. Now change the table in the from clause to the partitioned table you created for question 5 and note the estimated bytes processed. What are these values?

Choose the answer which most closely matches.

SELECT DISTINCT(VendorID)
FROM `ny-taxi-rides-447209.de_zoomcamp.yellow_taxidata_2024`
WHERE
  tpep_dropoff_datetime >= '2024-03-01'
  AND tpep_dropoff_datetime <= '2024-03-15';

**310.24** MB for Non-parititoned table

SELECT DISTINCT(VendorID)
FROM `ny-taxi-rides-447209.de_zoomcamp.yellow_taxidata_2024_part`
WHERE
  tpep_dropoff_datetime >= '2024-03-01'
  AND tpep_dropoff_datetime <= '2024-03-15';

**26.84 MB** for Partitioned table

Answer: `310.24 MB for non-partitioned table and 26.84 MB for the partitioned table`


### Question 7:

Where is the data stored in the External Table you created?

External Tables in BigQuery only references data from source and not actually saved/stored internally, therefore it is **stored in the bucket**.

Answer: `GCP Bucket`

### Question 8:
Is it best practice in Big Query to always cluster your data?
**No**, but it is only considered good practice clustering or partitioning when necessary and given the right circumstance.

Answer: `False`