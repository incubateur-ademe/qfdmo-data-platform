#!/usr/bin/env bash




# ln -s `pwd`/dags $AIRFLOW_HOME/dags

airflow scheduler &

# start the web server, default port is 8080
echo "Starting the webserver..."
port=${PORT:-80}
airflow webserver --port $port --debug