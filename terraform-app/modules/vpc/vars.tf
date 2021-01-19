
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "tenancy" {
  default = "default"
}

variable "subnet_cidr" {
  default = "10.0.0.0/24"
}

variable "az" {
  default = "us-east-1b"
}

variable "default_cidr" {
  default = "0.0.0.0/0"
}
