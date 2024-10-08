#!/bin/bash
set -e

# Load the CSV file into the database
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    COPY climate_data(date,meantemp,humidity,wind_speed,meanpressure)
    FROM '/docker-entrypoint-initdb.d/DailyDelhiClimateTrain.csv'
    DELIMITER ','
    CSV HEADER;
EOSQL
