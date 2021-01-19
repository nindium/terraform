locals {
  vpc_id = aws_vpc.main.id
}

resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = var.tenancy

  tags = {
    Name = "TF-Main"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = local.vpc_id
  cidr_block              = var.subnet_cidr
  availability_zone       = var.az
  map_public_ip_on_launch = true
  tags = {
    name = "TF-VPC-Subnet"
  }

}


resource "aws_internet_gateway" "igw" {
  vpc_id = local.vpc_id
  tags = {
    Name = "TF-igw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = local.vpc_id
  route {
    cidr_block = var.default_cidr
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Public RT"
  }
}

resource "aws_security_group" "bastion_sg" {
  name   = "bastion_sg"
  vpc_id = local.vpc_id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.default_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.default_cidr]
  }

  tags = {
    Name = "Bastion-SG"
  }
}

resource "aws_network_acl" "allow_tcp" {
  vpc_id     = local.vpc_id
  subnet_ids = [aws_subnet.public_subnet.id]
  egress {
    rule_no    = 10
    protocol   = "tcp"
    cidr_block = var.default_cidr
    from_port  = 0
    to_port    = 0
    action     = "allow"
  }

  ingress {
    rule_no    = 10
    protocol   = "tcp"
    cidr_block = var.default_cidr
    from_port  = 0
    to_port    = 0
    action     = "allow"
  }
  tags = {
    Name = "Allow TCP"
  }
}

resource "aws_route_table_association" "pubas" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}



output "subnet_id" {
  value = aws_subnet.public_subnet.id
}

output "sg_id" {
  value = aws_security_group.bastion_sg.id
}
