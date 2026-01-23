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
resource "aws_cloudwatch_metric_alarm" "rds_cpu_high" {
  alarm_name          = "${var.environment}-${var.region}-rds-cpu-high"
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
  alarm_actions      = [aws_sns_topic.alerts.arn]
  ok_actions         = [aws_sns_topic.alerts.arn]

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
  alarm_actions = [aws_sns_topic.alerts.arn]
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
  alarm_actions = [aws_sns_topic.alerts.arn]
}

################################
# RDS STORAGE ALARM
################################
resource "aws_cloudwatch_metric_alarm" "rds_storage" {
  alarm_name          = "${var.environment}-${var.region}-rds-storage-low"
  comparison_operator = "LessThanThreshold"
  threshold           = 10737418240 # 10 GB
  evaluation_periods  = 2
  statistic           = "Average"
  period              = 300

  metric_name = "FreeStorageSpace"
  namespace   = "AWS/RDS"

  dimensions = {
    DBInstanceIdentifier = var.rds_identifier
  }

  alarm_actions = [aws_sns_topic.alerts.arn]
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

################################
# SNS ALERT MANAGER
################################
resource "aws_sns_topic" "alerts" {
  name = "${var.environment}-${var.region}-alerts"
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = "thanigaivelansekar@gmail.com"
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
