# Developing in Devcontainers

A devcontainer is a Docker container that contains your code and development environment. Most modern IDEs support
connecting to a devcontainer for development. This allows you to develop against a stable environment that is not
dependent on the configuration of the rest of your host system.

Devcontainers are extremely flexible and can be configured in many ways via `devcontainer.json`, from running in Github
Codespaces to bind-mounting your repo directory, to cloning a repo into a dedicated Docker volume.

## Bind-Mounting Code

You can configure your devcontainer to simply bind-mount a directory from the Linux VM (usually mounted into the VM
from your host filesystem). This is the simplest way to work on code in a devcontainer but it comes with some downsides.

Pros:

- Dead simple. Just configure the devcontainer to bind-mount the directory.

Cons:
- Requires you to first mount the directory into your Linux VM running Docker (see [Advanced Docker
  Configuration](advanced_guide_to_docker.md) for more details on why this is a bad idea).
- Bind-mounts are slow because file system changes are propataged through layers of OS translation from container, to
  VM, to host.


## Volume-Mounting Code

Alternatively, you can store your repo code (or really anything you want to work on) inside a Docker volume that lives
entirely inside the Linux VM. Some IDEs (e.g. VSCode) actually provide a UI for this workflow, which clones a remote
repository into a volume and then mounts that volume into a devcontainer. If the repo you clone contains a
`.devcontainer/devcontainer.json` file, it uses that configuration. If the repo does not come with a devcontainer
configuration, VSCode will prompt you to create one.

Pros:

- Fast! Volumes do not require OS filesystem layer translation so everything will feel snappier
- Better isolation from host. You can avoid mounting your host filesystem into your Linux VM.

Cons:

- Ephemeral. If you delete your docker volume, your repo is gone. This may not be a problem if you push everything to a
  git remote but any .gitignored files will be gone.
- Less flexible. You don't get free access to your host filesystem. You only get your repo.


## SSH and GPG Keys

In pretty much any dev environment, you need access to SSH keys and GPG keys for authenticating with repositories
and signing commits. But usually, these keys live on your host machine and it's bad practice to be copying
keys around.

Luckily, in much the same way that Docker forwards `docker.sock` through to your host system, you can forward your
SSH auth socket into your Linux VM as well as your GPG agent socket. In Colima this is as simple as setting
`forwardAgent: true` in your `colima.yaml` configuration. VSCode will automatically pick these up and provide
access to your SSH keys and GPG keys inside your devcontainer.
