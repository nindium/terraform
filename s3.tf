locals {
  env_tags = {
    Environment = terraform.workspace
  }

  s3_tags = merge(var.s3_tags, local.env_tags)
}
#resource "aws_s3_bucket" "my_s3_bucket" {
#  bucket = var.s3b_name
#  acl    = "private"

#  tags = local.s3_tags
#}

resource "aws_s3_bucket" "alb_access_logs" {
  bucket = var.access_log_bucket_name
  acl    = "private"
  policy = data.template_file.s3_access_log_policy.rendered

  tags = {
    Name       = "tfalb-access-logs"
    Evironment = terraform.workspace
  }
}

data "template_file" "s3_access_log_policy" {
  template = file("data/iam/alb-s3-access-logs.json")
  vars = {
    access_log_bucket = var.access_log_bucket_name
  }
}
