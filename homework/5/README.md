# Homework 5: Batch Processing Spark

[Questions](https://github.com/DataTalksClub/data-engineering-zoomcamp/blob/main/cohorts/2025/05-batch/homework.md)

Code and other details will be found in notebook

## Question 1: Install Spark and PySpark
```python
import pyspark
pyspark.__version__
```

Answer: `3.4.2`

## Question 2: Yellow October 2024
```python
df \
    .repartition(4) \
    .write.parquet('data/')
```

Answer: `25 MB`

## Question 3: Count records
```python
df \
    .filter("DATE(tpep_pickup_datetime) = '2024-10-15'") \
    .selectExpr("count(1) AS count_trips").show()
```

Answer: `125,567`

## Question 4: Longest trip
```python
df \
    .selectExpr("(unix_timestamp(tpep_dropoff_datetime) - unix_timestamp(tpep_pickup_datetime)) / 3600 AS trip_duration") \
    .orderBy("trip_duration", ascending=False) \
    .limit(1) \
    .show()
```

Answer: `162`

## Question 5: User Interface
Using `localhost:4040` opens up the Spark Master UI

Answer: `4040`

## Question 6: Least frequent pickup location zone
```python
# combine taxi data with lookup table
df_join = df.join(df_zone, df.PULocationID == df_zone.LocationID, how='inner')

# least ranking
df_join.groupBy("Zone") \
    .count() \
    .withColumnRenamed("count", "trip_frequency") \
    .orderBy("trip_frequency", ascending=True) \
    .limit(1) \
    .show()
```

Answer: `Governor's Island/Ellis Island/Liberty Island`