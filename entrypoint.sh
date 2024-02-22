#!/bin/bash

# Initialize or upgrade the Airflow database before starting up
airflow db upgrade


airflow scheduler &

# If using CeleryExecutor, also start the Airflow worker in the background
if [ "$AIRFLOW_EXECUTOR" == "CeleryExecutor" ]; then
  airflow celery worker &
fi

exec "$@"