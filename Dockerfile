# Use the Bitnami Airflow image
FROM bitnami/airflow:latest

COPY entrypoint.sh /entrypoint.sh

USER root
RUN chmod +x /entrypoint.sh
USER 1001

# Set ARG for build-time variables
ARG AIRFLOW_DATABASE_PASSWORD
ARG AIRFLOW_DATABASE_USERNAME
ARG AIRFLOW_EMAIL
ARG AIRFLOW_EXECUTOR
ARG AIRFLOW__CELERY__BROKER_URL
ARG AIRFLOW__CORE__SQL_ALCHEMY_CONN

ENV AIRFLOW_DATABASE_PASSWORD=${AIRFLOW_DATABASE_PASSWORD} \
    AIRFLOW_DATABASE_USERNAME=${AIRFLOW_DATABASE_USERNAME} \
    AIRFLOW_EMAIL=${AIRFLOW_EMAIL} \
    AIRFLOW_EXECUTOR=${AIRFLOW_EXECUTOR} \
    AIRFLOW__CELERY__BROKER_URL=${AIRFLOW__CELERY__BROKER_URL} \
    AIRFLOW__CORE__SQL_ALCHEMY_CONN=${AIRFLOW__CORE__SQL_ALCHEMY_CONN}  \
    AIRFLOW_DATABASE_NAME=bitnami_airflow \
    AIRFLOW_DATABASE_USERNAME=bn_airflow

# Use the custom entrypoint script
ENTRYPOINT ["/entrypoint.sh"]

# Default command to start Airflow webserver
CMD ["airflow", "webserver"]