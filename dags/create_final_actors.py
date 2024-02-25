from datetime import datetime, timedelta
from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.providers.postgres.hooks.postgres import PostgresHook

from utils.utils import load_table, save_to_database


def read_data_from_postgres(**kwargs):
    table_name = kwargs["table_name"]
    pg_hook = PostgresHook(postgres_conn_id='lvao-preprod')
    engine = pg_hook.get_sqlalchemy_engine()
    df = load_table(table_name, engine)
    return df


def apply_corrections(**kwargs):
    df_normalized_actors = kwargs['ti'].xcom_pull(task_ids='load_normalized_actors')
    df_manual_actor_updates = kwargs['ti'].xcom_pull(task_ids='load_manual_actor_updates')

    df_normalized_actors = df_normalized_actors.set_index('identifiant_unique')
    df_manual_actor_updates = df_manual_actor_updates.set_index('identifiant_unique')

    df_normalized_actors.update(df_manual_actor_updates)

    return df_normalized_actors.reset_index()


def write_data_to_postgres(**kwargs):
    df_normalized_corrected_actors = kwargs['ti'].xcom_pull(task_ids='apply_corrections')
    pg_hook = PostgresHook(postgres_conn_id='lvao-preprod')
    engine = pg_hook.get_sqlalchemy_engine()
    save_to_database(df_normalized_corrected_actors, "lvao_final_actors", engine)


default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime(2024, 2, 7),
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

dag = DAG(
    'create_final_actors',
    default_args=default_args,
    description='DAG for applying correction on normalized actors',
    schedule_interval=None,
)

t1 = PythonOperator(
    task_id='load_normalized_actors',
    python_callable=read_data_from_postgres,
    op_kwargs={"table_name": "lvao_actors_processed"},
    dag=dag,
)

t2 = PythonOperator(
    task_id='load_manual_actor_updates',
    python_callable=read_data_from_postgres,
    op_kwargs={"table_name": "lvao_manual_actors_updates"},
    dag=dag,
)


t3 = PythonOperator(
    task_id='apply_corrections',
    python_callable=apply_corrections,
    provide_context=True,
    dag=dag,
)

t4 = PythonOperator(
    task_id='write_data_to_postgres',
    python_callable=write_data_to_postgres,
    provide_context=True,
    dag=dag,
)

[t1, t2] >> t3 >> t4
