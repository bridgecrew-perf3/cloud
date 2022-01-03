# cloud

Terraform configuration to bootstrap EC2 instance for personal development purpose.

## Getting started

### Prerequisites

Make sure the computer you are using to commence all these operations:

- has Terraform installed locally.
- make sure environment is configured with proper AWS credentials, namely `aws_access_key_id` and `aws_secret_access_key`. This will let Terraform act on your behalf.

### How to use

There are some variables references in [main.tf](./main.tf) (starting with `var.`). All of those variable definitions can be found in [variables.tf](./variables.tf).

After you have cloned this repo, you can apply:

    terraform apply --auto-approve

You'll be prompted with some basic question:

```
var.key_name
  name of key to be used for auth

  Enter a value: ec2-tutorial

var.private_subnet_cidr
  cidr block for private subnet

  Enter a value: 10.0.1.0/24

var.public_subnet_cidr
  cidr block for public subnet

  Enter a value: 10.0.2.0/24

var.vpc_region
  region for vpc

  Enter a value: ap-south-1
```

If you don't want to input these values on each `apply` and `destroy` then you can also create `terraform.tfvars` with valid key value pairs for the questions asked:

```
key_name = ec2-tutorial
vpc_region = ap-south-1
private_subnet_cidr = 10.0.1.0/24
public_subnet_cidr = 10.0.2.0/24
```

You can look at [AWS provider docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs) at for more info on resources used in the repo.

## Contribute

Are you a SysOps/TechOps guy/gal? We are looking for people who are well versed in networking and have a good knowledge of AWS infrastructure. Please head over to <https://github.com/santosh/cloud/issues> for ways to contribute to this project.
