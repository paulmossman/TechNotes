**<span style="font-size:3em;color:black">jq</span>**
***
It's like sed for JSON data.

See also:
- [Tutorial](https://stedolan.github.io/jq/tutorial/)
- [Manual](https://stedolan.github.io/jq/manual/)
- [Try Online](https://jqplay.org/)

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
This is also an example of [String interpolation](https://stedolan.github.io/jq/manual/#Stringinterpolation-%5C(foo)), which can be used to print two values on one line.

Example:
```bash
aws cloudformation describe-stacks | jq -r '.Stacks[] | select(.StackName=="Todays-Stack-Name")'
aws cloudformation describe-stacks --stack-name Todays-Stack-Name | jq -r '.Stacks[0]'
```

Example:
```bash
aws ec2 describe-instances --output json | \
   jq -r '.Reservations[].Instances | "Instance ID: \(.[0].InstanceId)  State: \(.[0].State.Name)  Public FQDN: \(.[0].NetworkInterfaces[0].Association.PublicDnsName)" '
```


## Select an array element by one of the object's values
Exact match:
```bash
$ echo { \"array\": [{\"id\": \"A\"},{\"id\": \"B\"}]} | jq '.array[] | select(.id=="A")'
{
  "id": "A"
}
```
Contains:
```bash
$ echo { \"array\": [{\"id\": \"AA\"},{\"id\": \"AB\"},{\"id\": \"BA\"}]} | jq '.array[] | select(.id | contains("B"))'
{
  "id": "AB"
}
{
  "id": "BA"
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

## Get the value of one attribute from every element in an array
```bash
echo { \"array\": [{\"id\": \"A\"},{\"id\": \"B\"},{\"id\": \"C\"}]} | jq '.array[] | .id' -r
A
B
C
```

## Manipulate JSON

See also: https://geeksocket.in/posts/manipulate-json-jq/

### Change an existing attribute's value
```bash
echo { \"array\": [{\"id\": \"A\", \"example\": \"bad value\"},{\"id\": \"B\", \"example\": \"good\"}]} | jq '(.array[] | select(.id=="A")).example = "replaced good"'
{
  "array": [
    {
      "id": "A",
      "example": "replaced good"
    },
    {
      "id": "B",
      "example": "good"
    }
  ]
}
```

### Add an attribute
Same syntax as changing an existing attribute, but it will add.
```bash
echo { \"array\": [{\"id\": \"A\"},{\"id\": \"B\"}]} | jq '(.array[] | select(.id=="A")).note = "The first letter"'
{
  "array": [
    {
      "id": "A",
      "note": "The first letter"
    },
    {
      "id": "B"
    }
  ]
}
```
