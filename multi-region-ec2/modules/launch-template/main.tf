# -------------------------------------
# Fetch latest Ubuntu 24.04 LTS AMI (Canonical)
# -------------------------------------
data "aws_ami" "ubuntu_24_04" {
  count       = var.ami_id == null ? 1 : 0
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/*/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# -------------------------------------
# Fetch latest Ubuntu 24.04 AMI from AWS SSM
# -------------------------------------
data "aws_ssm_parameter" "ubuntu_24_04" {
  name = "/aws/service/canonical/ubuntu/server/24.04/stable/current/amd64/hvm/ebs-gp3/ami-id"
}

# -------------------------------------
# Launch Template for EC2
# -------------------------------------
resource "aws_launch_template" "this" {
  name_prefix            = "dev-lt-"
  update_default_version = true

  # Use user-provided AMI if supplied, otherwise latest Ubuntu 24.04
  # image_id = coalesce(
  #   var.ami_id,
  #   data.aws_ami.ubuntu_24_04[0].id
  # )

  image_id = var.ami_id != "" ? var.ami_id : data.aws_ssm_parameter.ubuntu_24_04.value

  instance_type = var.instance_type
  key_name      = var.key_name

  vpc_security_group_ids = var.security_groups

  iam_instance_profile {
    name = var.iam_instance_profile_name
  }

  user_data = var.user_data

  lifecycle {
    create_before_destroy = true
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "${var.environment}-${replace(var.region_name, "-", "")}-ec2"
      OS          = "ubuntu-24.04"
      Environment = var.environment
    }
  }
}
