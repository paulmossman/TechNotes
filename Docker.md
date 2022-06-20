**<span style="font-size:3em;color:black">Docker</span>**
***

# Misc commands

## Memory and CPU usage
```bash
docker stat
```
Like Linux ```top```

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

# Small

## Using a Docker environment variable from a command required a shell.

   Works: docker exec -it ccc sh -c 'echo $MY_ENV_VAR'
   
   Doesn't work (for various reasons): docker exec -it ccc echo $MY_ENV_VAR
   
## Get the result of a 'docker exec' command
```bash
docker exec -t -i my-container sh -c 'my-command; exit $?'
```

