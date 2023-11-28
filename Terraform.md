**<span style="font-size:3em;color:black">Terraform</span>**
***

# Misc commands

## plan
Get a preview of what would be deployed by ```apply```.  Detects drift.

Note: ```No changes. Your infrastructure matches the configuration.```

## apply
Apply the changes, and update the state file.

## refresh
Update the state file based on what's actually deployed.  Detects drift.

## inform
Sometimes a better option than refresh.

# State

## Backend (Remote)

State is not stored on the local hard drive, remote only.

Types:
- Standard: Simple, e.g AWS S3
- Enhanced: Run operations remotely, e.g. Terraform Cloud