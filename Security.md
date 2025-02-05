# Security

## OWASP Cheatsheet Series

   https://cheatsheetseries.owasp.org/index.html

## User enumeration attack (e.g. via "Forgot Password?")

   https://cheatsheetseries.owasp.org/cheatsheets/Forgot_Password_Cheat_Sheet.html - CWE-200

## Principle of least privilege

   https://en.wikipedia.org/wiki/Principle_of_least_privilege

## Security Scans

Useful reference: https://badssl.com  (Note: https://github.com/chromium/badssl.com/issues/488)

### Web-based (Must be internet accessible)

https://www.ssllabs.com/ssltest/ is a good site for testing TLS protocol/ciphers.

https://securityheaders.com/ is a good site for testing security headers.

### Tools (Can be run locally)

https://github.com/rbsec/sslscan - TLS protocol/ciphers
```bash
make docker
docker run --rm -ti sslscan:sslscan /sslscan <URL>
```


## Common Weakness Enumberation (CWE)

For example:
- [CWE-321: Use of Hard-coded Cryptographic Key](https://cwe.mitre.org/data/definitions/321.html )
- [CWE-200: Exposure of Sensitive Information to an Unauthorized Actor](https://cwe.mitre.org/data/definitions/200.html)

## Have I Been Pwned? (affected by a data breach)

https://haveibeenpwned.com/