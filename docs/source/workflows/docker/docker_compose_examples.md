# Using Docker Compose for Development and Testing: Examples

## Purpose for this guideline

This document provides examples of how to use Docker Compose for development and testing.

## Motivation

Docker is great at isolating a build environment to ensure reproducibility and reduce chances of a mistake affecting the
host system (or vice versa). Docker compose is great at coordinating the spin up of networked "services" in an isolated
context, in a predictable order.

Docker provides an ideal testing environment, especially if you are planning to eventually run your application in
Docker. It allows you to specify the precise environment in which you intend to run your code, and you can bring up
testing containers and use the default entrypoint to run your tests.

Many development environments require "mocked" resources like test databases, load balancers, or other networked
resources like Elastic Search, Kibana, or Grafana. Docker provides a convenient way to create these mocked resources to
spec in a reproducible but disposable way.

## Running many different Docker compose services built from one Dockerfile

Enter Multi Stage Builds! You can now specify many different target images in a single Dockerfile. For example:

```Dockerfile
FROM python:3.9.0-slim AS my-containerized-app
USER root

ENV INSTALL_LOCATION=/opt/my_app
WORKDIR $INSTALL_LOCATION

# Create virtual environment and permanently activate it for this image
ENV VIRTUAL_ENV=/opt/venv
RUN python -m venv $VIRTUAL_ENV
# This adds not only the venv python executable but also all installed entrypoints to the PATH
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
# Upgrade pip to the latest version because poetry uses pip in the background to install packages
RUN pip install --upgrade pip

# Install poetry
RUN curl -sSL https://install.python-poetry.org | python -
# Add poetry to path
ENV PATH="$PATH:/root/.local/bin"

# Copy necessary files over (except for dockerignore-d files)
COPY my_app $INSTALL_LOCATION/my_app
COPY pyproject.toml $INSTALL_LOCATION

# Install my_app and all its (non-dev) dependencies according to pyproject.toml
RUN poetry install --no-dev

# Define the entrypoint of the container. Passing arguments when running the
# container will be passed as arguments to the function
ENTRYPOINT ["some_cli_entrypoint_to_my_app", "run"]



FROM my_containerized_app AS my-containerized-tests

# Install dev dependencies (not installed in application image)
RUN poetry install

# Copy tests over
COPY tests $INSTALL_LOCATION/tests

# Set entrypoint to pytest against the tests we just copied
ENTRYPOINT pytest $INSTALL_LOCATION



FROM alpine AS totally-unrelated-image
RUN apk add --update bash && rm -rf /var/cache/apk/*
COPY ./fooscript.sh:/opt/fooscript.sh
ENTRYPOINT /bin/bash /opt/fooscript.sh
```

And we can target those build stages from inside the docker compose file with `build: target:`, which tells docker how
to get (build) the image. Note that unless you run `docker compose build`, any existing image by that name will be used.

```yaml
version: '3'

services:
  app:
    image: my-app:latest
    build:
      context: .
      target: my-containerized-app

  tests:
    image: my-tests:latest
    build:
      context: .
      target: my-containerized-tests

  unrelated:
    image: totally-unrelated-image
    build:
      context: .
      target: totally-unrelated-image
```

And we can run our suite of images with `docker compose up`

## Running python unit tests using Docker compose

In development of the `lasp_datetime` library, we wanted to support many versions of Python and NumPy, and we needed to
test against all of those versions to make sure our library worked against all the supported versions. The following
`Dockerfile` and `docker-compose.yml` files demonstrate how to create a parameterized docker image build (parameterized
with a python version and numpy version) that allows testing the library being developed against the specified versions
of numpy and python. The Docker compose file demonstrates how to create a set of services that can be run in parallel
since these unit tests don't interfere with each other in any way.

