terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

##################################
# CPU Alarm
##################################
resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "${var.environment}-${var.region}-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  threshold           = 80
  evaluation_periods  = 2

  metric_name = "CPUUtilization"
  namespace   = "AWS/EC2"
  period      = 300
  statistic   = "Average"

  dimensions = {
    AutoScalingGroupName = var.asg_name
  }

  treat_missing_data = "notBreaching"
}

##################################
# Network In Alarm
##################################
resource "aws_cloudwatch_metric_alarm" "network_in" {
  alarm_name          = "${var.environment}-${var.region}-network-in-high"
  comparison_operator = "GreaterThanThreshold"
  threshold           = 50000000
  evaluation_periods  = 2

  metric_name = "NetworkIn"
  namespace   = "AWS/EC2"
  period      = 300
  statistic   = "Sum"

  dimensions = {
    AutoScalingGroupName = var.asg_name
  }
}

##################################
# Status Check Alarm (CRITICAL)
##################################
resource "aws_cloudwatch_metric_alarm" "status_check" {
  alarm_name          = "${var.environment}-${var.region}-status-check-failed"
  comparison_operator = "GreaterThanThreshold"
  threshold           = 0
  evaluation_periods  = 1

  metric_name = "StatusCheckFailed"
  namespace   = "AWS/EC2"
  period      = 300
  statistic   = "Maximum"

  dimensions = {
    AutoScalingGroupName = var.asg_name
  }
}

##################################
# CloudWatch Dashboard
##################################
resource "aws_cloudwatch_dashboard" "dashboard" {
  dashboard_name = "${var.environment}-${var.region}-ec2-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        width  = 12
        height = 6
        x      = 0
        y      = 0
        properties = {
          title  = "CPU Utilization"
          region = var.region
          metrics = [
            ["AWS/EC2", "CPUUtilization", "AutoScalingGroupName", var.asg_name]
          ]
          stat   = "Average"
          period = 300
        }
      },
      {
        type   = "metric"
        width  = 12
        height = 6
        x      = 12
        y      = 0
        properties = {
          title  = "Network In / Out"
          region = var.region
          metrics = [
            ["AWS/EC2", "NetworkIn", "AutoScalingGroupName", var.asg_name],
            [".", "NetworkOut", ".", "."]
          ]
          stat   = "Sum"
          period = 300
        }
      },
      {
        type   = "metric"
        width  = 24
        height = 6
        x      = 0
        y      = 6
        properties = {
          title  = "Status Check"
          region = var.region
          metrics = [
            ["AWS/EC2", "StatusCheckFailed", "AutoScalingGroupName", var.asg_name]
          ]
          stat   = "Maximum"
          period = 300
        }
      }
    ]
  })
}

# resource "aws_cloudwatch_metric_alarm" "cpu" {
#   alarm_name          = "${var.asg}-cpu-high"
#   comparison_operator = "GreaterThanThreshold"
#   threshold           = 80
#   evaluation_periods  = 2
#   metric_name         = "CPUUtilization"
#   namespace           = "AWS/EC2"
#   period              = 300
#   statistic           = "Average"

#   dimensions = {
#     AutoScalingGroupName = var.asg
#   }
# }
