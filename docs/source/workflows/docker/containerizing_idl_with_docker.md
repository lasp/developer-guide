# Containerizing IDL with Docker

## Purpose for this guideline

This document provides a preliminary implementation of IDL in a Docker container.

## A Few Things to Note

* Although the implementation described below is only valid for IDL version 8.6 and greater, the Dockerfile could
  presumably be modified to accommodate older versions. The difference is that the network license access is different
  for IDL 8.5 and earlier versions.
* This is not the same as Docker containers that access an external IDL on the host machine or via a network connection.
* The IDL image size is approximately 3GB, which is reasonable for an IDL installation (see
  https://www.l3harrisgeospatial.com/docs/PlatformSupportTable.html). The base CentOS 8 image is only 210MB, so the IDL
  installation accounts for more than 90% of the image.
* The IDLDE image size is approximately 3.5GB because a web browser (Firefox) has to be installed to export the display.
* For a simple container deployment, there is no Docker Compose file. The container is easily generated with simple
  command-line arguments.
* Provided that the host machine has LASP VPN access (for licensing purposes), the containerized IDL should work
  directly "out of the box" (i.e., no manual post-container creation steps are required).
* Although both the IDL and IDLDE images can be built locally using the Dockerfiles below, they are also available from
  the [LASP Image Registry](lasp_docker_registry).

## Dockerfile

The Dockerfile directives consist of the IDL installation, requisite libraries, licensing configuration and the default
runtime command:

```Dockerfile
# Build from parent image https://hub.docker.com/_/ubuntu
FROM ubuntu:22.04

WORKDIR /tmp

# Install Ubuntu packages, clean up the apt cache to reduce image size
# libxpm-dev and libxmu-dev are dependencies of IDL
# https://docs.docker.com/develop/develop-images/dockerfile_best-practices/
RUN apt-get update && apt-get install -y \
  curl \
  libxpm-dev \
  libxmu-dev \
  && rm -rf /var/lib/apt/lists/*

# Download IDL package, unarchive it, remove package, perform silent install using answer file
RUN curl -O https://artifacts.pdmz.lasp.colorado.edu/repository/datasystems/idl/installers/idl87.tar.gz \
  && tar -xzf ./idl87.tar.gz && rm -f ./idl87.tar.gz \
  && sh ./install.sh -s < ./silent/idl_answer_file

# Install packages useful for development (not required by IDL, only for inspection and debugging)
RUN apt-get update && apt-get install -y \
  libncurses5-dev \
  libncursesw5-dev \
  wget \
  && rm -rf /var/lib/apt/lists/*

# Set user-friendly aliases
RUN echo 'alias idl="/usr/local/harris/idl87/bin/idl"' >> ~/.bashrc \
   && echo 'alias idl="/usr/local/harris/idl87/bin/idl"' >> ~/.bash_profile

# Necessary for network-based licensing
RUN echo 'http://idl-lic.lasp.colorado.edu:7070/fne/bin/capability' >> /usr/local/harris/license/o_licenseserverurl.txt

CMD ["/usr/local/harris/idl87/bin/idl"]
```

## Stand-alone vs Multi-functional Container

If the objective is merely to include IDL in a container with other services, such as Jenkins, gcc, git, Python, etc.,
simply add the Docker commands from this example into the relevant Dockerfile. Do not include the `FROM` or `CMD`
statements (assuming that it is not a multi-stage build) and exclude any redundant instructions (e.g., `yum install
wget`). Note that the inclusion of IDL will increase the image size by about 2.5GB.

Provided that all necessary tools and services reside in the same container, simply use IDL as with any standard
installation. **The remainder of this guideline describes the implementation of IDL in a stand-alone IDL container.**

The following issues are associated with using IDL in a stand-alone container:

* Cross-container access
* File sharing between containers
* Access from a Jenkins service
* Integration of git
* Integration of `mgunit`

## Build the Image

To build the image, first copy the Dockerfile example above into a file named `Dockerfile`. If, for any reason, it is
necessary to maintain a running background container, replace the `CMD` argument with:

```Dockerfile
CMD ["tail", "-f", "/dev/null"]
```

Execute the following command from within the directory that contains the Dockerfile to build the image:

```bash
docker image build -t <image_name> .
```

The image name (`-t` argument) can be as simple as `idl`. For clarity, the name `idl_image` (to distinguish from
`idl_container`) is used in the examples below.

## Start the container

To start the container:

```bash
docker container run -it --name=<container_name> <image_name>
```

The container name is optional and can be as simple as `idl`. If successful, an `IDL>` prompt will appear. Note that
this container `run` command is identical on all operating systems (Linux, MacOS, Windows). If the container already
exists, access will differ, and the specifics depend on whether or not the container is running. The status of all
containers can be displayed with:

```bash
docker container ls -a
```

If the container is stopped, it must be restarted before access is possible:

```bash
docker restart <container_name>
```

Because the `run` command in the example above creates a new container, it must be replaced with the `exec` command if
the container already exists. In this case, the IDL executable (with full path) must be specified as well:

```bash
docker container exec -it <container_name> /usr/local/harris/idl87/bin/idl
```

For shell access to the container (possibly necessary for debugging), add `bash` to the end of the docker container
`run` command, or replace the `/usr/local/harris/idl87/bin/idl` command with `bash` in the docker container `exec`
command.

## Host Machine Access

The following demonstrates how to utilize IDL by directly interacting with a running container. In this example, the
(optional) container name is `idl_container` and the name of the (previously created) image is `idl_image`:

```bash
(base) MacL3947:idl stmu4541$ docker container run -it --name=idl_container idl_image
IDL 8.7.3 (linux x86_64 m64).
(c) 2020, Harris Geospatial Solutions, Inc.

Licensed for use by: University of Colorado - Boulder (MAIN)
License: 100
A new version is available: IDL 8.8
https://harrisgeospatial.flexnetoperations.com
IDL> print, ((cos(45.0d*(!PI/180.0d)))^2 + (sin(45.0d*(!PI/180.0d)))^2).tostring()
1.0000000000000000
IDL> exit
(base) stmu4541@MacL3947:~/projects/docker/idl$
```

## Cross-container Access

For web applications (e.g., Nginx, MySQL, etc.), accessing one containerized service from within another container
running on the same host is trivial. Simply create a Docker network, connect both containers to that network, and the
applications will find one another via default ports with no additional configuration.

Unfortunately, this does not work for non-web applications, such as IDL (at least it hasn't yet been determined how to
make it work). The solution, however, is not too difficult. Simply bind mount the Docker socket and the Docker
executable of the host machine to the non-IDL container. These bind mounts will provide access to the Docker service
running on the host machine from within the non-IDL container.

### Example Implementation

 In this example a container is created from the official `CentOS` image:

```bash
docker container run -it --name=centos_container --rm -v /var/run/docker.sock:/var/run/docker.sock -v /usr/bin/docker:/usr/bin/docker centos bash
```

This `docker container run` command generates a CentOS container and initiates an interactive connection to that
container with a `bash` shell.

A `/ #` prompt will appear, which allows the user to execute commands from within the container. The `docker container
run` flags are:

| Flag     | Purpose                                                                                                           |
|----------|-------------------------------------------------------------------------------------------------------------------|
| --rm     | Remove the container upon exit (optional)                                                                         |
| -it      | Run the container in interactive mode (required)                                                                  |
| --name   | Assign a user-defined name to the container (optional)                                                            |
| -v       | Bind mount the host directory or file (in this case, the Docker socket and executable to the container (required) |

If the `idl_container` container is not already running, start the separately containerized IDL from within the
`centos_container` (non-IDL) container as follows (note that the `idl_image` image must already exist, see above):

```bash
docker container run -it --rm idl_image /usr/local/harris/idl87/bin/idl
```

This spins up an unnamed IDL container from the `idl_image` image that exists on the host machine (see above). Because
the Docker socket is shared between the host and the CentOS (non-IDL) container, the IDL container is accessible from
within the `centos_container`.

If the `idl_container` container is already running, access IDL from within the `centos_container` container by
replacing `run` with `exec`:

```bash
docker container exec -it idl_container /usr/local/harris/idl87/bin/idl
```

In this case, because the IDL container already exists, it is necessary to include the name of the IDL container in the
docker container `exec` command. An IDL prompt will appear.

Note that this still results in an interactive session with the IDL container, and falls short of the ultimate objective
of remote non-interactive use of the containerized IDL deployment in, for example, a Jenkins build. To achieve this, an
additional necessary step is the implementation of file sharing between containers.

## Inter-container File Sharing

This section describes the manner in which the IDL container can access files (e.g., IDL procedures or functions) that
reside in the non-IDL container. Basically, the objective is to share files between containers. This is necessary
because the non-IDL container will be responsible for the service (e.g., Jenkins) that clones or checks out the IDL
files from a source code repository.

There are two similar solutions. The preferred approach depends on whether or not it is necessary to access the files
from the host machine.

### Solution 1 -- Shared Name Volume

If there is no need to access the shared files from the host machine, the simplest solution is to create a named Docker
volume that is shared between the IDL and non-IDL containers.

Although, technically, a named volume exists on the host, it is managed by the Docker daemon and is not intended to be
accessed from the host.

#### On the Host Machine

First, create a named Docker volume:

```bash
docker volume create --name SharedData
```

Now, as in the previous example, spin up a non-IDL container based on the official `CentOS` image, but include an
additional bind mount for the newly-created data volume:

```bash
docker container run --rm -it --name=centos_container -v /var/run/docker.sock:/var/run/docker.sock -v /usr/bin/docker:/usr/bin/docker -v SharedData:/src centos bash
```

#### In the Interactive Shell Inside the `CentOS` Container

From the interactive shell, create a simple test file in the `/src` directory of the `centos_container` (non-IDL)
container. For example:

```idl
# hello_world.pro
pro hello_world
  print, 'Hello World'
end
```

Spin up an unnamed IDL container based on the previously created `idl_image` image, mount the named volume
(`SharedData`) using the `-v` option, and append the `/src/hello_world.pro` file (or `/src/hello_world`, without the
`.pro` extension, works equally well) as a command-line argument.

```bash
docker container run --rm -v SharedData:/src idl_image /usr/local/harris/idl87/bin/idl /src/hello_world.pro 2> err.txt
```

this example also includes error output redirection.

The result should be:

```bash
docker container run --rm -v SharedData:/src idl_image /usr/local/harris/idl87/bin/idl /src/hello_world.pro 2> err.txt
Hello World
```

### Solution 2 -- Host Directory Bind Mount

Here, file systems in both containers are bind mounted to a common directory on the host machine. This allows file
access directly from the host machine when necessary.

In the following example, two containers are created: an IDL container and a non-IDL container. The former will
essentially consist only of the IDL application, whereas the latter could include multiple components, such as a Jenkins
service, Python, Java, etc. In this example, however, the non-IDL container consists, as before, of a simple `CentOS`
OS.

Create an IDL container named `idl_container` from the `idl_image` image generated by the Dockerfile included above, and
include a bind mount to a directory on the host machine. In this example, the host directory is
`/Users/stmu4541/projects/docker/src`, and is bind mounted to a directory named `/src` in the IDL container:

```bash
docker container run -d -v /Users/stmu4541/projects/docker/src:/src --name=idl_container idl_image
```

The container is named `idl_container`, and the `/Users/stmu4541/projects/docker/src` directory on the host is bind
mounted to the `/src` directory in the container.

Now create the non-IDL container named `centos_container`:

```bash
docker container run --rm -it --name=centos_container -v /Users/stmu4541/projects/docker/src:/src -v /var/run/docker.sock:/var/run/docker.sock -v /usr/bin/docker:/usr/bin/docker lentos bash
```

Here, `lentos`, which immediately precedes the bash command specifies the official `centos` image.

The three bind mounts are identical to those described in Solution 1 except that the named volume mount (`SharedData`)
has been replaced by a bind mount to a directory (`/Users/stmu4541/projects/docker/src`) on the host machine.

The `/Users/stmu4541/projects/docker/src` directory on the host machine, and the `/src` directories on both containers
refer to the same file system. In other words, any file that resides in the `/Users/stmu4541/projects/docker/src` host
directory or the `/src` directory in the non-IDL container, is visible to the `/src` directory of the IDL container.

## Jenkins as the Non-IDL Container

Using a Jenkins-based principal container is not significantly different than the example above, except that the
`CentOS` image is replaced with a Jenkins image -- in this case, `jenkins/jenkins:lts-centos`, which is based on the
latest `CentOS` OS.

```bash
docker container run --name=jenkins -v /var/run/docker.sock:/var/run/docker.sock -v /usr/bin/docker:/usr/bin/docker -p 8080:8080 jenkins/jenkins:lts-centos
```

Note that a Dockerfile is not required for this simple example since the container is created from the official `CentOS`
Jenkins image (`jenkins/jenkins:lts-centos`). A Dockerfile is required only when it is necessary to install additional
tools, such as Ant, Gradle, various compilers, etc.

## Run a Containerized IDLDE and Export the Display to the Host Machine

Also, see [Export Display from Docker Container - Proof of Concept Confluence
page](https://confluence.lasp.colorado.edu/display/DS/Export+Display+from+Docker+Container+-+Proof+of+Concept) for a
general discussion of exporting a display from a Docker container.

The following steps are necessary to run a containerized IDLDE and export the display to the host machine:

1. A web browser must be installed in the container (or, ideally, as below, the image from which the container is
   generated).
2. A very short IDLDE Dockerfile is necessary to add a web browser to the IDL Image. This will create a new IDLDE image.
3. Source the `idl_setup` script during image creation.
4. The IDLDE container must be run with the `DISPLAY` environment parameter set to that of the host machine.
5. For Linux, the IDLDE container must be run with the host machine X socket bind mounted to the container.

Create a very short IDLDE Dockerfile that sources the IDL setup script and adds a Firefox web browser to the base IDL
image. Note that the base image (named `idl_image` in the following Dockerfile) must exist before this Dockerfile can be
processed (see above).

```Dockerfile
FROM idl_image
RUN source /usr/local/harris/idl/bin/idl_setup.bash \
    && /usr/bin/yum update -y \
    && /usr/bin/yum install -y firefox
CMD [ "/usr/local/harris/idl/bin/idlde" ]
```

Build the IDLDE image as follows:

```bash
docker image build -t idlde_image .
```

As always, this image build command must be run in the same directory as the relevant Dockerfile.

### Run the Containerized IDLDE

#### Pull the IDLDE Image from the LASP Image Registry

The image can be built locally using the above Dockerfiles and the `docker image build` command, or it can be obtained
from the [LASP Image Registry](lasp_docker_registry). To pull the image, log into the LASP Image Registry and use the
`pull` command:

```bash
docker pull docker-registry.pdmz.lasp.colorado.edu/tsis/idlde_centos7:latest
```

I recommend re-tagging the image for convenience (this will not create an additional copy of the image, it acts more
like a symbolic link to the same image):

```bash
docker image tag docker-registry.pdmz.lasp.colorado.edu/tsis/idlde_centos7 idlde_image
```

#### Run the Containerized IDLDE on Linux

Run the IDLDE container with the container `DISPLAY` environment parameter set to that of the host machine and bind
mount the host machine X socket to the container:

```bash
docker container run -it --rm -e DISPLAY=${DISPLAY} -v /tmp/.X11-unix:/tmp/.X11-unix idlde_image
```

#### Run the Containerized IDLDE on MacOS

The instructions for MacOS adopt a different approach than that for Linux. While there may be a more consistent
implementation to run the containerized IDLDE on both Linux and MacOS, the following steps will suffice. Note that
XQuartz must be running on the Mac.

First, `localhost` must allow X forwarding (`127.0.0.1` resolves to `localhost`):

```bash
xhost + 127.0.0.1
```

Then simply run the container with the `DISPLAY` environment parameter set to:

```bash
docker container run -e DISPLAY=host.docker.internal:0 idlde_image
```

## Useful Links

* [Official Docker documentation](https://docs.docker.com/)

## Acronyms

* **gcc** = GNU (GNU's Not Unix) Compiler Collection
* **IDL** = Interactive Data Language
* **IDLDE** = IDL Development Environment
* **MySQL** = My Structured Query Language
* **Nginx** = Engine-X
* **OS** = Operating System
* **VPN** = Virtual Private Network
* **yum** = Yellowdog Updater, Modified

*Credit: Content taken from a Confluence guide written by Steven Mueller*
