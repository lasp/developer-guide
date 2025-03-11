# LASP Image Registry

## Purpose for this guideline

This document provides instructions on how to push and pull Docker images to/from the LASP image registry.

## Overview

LASP has established its own image registry, `docker-registry.pdmz.lasp.colorado.edu`, and, in general, does not rely on
Docker Hub. The web team has granted access privileges to the Nexus repositories, including the Docker image registry,
using WebIAM credentials. For more info about accessing the LASP Image registry, check out the [LASP Docker registry
page](lasp_docker_registry).

The url for access to the LASP image registry is
[https://artifacts.pdmz.lasp.colorado.edu](https://artifacts.pdmz.lasp.colorado.edu).

## Push an image to the registry

### Retag the image

First, it is necessary to retag the image to include the registry name and registry account. In general, this is:

```bash
docker-registry.pdmz.lasp.colorado.edu/<registry_account>/<image_name>:<image_tag>
```

A specific example, using a current TIM development image is

```bash
docker image tag dsinteg2_migration docker-registry.pdmz.lasp.colorado.edu/tsis/dsinteg2_migration
```

where `tsis` is the registry account name assigned to this project by the web team.

### Log into the registry

Before the image can be pushed to the LASP image registry, a connection must be established as follows:

```bash
docker login -u <webiam_username> -p <webiam_password> docker-registry.pdmz.lasp.colorado.edu
```

For example:

```bash
docker login -u smueller -p <smueller_password> docker-registry.pdmz.lasp.colorado.edu
```

If the connection fails, try enclosing the password with double quotes.

### Push the image to the registry

Push the image to the registry as follows:

```bash
docker push docker-registry.pdmz.lasp.colorado.edu/<registry_account>/<image_name>:<image_tag>
```

For example:

```bash
docker push docker-registry.pdmz.lasp.colorado.edu/tsis/dsinteg2_migration
```

The registry account name is set by the web team, and they refer to it as the namespace.

## Pull the image from the registry from the command line

To pull a registry image, simply include the registry address (`docker-registry.pdmz.lasp.colorado.edu`), the project
account name (e.g. `tsis`), followed by the image name (e.g. `dsinteg2_migration`).

For example:

```bash
docker pull docker-registry.pdmz.lasp.colorado.edu/tsis/dsinteg2_migration
```

Or, the following command:

```bash
docker container run --user root --rm -it --name timDevContainer docker-registry.pdmz.lasp.colorado.edu/tsis/dsinteg2_migration bash
```

This will launch a container based on the registry `dsinteg2_migration` image and connect to that container with a
`bash` shell.

## Pull the image from the registry in the Docker compose file

Referencing the registry image in the Docker compose file is simple. Just use the new tag name, that now includes the
registry and account name, in the image specification. For example:

```yaml
more docker-compose.yml
version: '3'

services:
  timDev:
    image: docker-registry.pdmz.lasp.colorado.edu/tsis/dsinteg2_migration
    restart: unless-stopped
    volumes:
      - /home/stmu4541/projects/tsis_tim/tim_processing/timDev/jenkins/data:/var/jenkins_home
    ports:
      - 8082:8080
```

Only the image argument is relevant to the registry pull.

## Useful Links

* [Official Docker documentation](https://docs.docker.com/)
* [LASP image registry](https://artifacts.pdmz.lasp.colorado.edu)

## Acronyms

* **TIM** = Total Irradiance Monitor
* **URL** = Uniform Resource Locator

*Credit: Content taken from a Confluence guide written by Steven Mueller*