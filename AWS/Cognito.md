**<span style="font-size:3em;color:black">AWS Cognito</span>**
***

# CLI delete user (much faster than console)
```bash
aws cognito-idp admin-delete-user --user-pool-id ___ --username ___
```

# App clients
There are two types of AWS Cognito App clients:
- Public
- Confidential

Both types have an Client ID, which is not a secret.
Confidential clients (not Public clients) also have a "Client secret".