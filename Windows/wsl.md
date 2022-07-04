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

# Root location on Windows
The ```/``` directory in the WSL shell is this path under Windows:
```
\\wsl$\Ubuntu-20.04
```

Easy way to open the WSL shell's ```pwd``` in Windows Explorer:
```bash
explorer.exe .
```

# Links
   
   https://docs.microsoft.com/en-us/windows/wsl/basic-commands
   
   