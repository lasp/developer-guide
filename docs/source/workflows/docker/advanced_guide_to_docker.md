# Advanced Docker Topics

## How Docker Works

### The Linux Host (Usually a VM)

Docker and its underlying container orchestration system fundamentally only runs on Linux. If you are using a Mac or
Windows machine, your Docker system is running on a VM. On Windows this VM is usually Windows Subsystem for Linux (WSL)
and on Mac this is usually the Docker Desktop-managed VM or a Colima VM.

The container runtime and Docker system run on this VM host, which forwards the docker socket (`docker.sock`) through to
your host system to allow you to use Docker commands in your host terminal. All the containers themselves are created on
the VM filesystem.

### The Container Runtime

Most container orchestration systems run on `containerd`, a low level container orchestration layer that provides the
foundation for other tools to manage and work with containers in a standard way. The containerd project was originally
started by Docker but has been donated open source.

### The CLI and Middle Layers

Docker is one of many CLI tools that can interact with containerd to build and run containers. Another popular tool is
`nerdctl`. Different tools have different levels of "middleware" that sit between the CLI and the containerd runtime.
For example, Docker uses the open source Moby software as a middle layer between the Docker CLI and containerd to
organize containers. Other tools interact with containerd directly.

## Advanced Configuration

### Running Containers Inside Containers

It is common, especially when using [devcontainers](developing_in_devcontainers.md), that you might need to build
and run a docker container inside another docker container.

> [!CAUTION]
> Neither DooD nor DinD is secure. DooD compromises the Linux host by allowing full filesystem access to the nested
> containers and DinD compromises the host by elevating the container's system capabilities, allowing it to wreak havoc
> on the Linux host.

_See below for suggestions to isolate your host filesystem from your Linux VM._

#### Docker Outside of Docker (DooD)

In this model, all containers run on a Linux host with a docker daemon running. When containers are launched, the Linux
host's docker.sock is mounted into the container, allowing the Docker CLI inside the container to interact with the
host's Docker daemon.

This means that all containers are sharing the same docker.sock and therefore the same docker context. For example, if
you are running two containers and one builds a docker image, the other container can see that image!

Pros:

- Containers do not need any additional privileges to manage a docker daemon at the system level
- Simple - just forward the docker.sock into the container

Cons:

- Container has control over the host Docker daemon
- Poor isolation between running containers - docker builds can interfere because they share a daemon
- Poor isolation from the VM host - nested containers can bind mount any directory on the Linux host because they are
  using the host daemon and filesystem

#### Docker In Docker (DinD)

In this model, containers install a full Docker daemon internally. The container has its own docker daemon and is
entirely segregated from the host's daemon when building nested containers. Typically DinD containers store their docker
data in a Docker Volume to improve performance. This volume exists in the Linux Host's Docker system.

Pros:

- Isolation of Docker daemons - containers don't share the docker.sock
- Isolation from Linux host filesystem - containers can't use nested containers to access host filesystem

Cons:

- Complicated - Each container comes with a Volume to store docker data and a full docker daemon running inside the
  container
- Elevated system permissions required - to manage the docker daemon, DinD containers require additional system level
  permissions not usually granted to a container

### Securing Your Data

_This is always best practice but is essential if you are running docker in docker or docker outside of docker._

Because Docker containers run only on the Linux host (usually VM), they only have access to the Linux filesystem. This
is good but to make Docker more beginner friendly, most VM solutions (e.g. Docker Desktop and Colima) default to
mounting your entire home directory into your Linux VM, giving your Docker containers access to all your files. If
you've ever wondered how a Docker container isolated to a Linux VM can bind-mount a directory on your Mac, this is what
makes that work seamlessly. In fact, the VM defaults to mounting your home directory to exactly the same path, so while
it _seems_ like your bind-mount commands reflect your host filesystem, they really reflect the path inside the VM.

```
Mac Filesystem -> Linux VM -> Docker Container
```

Don't accept this default! Choose exactly what data your Docker containers should be able to access by limiting what
your Linux VM is allowed to mount. Remember that the bind-mount path you give to your containers is really the path to
the data _inside the Linux VM_.

