# .ec2
Terraform configuration to bootstrap EC2 instance. 

## How to use these templates

1. Import `aws_key_pair` from account. 

For being able to SSH into your instance after provisioning, the first thing to use these template would be to obtain a `.pem` key from AWS. Once you get that, you will have to use it to create public key. 

- Run `openssl rsa -in key.pem -pubout`.
- Paste the output (not the header and footer part) and paste it into `public_key` section of `aws_key_pair` resource. 
- Give name to the key and use it accross the template where it is needed. 
- Import the key, `terraform import aws_key_pair.key key`

2. Import `aws_default_vpc` from the account.

You may not need this step. If that is the case, please delete the `aws_default_vpc` resource block from `networking.tf`.

If you choose to use your default vpc created with your AWS account, you can run this commands: 

    terraform import aws_default_vpc.default <vpc-a01106c2>

You may need to import default_subnet, but I haven't got time to test that yet.

Visit variables file to change some defaults. 

## TODO

- [x]: SSH Key pair
- [x]: Security groups
- [x]: User data
    - [ ]: Package installation and basic configuration
    - [ ]: EFS mount
    - [ ]: Change SSH port
    - [ ]: vimfiles and dotfiles
