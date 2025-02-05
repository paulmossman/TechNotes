**<span style="font-size:3em;color:black">Docker</span>**
***

# Misc commands

## Memory and CPU usage
```bash
docker stats
```
Like Linux ```top```

## Delete all stopped containers
```bash
docker container prune
```

## History
```bash
docker history <Image Name>
```
Show the infor on each layer in the specified Docker image.

## Dangling images

i.e. Images with Name "<none>".

```bash
docker rmi $(docker images --filter "dangling=true" -q --no-trunc)
```

To avoid: Add `--rm` to `docker build`.

# Network - misc

## List available networks
```bash
docker network ls
```

## Specify a network during ```docker run```
For example:
```bash
docker run .... --network="host"
```

## Publish Port
```bash
docker run -p 8080:80 <image>
```
The first port is Docker host, the second port is Docker container.

## Add an /etc/hosts entry
```bash
docker run --add-host=example.com:10.0.0.1 --rm -it alpine grep example.com /etc/hosts
```

# Volumes
https://www.baeldung.com/ops/docker-volumes

## Mount Windows volumes
```bash
docker run -v //c/:/c --rm -it alpine ls /c
```
PostgreSQL specific:
```
docker run --rm --network=host -v "//c/:/c" postgres pg_dump --format=custom -d db_name --verbose -f "/c/tmp/dump.backup"
```
Busybox (["The Swiss Army knife of Embedded Linux"](https://en.wikipedia.org/wiki/BusyBox)):
```cmd
docker run -v //c/:/c --rm -it busybox ash # Shell
```

## Mount host `pwd`
```
docker run --rm -it -v $(pwd):/host_pwd busybox
```

# Small

## Inspect
```
docker inspect `docker ps | grep <container name> | cut -f1 -d" "` | more
```


## Run, interactive command line, delete upon exit
```bash
docker run --rm -it alpine
```

## Run, some command(s) first, then interactive command line
```bash
docker run --rm -it -v $(pwd):/host_pwd \
  ubuntu /bin/bash \
  -c 'cd /host_pwd; exec bash'
```

## Run, start ssh-agent first, then interactive command line
```bash
docker run --rm -it -v $(pwd):/host_pwd \
  jenkins/ssh-agent /bin/bash \
  -c 'eval $(ssh-agent) > /dev/null; echo $SSH_AUTH_SOCK; exec bash'
```

## Run, with name
```bash
docker run --name alpine-today --rm -it alpine
```

## Shell access
```bash
docker exec -it <mycontainer> bash
```

## Run indefinitely and detached
```bash
docker run -d alpine tail -f /dev/null
```


## Using a Docker environment variable from a command required a shell.

   Works: docker exec -it ccc sh -c 'echo $MY_ENV_VAR'
   
   Doesn't work (for various reasons): docker exec -it ccc echo $MY_ENV_VAR
   
## Get the result of a 'docker exec' command
```bash
docker exec -t -i my-container sh -c 'my-command; exit $?'
```

## Check that the docker daemon is running, and that you have permission to use it.
```
docker info > /dev/null 2>&1
if [ $? != "0" ]; then
   echo ERROR: Docker daemon is not running, and/or you\'re not in the \'docker\' group.>&2
   exit 1
fi
```

# Security

Containers are not completely isolated from their hosts (unlike VMs.)  Their atually run directly on the host, but just in their own namespace.  

# Dockerfile

## ENTRYPOINT

Like ```CMD```, except that the ```docker run``` parameters (if present) get ***appended*** to it.  If not present, then the ```CMD``` contents are used.

Overridden by ```docker```'s ```--entrypoint``` parameter.

# Architecture

## containerd

High-level industry-standard container runtime.  Implements Open Container Initiative (OCI)-compliant runtimes, between OS and Docker.

A standalone CNCF project.

Good post: https://www.docker.com/blog/containerd-vs-docker/

# Docker Hub

## Digests

Index digest vs Manifest digest

e.g. https://hub.docker.com/layers/bitwarden/self-host/2024.7.2-beta/images/sha256-746f057421a8fec924662325395d7de53d524799ee56c9dd3078336ff8e91c20?context=explore

Index digest: sha256:73ce...

Manifest digests:
- **linux/amd64**: sha256:746f...
- **linux/arm74**: sha256:20d3...
```bash
docker pull bitwarden/self-host:2024.7.2-beta
...
docker image ls --digests  bitwarden/self-host
REPOSITORY            TAG             DIGEST           IMAGE ID       CREATED       SIZE
bitwarden/self-host   2024.7.2-beta   sha256:20d3...   b5a485c3c35a   11 days ago   1.01GB
bitwarden/self-host   2024.7.2-beta   sha256:73ce...   b5a485c3c35a   11 days ago   1.01GB
```
