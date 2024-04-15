**<span style="font-size:3em;color:black">AWS CLI</span>**
**<span style="font-size:3em;color:black">AWS CLI</span>**
***

[AWS CLI Command Reference](https://awscli.amazonaws.com/v2/documentation/api/latest/index.html)

# Global Options
```
--output text | json | yaml | <others>
```

# Miscellanous Commands

## Monthly costs
Requires user to be enabled for cost explorer access.

Note the Start and End dates.  The End date is not included in the results.

Monthly total:
```bash
aws ce get-cost-and-usage --time-period Start=2022-03-01,End=2022-04-01 --granularity MONTHLY --metrics BlendedCost
```

One service for one day:
```bash
aws ce get-cost-and-usage --profile fp-RO-PROD --time-period Start=2022-03-01,End=2022-03-02 --granularity DAILY --metrics BlendedCost --filter '{"Dimensions": {"Key":"SERVICE", "Values": ["Amazon Relational Database Service"]}}' | jq -r '.ResultsByTime[0].Total.BlendedCost.Amount'
```


## Get Account Info

### ID
```bash
aws sts get-caller-identity --output json | jq -r ".Account"
```

### Username
```bash
aws sts get-caller-identity --output json  | grep Arn
```

# AWS CLI/SDK Profiles - ```configure```

## List profiles
```bash
aws configure list-profiles
```

## Add/update a profile
```bash
aws configure --profile easy-aws-privacy-vpn
```

From a script:
```bash
cat << EOF | aws configure --profile easy-aws-privacy-vpn
${AccessKeyId}
${SecretAccessKey}
ca-central-1
json
EOF
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

# VPC

## Show all resources in a Subnet
```bash
aws ec2 describe-network-interfaces --filters Name=subnet-id,Values=${SUBNET} | grep Description
```

## Security Groups

### Show all Security Groups (in the specified VPC) with an egress rule containing "0.0.0.0/0"
```bash
aws ec2 describe-security-groups --filters Name=vpc-id,Values=${VPC_ID} --output json | jq -r '.SecurityGroups[] | select(.IpPermissionsEgress[].IpRanges[].CidrIp == "0.0.0.0/0") | "\(.GroupId) \(.GroupName) \(.Description)"'
```

### Show all Network Interfaces the use the specified Security Group
```bash
aws ec2 describe-network-interfaces --filters Name=group-name,Values=${SECURITY_GROUP_NAME} --output json | jq -r '.NetworkInterfaces[] | "\(.NetworkInterfaceId) \(.Attachment.InstanceOwnerId) \(.Description)"'
```

### 'Security group game' (GroupName) vs. 'Name' (Tag with Key=="Name")
```bash
aws ec2 describe-security-groups --output json | jq -r '.SecurityGroups[] |  select(.Tags!=null) | "\(.GroupName) \(.Tags[] | select(.Key == "Name") | .Value)"' 
```
Note: This only list those that have a Tag whose Key is "Name", which is optional.

### Manipulate Security Group Rules

#### Egress/Ingress
e.g. HTTPS, by CIDR
```bash
aws ec2 authorize-security-group-egress --profile ${PROFILE} --region ${REGION} --group-id ${SG} --ip-permissions \
   IpProtocol=tcp,FromPort=443,ToPort=443,IpRanges='[{CidrIp=0.0.0.0/0,Description="Allow HTTPS"}]'

aws ec2 revoke-security-group-egress --profile ${PROFILE} --region ${REGION} --group-id ${SG} --ip-permissions \
   IpProtocol=tcp,FromPort=443,ToPort=443,IpRanges='[{CidrIp=0.0.0.0/0}]'
```
e.g. SSH, by Security Group
```bash
aws ec2 authorize-security-group-egress --profile ${PROFILE} --region ${REGION} --group-id ${SG} --ip-permissions \
   IpProtocol=tcp,FromPort=22,ToPort=22,UserIdGroupPairs="[{GroupId=${SG},Description=\"Allow SSH from within the SG\"}]"
```

# EC2

## Get the ID and Public FQDN of all EC2 instances
```bash
aws ec2 describe-instances --output json | \
   jq -r '.Reservations[].Instances[] | "Instance ID: \(.InstanceId)  State: \(.State.Name)  Public FQDN: \(.NetworkInterfaces[0].Association.PublicDnsName)" '
```
Running only:
```bash
aws ec2 describe-instances --output json | \
   jq -r '.Reservations[].Instances[] | select(.State.Name=="running") | "Instance ID: \(.InstanceId)  Public FQDN: \(.NetworkInterfaces[0].Association.PublicDnsName)" '
```

## Check if v2 is required for accessing instannce metadata
Check all instances in a specific Region:
```bash
PROFILE=default
INSTANCE_IDS=`aws ec2 describe-instances --profile ${PROFILE} --region=us-east-1 | jq -r '.Reservations[].Instances[] | select(.State.Name=="running") | .InstanceId'`
for INSTANCE_ID in ${INSTANCE_IDS}; do
   echo -n "$INSTANCE_ID - " 
   aws ec2 describe-instances --instance-ids ${INSTANCE_ID} --query "Reservations[].Instances[].{HttpEndpoint:MetadataOptions.HttpEndpoint,HttpTokens:MetadataOptions.HttpTokens}" --region us-east-1 --profile ${PROFILE} | jq '.[].HttpTokens'
done
```

## Launch an EC2 Instance with a Name and Public IP
```bash
aws ec2 run-instances --profile=${PROFILE} \
   --image-id ${AMI_ID} \
   --instance-type t2.micro \
   --key-name ${KEY_NAME} \
   --region us-east-1 \
   --security-group-ids ${SECURITY_GROUP} \
   --subnet-id ${SUBNET} \
   --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${NAME}}]" \
   --associate-public-ip-address
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

# SSM

## Get the latest ID of a particular AWS AMI
```bash
aws ssm get-parameter --name /aws/service/ami-amazon-linux-latest/al2023-ami-kernel-6.1-x86_64 --query "Parameter.Value"
```

ECS-optimized specifically:
```bash
aws ssm get-parameters --names /aws/service/ecs/optimized-ami/amazon-linux-2/recommended/image_id --query "Parameters[]" | jq -r '.[] | .Value'
```

# ACM

## Delete a certificate by name
```bash
delete_acm_certificate_by_name () {

    CERT_NAME=$1

    CERT_ARN_OUTPUT=`aws acm list-certificates --query "CertificateSummaryList[?DomainName=='${CERT_NAME}'].CertificateArn"  --output json`
    
    echo ${CERT_ARN_OUTPUT} | grep "\[\]"
    RESULT=$?
    if [[ "$RESULT" == "0" ]]; then
        echo "ERROR: Failed to find an ACM certificate named: ${CERT_NAME}" >&2
    else
        CERT_ARN=`echo ${CERT_ARN_OUTPUT} | jq -r '.[0]'`
        aws acm delete-certificate --certificate-arn ${CERT_ARN}
        RESULT=$?
        if [ ${RESULT} != "0" ]; then
            echo "ERROR: Failed to delete ACM certificate: ${CERT_ARN}" >&2
        fi
    fi
}

delete_acm_certificate_by_name "example.certificate.name"
```