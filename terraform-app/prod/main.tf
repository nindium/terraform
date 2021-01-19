provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "learner" {
  key_name   = "learner"
  public_key = file("/home/just/.ssh/id_rsa.pub")
}

module "prod-vpc" {
  source      = "../modules/vpc"
  vpc_cidr    = "172.16.0.0/16"
  subnet_cidr = "172.16.10.0/24"
  az          = "us-east-1a"

}

module "prod-ec2" {
  source                 = "../modules/ec2"
  ec2_count              = 2
  ec2_name               = "ProdSrv"
  subnet_id              = module.prod-vpc.subnet_id
  ec2_key                = aws_key_pair.learner.key_name
  sg_id                  = module.prod-vpc.sg_id
  ec2_private_ip_pattern = "172.16.10"
}
