# Docker compose files

These Docker compose files can be used to quickly try out the Opencast system in
different configurations. They are not designed to be production instances, but
rather quick and dirty dev/demo instances.

## Usage

Within this directory you simply can run these commands to startup an Opencast
system:

```sh
$ docker-compose -f <docker-compose-file>.yml up
```

There are multiple compose files you can choose from, showcasing the different
ways one can use the Docker images:

-   [**`docker-compose.allinone.h2.yml`**](docker-compose.allinone.h2.yml)<br>
    This setup starts a simple allinone Opencast distribution including Apache
    ActiveMQ, Elasticsearch, and the internal H2 database.

-   [**`docker-compose.allinone.h2+pyca.yml`**](docker-compose.allinone.h2+pyca.yml)<br>
    This setup starts a simple allinone Opencast distribution including Apache
    ActiveMQ, Elasticsearch, the internal H2 database, and pyCA as capture agent.

-   [**`docker-compose.allinone.mariadb.yml`**](docker-compose.allinone.mariadb.yml)<br>
    This setup starts a simple allinone Opencast distribution including Apache
    ActiveMQ, Elasticsearch, and MariaDB.

-   [**`docker-compose.allinone.postgres.yml`**](docker-compose.allinone.postgres.yml)<br>
    This setup starts a simple allinone Opencast distribution including Apache
    ActiveMQ, Elasticsearch, and PostgreSQL.

-   [**`docker-compose.build.yml`**](docker-compose.build.yml)<br>
    This setup starts a simple allinone Opencast distribution including Apache
    ActiveMQ, Elasticsearch, and the internal H2 database using the `build`
    Docker image. This is useful for development and testing.

-   [**`docker-compose.multiserver.build.yml`**](docker-compose.multiserver.build.yml)<br>
    This setup starts a multiserver Opencast distribution with one admin, worker
    and presentation including Apache ActiveMQ, Elasticsearch, and MariaDB using
    the `build` Docker image. This is useful for development and testing.

-   [**`docker-compose.multiserver.mariadb.yml`**](docker-compose.multiserver.mariadb.yml)<br>
    This setup starts a multiserver Opencast distribution with one admin, worker
    and presentation including Apache ActiveMQ, Elasticsearch, and MariaDB.

-   [**`docker-compose.multiserver.postgres.yml`**](docker-compose.multiserver.postgres.yml)<br>
    This setup starts a multiserver Opencast distribution with one admin, worker
    and presentation including Apache ActiveMQ, Elasticsearch, and PostgreSQL.
