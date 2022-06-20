**<span style="font-size:3em;color:black">Miscellaneous Linux</span>**
***

# Date

## Set the Date
```
date +"%d %b %Y %H:%M:%S"
sudo date -s "4 DEC 2007 13:45:00"
```
The 1st prints the current date in the format that the 2nd accepts.

## Print YYYY-MM-DD
```
date '+%Y-%m-%d'
```

# Networking

## What process is using a port?
```bash
sudo netstat -nap | grep 0:8080
```
