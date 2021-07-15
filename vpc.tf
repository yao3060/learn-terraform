# Provides a VPC resource.
resource "aws_vpc" "yyy-vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "YYY VPC"
  }
}

# Provides a resource to create a VPC Internet Gateway.
resource "aws_internet_gateway" "yyy-internet-gateway" {
  vpc_id = aws_vpc.yyy-vpc.id

  tags = {
    Name = "YYY Internet Gateway"
  }
}

# Provides a resource to create a VPC routing table.
resource "aws_route_table" "yyy-route-table" {
  vpc_id = aws_vpc.yyy-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.yyy-internet-gateway.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.yyy-internet-gateway.id
  }

  tags = {
    Name = "YYY Route Table"
  }
}

# Provides an VPC subnet resource.
resource "aws_subnet" "yyy-subnet" {
  vpc_id            = aws_vpc.yyy-vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "cn-north-1a"

  tags = {
    Name = "YYY Subnet"
  }
}

# Resource: aws_route_table_association
resource "aws_route_table_association" "yyy-route-table-assoc-a" {
  subnet_id      = aws_subnet.yyy-subnet.id
  route_table_id = aws_route_table.yyy-route-table.id
}

# Resource: aws_security_group
resource "aws_security_group" "yyy-security-group-allow-web" {
  name        = "allow_web_traffic"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.yyy-vpc.id

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
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
    Name = "Allow Web"
  }
}

# Resource: aws_network_interface
# Provides an Elastic network interface (ENI) resource.

resource "aws_network_interface" "yyy-eni" {
  subnet_id       = aws_subnet.yyy-subnet.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.yyy-security-group-allow-web.id]

  tags = {
    Name = "YYY ENI"
  }
}

# Resource: aws_eip
# Provides an Elastic IP resource.
resource "aws_eip" "yyy-eip" {
  vpc                       = true
  network_interface         = aws_network_interface.yyy-eni.id
  associate_with_private_ip = "10.0.1.50"
  depends_on                = [aws_internet_gateway.yyy-internet-gateway]
  tags = {
    Name = "YYY EIP"
  }
}
