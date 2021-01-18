resource "aws_subnet" "private_subnet" {
  count             = length(slice(local.az_names, 0, 2))
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index + length(local.az_names))
  availability_zone = local.az_names[count.index]
  tags = {
    Name = "Private Subnet-${count.index + 1}"
  }
}

# NAT instance
resource "aws_instance" "nat" {
  ami                    = var.amazon_linux_image[var.aws_region]
  subnet_id              = local.pub_sub_ids[0]
  instance_type          = var.aws_instance_type
  source_dest_check      = false
  vpc_security_group_ids = [aws_security_group.nat_sg.id]

  tags = {
    Name = var.instance_names["nat"]
  }
}
