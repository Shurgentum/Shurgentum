# Create a VPC
resource "aws_vpc" "eks" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "eks_vpc"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "eks_igw" {
  vpc_id = aws_vpc.eks.id
}

# Create internet gateway route
resource "aws_route_table" "eks_gw_route" {
  vpc_id = aws_vpc.eks.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks_igw.id
  }
  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.eks_igw.id
  }
}

# Create subnet
resource "aws_subnet" "eks_subnet" {
  vpc_id            = aws_vpc.eks.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = var.default_az
}

# Associate route table with subnet
resource "aws_route_table_association" "eks_gw_route_assoc" {
  route_table_id = aws_route_table.eks_gw_route.id
  subnet_id      = aws_subnet.eks_subnet.id
}

# Create security group 
resource "aws_security_group" "allow_tls" {
  name        = "allow_http"
  description = "Allow HTTP inbound traffic"
  vpc_id      = aws_vpc.eks.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["178.136.102.112/32"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

# Create Network interface
resource "aws_network_interface" "nic" {
  subnet_id       = aws_subnet.eks_subnet.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.allow_tls.id]
}

# Reserve elastic IP
resource "aws_eip" "eip" {
  vpc                       = true
  network_interface         = aws_network_interface.nic.id
  associate_with_private_ip = "10.0.1.50"
  depends_on = [
    aws_internet_gateway.eks_igw
  ]
}
