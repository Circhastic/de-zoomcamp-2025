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
    table_name_lookup = params.table_name_lookup

    # download the csv
    url_data='https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/green_tripdata_2019-10.csv.gz'
    csv_name_data = url_data.split("/")[-1]

    url_lookup='https://github.com/DataTalksClub/nyc-tlc-data/releases/download/misc/taxi_zone_lookup.csv'
    csv_name_lookup = url_lookup.split("/")[-1]

    os.system(f'wget {url_data} -O {csv_name_data}')
    os.system(f'wget {url_lookup} -O {csv_name_lookup}')

    engine = create_engine(f'postgresql://{user}:{password}@{host}:{port}/{db}')

    # create the green taxi table
    df_iterator = pd.read_csv(csv_name_data, iterator=True, chunksize=100000)
    df = next(df_iterator)
    df.lpep_pickup_datetime = pd.to_datetime(df.lpep_pickup_datetime)
    df.lpep_dropoff_datetime = pd.to_datetime(df.lpep_dropoff_datetime)
    df.head(n=0).to_sql(name=table_name, con=engine, if_exists='replace')
    df.to_sql(name=table_name, con=engine, if_exists='append') # initial chunk rows insertion for data

    # create the lookup table
    df_lookup = pd.read_csv(csv_name_lookup)
    df_lookup.to_sql(name=table_name_lookup, con=engine, if_exists='append') # initial chunk rows insertion for lookup

    counter = 0
    time_counter = 0

    while True:
        t_start = time()
        
        df = next(df_iterator)
        
        df.lpep_pickup_datetime = pd.to_datetime(df.lpep_pickup_datetime)
        df.lpep_dropoff_datetime = pd.to_datetime(df.lpep_dropoff_datetime)
        
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

    # user, password, host, port, database name, table names
    parser.add_argument('--user', help='user name for postgres')
    parser.add_argument('--password', help='password for postgres')
    parser.add_argument('--host', help='host name for postgres')
    parser.add_argument('--port', help='port for postgres')
    parser.add_argument('--db', help='db name for postgres')
    parser.add_argument('--table_name', help='name of the table where we will write the results of the data to')
    parser.add_argument('--table_name_lookup', help='name of the table where we will write the results of the lookup to')

    args = parser.parse_args()

    main(args)
