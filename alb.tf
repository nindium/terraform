resource "aws_lb_target_group" "cloudiar-tf" {
  name     = "cloudiar-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.my_vpc.id
}

resource "aws_lb_target_group_attachment" "cloudiar" {
  count            = var.web_instances_count
  target_group_arn = aws_lb_target_group.cloudiar-tf.arn
  target_id        = aws_instance.web[count.index].id
  port             = 80
}

resource "aws_lb" "cloudiar-lb" {
  name               = "cloudiar-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.elb_sg.id]
  subnets            = [local.pub_sub_ids[0], local.pub_sub_ids[1]]
  access_logs {
    bucket  = var.access_log_bucket_name
    enabled = true
  }
  tags = {
    Environment = terraform.workspace
  }
}

resource "aws_lb_listener" "web_listener" {
  load_balancer_arn = aws_lb.cloudiar-lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.cloudiar-tf.id
  }
}
