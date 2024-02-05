# qfdmo-data-platform

Gestion des données de la plateforme «Que faire de mes objets»

## Developpement

### Prérequis

- Python 3.11
- docker-compose (lancement de la DB)

### Préparation des packages à installer

Cette action n'est executée que si on souhaite modifier la liste des packages dans requirements.txt
requirements.txt est généré à partir des packages installés en suivant le processus d'installation de la page :
https://airflow.apache.org/docs/apache-airflow/stable/start.html

```sh
AIRFLOW_VERSION=2.8.1
CONSTRAINT_URL="https://raw.githubusercontent.com/apache/airflow/constraints-${AIRFLOW_VERSION}/constraints-${PYTHON_VERSION}.txt"
PYTHON_VERSION="$(python --version | cut -d " " -f 2 | cut -d "." -f 1-2)"
CONSTRAINT_URL="https://raw.githubusercontent.com/apache/airflow/constraints-${AIRFLOW_VERSION}/constraints-${PYTHON_VERSION}.txt"
pip install "apache-airflow[postgres]==${AIRFLOW_VERSION}" --constraint "${CONSTRAINT_URL}"  
```

Récupération des packages et de leur version pour modifier le requirements.txt

```sh
pip list | tail -n +3 | sed "s/ /=/" | sed "s/ //g" > requirements.txt
```

### Installation

Installer les packages python :

```sh
pip install -r requirements.txt -r dev-requirements.txt
```

### lancement standalone

Copy et modification des variables d'environnement

Lancement de la DB avec docker-compose

```sh
docker compose up -d
```

Lancement de airflow avec le script

```sh
./bin/dev-start
```

Ou avec honcho 

```sh
honcho start -f Procfile.dev
```

Noter le mot de passe de l'utilisateur admin

### Accès à l'interface

http://localhost:8080


## Production

Reste à faire