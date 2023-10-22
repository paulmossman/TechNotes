# Equivalent to Linux /etc/hosts

Notepad --> Open as Administrator

File -> Open, and navigate to C:\Windows\System32\drivers\etc

Change the file type from *.txt to *.*, then open `hosts`.

Save.

NOTE: These entries don't affect ```nslookup```.  (But they do affect ```ping```, ```nc```, etc.)