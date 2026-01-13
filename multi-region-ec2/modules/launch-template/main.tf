# -------------------------------------
# Fetch latest Ubuntu 22.04 AMI (Canonical) dynamically per region
# -------------------------------------
data "aws_ami" "ubuntu_22_04" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# -------------------------------------
# Launch Template for EC2
# -------------------------------------
resource "aws_launch_template" "this" {
  name_prefix   = "dev-classic-lt-"
  image_id      = data.aws_ami.ubuntu_22_04.id
  instance_type = var.instance_type
  key_name      = var.key_name

  vpc_security_group_ids = var.security_groups

  iam_instance_profile {
    name = var.iam_instance_profile_name
  }

  user_data = var.user_data

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "dev-classic-instance"
    }
  }
}
