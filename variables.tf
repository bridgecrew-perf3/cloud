
variable "key_name" {
  description = "name of key to be used for auth"
}

variable "vpc_region" {
  description = "region for vpc"
}

variable "private_subnet_cidr" {
  description = "cidr block for private subnet"
}

variable "public_subnet_cidr" {
  description = "cidr block for public subnet"
}

variable "public_availability_zone" {
  description = "availability zone for resources in public subnet"
}

variable "name_tag" {
  description = "default value for Name tag in provisioned resources"
  default     = "Powered by git.io/JRSD2"
}

variable "root_ebs_capacity" {
  description = "EBS volume size for master_node"
}
