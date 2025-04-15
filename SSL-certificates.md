# SSL Certificates

## $SERVER's port 443...

### Examine an SSL certificate from a server
```bash
SERVER=... ; echo | openssl s_client -showcerts -servername $SERVER -connect $SERVER:443 2>/dev/null | openssl x509 -inform pem -noout -text
```
See: https://www.openssl.org/

### Contents of a certificate file (e.g. CA)
Java keytool:
```bash
keytool -printcert -v -file __.pem
```
openssl (PEM):
```bash
openssl x509 -text -in __.pem
```

openssl (PFX):
```bash
openssl pkcs12 -info -in __.pfx
# OR
openssl pkcs12 -info -legacy -in __.pfx 
```

### Examine SSL Ciphers supported
#### nmap tool
See: https://nmap.org/
```bash
nmap --script ssl-enum-ciphers -p 443 $SERVER
```
#### SSL Labs scan
See: https://www.ssllabs.com/ssltest/


## Extended Validation

https://en.wikipedia.org/wiki/Extended_Validation_Certificate#Removal_of_special_UI_indicators - Browsers no longer surface this indicator.  (Used to be green bars in the URL box.)  It's no longer best practice.  See also - https://duo.com/decipher/chrome-and-firefox-removing-ev-certificate-indicators

Note that TLS certificate vendor's websites use them.  But they also make money by selling this add-on.

## Very Basic Self-signed SSL Certificate
```
openssl genrsa -out s.key 2048
openssl req -new -key s.key -out s.csr -subj "/CN=example.com"
openssl x509 -req -days 365 -in s.csr -signkey s.key -out s.crt
```
But when imported as a CA, it's not trusted by Chrome.

