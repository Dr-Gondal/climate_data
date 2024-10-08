FROM python:3.9-slim

RUN pip install psycopg2-binary

COPY get_data_script.py /app/get_data_script.py

CMD ["python", "/app/get_data_script.py"]
