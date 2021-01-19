provider "aws" {
  region = "us-east-1"
}

module "my_vpc" {
  source      = "../modules/vpc"
  vpc_cidr    = "192.168.0.0/16"
  tenancy     = "default"
  subnet_cidr = "192.168.1.0/24"

}

module "my_ec2" {
  source         = "../modules/ec2"
  ec2_count      = 1
  ami_id         = "ami-0be2609ba883822ec"
  instance_type  = "t2.micro"
  ec2_private_ip = "192.168.1.10"
  sg_id          = "default"
  subnet_id      = module.my_vpc.subnet_id

}
