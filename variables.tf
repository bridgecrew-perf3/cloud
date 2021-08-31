
variable "key_name" {
  description = "name of key to be used for auth"
}

variable "vpc_region" {
  description = "region for vpc"
  default = "ap-south-1"
}

variable "private_subnet_cidr" {
  description = "cidr block for private subnet"
  default = "10.0.1.0/24"
}

variable "public_subnet_cidr" {
  description = "cidr block for public subnet"
  default = "10.0.2.0/24"
}

