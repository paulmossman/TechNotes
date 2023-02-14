**<span style="font-size:3em;color:black">WSL</span>**
***

# Basic commands

   List running distros
   wsl --list --running

   List available Linux distributions
   wsl --list --online
   
   Install a specific Linux distribution
   wsl --install --distribution <Distribution Name>
   
   Terminae a running distro
   wsl --terminate ____

# With Windows...

## Access WSL content from Windows Explorer
The ```/``` directory in the WSL shell is this path under Windows:
```
\\wsl$\Ubuntu-20.04
```

Easy way to open the WSL shell's ```pwd``` in Windows Explorer:
```bash
explorer.exe .
```

## Access regular Windows filesystem drives from WSL
```bash
cd /mnt/c/
```


# Password-less sudo
```bash
echo "`whoami` ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/`whoami` && sudo chmod 0440 /etc/sudoers.d/`whoami`
```

# Change default user
Changes the users that's is logged in upon launching a new WSL shell.
Useful for assuming root user to reset the regular user's password (for using 'sudo'.)
From Windows cmd:
```shellscript
ubuntu2004 config --default-user root
```

# Docker command-line
It requires WSL version 2.  Otherwise you get:
```bash
docker: Cannot connect to the Docker daemon at unix:///var/run/docker.sock. Is the docker daemon running?
```
AND in Docker -> Settings - Resources: "Enable integration" for your distro.

# Links
   
   https://docs.microsoft.com/en-us/windows/wsl/basic-commands
   
   