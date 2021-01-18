locals {
  az_names = data.aws_availability_zones.az.names
  az_num   = 0
}

resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.my_vpc.id
  #cidr_block        = cidrsubnet(var.vpc_cidr, 8, local.az_num + 1)
  #availability_zone = local.az_names[0]
  count                   = length(local.az_names)
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index)
  availability_zone       = local.az_names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "Public Subnet-${count.index + 1}"

  }
}
