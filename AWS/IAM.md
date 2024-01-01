**<span style="font-size:3em;color:black">IAM</span>**
***

Note: https://medium.parttimepolymath.net/no-more-aws-access-keys-13a3c3f2337a

# Permissions

## Useful Read-only

AWS managed:
- ```IAMUserChangePassword```
- ```ReadOnlyAccess```

Inline ```AllowManageOwnSecurityCredentials```:
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowViewAccountInfo",
            "Effect": "Allow",
            "Action": [
                "iam:GetAccountPasswordPolicy",
                "iam:GetAccountSummary"
            ],
            "Resource": "*"
        },
        {
            "Sid": "AllowManageOwnPasswords",
            "Effect": "Allow",
            "Action": [
                "iam:ChangePassword",
                "iam:GetUser"
            ],
            "Resource": "arn:aws:iam::*:user/${aws:username}"
        },
        {
            "Sid": "AllowManageOwnAccessKeys",
            "Effect": "Allow",
            "Action": [
                "iam:CreateAccessKey",
                "iam:DeleteAccessKey",
                "iam:ListAccessKeys",
                "iam:UpdateAccessKey"
            ],
            "Resource": "arn:aws:iam::*:user/${aws:username}"
        },
        {
            "Sid": "AllowManageOwnSSHPublicKeys",
            "Effect": "Allow",
            "Action": [
                "iam:DeleteSSHPublicKey",
                "iam:GetSSHPublicKey",
                "iam:ListSSHPublicKeys",
                "iam:UpdateSSHPublicKey",
                "iam:UploadSSHPublicKey"
            ],
            "Resource": "arn:aws:iam::*:user/${aws:username}"
        }
    ]
}
```

Inline ```AllowManageOwnMFA``` (if you use MFA): See [AWS: Allows MFA-authenticated IAM users to manage their own MFA device on the My Security Credentials page](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_examples_aws_my-sec-creds-self-manage-mfa-only.html).  But remove the ```DenyAllExceptListedIfNoMFA``` Sid if you need Access Keys operations to work.  (i.e. cmd-line and/or SDK, which don't use MFA.)

# Assume Admin in an account created under AWS Organizations

Works for just about everything, except closing the account and re-setting the root password.

Only works for AWS accounts that have the ```OrganizationAccountAccessRole``` defined, as is the default when **created** by AWS Organizations.  (i.e. Not accounts that were created independently, and then **join** the Origanization.)

From the AWS Console, the steps:

## Create an IAM Policy (once):

Select a Service: STS, then click on "STS"

Action: "AssumeRole"

Resources: "Specific", then click on "AddArn"

- "Other account" should be selected by default
- Enter the Account Number
- Resource role name with path: ```OrganizationAccountAccessRole```
- Click "Add ARNs"

Click "Next"

Policy name: e.g. ```GrantAccessToOrganizationAccountAccessRole-<AWS Account #>```

Click "Create policy"

## Assume the Role (each time you need to access the account):

From the upper right drop-down, click "Switch role"

- Account: The AWS Account Number
- Role: ```OrganizationAccountAccessRole```
- Pick and note a colour

Click "Switch Role"

The upper right drop-down will now identify the Role that's assume and the Account #, and in the selected colour.

When done, upper right drop-down "Switch back".
