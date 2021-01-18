resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block  = var.default_cidr
    instance_id = aws_instance.nat.id
  }
  tags = {
    Name = "Private-RT (${terraform.workspace})"
  }
}

resource "aws_route_table_association" "privas" {
  count          = length(slice(local.az_names, 0, 2))
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_rt.id
}
