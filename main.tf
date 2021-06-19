provider "aws" {
  profile = "default"
  region  = var.region
}

resource "aws_key_pair" "ec2-tutorial" {
  key_name   = "ec2-tutorial"
  public_key = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAmkP+RJdHFRzVIJeQomhSsTW5yXHZ0EDDLuuUpshu3ntYBYQuKBlSkXUQSxm9AlgITbPN+lb+Yq0OiCtdgkDg9Wk0NdiBeYyxFZCazlfcPYrmH6OPElR9/5sSnIVeU/rx8DZH0V+MDbZQjZArXG/GHdhFP2BWU/+1SeAFyTte1RXkc67JK8szGhCjZnqL416PRcRMHbWp9Nha9/AQICitzPCgCrIIwsIxu27ufs4JhgOpIfKKR5Kmj0f2+t80vz2pzudBemRLg4uKazetpyzqT2ElJrSEcuYo6WVu0L+Laq7IldSrhG5jIRZoJ8WD5tVUO3oKHBHy6D6HgAcAC6EVzwIDAQAB"
}

resource "aws_instance" "cloud_home" {
  ami                     = "ami-0bcf5425cdc1d8a85"
  instance_type           = "t3a.small"
  disable_api_termination = false
  availability_zone       = var.availability_zone
  key_name                = "ec2-tutorial" # paste key name
  vpc_security_group_ids  = [aws_security_group.basic_sg.id]

  credit_specification {
    cpu_credits = "standard"
  }

  user_data = <<EOF
    #!/bin/bash

    sudo yum update -y -q
    sudo yum upgrade -y -q

    # Install initial tools
    sudo yum group install 'Development Tools' -y -q
    sudo amazon-linux-extras install epel -y
    sudo yum install vim-X11 go docker -y

    # Configure initial tools
    sudo systemctl start docker
    sudo systemctl enable docker
    sudo groupadd docker
    sudo usermod -aG docker ec2-user
    sudo newgrp docker
  EOF

  tags = { # create your own or use these defaults
    Name        = "Reserved Instance"
    IsAutomated = "True"
    AutomatedBy = "Terraform"
  }
}
