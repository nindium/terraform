
resource "aws_key_pair" "learner" {
  key_name   = "learner"
  public_key = file("data/learner.pub")

}

resource "aws_instance" "web" {
  count = var.web_instances_count
  #ami                    = data.aws_ami.ubuntu.id   #Used for demostration purpouse (How to get ami dynamically)
  ami                    = var.amazon_linux_image[var.aws_region]
  instance_type          = var.aws_instance_type
  subnet_id              = local.pub_sub_ids[count.index]
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  key_name               = aws_key_pair.learner.key_name
  user_data              = file("data/scripts/apache.sh")
  iam_instance_profile   = aws_iam_instance_profile.ec2s3_access_profile.name
  private_ip             = "10.0.${count.index}.10"
  tags = {
    Name        = join(" ", ["WebServer", count.index])
    Environment = terraform.workspace
  }

}
