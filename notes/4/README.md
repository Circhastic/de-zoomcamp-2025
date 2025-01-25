## Week 4 Notes: DBT and Analytics Engineering

[Goated Notes Again by Alvaro Navas](https://github.com/ziritrion/dataeng-zoomcamp/blob/main/notes/4_analytics.md)

[DBT Official Documentation and Quickstart](https://docs.getdbt.com/docs/get-started-dbt)

[Setting up dbtCloud with BigQuery](https://github.com/DataTalksClub/data-engineering-zoomcamp/blob/main/04-analytics-engineering/dbt_cloud_setup.md)

Data Engineering > Analytics engineering > Data Analytics

Usual flow is: Data Sources (Data Lake) > Data Platforms (Warehouse) - dbt transforms data here

### Dimensional Modelling
- _**Fact Table**_:
    - _Facts_ = _Measures_
    - Typically numeric values which can be aggregated, such as measurements or metrics.
        - Examples: sales, orders, etc.
    - Corresponds to a [_business process_](https://www.wikiwand.com/en/Business_process) .
    - Can be thought of as _"verbs"_.
- _**Dimension Table**_:
    - _Dimension_ = _Context_
    - Groups of hierarchies and descriptors that define the facts.
        - Example: customer, product, etc.
    - Corresponds to a _business entity_.
    - Can be thought of as _"nouns"_.
- Dimensional Modeling is built on a [_**star schema**_](https://www.wikiwand.com/en/Star_schema) with fact tables surrounded by dimension tables.

### How does dbt work?
[DBT Tutorial with Snowflake](https://www.youtube.com/watch?v=efsqqD_Gak0&list=PLohMhitTY9xuEVMpLG3xXhsKG9j2XCTeF)

dbt works by defining a _**modeling layer**_ that sits on top of our Data Warehouse. The modeling layer will turn _tables_ into _**models**_ which we will then transform into _derived models_, which can be then stored into the Data Warehouse for persistence.

A _**model**_ is a .sql file with a `SELECT` statement; no DDL or DML is used. dbt will compile the file and run it in our Data Warehouse.