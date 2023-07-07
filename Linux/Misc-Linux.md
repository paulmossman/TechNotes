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
(This does not work under WSL.)

## DNS SRV - dig
Look for "ANSWER SECTION"

```bash
dig -t A <hostname>
dig -t SRV _sip._tcp.yourdomain.com
dig -t SRV _sips._tcp.yourdomain.com
dig -t SRV _sip._udp.yourdomain.com  # e.g. dig -t SRV _sip._udp.int-udp.pingtel.com

dig -x <ip_address> | grep -b1 "ANSWER SECTION" | tail -1 | cut -f3 | sed -e "s/.$//g"
 \--> Lookup a DNS name from the IP address.  (only certain shells...)
```

INSTALL: ```yum -y install bind-utils```

# Scripting 

## Arbitrary path
```python
#!/usr/bin/env python
```