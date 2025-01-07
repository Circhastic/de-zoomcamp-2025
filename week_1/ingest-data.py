# !pip install psycopg2-binary

import argparse
from time import time
import os

import pandas as pd
from sqlalchemy import create_engine

def main(params):
    user = params.user
    password = params.password
    host = params.host
    port = params.port
    db = params.db
    table_name = params.table_name
    url = params.url
    csv_name = url.split("/")[-1]

    # download the csv
    os.system(f'wget {url} -O {csv_name}')

    engine = create_engine(f'postgresql://{user}:{password}@{host}:{port}/{db}')

    df_iterator = pd.read_csv(csv_name, iterator=True, chunksize=100000)

    df = next(df_iterator)

    df.tpep_pickup_datetime = pd.to_datetime(df.tpep_pickup_datetime)
    df.tpep_dropoff_datetime = pd.to_datetime(df.tpep_dropoff_datetime)

    df.head(n=0).to_sql(name=table_name, con=engine, if_exists='replace')
    df.to_sql(name=table_name, con=engine, if_exists='append') # initial chunk rows insertion

    counter = 0
    time_counter = 0

    while True:
        t_start = time()
        
        df = next(df_iterator)
        
        df.tpep_pickup_datetime = pd.to_datetime(df.tpep_pickup_datetime)
        df.tpep_dropoff_datetime = pd.to_datetime(df.tpep_dropoff_datetime)
        
        df.to_sql(name=table_name, con=engine, if_exists='append')

        t_end = time()
        t_elapsed = t_end - t_start
        
        print('Chunk Insertion Done! Time taken %.2f seconds' %(t_elapsed))

        counter += 1
        time_counter += t_elapsed

        if counter == 14:
            print('All chunks loaded! Total time taken: %.2f seconds' %(time_counter))
            break

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Ingest csv data into postgres')

    # user, password, host, port, database name, table name, url for the csv file
    parser.add_argument('--user', help='user name for postgres')
    parser.add_argument('--password', help='password for postgres')
    parser.add_argument('--host', help='host name for postgres')
    parser.add_argument('--port', help='port for postgres')
    parser.add_argument('--db', help='db name for postgres')
    parser.add_argument('--table_name', help='name of the table where we will write the results to')
    parser.add_argument('--url', help='url for the csv file')

    args = parser.parse_args()

    main(args)
