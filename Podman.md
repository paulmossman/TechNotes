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

[The Docker images registry for the Podman machine.](https://quay.io/repository/podman/machine-os?tab=tags)
For example, use an older one:
```bash
podman machine init --image docker://quay.io/podman/machine-os:5.0 --cpus 4 --now 
```

How to check the version of the Podman machine:
```bash
podman machine ssh
...
rpm-ostree status
```
(Shows the version.)

## Mac: Uses Apple's virtualization
Hypervisor
```
/opt/homebrew/Cellar/podman/5.1.1/libexec/podman/vfkit
```
https://github.com/crc-org/vfkit

https://github.com/crc-org/vfkit/blob/main/doc/usage.md

```vfkit``` is the process that runs the VM.  The VM terminates when the process exits.


## Alternative to "podman-mac-helper"
```bash
PodmanSocketPath=`podman machine inspect | jq -r '.[0].ConnectionInfo.PodmanSocket.Path'`

docker context create --docker host=unix://${PodmanSocketPath} podman

docker context use podman
```