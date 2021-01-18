data "template_file" "ec2_s3_policy" {
  template = file("data/iam/role-policy-template.json")
  vars = {
    s3_bucket_arn = "arn:aws:s3:::${var.s3b_name}/*"
  }
}


resource "aws_iam_role" "ec2s3_access_role" {
  name               = "ec2s3_access_role"
  assume_role_policy = file("data/iam/ec2-trust-policy.json")

}

resource "aws_iam_role_policy" "ec2s3_access_policy" {
  name   = "ec2s3_access_policy"
  role   = aws_iam_role.ec2s3_access_role.id
  policy = data.template_file.ec2_s3_policy.rendered
}

resource "aws_iam_instance_profile" "ec2s3_access_profile" {
  name = "ec2s3_access_profile"
  role = aws_iam_role.ec2s3_access_role.name
}
