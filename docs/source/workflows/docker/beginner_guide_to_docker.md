# A Beginner's Guide to Docker

## Purpose for this guideline

This guide is intended to provide an overview of what Docker is, how it's used, and the basics of running Docker
containers. It will not go in depth on creating a Docker image, or on the more nuanced aspects of using Docker. For a
more in-depth introduction, you can read through the official Docker docs.

## Overview

Docker is a tool for containerizing code. You can basically think of it as a lightweight virtual machine. Docker works
by defining an image which includes whatever you need to run your code. You start with a base image, which is a pre-made
Docker image, then install your dependencies on top. Python? Java? Fortran libraries? Almost anything you can install
into a normal computer, you can install into Docker. There are plenty of base images available. You can start with
something as basic as [Arch linux](https://hub.docker.com/_/archlinux), or as complicated as a
[Windows base image with Python already installed](https://hub.docker.com/r/microsoft/windows-cssc-python).

Once you have created your Docker image, it can be uploaded to LASP's internal registry for other people or machines to
use. Every machine runs the Docker image in the same way. The same image can be used for local development, for running
tests in Jenkins or GitHub Actions, or for running production code in AWS Lambdas. It creates a standard environment, so
new developers can get started quickly, and so everyone can keep their local environments clean. Docker also makes it
possible to archive the entire environment, not just the code. Code is only useful as long as people can run it.
Finally, unlike many virtual machines, Docker is lightweight enough to be run only when needed, and updated frequently.

## Basics of Docker

If you've used Virtual Machines in the past, the basic uses of Docker will be familiar to you. A few terms are defined
below. For a more in-depth explanation, see the [official Docker overview](https://docs.docker.com/get-started/).

**Docker Image:** The Docker image contains all the information needed to run the Docker container. This includes the
entire operating system, file system, and dependencies.

**Docker Container:** A Docker container is a specific instance of a Docker image. A Docker container is used to run
commands within the environment defined by the Docker image.

**Dockerfile:** The dockerfile is what defines a Docker image. It contains the commands for building a Docker image,
including things like the base image to use, the installation steps to run, creating needed directories, etc.

**Docker Compose:** A Docker compose file is an optional file which defines how to run the Docker images. This can be
useful if you will be running multiple images in tandem, attaching volumes or networks to the containers, or just
generally find yourself running the same commands for creating containers and want to optimize that.

**Docker Registry:** A registry or archive store is a place to store and retrieve docker images. This is one way to
share already-built docker images. LASP has a private repository, in the form of the LASP docker registry.

So, you define a Docker *image* using a *Dockerfile* and/or a *Docker Compose* file. Running this image produces a
Docker *container*, which runs your code and environment. An image can be pushed up to a *registry*, where anyone with
access can pull the image and run the container themselves without needing access to the Dockerfile.

## Getting Started

This section will outline some basic commands and use cases for Docker. First, you need to
[install Docker](https://docs.docker.com/get-started/get-docker/) on your computer. Next, start by creating a
dockerfile. This example dockerfile will run an `alpine` image and install Python. Traditionally, dockerfiles are named
`Dockerfile`, although you can append to that if needed (eg, `dev.Dockerfile`). The `docker build` command will look in
the current directory for a file named `Dockerfile` by default, but you can specify a different file though command line
arguments or through your docker compose file.

Generally, each Docker image should be as small as possible. Each Dockerfile should only do one thing at a time. If you
have a need for two extremely similar docker containers, you can also use [Multi-stage builds](multi_stage_builds). You
can orchestrate multiple docker containers that depend on each other using
[Docker compose](docker_compose_examples).

To start, your Dockerfile should specify the base image using `FROM .`. Then, you can set up the environment by using
`RUN` commands to run shell commands. Finally, you can finish the container by using a `CMD` command. This is an
optional command that will run once the entire container is set up.

Here is our example Dockerfile:

```dockerfile
# Starting with alpine as our base image
FROM alpine

# Install python
RUN apk add --update --no-cache python3 && ln -sf python3 /usr/bin/python
RUN python3 -m ensurepip
RUN pip3 install --no-cache --upgrade pip setuptools
```

In the same folder, we run the `build` command to build our image:

```bash
docker build --platform linux/amd64 -f Dockerfile -t docker_tutorial:latest .
```

The flag `–platform linux/amd64` is optional unless you are [running an M1 chip mac](running_docker_with_m1). The `-f`
flag indicates the name of the Dockerfile -- in this case, it is also optional, since `Dockerfile` is the default value.
The `-t` flag is a way to track the docker images and containers on our system by adding a name and a tag. `latest` is
the tag used to indicate the latest version of a Docker image. Additional useful flags include `--no-cache` for a clean
rebuild, and you can find a full list of flags [here](https://docs.docker.com/reference/cli/docker/buildx/build/).

Now that we have built the image, we can see all the Docker images that are built on our system by running the
`docker images` command:

```plaintext
$ docker images
REPOSITORY                       TAG       IMAGE ID       CREATED         SIZE
docker_tutorial                  latest    71736be7c555   5 minutes ago   91.9MB
```

> **Info**: If you prefer to use a GUI, the Docker Desktop application can also be used to view, run, and delete docker
> images.

If we wanted, we could now push that image up to a registry by using the `docker push`
[command](https://docs.docker.com/reference/cli/docker/image/push/). Alternatively, instead of building the image, you
could pull an existing image using the `docker pull` [command](https://docs.docker.com/reference/cli/docker/image/pull/).

Now that we have an image locally, we can run a container from that image using the `docker run` command:

```bash
docker run --platform linux/amd64 -it --name tutorial docker_tutorial:latest
```

Once again, the platform is optional, unless you are on an M1 mac. The `-it` flag opens an interactive `tty` session --
basically so you can interact with the container via the command line. The ``--name`` flag gives the container a name.
Another key flag to know is `-d`, which runs the container in detached mode. This will let the container run in the
background without attaching to your terminal. You can see all currently running Docker containers with `docker ps`, and
all currently existing Docker containers with `docker ps -a` .

Running the `docker run` command will start your container and connect to it, so you can interactively run commands. If
you run `which python` in this container, you should see that Python is successfully installed. You can use `^D` to
detach from the container and stop it.

With that, you have successfully run the Docker container! This is a good way to debug and run code inside a container
for development purposes. If you want to have the Docker image automatically execute code when you run it, we can use
the `CMD` command. For example, this can be used to run tests or the main application for a lambda container.

To do this, add a line with a `CMD` at the bottom of your `Dockerfile`:

```dockerfile
CMD echo "Hello world"
```

Once you build the container, you can run it without the interactive session:

```bash
docker run --platform linux/amd64 docker_tutorial:latest
```

This will run once, execute the command in `CMD` at the end, and then exit the container. You can see that the container
has successfully exited with `docker ps -a`. The `CMD` is how most Docker containers that run code without human
intervention work. For an example of a system where that's operating, you can read the documentation on the [TIM tests
in Docker](https://confluence.lasp.colorado.edu/display/DS/Containerize+TIM+Processing+-+Base+Image).

## Docker Cheat Sheet

Here is a list of Docker commands that might be useful to have as a shorthand:

```bash
# build locally
docker build --platform linux/amd64 -f <filename> -t <name>:latest .

# Run in interactive mode
docker run --platform linux/amd64 -it --name <container name> <image name>:latest

# Login to docker registry
docker login <registry_hostname>

# View docker images
docker images

# View docker containers
docker ps -a

# Remove stopped containers
docker container prune

# Remove dangling images (run after container prune)
docker image prune
```

## Useful Links

* [Official Docker documentation](https://docs.docker.com/)
* [Installing Docker engine](https://docs.docker.com/engine/install/)
* [Installing Docker Desktop for Mac](https://docs.docker.com/desktop/install/mac-install/)
* [Docker CLI cheatsheet](https://docs.docker.com/get-started/docker_cheatsheet.pdf)

## Acronyms

* **apk** = Alpine Package Keeper
* **amd64** = 64-bit Advanced Micro Devices
* **AWS** = Amazon Web Services
* **pip** = Pip Installs Packages
* **ps** = Process Status
* **tty** = TeleTYpe (terminal)

*Credit: Content taken from a Confluence guide written by Maxine Hartnett*
