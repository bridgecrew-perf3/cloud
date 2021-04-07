provider "aws" {
  profile = "default"
  region  = var.region
}

resource "aws_instance" "cloud_home" {
  ami                     = "ami-0bcf5425cdc1d8a85"
  instance_type           = "t3a.small"
  disable_api_termination = false
  availability_zone       = var.availability_zone

  credit_specification {
    cpu_credits = "standard"
  }

  // security groups?

  user_data = ""

  tags = {
    Name         = "Reserved Instance"
    InstalledVia = "Terraform"
  }
}
