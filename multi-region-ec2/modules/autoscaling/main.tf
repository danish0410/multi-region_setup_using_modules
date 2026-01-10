resource "aws_autoscaling_group" "this" {
  min_size            = var.min
  max_size            = var.max
  desired_capacity    = var.desired
  vpc_zone_identifier = var.subnets

  launch_template {
    id      = var.launch_template
    version = "$Latest"
  }
}
