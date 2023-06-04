**<span style="font-size:3em;color:black">PuTTY</span>**
***

# General

https://www.chiark.greenend.org.uk/~sgtatham/putty/   (Not https://www.putty.org/)

# Backup / Restore
Backup:
```
regedit /e "%userprofile%\<path>\putty-registry.reg" HKEY_CURRENT_USER\Software\Simontatham
```
Execute ```putty-registry.reg``` to restore the settings.
