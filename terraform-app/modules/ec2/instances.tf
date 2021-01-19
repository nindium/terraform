
resource "aws_instance" "web" {
  count                  = var.ec2_count
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  key_name               = var.ec2_key
  private_ip             = join(".", [var.ec2_private_ip_pattern, count.index + 10])
  vpc_security_group_ids = [var.sg_id]
  tags = {
    Name = "${var.ec2_name}-${count.index}"
  }
}
