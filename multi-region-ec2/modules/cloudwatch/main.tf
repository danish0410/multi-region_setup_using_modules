resource "aws_cloudwatch_metric_alarm" "cpu" {
  alarm_name          = "${var.asg}-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  threshold           = 80
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"

  dimensions = {
    AutoScalingGroupName = var.asg
  }
}
