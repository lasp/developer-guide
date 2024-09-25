# Running Docker on Mac M1 Chips

## Purpose for this guideline

This document provides guidelines on how to use Docker with Apple computers that use M1 chips.

## Background

Starting in 2020, Apple started using a [new design of chip](https://www.macrumors.com/guide/m1/) in their computers.
This chip, called the M1 chip, replaced the Intel x86 architecture of previous Mac computers with a new ARM-based system
designed at Apple. This allowed Apple to move away from Intel chips and start producing their own. Unfortunately, this
new style of chip introduces plenty of incompatibility problems, since it's based on an ARM architecture, whereas most
computers are still on x86. ARM is still primarily used in mobile devices. It is generally possible to run x86 programs
on ARM, but [performance takes a hit](https://www.toptal.com/apple/apple-m1-processor-compatibility-overview).

Unfortunately, Docker is one program that depends heavily on the underlying architecture. Most software is going to or
has already added support for M1 chips, since Apple is such a large portion of the market, but there will be growing
pains, since this is a pretty big departure from existing chips.

This guide will cover some of the issues that may come up when running Docker on an M1 chip computer. At the time of
writing, they all have various workarounds, but may have performance costs.

Here are some of the [known issues surrounding running Docker on M1
Macs](https://docs.docker.com/desktop/install/mac-install/#known-issues).

## Running RHEL 7 on Docker

Red Hat has some [compatibility issues](https://access.redhat.com/discussions/5966451) with the M1 chip no matter the
method used for virtualization. This is because (according to the RHEL discussion boards) Red Hat is built for a default
page size of 64k, while the M1 CPU page size is 16k. One way to fix this is to rebuild for a different page size.

### Short-term Solution

A solution is to use the [`platform` option](https://devblogs.microsoft.com/premier-developer/mixing-windows-and-linux-containers-with-docker-compose/)
in [docker compose](https://docs.docker.com/compose/). It's an option that allows you to select the platform to build
the image. If you set the platform to `linux/x86_64` then the page size issue isn't a problem and the Docker image will
build locally. It is not clear what exactly it's doing - perhaps it is that the M1 chip is using some sort of
virtualization scheme on the x86 version of the docker image that makes it work - but it's a simple fix that works well.

This does require an up-to-date version of Docker, as the `platform` keyword is only available for a [few
versions](https://github.com/docker/compose/pull/5985). The newer versions of Docker also include some fixes for the M1
chips in general.

Below is an example of a `docker-compose` file. To run this, you simply run `docker compose up` and it will run the
provided Dockerfile. You can add a `-d` flag to run the container in detached mode. To shut the container down, run
`docker compose down`. It will cache a bunch of info, so if you want it to rebuild the image, you can run `docker compose
down --rmi all` to remove the images:

```yaml
version: "3.8"
services:
base:
    # The platform setting is needed to run on Mac M1 chip, comment out if you're on a different type of machine.
    platform: linux/x86_64
    build:
      dockerfile: ./Dockerfile
    container_name: container_name
    tty: true
```

The `platform` keyword is also available on `docker build` and `docker run` commands. If you use
`--platform linux/amd64` on `docker build` and `docker run` commands you can force the platform without needing to use
`docker compose`.

## Docker Container Hanging on M1

[This is a known issue with Docker](https://github.com/docker/for-mac/issues/5590). Docker has already released some
patches to try and fix it, but it could still be encountered. Basically, the Docker container will hang permanently
while running. Sometimes running `docker ps` will work, sometimes not. In order to recover from that point, restart the
Docker daemon. If you're using Docker Desktop, you can restart it that way, although it may require to force kill any
Docker programs.

The best way to fix it is to go to the Docker Desktop Dashboard > Settings > Resources and change the number of CPUs
down to 1. This will obviously impact performance in other ways, but may help avoid encountering this permanent hang.

## Acronyms

* **amd64** = 64-bit Advanced Micro Devices
* **ARM** = Advanced RISC (Reduced Instruction Set Computer) Machines
* **CPU** = Central Processing Unit
* **ps** = Process Status
* **RHEL** = Red Hat Enterprise Linux

*Credit: Content taken from a Confluence guide written by Maxine Hartnett*
