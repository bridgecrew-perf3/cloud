# 2. Always create a new VPC for application and don't use default one
resource "aws_vpc" "development-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Powered by git.io/JRSD2"
  }
}

# 3. igw is per vpc basis. You create routing table per subnet basis
# to route to this igw
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.development-vpc.id

  tags = {
    Name = "Powered by git.io/JRSD2"
  }
}

# 4. This route table to route all data to the internet.
# So only use on public subnet/
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.development-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "Powered by git.io/JRSD2"
  }
}

# 5. At least 2 subnets, public & private

# Only public can communicate to internet.
resource "aws_subnet" "subnet-private" {
  vpc_id            = aws_vpc.development-vpc.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = "ap-south-1b"

  tags = {
    "Name" = "private by Terraform"
  }
}

# Private can only communicate to public (but not the internet). 
# Or can use NAT.
resource "aws_subnet" "subnet-public" {
  vpc_id            = aws_vpc.development-vpc.id
  cidr_block        = var.public_subnet_cidr
  availability_zone = "ap-south-1a"

  tags = {
    "Name" = "public by Terraform"
  }
}

# 6. Associate public route table with the public subnet
# Anything not destined to the subnet cidr range will go to the internet
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet-public.id
  route_table_id = aws_route_table.public-rt.id
}

# 7. Configure security group for tight security
resource "aws_security_group" "allow_web" {
  name        = "allow_web"
  description = "Allow incoming traffic from HTTP & HTTPS"
  vpc_id      = aws_vpc.development-vpc.id

  # Allow HTTP.
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTPS.
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Allow web"
  }
}


# 7. Configure security group for tight security
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow incoming traffic from SSH"
  vpc_id      = aws_vpc.development-vpc.id

  # Allow SSH.
  ingress {
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Allow SSH"
  }
}


# 8. This network interface is the logical mediator between subnet
# and the elastic IP. This resource will consume 1 ip from our 
# public subnet.
resource "aws_network_interface" "eni-public" {
  subnet_id   = aws_subnet.subnet-public.id
  private_ips = ["10.0.2.50"]
  security_groups = [
    aws_security_group.allow_web.id,
    aws_security_group.allow_ssh.id
  ]
}

# 9. Elastic IP for us to connect
resource "aws_eip" "one" {
  vpc                       = true
  network_interface         = aws_network_interface.eni-public.id
  associate_with_private_ip = "10.0.2.50"
  depends_on = [
    aws_internet_gateway.gw
  ]
}
