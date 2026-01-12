data "aws_ssm_parameter" "ubuntu_24_04" {
  name = "/aws/service/canonical/ubuntu/server/24.04/stable/current/amd64/hvm/ebs-gp3/ami-id"
}

resource "aws_launch_template" "this" {
  name_prefix   = "lt-"
  image_id      = data.aws_ssm_parameter.ubuntu_24_04.value
  instance_type = var.instance_type

  vpc_security_group_ids = var.security_groups

  iam_instance_profile {
    name = var.iam_instance_profile_name
  }
}
