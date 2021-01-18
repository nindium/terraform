
locals {
  vpc_name = terraform.workspace == "dev" ? "VPC-TF-Dev" : "VPC-TF-Prod"
}

resource "aws_vpc" "my_vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  tags = {
    Name        = local.vpc_name
    Environment = terraform.workspace
    Location    = "USA"
  }
}
