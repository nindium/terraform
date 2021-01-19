variable "ec2_count" {
  default = 1
}

variable "ami_id" {
  default = "ami-0be2609ba883822ec"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "subnet_id" {

}

variable "ec2_key" {
  default = "Bastion"
}

variable "ec2_private_ip_pattern" {
  default = "192.168.10"
}

variable "sg_id" {

}

variable "ec2_name" {
  default = "EC2"
}
