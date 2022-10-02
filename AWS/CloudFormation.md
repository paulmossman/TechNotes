**<span style="font-size:3em;color:black">CloudFormation</span>**
***

[Template Reference](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/template-reference.html)

# Command-line

## Launch
```bash
aws cloudformation create-stack --stack-name <Stack Name> \
   --template-body "file://./TemplateFile.yml" \
   --parameters \
      ParameterKey=Param1,ParameterValue="Param1Value" \
   --profile ${PROFILE}
```

But ```--template-body``` doesn't support files over a certain size.  Beyond that size you need to use ```--template-url```.

### --template-url <HTTP URL>
Even though the template must be in AWS S3 (or AWS Systems Manager), ```s3://``` doesn't work.  It needs to be ```https://``` or ```http://```.  If you use an S3 URI you'll get the following unhelpful error:
```bash
An error occurred (ValidationError) when calling the CreateStack operation: S3 error: Domain name specified in <S3 bucket name> is not a valid S3 domain
```
Note that the template does **not** need to be publicly HTTP accessible.

### Wait for Stack Creation
```bash
wait_stack_create_complete () {

   STACK_NAME=$1

   aws cloudformation wait stack-create-complete --stack-name ${STACK_NAME} --profile ${PROFILE}
   WAIT_STATUS=$?
   if [ $WAIT_STATUS -ne 0 ]; then
       echo "ERROR: Failed '${STACK_NAME}' wait" >&2
       exit $WAIT_STATUS
   fi

   echo -n "Stack '${STACK_NAME}' status: "
   aws cloudformation describe-stacks --profile ${PROFILE} --stack-name ${STACK_NAME} | jq -r ".Stacks[0].StackStatus"
}

check_createstack_status_and_wait () {

   CREATE_STATUS=$1
   STACK_NAME=$2

   if [ $CREATE_STATUS -ne 0 ]; then
       echo "ERROR: Failed to create stack '${STACK_NAME}'" >&2
       exit $CREATE_STATUS
   fi

   wait_stack_create_complete ${STACK_NAME}
}
```

## Use jq to get Output values
All (JSON):
```bash
aws cloudformation describe-stacks --stack-name <Stack Name> | jq -r '.Stacks[0].Outputs[]'
```
One (just the value):
```bash
aws cloudformation describe-stacks --stack-name <Stack Name> | jq -r '.Stacks[0].Outputs[] | select(.OutputKey == "<Output Key>") | .OutputValue'
```


# Parameters
https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/parameters-section-structure.html


## Use a Parameter
Alone:
```yaml
Ref: <Parameter Name>
```

Into a String:
```yaml
   !Sub ${<Parameter Name>} the rest of the string...
```

# String Substitution / Join Strings
```yaml
   !Join [ delimiter, [ comma-delimited list of values ] ]
```
"delimitor" is often a blank string.
For example:
```yaml
   !Join [ delimiter, [ comma-delimited list of values ] ]
```

# Psuedo Parameters Reference

Region, Account ID, Stack Name, etc

https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/pseudo-parameter-reference.html

Example (role trust policy to explicitly trust the role itself):
```yaml
   ...
   Principal:
      AWS: !Sub arn:aws:iam::${AWS::AccountId}:role/${AWS::StackName}-lambda-role
```

# Former2 Tool
Generate CloudFormation templates from AWS resources

https://aws.amazon.com/blogs/opensource/accelerate-infrastructure-as-code-development-with-open-source-former2/

Though see: https://github.com/iann0036/former2/blob/master/RESOURCE_COVERAGE.md   (Not everything is covered.)

https://former2.com/ (But don't put your credentials into a 3rd-party website...)

## Run Former2 locally

https://github.com/iann0036/former2/blob/master/HOSTING.md  (127.0.0.1 doesn't need extension)

https://github.com/iann0036/former2/blob/master/Dockerfile The build and run commands, but set $host_port env var, e.g. 80

