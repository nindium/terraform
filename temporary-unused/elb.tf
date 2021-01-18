resource "aws_elb" "web_elb" {
  name            = "cloudiar-elb-${terraform.workspace}"
  subnets         = [local.pub_sub_ids[0], local.pub_sub_ids[1]]
  security_groups = [aws_security_group.elb_sg.id]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/index.html"
    interval            = 30
  }

  #instances                   = [aws_instance.web[0].id, aws_instance.web[1].id]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 30

  tags = {
    Name = "Cloudiar-ELB-${terraform.workspace}"
  }
}
