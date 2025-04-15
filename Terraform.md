**<span style="font-size:3em;color:black">Terraform</span>**
***

# terraform.tfstate ("state") file

Critical.  It keeps track of the state of the Terraform project.  Keep it backed up in a "backend" for Production and/or shared projects.  Online storage (e.g. [AWS S3 backend](https://developer.hashicorp.com/terraform/language/settings/backends/s3)) works well.  (But secure access, enable versioning, encrypt, etc.)

It may contain secrets, so don't store in source control.

Enhanced: Run operations remotely, e.g. HashiCorp Terraform Cloud.  HashiCorp Vault.

A local file is fine for single-user prototyping and development.

See also "Workspaces".

## State locking
Prevent multiple users/processes from changing the state at the same time.

Manual unlock: ```terraform force-unlock <Lock ID>```

# Core Workflow
1. Write
2. Plan
3. Apply

# CLI Commands

## init
Initialize the project in the local directory.  i.e. Download the provider plugin files.  (Does **not** create/update the terraform.tfstate file.)  Re-run it whenever you modify or change dependencies.

## plan
Get a preview of what would be deployed by ```apply```.  Detects drift.  (Does **not** create/update the terraform.tfstate file.)

If everything is up to date: ```No changes. Your infrastructure matches the configuration.```

The ```-target``` option restricts the plan to only a subset of resources.

## apply
Apply the changes (by creating missing resources), and update the terraform.tfstate file.  (Creates the terraform.tfstate file if it doesn't exist.)

## destroy
Delete all the resources in the project.

Equivalent: ```terraform apply -destroy```

## refresh
Update the terraform.tfstate file based on the resources that are **actually** deployed and configured in Terraform.  Detects drift.

Scenario:
- ```apply```, to create a VPC in AWS
- Manually delete that VPC in AWS
    - At this point the Terraform state file is out-of-sync.
- ```refresh```
    - At this point the Terraform state file is in-sync.
- ```plan``` will show that a VPC will be created
- ```apply``` will create the VPC

## inform
Sometimes a better option than refresh.

## Other CLI commands

### state
```
terraform state list
terraform state rm 'module.__.this'
```
Now removed from TF state, so TF won't try to destroy it.

### console
Run arbitrary commands in the context of the current project.  But must be restarted to detect changes in files.

### validate
Valid Terraform code:
```bash
Success! The configuration is valid.
```

### fmt (format)
Rewrite all the Terraform files to meet the sytle conventions.

Though it cannot handle an opening brace (aka curly bracket, ```{```) being on the next line...

### taint <resource name>
Mark the resource as "tainted", so it's replaced on the next ```apply```.

### untaint <resource name>
Remove the "tainted" mark from a resource.

### import <(Terraform) resource name> <Target ID>
Capture the resources already created into the Terraform state file.  The resource must already be described in a Terraform source file.

Azure Portal -> JSON View -> Use "id" for Parameter #2

To import an AWS VPC <Target ID> would be the AWS ID of the VPC, for example: ```vpc-0b113a2f734aaf60d```.

Similar, but different: [Former2](https://github.com/iann0036/former2/blob/master/README.md)

### state <sub-command>

#### list [filter on (Terraform) resource name]
List the resources in the Terraform state file.  Resources can be filtered by their nesting hierarchy.

#### pull
Display the contents of the terraform.tfstate file.

#### mv <Old (Terraform) resource name> <Current (Terraform) resource name>
Rename a resource in the Terraform state file.  The resource must already be renamed in the Terraform source file(s).

#### rm <(Terraform) resource name>
Delete a resource from the terraform.tfstate file.  (It does **not** delete the target resource.)

#### push
Last resort: Fix a big problem fixed in the local state file, this will overwrite it to the remote state file.

## CLI options
```-auto-approve```: Skip the "Do you want to perform these actions?" interactive prompt.

## Workspaces
Each workspace has its own ```terraform.tfstate``` file.  When there are multiple workspaces in a Terraform project they're organized by separate sub-directories in ```terraform.tfstate.d```.

```workspace <sub-command>```
- list
- new <workspace name>
- show
- select <workspace name>
- delete <workspace name>


# Variables (Input)

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
    default = true   # Note: No double-quotes.
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

If ```default``` is omitted and the variable's value is not supplied elsewhere, then terraform will prompt for it:
```bash
% terraform apply
...
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

## How to assign a variable a value, in order of precedence:

1. Command-Line:
    - ```-var```
        - e.g. ```-var="vpc_name=My VPC"```
    - ```-var-file```
        - e.g. ```-var-file=devtest.tfvars```
        - e.g. ```-var-file=devtest.tfvars.json```
    - If a variable is defined in **both** of the above, then the one that appears **last** on the command-line takes precedence.
2. ```auto``` files:
    - **Any** files with names ending in ```.auto.tfvars``` or ```.auto.tfvars.json```
        - e.g. ```paul.auto.tfvars```
        - e.g. ```paul.auto.tfvars.json```
        - e.g. ```halifax.auto.tfvars```
    - If a variable is defined in **multiple** auto files, then the one that appears in the file whose name sorts to last takes precedence.  i.e. ```ls *.auto.tfvars* | sort```
3. ```terraform.tfvars.json``` file
4. ```terraform.tfvars``` file
5. Environment Variables: ```TF_VAR_<variable name>```
    - e.g. ```export TF_VAR_vpc_name="My VPC"```
6. Default (```default = "My VPC"```) in the variable definition.
7. If none of the above, the CLI will prompt for it.

(The [Terraform documentation](https://developer.hashicorp.com/terraform/language/values/variables#variable-definition-precedence) doesn't tell the whole story.)

## Variable File syntax

### Simple
```bash
vpc_name = "My VPC"
port = 8080
egress_ports = [22, 80, 443]
```

### JSON
```json
{
    "vpc_name": "My VPC",
    "port": 8080,
    "egress_ports": [22, 80, 443]
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

# Terraform Language
[Reference](https://developer.hashicorp.com/terraform/language)

## Backends
[Available Backends](https://developer.hashicorp.com/terraform/language/settings/backends/configuration#available-backends)

When using a remote backend: State data is only kept in memory, not in files.

### S3
```json
terraform {
    backend "s3" {
        bucket = "<S3 bucket name>"
        key    = "<path and filename>"
        region = "ca-central-1"
    }
}
```

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

## Built-In Functions
There are many.  [Reference](https://developer.hashicorp.com/terraform/language/functions)
Examples:
- ```max```: Return the largest from a set of numbers.
- ```index```: Return the index of the specified value in the specified list.
- ```values```: Return a list of the values from the specified map.
- ```file```: Return the contents of the specified text file as a string.
- ```flatten```: Returns a (non-nested) list of elements from the specified list(s), which may include nested lists.

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
data "aws_ssm_parameter" "recommended-al2023" {
    name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-6.1-x86_64 "
}
resource "aws_instance" "my_amazon-linux-2_server" {
    ami = data.aws_ssm_parameter.recommended-al2023.value
    ...
```
Reference: [Data Source: aws_ssm_parameter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter)

### Alternate AMI example
```json
data "aws_ami" "latest-al2023" {
    most_recent = true
    owners = ["amazon"]
    filter {
        name = "name"
        values = ["al2023-ami-2023*"]
    }
    filter {
        name = "architecture"
        values = ["x86_64"]
    }
    filter {
        name = "root-device-type"
        values = ["ebs"]
    }
    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }
}

resource "aws_instance" "my_al2023_instance" {
  ami = data.aws_ami.latest-al2023.id
  ...
```

Reference: [Data Source: aws_ami](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami)

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
}
output "Default_Security_Group_ID" {
    value = data.aws_security_group.default_security_group.id
}
```
Note: The two filter name values are Filter.N from the [AWS API Reference](https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_DescribeSecurityGroups.html)
Result:
```bash
...
Outputs:

Default_Security_Group_ID = "sg-01c35c03ddb65d0f2"
```
Reference: [Data Source: aws_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group)

## Versioning (Modules and Providers)

### Dependency Lock File

Always: `.terraform.lock.hcl`

Locks **only** Provider versions, **not** Module versions.

Upon `terraform init` the latest version for each Provider that matches its contraints are selected and "locked" into `.terraform.lock.hcl`.  Every `apply` will then always use the "locked" Provider versions, until:
```bash
terraform init -upgrade
```

Versus Modules: Every `apply` (TODO: or `plan`?) will use the latest version for each that matches its contraints.

[Reference](https://developer.hashicorp.com/terraform/language/files/dependency-lock)

### Pessimistic Constraint Operator
The *pessimistic constraint* operator ```~>``` matches only ```>``` increments of the *rightmost* version component, e.g.:
- ```~> 1.0.5```: Matches 1.0.5, 1.0.6, and 1.0.10 but not 1.1.0, nor 1.0.4, nor 0.9.
- ```~> 1.2```: Matches 1.2, 1.3, 1.4, and 1.10, but not 2.0, nor 1.1, nor 0.9.

[Reference](https://developer.hashicorp.com/terraform/language/expressions/version-constraints)

# Modules
Module: A directory that contains Terraform files, as a block of re-usable code.  Can be local or remote.  These are built on top of the raw Providers.

## Types
### Remote
HashiCorp Terraform Registry [Browse](https://registry.terraform.io/browse/modules)

For example there are AWS modules for VPC, IAM, Security Groups, S3 buckets, etc.

### Local
On the local machine running Terraform.

## Module Inputs
Assuming ```resource_name``` is a variable in the module, set the value:
```json
module "my_module" {
    source = "./my_module"
    resource_name = "The Name"
}
```

## Module Outputs
Reference a module's output:
```json
module.<module name>.<output name>
```

Outputs declared inside modules are **not** automatically pulled through.  It needs to be declared also:
```json
output "<variable name, which does not need to be the same>" {
    value module.<module name>.<variable/data name in the module>
}
```

### Module Data
A module's data cannot be directly access from outside.  Use output instead, for example:
```json
data "aws_ami" "latest-al2023" {
    ...
}
output "latest-al2023" {
    value = data.aws_ami.latest-al2023
}
```

Then access it, for example:
```json
resource "aws_instance" "myec2" {
    ami = module.<module name>.latest-al2023.id
    ...
```

# Providers

## Documentation
[All](https://registry.terraform.io/browse/providers) (many)
- [AWS](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Kubernetes](https://registry.terraform.io/providers/hashicorp/kubernetes/latest)
- [TLS](https://registry.terraform.io/providers/hashicorp/tls/latest)

## Multi-Provider Setup - Using Alias
```json
provider "aws" {
    region = "ca-central-1"
    profile = "account1_admin"
    alias = "montreal-admin"
}
provider "aws" {
    region = "ca-west-1"
    profile = "account2_limited"
    alias = "calgary-limited"
}

resource "aws_vpc" "calgary-vpc" {
    provider = aws.calgary-limited
    ...
```

## Examples

### Create Private TLS CA (Certificate Authority) and Certificates
See [here](https://amod-kadam.medium.com/create-private-ca-and-certificates-using-terraform-4b0be8d1e86d)


## Plugins
The code for Providers is stored in Plugins.  You can store custom plugins in a local directory.

### Provisioners
A last restort.  [Reference](https://developer.hashicorp.com/terraform/language/resources/provisioners/syntax)

You can also create a provisioner in the "null" resource, i.e. not conencted to an actual underlying resource.  See: [terraform_data](https://www.terraform.io/docs/language/resources/provisioners/null_resource.html)
You can also create a provisioner in the "null" resource, i.e. not conencted to an actual underlying resource.  See: [terraform_data](https://www.terraform.io/docs/language/resources/provisioners/null_resource.html)

#### ```file```
Copies file/directory from the local machine into the new resource.
```json
resource "aws_instance" "my_ec2_instance" {
    ...

    provisioner "file" {
        source = "./tmp.txt"
        destination = "/etc/installed-tmp.txt"
    }
```

### ```local-exec```
Invokes a command on the local machine, after the remote resource is created.

```command``` is the single command to execute.  (Required.)

### ```remote-exec```
Invokes command(s) on the remote resource, after it's created.

Exactly one of the following is required:
- ```inline```: The list of command strings.
- ```script```: String path to a local script that will be copied to the remote and executed.
- ```scripts```: As above, except a list.  Executed in the order they appear.
