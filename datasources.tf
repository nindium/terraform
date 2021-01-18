data "aws_availability_zones" "az" {
  state = "available"
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # 'Canonical' id

  filter {
    name = "name"
    values = [
      #"Ubuntu Server 20.04 *",
      "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20201026",

    ]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}
