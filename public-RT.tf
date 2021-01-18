
locals {
  pub_sub_ids = aws_subnet.public_subnet[*].id
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = var.default_cidr
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "Public-RT (${terraform.workspace})"
  }
}

# Public subnet association
resource "aws_route_table_association" "pubas" {
  count          = length(local.az_names)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_rt.id
}
