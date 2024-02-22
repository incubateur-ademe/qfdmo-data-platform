# Use the Bitnami Airflow image
FROM bitnami/airflow:latest

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

# Set environment variables for Airflow configuration
ENV AIRFLOW_DATABASE_NAME=bitnami_airflow \
    AIRFLOW_DATABASE_USERNAME=bn_airflow
# Use the custom entrypoint script
ENTRYPOINT ["/entrypoint.sh"]

CMD ["airflow", "webserver"]