# .ec2
Terraform configuration to bootstrap EC2 instance. 

## What is has

Just to be sure we are on same page, I use this template to manage my personal development cum learning needs. So AWS resources used are according to that only. 

It has following resources in a nutshell:

1. 1 EC2 instance, running Amazon Linux 2.
2. 1 Security group to allow SSH, HTTP and HTTPS access. Additional group to allow egress from EC2 to EFS.
3. 1 EFS volume. 

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

```
# EFS Mounting at startup
yum install -y amazon-efs-utils
yum install -y nfs-utils
export file_system_id_1=fs-de09280f
export efs_mount_point_1=/efs
mkdir -p $efs_mount_point_1
test -f "/sbin/mount.efs" && printf "\n$file_system_id_1:/ $efs_mount_point_1 efs tls,_netdev\n" >> /etc/fstab || printf "\n$file_system_id_1.efs.ap-south-1.amazonaws.com:/ $efs_mount_point_1 nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport,_netdev 0 0\n" >> /etc/fstab
test -f "/sbin/mount.efs" && printf "\n[client-info]\nsource=liw\n" >> /etc/amazon/efs/efs-utils.conf
retryCnt=15; waitTime=30; while true; do mount -a -t efs,nfs4 defaults; if [ $? = 0 ] || [ $retryCnt -lt 1 ]; then echo File system mounted successfully; break; fi; echo File system not available, retrying to mount.; ((retryCnt--)); sleep $waitTime; done;

df -h >> /home/ec2-user/disk-report.txt
```
