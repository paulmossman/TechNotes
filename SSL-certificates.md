# SSL Certificates

## Examine an SSL certificate from a $SERVER's port 443
```
echo | openssl s_client -showcerts -servername $SERVER -connect $SERVER:443 2>/dev/null | openssl x509 -inform pem -noout -text
```


## Extended Validation

https://en.wikipedia.org/wiki/Extended_Validation_Certificate#Removal_of_special_UI_indicators - Browsers no longer surface this indicator.  (Used to be green bars in the URL box.)  It's no longer best practice.  See also - https://duo.com/decipher/chrome-and-firefox-removing-ev-certificate-indicators

Note that TLS certificate vendors use them, because they make extra money by selling this add-on.