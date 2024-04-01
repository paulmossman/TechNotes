**<span style="font-size:3em;color:black">Terraform</span>**
***

# terraform.tfstate ("state") file

Critical.  It keeps track of the state of the Terraform project.  Keep it backed up for Production and/or shared projects.  Online storage (e.g. [AWS S3 backend](https://developer.hashicorp.com/terraform/language/settings/backends/s3)) is ideal.

It may contain secrets, so don't store in source control.  And secure access to it if stored in online storage.

Enhanced: Run operations remotely, e.g. Terraform Cloud

A local file is fine for single-user prototyping and development.

# CLI Commands

## init
Initialize the project in the local directory.  i.e. Download the provider files.  (Does not create/update the terraform.tfstate file.)

## plan
Get a preview of what would be deployed by ```apply```.  Detects drift.  (Does not create/update the terraform.tfstate file.) 

If everything is up to date: ```No changes. Your infrastructure matches the configuration.```

## apply
Apply the changes (by creating missing resources), and update the terraform.tfstate file.  (Creates the terraform.tfstate file if it doesn't exist.)

## destroy
Delete all the resources in the project.

## refresh
Update the terraform.tfstate file based on the resources that are actually deployed.  Detects drift.

## inform
Sometimes a better option than refresh.

## CLI options

```-auto-approve```: Skip the "Do you want to perform these actions?" interactive prompt.

# Variables (Input)

## The ways to assign a variable a value, in order of precedence:
1. Command-Line: 
    - ```-var```
        - e.g. ```-var="vpc_name=My VPC"```
    - ```-var-file```
        - e.g. ```-var-file="devtest.tfvars"```
        - Simple file syntax: ```vpc_name = "My VPC"```
3. Automatically from files:
    - terraform.tfvars [.json]
    - *.auto.tfvars [.json]
    - (Same simple file syntax as above.)
4. Environment Variables that start with ```TF_VAR_```:
    - e.g. ```export TF_VAR_vpc_name="My VPC"```
5. Default (```default = "My VPC"```) in the definition.
6. If none of the above, the CLI will prompt for it.

## Define
```json
variable "vpc_name" {
    type = string
    default = "My VPC"
}

variable "https_port" {
    type = number
    default = 443   # Note: No double-quotes.
}

variable "production" {
    # Type: boolean
    default = true
}

variable "list_of_different_types" {
    type = list
    default = ["a", 15, true]
}

variable "person_map" {
    type = map
    default = {
        name = "Paul"
        age = 25
    }
}
```

If ```default``` is omitted and the variable's value is not supplied on the command-line, then terraform will prompt for it:
```bash
% terraform apply  
var.vpc_name
  Enter a value: 
```

## Reference a Variable
```json
resource "aws_vpc" "my_vpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = var.vpc_name
    }
}
```

# Output
JSON:
```json
output "VPC_ID" {
    value = aws_vpc.my_vpc.id
}
```
Result:
```bash
...

Outputs:

VPC_ID = "vpc-0cae74324b9642eab"
```
Reference: [aws_vpc attributes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc#attribute-reference)

# Configuration Language (in JSON)
[Reference](https://developer.hashicorp.com/terraform/language)

## Dynamic Blocks
Warning: Don't overuse them.
```json
variable "web_in_and_out_ports" {
    type = list(number)
    default = [80, 443]
}
resource "aws_security_group" "web_server" {
  name = "Web ports in and out"
  dynamic "ingress" {
        for_each = var.web_in_and_out_ports
        content {
            from_port = ingress.value
            to_port = ingress.value
            protocol = "TCP"
            cidr_blocks = ["0.0.0.0/0"]
        }
    }
    dynamic "egress" {
        for_each = var.web_in_and_out_ports
        content {
            from_port = egress.value
            to_port = egress.value
            protocol = "TCP"
            cidr_blocks = ["0.0.0.0/0"]
        }
    }
}
```

## Dependencies
```json
resource "aws_db_instance" "my_db" {
    ...
}
resource "aws_instance" "my_ec2_instance" {
    ...
    depends_on = [aws_db_instance.my_db]
}
```

## Data Sources
Load data from an *existing* resource, and access the value like a variable.  See the "Data Sources" section in the provider documentation.
```json
data "aws_ssm_parameter" "recommended_amazon-linux-2" {
    name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-6.1-x86_64 "
}
resource "aws_instance" "my_amazon-linux-2_server" {
    ami = data.aws_ssm_parameter.recommended_amazon-linux-2.value
    ...
```
Reference: [Data Source: aws_ssm_parameter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter)

### Filtering
Given an "aws_vpc" resource named "my_vpc":
```json
data "aws_security_group" "default_security_group" {
    filter {
        name = "vpc-id"
        values = [aws_vpc.my_vpc.id]
    }
    filter {
        name = "group-name"
        values = ["default"]
    }
    # The two name values: Filter.N from https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_DescribeSecurityGroups.html
}
output "Default_Security_Group_ID" {
    value = data.aws_security_group.default_security_group.id
}
```
Result:
```bash
...
Outputs:

Default_Security_Group_ID = "sg-01c35c03ddb65d0f2"
```
Reference: [Data Source: aws_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group)

# Provider Documentation
- [AWS](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)