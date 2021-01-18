resource "aws_security_group" "nat_sg" {

  name        = "NAT instance SG"
  description = "NAT instance Security Group (allow traffic from private subnets)"
  vpc_id      = aws_vpc.my_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.default_cidr]
  }

  tags = {
    Name = "NAT SG"
  }

}

resource "aws_security_group" "web_sg" {
  name        = "WEB server SG"
  description = "Allow access to WEB servers by ports: 22, 80, 443"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.default_cidr]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.default_cidr]
  }

  ingress {
    from_port   = 443
    to_port     = 443
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
    Name = "WEB SG"
  }
}

resource "aws_security_group" "elb_sg" {
  name        = "ELB SG"
  description = "Allow WEB traffic for ELB"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
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
    Name = "ELB SG"
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "RDS SG"
  description = "Allow traffic for RDS"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.nat_sg.id]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.default_cidr]
  }

  tags = {
    Name = "RDS SG"
  }
}
