**<span style="font-size:3em;color:black">EC2</span>**
***

# Metadata

## From an EC2 instance
v1:
```bash
curl http://169.254.169.254/latest/meta-data/instance-id  && echo ""
```

v2: 
```bash
TOKEN=`curl -s -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"` && curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id && echo ""
```

## AWS CLI
```bash
PROFILE=default
INSTANCE_ID=i-___
aws ec2 describe-instances --instance-ids ${INSTANCE_ID} --query "Reservations[].Instances[].{HttpEndpoint:MetadataOptions.HttpEndpoint,HttpTokens:MetadataOptions.HttpTokens}" --region us-east-1 --profile ${PROFILE}
```
HttpEndpoint: Enabled means HAS metadata access
HttpTokens: Optional means v1 can be used.  Required means v2 only.  ("IMDSv1 credentials are not available")

### Check for v1 vs. v2 on all EC2 instances in a Region
```bash
PROFILE=default
REGION=us-east-1
INSTANCE_IDS=`aws ec2 describe-instances --profile ${PROFILE} --region=${REGION} | jq -r '.Reservations[].Instances[] | select(.State.Name=="running") | .InstanceId'`
for INSTANCE_ID in ${INSTANCE_IDS}; do
   echo -n "$INSTANCE_ID - " 
   aws ec2 describe-instances --instance-ids ${INSTANCE_ID} --query "Reservations[].Instances[].{HttpEndpoint:MetadataOptions.HttpEndpoint,HttpTokens:MetadataOptions.HttpTokens}" --region ${REGION} --profile ${PROFILE} | jq '.[].HttpTokens'
done
```
