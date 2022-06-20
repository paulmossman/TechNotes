**<span style="font-size:3em;color:black">CloudFormation</span>**
***

[Template Reference](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/template-reference.html)

# Command-line Launch
```bash
aws cloudformation create-stack --stack-name <Stack Name> \
   --template-body "file://./TemaplateFile.yml" \
   --parameters \
      ParameterKey=Param1,ParameterValue="Param1Value" \
   --profile ${PROFILE}
```

## Wait for Stack Creation
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



# Former2 Tool
Generate CloudFormation templates from AWS resources

https://aws.amazon.com/blogs/opensource/accelerate-infrastructure-as-code-development-with-open-source-former2/

https://former2.com/ (But don't put your credentials into a 3rd-party website...)

## Run locally

https://github.com/iann0036/former2/blob/master/HOSTING.md  (127.0.0.1 doesn't need extension)

https://github.com/iann0036/former2/blob/master/Dockerfile The build and run commands, but set $host_port env var, e.g. 80

Though see: https://github.com/iann0036/former2/blob/master/RESOURCE_COVERAGE.md   (Not everything is covered.)
