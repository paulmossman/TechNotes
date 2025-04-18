**<span style="font-size:3em;color:black">Miscellaneous Linux</span>**
***

# Grep

## Grep OR

Option 1: ```grep 'pattern1\|pattern2' file.txt```

Option 2 (RegExp): ```grep -E 'pattern1|pattern2' file.txt```

# Date

## Set the Date
```
date +"%d %b %Y %H:%M:%S"
sudo date -s "4 DEC 2007 13:45:00"
```
The 1st prints the current date in the format that the 2nd accepts.

## Print
YYYY-MM-DD:
```
date '+%Y-%m-%d'
```
Timestamp:
```
date '+%Y%m%d%H%M%S'
```
Time only:
```
date +%R
```

# Networking

## What process is using a port?
```bash
sudo netstat -nap | grep 0:8080
```
(This does not work under WSL.)

Package: `net-tools`

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
To install: ```yum -y install bind-utils```


## Test a TCP/UDP network connection
TCP (default):
```
nc -vzw 3 <Host> <Port>
```
Just scans for listening daemons, doesn't actually send any data (-z).
Timeout of 3s (-w).
Verbose (-v)

## Local IP4 address
Simple:
```bash
hostname -I
```

Complex:
```bash
ip address show dev eth0 | grep "inet " | cut -c10- | cut -f1 -d/
```

Also ```ifconfig``` may be an option, but it's often not installed by default.

# Scripting 

## Arbitrary path
```python
#!/usr/bin/env python
```