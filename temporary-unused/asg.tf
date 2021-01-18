resource "aws_launch_configuration" "web_lc" {
  name                 = "web_lc"
  image_id             = var.amazon_linux_image[var.aws_region]
  instance_type        = var.aws_instance_type
  key_name             = aws_key_pair.learner.key_name
  user_data            = file("data/scripts/apache.sh")
  iam_instance_profile = aws_iam_instance_profile.ec2s3_access_profile.name
  security_groups      = [aws_security_group.web_sg.id]

}

resource "aws_autoscaling_group" "web_asg" {
  name                      = "web_asg"
  min_size                  = 1
  max_size                  = 4
  desired_capacity          = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  vpc_zone_identifier       = [local.pub_sub_ids[0], local.pub_sub_ids[1]]
  launch_configuration      = aws_launch_configuration.web_lc.name
  load_balancers            = [aws_elb.web_elb.name]
}

resource "aws_autoscaling_policy" "web_policy_up" {
  name                   = "web_policy_up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.web_asg.name
}

resource "aws_autoscaling_policy" "web_policy_down" {
  name                   = "web_policy_down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.web_asg.name
}

resource "aws_cloudwatch_metric_alarm" "web_cpu_alarm_ge_80" {
  alarm_name          = "web_cpu_alarm_60"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "60"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web_asg.name
  }

  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions     = [aws_autoscaling_policy.web_policy_up.arn]
}

resource "aws_cloudwatch_metric_alarm" "web_cpu_alarm_ge_30" {
  alarm_name          = "web_cpu_alarm_30"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "30"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web_asg.name
  }

  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions     = [aws_autoscaling_policy.web_policy_down.arn]
}
