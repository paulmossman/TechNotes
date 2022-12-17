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

## List the ID and Name of all User Pools
```bash
aws cognito-idp list-user-pools --max-results 60 | jq -r '.UserPools[ ] | .Id+" - "+.Name'
```


# S3

Note: s3 vs s3api.  The s3 tool does not support the ```--output``` option.

## Cat an S3 text file's contents to stdout
```bash
s3 cp s3://mybucket/stream.txt -
```

## Block all public access (at the Bucket level)
```bash
aws s3api put-public-access-block \
    --bucket bucket-name \
    --public-access-block-configuration "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"
```

## sync (source → destination)

Pull all files (and sub-contents) in the specified S3 folder to local ```pwd```:
```bash
aws s3 sync s3://bucket-name .
```

## Delete a bucket and contents
Empty the bucket:
```bash
aws s3 rm s3://bucket-name --recursive
```
Without ```--recursive``` the ```rm``` command will silently fail on non-empty buckets.

Then delete the bucket:
```bash
aws s3 rb s3://bucket-name
```

Together:
```bash
REMOVE_BUCKET=s3://bucket-name
aws s3 rm ${REMOVE_BUCKET} --recursive ; aws s3 rb ${REMOVE_BUCKET}
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