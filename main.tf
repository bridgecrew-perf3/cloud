provider "aws" {
  profile = "default"
  region  = var.region
}

resource "aws_key_pair" "" { # paste key name
  key_name   = "" # paste key name
  public_key = "" # paste public key generated from openssl rsa -in <key.pem> -pubout
}

resource "aws_instance" "cloud_home" {
  ami                     = "ami-0bcf5425cdc1d8a85"
  instance_type           = "t3a.small"
  disable_api_termination = false
  availability_zone       = var.availability_zone
  key_name                = "" # paste key name
  vpc_security_group_ids  = [aws_security_group.basic_sg.id]

  credit_specification {
    cpu_credits = "standard"
  }

  user_data = <<EOF
    #!/bin/bash

    sudo yum update -y -q
    sudo yum upgrade -y -q
    sudo yum group install 'Development Tools' -y -q
  EOF

  tags = { # create your own or use these default
    IsAutomated = "True"
    AutomatedBy = "Terraform"
  }
}
