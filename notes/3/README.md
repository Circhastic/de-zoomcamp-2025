## Week 3 Notes: Data Warehousing (using BigQuery)

Other Data Warehousing Services
- Amazon Redshift
- Snowflake
- Azure Synapse
- Databricks
- Teradata etc.

### Best Practices
**Clustering** over Partitioning

**Cost Reduction**
- Avoid `SELECT *` to reduce columns to display.
- Price your queries before running.
- Use clustered and/or partitioned tables if possible.
- Use streaming inserts with caution.
- Materialize query results in stages.

**Query Performance**
- Filter on partitioned columns
- Denormalizing Data
- Use [nested or repeated columns](https://cloud.google.com/blog/topics/developers-practitioners/bigquery-explained-working-joins-nested-repeated-data)
- Use external data sources appropriately (higher performance requirement)
- Reduce data before using a `JOIN`
- Do not treat WITH clauses as prepared statements (additional charges)
- Avoid oversharding tables (partitioning?)
- Avoid JS user-defined functions
- Order Last
- Place the table with the **largest number of rows first**, followed by the table with the fewest rows, and then the remaining tables by decreasing size