**<span style="font-size:3em;color:black">jq</span>**
***
It's like sed for JSON data.

# Miscellaneous

## Simple pretty-print
```bash
cat tmp.json | jq '.'
```

## Omit double-quotes from outputted values
```
-r
```

## Array entries output onto a single line (--compact-output)
```bash
aws ecs list-task-definitions | jq -c '.taskDefinitionArns[]'
```

## Useful with AWS CLI output
http://stackoverflow.com/questions/22704831/using-jq-to-parse-json-output-of-aws-cli-tools

Example:
```bash
aws rds describe-db-instances | jq ' .DBInstances[] | .DBInstanceIdentifier,.DBInstanceClass,.Endpoint.Address'
```

Example:
```bash
aws ec2 describe-subnets | jq -r '.Subnets[] | "\(.AvailabilityZone) - \(.DefaultForAz)"'
```

Example:
```bash
aws cloudformation describe-stacks | jq -r '.Stacks[] | select(.StackName=="Todays-Stack-Name")'
aws cloudformation describe-stacks --stack-name Todays-Stack-Name | jq -r '.Stacks[0]'
```


## Select an array element by one of the object's values
```bash
$ echo { \"array\": [{\"id\": \"A\"},{\"id\": \"B\"}]} | jq '.array[] | select(.id=="A")'
{
  "id": "A"
}
```

## Get the first/last element of an array
```bash
 echo { \"array\": [{\"id\": \"A\"},{\"id\": \"B\"},{\"id\": \"C\"}]} | jq '.array | first,last'
{
  "id": "A"
}
{
  "id": "C"
}
```

## How to manipulate JSON using jq
https://geeksocket.in/posts/manipulate-json-jq/