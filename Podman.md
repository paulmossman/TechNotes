**<span style="font-size:3em;color:black">Podman</span>**
***

# VM
After installation, you must start a VM:

    podman machine init --cpus 4 --now

Then run the suggested "podman-mac-helper" commands to allow Podman to use the default Docker API socket.

To stop and remove it afterwards:

    podman machine stop
    
    podman machine rm

The default machine name is "podman-machine-default".

The extracted VM image is stored (on a Mac) at:
```
~/.local/share/containers/podman/machine/applehv/<machine name>-arm64.raw
```

## Alternative to "podman-mac-helper"
```bash
PodmanSocketPath=`podman machine inspect | jq -r '.[0].ConnectionInfo.PodmanSocket.Path'`

docker context create --docker host=unix://${PodmanSocketPath} podman

docker context use podman
```