For the full repo code, see
[https://bitbucket.lasp.colorado.edu/projects/SDS/repos/lasp_datetime/browse](https://bitbucket.lasp.colorado.edu/projects/SDS/repos/lasp_datetime/browse)

All tests can be run with the following commands:

`run_tests.sh`:

```bash
#!/bin/bash

# First build all the images listed in the docker-compose file
docker compose build

# Run all service entrypoints (unit tests) in parallel
docker compose up

# Remove all the leftover containers
docker compose down
```

`Dockerfile`:

```Dockerfile
# Python version with which to test (must be supported and available on dockerhub)
ARG BASE_IMAGE_PYTHON_VERSION

FROM python:${BASE_IMAGE_PYTHON_VERSION}-slim

# Optional numpy version
ARG NUMPY_VERSION

USER root

ENV INSTALL_LOCATION=/opt/lasp_datetime
WORKDIR $INSTALL_LOCATION

# Create virtual environment and permanently activate it for this image
ENV VIRTUAL_ENV=/opt/venv
RUN python -m venv $VIRTUAL_ENV
# This adds not only the venv python executable but also all installed entrypoints to the PATH
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
# Upgrade pip to the latest version because poetry uses pip in the background to install packages
RUN pip install --upgrade pip

RUN apt-get update
RUN apt-get install -y curl

# Install poetry
RUN curl -sSL https://install.python-poetry.org | python -
# Add poetry to path
ENV PATH="$PATH:/root/.local/bin"

COPY lasp_datetime $INSTALL_LOCATION/lasp_datetime
COPY tests $INSTALL_LOCATION/tests
COPY pylintrc $INSTALL_LOCATION

COPY pyproject.toml $INSTALL_LOCATION
# LICENSE.txt is referenced by setup.cfg
COPY LICENSE.txt $INSTALL_LOCATION

# Install all dependencies (including dev deps) specified in pyproject.toml
RUN poetry install -v

# Optionally override the numpy version
RUN if [ -n "${NUMPY_VERSION}" ]; then pip install numpy==$NUMPY_VERSION; fi

ENTRYPOINT pytest --cov-report=xml:coverage.xml \
    --cov-report=term \
    --cov=lasp_datetime \
    --junitxml=junit.xml \
    tests
```

`docker-compose.yml`:

```yaml
version: '3'

services:
  3.6-min-numpy-tests:
    image: lasp-datetime-3.6-min-numpy-test:latest
    build:
      args:
        - BASE_IMAGE_PYTHON_VERSION=3.6
        - NUMPY_VERSION=1.15.0

  3.6-tests:
    image: lasp-datetime-3.6-test:latest
    build:
      args:
        - BASE_IMAGE_PYTHON_VERSION=3.6

  3.7-tests:
    image: lasp-datetime-3.7-test:latest
    build:
      args:
        - BASE_IMAGE_PYTHON_VERSION=3.7

  3.8-tests:
    image: lasp-datetime-3.8-test:latest
    build:
      args:
        - BASE_IMAGE_PYTHON_VERSION=3.8

  3.9-tests:
    image: lasp-datetime-3.9-test:latest
    build:
      args:
        - BASE_IMAGE_PYTHON_VERSION=3.9
```

## Creating a development database with Flyway and Postgres

A common use case for web apps and processing infrastructure is the need for a local development database. Docker can
provide an easily maintained (and cleaned up) development database to use locally, both for development and for unit
testing. Below is a configuration for such a setup:

`rebuild_dev_db.sh`:

```bash
# There is nothing to build (images are all on dockerhub) so we go straight to bringing up the system
docker compose up flyway-dev flyway-test

# The above will create one persistently running postgres container named "db" on its own network but with port 5432
# forwarded to localhost:5432 for easy unit testing along with two stopped flyway containers, which ran just long enough
# to migrate your DB schema and then stopped. When you are done with everything, you can stop and remove all your
# containers (services) with
docker compose down
```

`docker-compose.yml`:

```yaml
version: '3'

services:
  db:
    # This image comes from dockerhub. No need to build it locally.
    image: postgres:14
    restart: always
    ports:
      - "5432:5432"
    environment:
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=masterpass
      - POSTGRES_DB=postgres
    # Mount the initdb script with users, roles, login info to initialize the root database
    volumes:
      - ./initdb.sh:/docker-entrypoint-initdb.d/initdb.sh

  flyway-dev:
    # Image comes from dockerhub.
    image: flyway/flyway:latest
    environment:
      - FLYWAY_PASSWORD=masterpass
      - FLYWAY_CONNECT_RETRIES=60
    # Entrypoint is to run flyway migrate against the container named "db" and the database named sdp_dev
    command: -url=jdbc:postgresql://db:5432/sdp_dev migrate
    # Copy SQL migrations and flyway config file into the flyway image
    volumes:
      - ./migrations:/flyway/sql
      - ./flyway.conf:/flyway/conf/flyway.conf
    depends_on:
      - db

    flyway-test:
    # Image comes from dockerhub.
    image: flyway/flyway:latest
    environment:
      - FLYWAY_PASSWORD=masterpass
      - FLYWAY_CONNECT_RETRIES=60
    # Entrypoint is to run flyway migrate against the container named "db" and the database named sdp_test
    command: -url=jdbc:postgresql://db:5432/sdp_test migrate
    # Copy SQL migrations and flyway config file into the flyway image
    volumes:
      - ./migrations:/flyway/sql
      - ./flyway.conf:/flyway/conf/flyway.conf
    depends_on:
      - db
```

`initdb.sh`:

```bash
#!/bin/bash
# Sets up the development database with roles, users, databases, and default permissions
# This script gets copied into the Dockerized postgres instance so it brings this up on start

export PGUSER=postgres
export PGPASSWORD=masterpass

cat << EOF | psql -d postgres
CREATE ROLE reader_role;
CREATE ROLE processor_role;  -- privileges for processing data
CREATE ROLE tester_role;  -- privileges for running unit tests

CREATE USER unit_tester PASSWORD 'testerpass' IN ROLE tester_role;
CREATE USER processor PASSWORD 'processorpass' IN ROLE processor_role;
CREATE USER reader PASSWORD 'readerpass' IN ROLE reader_role;

CREATE DATABASE sdp_dev OWNER postgres;
CREATE DATABASE sdp_test OWNER postgres;
EOF

echo "Granting default permissions to processor, unit_tester, and reader"
# ON sdp_dev DATABASE
cat << EOF | psql -d sdp_dev
GRANT USAGE ON SCHEMA public TO processor_role;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT, INSERT, UPDATE ON TABLES TO processor_role;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT USAGE, SELECT ON SEQUENCES TO processor_role;

GRANT USAGE ON SCHEMA public TO reader_role;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO reader_role;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT USAGE, SELECT ON SEQUENCES TO reader_role;
EOF

# ON sdp_test DATABASE
cat << EOF | psql -d sdp_test
GRANT USAGE ON SCHEMA public TO tester_role;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL PRIVILEGES ON TABLES TO tester_role;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT USAGE, SELECT ON SEQUENCES TO tester_role;

GRANT USAGE ON SCHEMA public TO reader_role;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO reader_role;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT USAGE, SELECT ON SEQUENCES TO reader_role;
EOF
```

Obviously you will also need a valid Flyway config, like here:
[https://flywaydb.org/documentation/configuration/configfile](https://flywaydb.org/documentation/configuration/configfile)

And you will need some Flyway migration scripts to build up your DB schema however you like here:
[https://flywaydb.org/documentation/getstarted/why](https://flywaydb.org/documentation/getstarted/why)

## Useful Links

* [Official Docker documentation](https://docs.docker.com/)
* [Docker compose documentation](https://docs.docker.com/compose/)
* [Dockerfile reference](https://docs.docker.com/engine/reference/builder/)
* [Multi Stage Builds documentation](https://docs.docker.com/develop/develop-images/multistage-build/)
* [Docker compose networking documentation](https://docs.docker.com/compose/networking/)
* [Docker Compose and Multi-stage Builds](multi_stage_builds)

## Acronyms

* **apk** = Alpine Package Keeper
* **pip** = Pip Installs Packages

*Credit: Content taken from a Confluence guide written by Gavin Medley and Maxine Hartnett*