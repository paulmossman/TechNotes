**<span style="font-size:3em;color:black">AWS CLI</span>**
***

[AWS CLI Command Reference](https://awscli.amazonaws.com/v2/documentation/api/latest/index.html)

# Global Options
```
--output text | json | yaml | <others>
```

# Miscellanous Commands

## Montly costs
```bash
aws ce get-cost-and-usage --time-period Start=2022-03-01,End=2022-04-01 --granularity MONTHLY --metrics BlendedCost
```

## Get Account Info

### ID
```bash
aws sts get-caller-identity | jq -r ".Account"
```

### Username
```bash
aws sts get-caller-identity | grep Arn
```

# Cognito
Why not simply ```cognito``` I don't know...
```bash
aws cognito-idp help
```

# S3

Note: s3 vs s3api

## sync (source --> destination)

Pull all files (and sub-contents) in the specified S3 folder to local ```pwd```:
```
aws s3 sync <S3 URI of folder> .
```

# EC2

## User Data
Note: It's Base64 encoded...
```bash
aws ec2 describe-instance-attribute --instance-id ___ --attribute userData
aws ec2 describe-launch-template-versions ---launch-template-name ___ --versions 1 | jq '.LaunchTemplateVersions[0].LaunchTemplateData.UserData'
```

# ECS

## Search for a string ("password") 'environment' JSON of all Task Definitions
```bash
tds=`aws ecs list-task-definitions | jq -cr '.taskDefinitionArns[]'`
for td in ${tds}; do echo "$td" ; aws ecs describe-task-definition --task-definition "$td" | jq '.taskDefinition.containerDefinitions[0].environment' | grep -i password; done
```