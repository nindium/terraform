variable "vpc_cidr" {
  description = "VPC subnet"
  type        = string
  default     = "10.0.0.0/16"
}

variable "aws_region" {
  description = "Define AWS region"
  type        = string
  default     = "us-east-1"
}

variable "default_cidr" {
  description = "Define default cidr block (default route etc)"
  type        = string
  default     = "0.0.0.0/0"
}

variable "amazon_linux_image" {
  description = "AWS Amazon linux image"
  type        = map(any)
  default = {
    "us-east-1" : "ami-0be2609ba883822ec"
    "us-east-2" : "ami-0a0ad6b70e61be944"
  }
}

variable "aws_instance_type" {
  description = "Define EC2 instance type for all instances in the project"
  type        = string
  default     = "t2.micro"
}

variable "instance_names" {
  description = "Names for instances in the project"
  type        = map(any)
  default = {
    "nat" : "NAT instance"
    "web" : "WEB (Ubuntu)"
  }
}

variable "web_instances_count" {
  description = "Define how many WEB instances should we have"
  type        = number
  default     = 2
}

variable "s3_tags" {
  type = map(string)
  default = {
    Name = "Bucket-TF"
  }
}

variable "s3b_name" {
  description = "S3 bucket name"
  type        = string
  default     = "cloudschool-s3-stor"
}

variable "access_log_bucket_name" {
  description = "S3 bucket to store ALB access logs"
  type        = string
  default     = "tfalb-access-logs"
}
