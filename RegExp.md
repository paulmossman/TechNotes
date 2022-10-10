**<span style="font-size:3em;color:black">Regular Expressions</span>**
***

# Or
```bash
grep "47.135.152.["22""50"]" <file>
47.135.152.22
47.135.152.50
```

# Repetition - match preceding token 
? → optional

\* → 0 or more

\+ → 1 or more
```bash
grep "CSeq: [0-9]* SUBSCRIBE" 
```

# Backreference - repeat a capturing group.
e.g. AWS Cognito URL must have "Region" twice, Java:
```java
// Note: The "\\1" part is the back-reference to the Region in the 
// endpoint domain name.  They must be the same.
// For example: https://cognito-idp.us-east-1.amazonaws.com/us-east-1_fgTHwGEfw
private static final Pattern COGNITO_ISSUER_URL_RE = Pattern
      .compile("https://cognito-idp\\.([a-z0-9-]+)\\.amazonaws.com/\\1_[A-Za-z0-9]+");

return COGNITO_ISSUER_URL_RE.matcher(issuer).matches();
```

# Examples

## MAC (Media Access Control) filename (without : or -)
```bash
ls . |  grep -E "^[0-9a-fA-F]{12}$"
```
The caret ^ and the dollar sign $ are metacharacters that respectively match the empty string at the beginning and end of a line.

