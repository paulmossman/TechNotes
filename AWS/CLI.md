**<span style="font-size:3em;color:black">AWS CLI</span>**
***

# Global Options
```
--output text | json | yaml | <others>
```

# Miscellanous Commands

## Montly costs
```bash
aws ce get-cost-and-usage --time-period Start=2022-03-01,End=2022-04-01 --granularity MONTHLY --metrics BlendedCost
```

## Get Account ID
```bash
aws sts get-caller-identity | jq -r ".Account"
```

# Cognito
Why not simply ```cognito``` I don't know...
```bash
aws cognito-idp help
```