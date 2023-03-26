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

# Dangling images

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
docker run .... -p 8080:80
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


# Small

## Run, interactive command line, delete upon exit
```bash
docker run --rm -it alpine
```

## Run, with name
```bash
docker run --name alpine-today --rm -it alpine
```

## Shell access
```bash
docker exec -it <mycontainer> bash
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