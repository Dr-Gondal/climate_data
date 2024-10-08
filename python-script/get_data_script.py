import psycopg2
from psycopg2 import sql
import time
import os

# DB connection params
DB_NAME     = os.getenv('DB_NAME')
DB_USER     = os.getenv('DB_USER')
DB_PASSWORD = os.getenv('DB_PASSWORD')
DB_HOST     = os.getenv('DB_HOST')
DB_PORT     = os.getenv('DB_PORT')

time.sleep(5)

# Connect to PostgreSQL db
try:
    connection = psycopg2.connect(
        dbname=DB_NAME,
        user=DB_USER,
        password=DB_PASSWORD,
        host=DB_HOST,
        port=DB_PORT
    )
    cursor = connection.cursor()
    print("Successfully connected to the database")

    # SQL query to find the min and max humidity values for each year
    query = """
    SELECT 
        EXTRACT(YEAR FROM date) AS year,
        MIN(humidity) AS min_humidity,
        MAX(humidity) AS max_humidity
    FROM 
        climate_data
    GROUP BY 
        EXTRACT(YEAR FROM date)
    ORDER BY 
        year;
    """

    cursor.execute(query)

    results = cursor.fetchall()

    # Print results
    print("Year | Min Humidity | Max Humidity")
    print("-----------------------------------")
    for row in results:
        print(f"{int(row[0])}  | {row[1]:.16f} | {row[2]:.16f}")

except Exception as error:
    print("Error connecting to the database:", error)
finally:
    if connection:
        cursor.close()
        connection.close()
        print("Database connection closed")
