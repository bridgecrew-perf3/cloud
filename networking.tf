resource "aws_default_vpc" "default" {
}

# Subnets need some work
resource "aws_default_subnet" "ap-south-1a" {
  availability_zone = "ap-south-1a"
}

resource "aws_default_subnet" "ap-south-1b" {
  availability_zone = "ap-south-1b"
}

resource "aws_default_subnet" "ap-south-1c" {
  availability_zone = "ap-south-1c"
}

resource "aws_security_group" "basic_sg" {
  name        = "basic_sg"
  description = "Allow incoming traffic from SSH, HTTP & HTTPS"
  vpc_id      = aws_default_vpc.default.id

  # Allow SSH.
  # TODO: Can we change this to 29885?
  # For that we would need to modify sshd.conf
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["106.207.0.0/16"]
  }

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

  # Allow all outgoing traffic. 
  # TODO: Is it default behavior?
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
