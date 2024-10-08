#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL

    CREATE TABLE climate_data (
        id SERIAL PRIMARY KEY,
        date date,
        meantemp  numeric(20, 16),
        humidity numeric(20, 16),
        wind_speed numeric(20, 16),
        meanpressure numeric(20, 16)
    );
EOSQL
