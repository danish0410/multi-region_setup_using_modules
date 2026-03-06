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

  target_group_arns = var.target_group_arns

  health_check_type         = "ELB"
  health_check_grace_period = 600

  tag {
    key                 = "Name"
    value               = "Xpress-prod-ec2"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }

  instance_refresh {
    strategy = "Rolling"

    preferences {
      min_healthy_percentage = var.min_healthy_percentage
      max_healthy_percentage = var.max_healthy_percentage
      instance_warmup        = var.instance_warmup

      auto_rollback                = true
      scale_in_protected_instances = "Ignore"
      standby_instances            = "Ignore"
    }
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
