#!/bin/bash

# Initialize or upgrade the Airflow database before starting up
airflow db migrate


airflow scheduler &

# If using CeleryExecutor, also start the Airflow worker in the background
if [ "$AIRFLOW_EXECUTOR" == "CeleryExecutor" ]; then
  airflow celery worker &
fi

airflow webserver --port 8080

# Set the Airflow home environment variable
#ENV AIRFLOW_HOME=/app

# Expose the Airflow web server port
EXPOSE 8080

# Start the Airflow web server and scheduler
#CMD ["airflow", "webserver", "--port", "8080", "&", "airflow", "scheduler"]
CMD ["airflow","webserver","--port","8080"]