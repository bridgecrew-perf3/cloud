# 1. First the initialization
provider "aws" {
  profile = "default"
  region  = var.vpc_region
}

resource "aws_instance" "master_node" {
  ami               = "ami-07d2a553c8ada9631"
  instance_type     = "t3a.small"
  availability_zone = var.public_availability_zone
  key_name          = var.key_name

  root_block_device {
    volume_size = var.root_ebs_capacity
    encrypted   = true
  }
  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.eni-public.id
  }

  tags = {
    "Name" = var.name_tag
  }
}
