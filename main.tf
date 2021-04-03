terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
}


provider "aws" {
  profile = "default"
  region  = var.region
}

resource "aws_instance" "cloud_home" {
  ami           = "ami-0bcf5425cdc1d8a85"
  instance_type = "t3a.small"

  tags = {
    Name         = "CloudHome"
    InstalledVia = "Terraform"
  }
}
