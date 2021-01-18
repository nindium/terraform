provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {
    region         = "us-east-1"
    bucket         = "cloudiar-terraf-bucket"
    key            = "VPC-TF/terraform.tfstate"
    dynamodb_table = "cloudiar-tf"
  }
}
