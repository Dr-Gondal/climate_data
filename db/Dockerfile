# Stage1: Setup PostgreSQL with initial data
FROM postgres:13 AS postgres-setup

ENV POSTGRES_USER=${DB_USER}
ENV POSTGRES_PASSWORD=${DB_PASSWORD}
ENV POSTGRES_DB=${DB_NAME}

# Copy the DailyDelhiClimateTrain.csv file and init scripts
COPY DailyDelhiClimateTrain.csv /docker-entrypoint-initdb.d/DailyDelhiClimateTrain.csv
COPY init_db.sh /docker-entrypoint-initdb.d/init_db.sh
COPY load_csv.sh /docker-entrypoint-initdb.d/load_csv.sh

EXPOSE 5432

# Stage2: Final image
FROM postgres:13

ENV POSTGRES_USER=${DB_USER}
ENV POSTGRES_PASSWORD=${DB_PASSWORD}
ENV POSTGRES_DB=${DB_NAME}

# Copy the database setup from the first stage
COPY --from=postgres-setup /docker-entrypoint-initdb.d /docker-entrypoint-initdb.d

EXPOSE 5432

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["postgres"]
