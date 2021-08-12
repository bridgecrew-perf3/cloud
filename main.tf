# 1. First the initialization
provider "aws" {
  profile = "default"
  region  = var.vpc_region
}

resource "aws_instance" "master_node" {
  ami                     = "ami-0bcf5425cdc1d8a85"
  instance_type           = "t3a.small"
  availability_zone       = "ap-south-1a" # same as public subnet az
  key_name                = var.key_name

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.eni-public.id
  }

  user_data = <<EOF
    #!/bin/bash

    sudo yum update -y -q
    sudo yum upgrade -y -q

    # Install initial tools
    sudo yum group install 'Development Tools' -y -q
    sudo amazon-linux-extras install epel -y
    sudo yum install vim-X11 golang docker tmux tree python3 git-lfs -y

    # Configure initial tools
    sudo systemctl start docker
    sudo systemctl enable docker
    sudo groupadd docker
    sudo usermod -aG docker ec2-user
    sudo newgrp docker
  EOF

  tags = {
    "Name" = "Powered by git.io/JRSD2"
  }
}
