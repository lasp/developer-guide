# Docker Compose and Multi-stage Builds

## Purpose for this guideline

This guide provides an overview and some examples of how to create a multi-stage build in a Dockerfile, which allows a
user to split up build steps into different stages.

This documentation was inspired by the processes of containerizing
the [Jenkins TIM test suite](https://confluence.lasp.colorado.edu/display/DS/TIM+Containers+Archive), and providing
multiple ways of running the tests -- both through Intellij, and locally, plut the ability to add additional ways of
testing if they came up. Additionally, there are a few complications with the ways that [Red Hat VMs run on the Mac M1
chips](./running_docker_with_m1.md) that was introduced in 2020. All of these requirements led the TIM developers to use
something that allows for a lot of flexibility and simplification in one Dockerfile: multi-stage builds and a docker
compose file. This guideline will go over the general use case of both technologies and the specific use case of using
them for local TIM tests.

## Multi-stage Build

### Multi-stage build overview

A multi-stage build is a type of Dockerfile which allows you to split up steps into different stages. This is useful if
you want to have most of the Dockerfile be the same, but have specific ending steps be different for different
environments or use cases. Rather than copying the commands into different Dockerfiles, you can have multiple stages.
In this case, we want the Dockerfile to do different steps if it's running locally in the terminal, if it's running in
Jenkins, or if it's running through Intellij. This can also be used for development vs production environments, running
on Mac vs Linux, etc. You can also use multi-stage builds to start from different base images.

For additional info on multi-stage builds, you can check out the [Docker
documentation](https://docs.docker.com/build/building/multi-stage/).

### Creating and using a multi-stage build

Creating a multi-stage build is simple. You can name the first stage, where you build off a base image, using `FROM
<image name> AS <stage name>`. After that, you can use it to build off of in later steps -- in this case, you can see
that the first stage is named `builder` and the second stage builds off of `builder` in a new stage named `build1`. This
means if you run the stage `build1`, the Docker container will first do all the steps in the `builder` stage, and then
execute all the steps in `build1`:

```dockerfile
# FROM https://docs.docker.com/develop/develop-images/multistage-build/#use-an-external-image-as-a-stage
# syntax=docker/dockerfile:1
FROM alpine:latest AS builder
RUN apk --no-cache add build-base

FROM builder AS build1
COPY source1.cpp source.cpp
RUN g++ -o /binary source.cpp

FROM builder AS build2
COPY source2.cpp source.cpp
RUN g++ -o /binary source.cpp
```

To specify the stage, you can use the `--target <target name>` flag when building from the command line, or `target:
<target name>` when building from a docker compose file.

### TIM containerization multi-stage builds

In the TIM test container, multi-stage builds are used to differentiate between running the tests locally in a terminal
and running the commands through Intellij. In the local terminal, the code is copied in through an external shell
script, and then the `ant` build steps are run through `docker exec` commands. This is more complicated to learn how to
use, but ultimately allows for more flexibility and the ability to re-run the tests without needing to rebuild the
container. This also lets the end user run the tests multiple times without stopping and starting the container.
However, this means the container isn't automatically turned off. This use case is more for people who have some
experience using Docker and want more flexibility. Therefore, it uses the most basic "base" target, which doesn't build
any TIM processing code into the image and provides only the basic setup for using the container.

The case for running in Intellij is slightly different. This was intended to work similarly to the way junit tests run
in Intellij -- so the user hits a button, the tests run, and then everything is cleaned up afterwards. This resulted in
a second stage which would run the `ant` tests and generate a test report, before removing the container. This stage can
also be run from the command line, but since the test results need to be copied out, the container still has to be
manually stopped.

Jenkins will most likely use the same base target as local testing -- but for production, if we decide to embed the
production code into the container, this can be added as a separate target. Multi-stage builds allow us to put all
these use cases into one Dockerfile, while the docker compose file allows us to simplify using that end file.

## Docker compose

A [docker compose file](https://docs.docker.com/reference/compose-file/) is often used to create a network of different
docker containers representing different services. However, it is also a handy way of automatically creating volumes,
secrets, environment variables, and various other aspects of a Docker container. Basically, if you find yourself using
the same arguments in your `docker build` or `docker run` commands, that can often be automated into a docker compose
file.

### Docker compose overview

Using a docker compose file allows you to simplify the commands needed to start and run docker containers. For example,
let's say you need to run a Docker container using a Dockerfile in a different directory with an attached volume and an
environment variable. Maybe you also want to name the container `example`. The command to build and start that docker
container would normally be:

```bash
$ docker build -f dockerfiles/Dockerfile -t example:latest
$ docker run -d \
  --name example \
  -v myvol2:/app \
  -e ENV_VAR="test var"
  example:latest
```

This can easily grow in complexity as more volumes are needed, secrets passed in, etc. However, if most of these
settings don't change between runs, then we can instead move them into a docker compose file. This file is named
`docker-compose.yml` and for this example would look something like this:

```yaml
version: "3.9"
  services:
    base:
      build:
        dockerfile: dockerfiles/Dockerfile
      tty: true
      container_name: example
      volumes:
        - myvol2:/app
      environment:
        ENV_VAR: "test var"
```

If you wanted to tag this image, you can find more info on doing that
[here](https://docs.docker.com/reference/compose-file/build/#consistency-with-image).

With this docker compose file, you can build and run the Dockerfile with the following command:

```bash
$ docker compose up -d
```

You can run multiple Dockerfiles out of one docker compose file by adding additional services. You can run specific
services by adding onto the docker compose file.

Docker compose will use existing containers or images if they exist, and cache any info that's downloaded from the
internet when rebuilding the images. If you want to stop the docker container without removing the image, you can use
`docker compose down`. If you do want to remove the images, `docker compose down --rmi all` will remove all images that
the docker compose file built.

Docker compose is a very powerful tool, and everything you can do when building on the command line can also be done in
docker compose. For more info, you can check out the [docker compose documentation](https://docs.docker.com/compose/).

### TIM `docker-compose.yml` file explained

All the Docker functionality can easily be accessed using the docker compose file. Currently, this is set up for only a
few different use cases, but it can be updated if needed.

```yaml
# As of 6/6/22
version: "3.8"
services:
  base:
    # Create a container without copying in tim_processing or running any commands
    # The platform setting is needed to run on Mac M1 chip, comment out if you're on a different type of machine.
    platform: linux/x86_64
    build:
      context: ../../../
      dockerfile: ./tim_processing/docker/Dockerfiles/Dockerfile
      target: base
    container_name: tim_processing_base
    tty: true

  intellij:
    # Create a container with the local tim_processing copied in and run docker/scripts/antbuild.sh
    platform: linux/x86_64
    build:
      context: ../../../
      dockerfile: ./tim_processing/docker/Dockerfiles/Dockerfile
      target: intellij
    container_name: tim_processing_intellij
    tty: true

  test_tsis:
    # Create the same image as intellij and run ant tim_processing_tsis_tests
    platform: linux/x86_64
    build:
      context: ../../../
      dockerfile: ./tim_processing/docker/Dockerfiles/Dockerfile
      target: test_tsis
    container_name: tim_processing_test_tsis
    tty: true

  report_tsis:
    # Create the same image as intellij, run tim_processing_tsis_tests, and generate a test report.
    platform: linux/x86_64
    build:
      context: ../../../
      dockerfile: ./tim_processing/docker/Dockerfiles/Dockerfile
      target: test_report_tsis
    container_name: tim_processing_report_tsis
    tty: true

  single_test:
    # Create the same image as intellij, run a single test as determined by the SINGLE_TEST_TIM environment variable,
    # and generate a test report.
    platform: linux/x86_64
    build:
      context: ../../../
      dockerfile: ./tim_processing/docker/Dockerfiles/Dockerfile
      target: single_test_report
    environment:
      SINGLE_TEST_TIM: ${SINGLE_TEST_TIM}
    container_name: tim_processing_single_test
    tty: true
```

Each service is designed for a slightly different use case. The most basic one, `base`, just creates and runs the
Docker container with the necessary data files and tools to run the `tim_processing` tests. This is generally the one
used for working in the terminal. The others all run different stages of the build, and are used in Intellij to create
simple configurations that can accomplish different goals.

Here is what each piece of the service setting means:

* `base` | `test_tsis` | `intellij`: this is the name of the service. You can designate what service to use by passing
   it to the docker compose command: `docker compose up base`.
* `platform`: This is required for Mac M1 chips, but not for other machines. This is due to issues running Red Hat on M1
  chips.
* `build`: This block contains the build info. It is somewhat optional, it can be replaced with an image block if you
  decide to move to images that are mostly stored in the registry rather than built locally.
* `context`: This sets the build context, basically where the docker compose is running from. In this case, it's set to
  above the `tim_processing` parent directory so the entire codebase can be copied in.
* `dockerfile`: Since the context is set to one above `tim_processing`, we need to specify where the dockerfile is, even
  though the Dockerfile and the `docker-compose.yml` file are in the same directory in the repo.
* `target`: This designates the target for the multi-stage build. This is the main difference between the different
  services.
* `container_name`: The name of the container.
* `tty: true`: This line allows the created docker container to run in detached mode.
* `environment`: This can be used to pass environment variables into the docker container. Currently, this is only used
  for the `single_test` service, to set the test that you want to run.

## Acronyms

* **apk** = Alpine Package Keeper
* **TIM** = Total Irradiance Monitor
* **tty** = TeleTYpe (terminal)
* **VM** = Virtual Machine

*Credit: Content taken from a Confluence guide written by Maxine Hartnett*
