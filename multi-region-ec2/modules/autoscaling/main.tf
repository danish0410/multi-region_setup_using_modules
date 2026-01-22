resource "aws_autoscaling_group" "this" {
  name                = "${var.environment}-${var.region}-asg"
  min_size            = var.min
  max_size            = var.max
  desired_capacity    = var.desired
  vpc_zone_identifier = var.subnets

  launch_template {
    id      = var.launch_template
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.environment}-${var.region}-ec2"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

# resource "aws_autoscaling_group" "this" {
#   min_size            = var.min
#   max_size            = var.max
#   desired_capacity    = var.desired
#   vpc_zone_identifier = var.subnets

#   launch_template {
#     id      = var.launch_template
#     version = "$Latest"
#   }
# }
