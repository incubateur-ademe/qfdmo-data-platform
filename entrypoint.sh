#!/usr/bin/env bash


airflow celery worker &

airflow scheduler &

# start the web server, default port is 8080
echo "Starting the webserver..."
port=${PORT:-8080}
airflow webserver --port $port --debug

