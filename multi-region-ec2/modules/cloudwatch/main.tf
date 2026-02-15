terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

################################
# SNS ALERT MANAGER
################################
resource "aws_sns_topic" "alerts" {
  name = "${var.environment}-${var.region}-alerts"
}

# resource "aws_sns_topic_subscription" "email" {
#   topic_arn = aws_sns_topic.alerts.arn
#   protocol  = "email"
#   endpoint  = var.alert_email
# }

##################################
# EC2 CPU ALARM
##################################
resource "aws_cloudwatch_metric_alarm" "ec2_cpu_high" {
  alarm_name          = "${var.environment}-${var.region}-ec2-cpu-high"
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
}

##################################
# EC2 NETWORK IN ALARM
##################################
resource "aws_cloudwatch_metric_alarm" "network_in_high" {
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
# INSTANCE STATUS CHECK FAILED
##################################
resource "aws_cloudwatch_metric_alarm" "instance_status_failed" {
  alarm_name          = "${var.environment}-${var.region}-instance-status-failed"
  comparison_operator = "GreaterThanThreshold"
  threshold           = 0
  evaluation_periods  = 1

  metric_name = "StatusCheckFailed_Instance"
  namespace   = "AWS/EC2"
  period      = 60
  statistic   = "Maximum"

  dimensions = {
    AutoScalingGroupName = var.asg_name
  }

  alarm_actions = [aws_sns_topic.alerts.arn]
}

##################################
# SYSTEM STATUS CHECK FAILED
##################################
resource "aws_cloudwatch_metric_alarm" "system_status_failed" {
  alarm_name          = "${var.environment}-${var.region}-system-status-failed"
  comparison_operator = "GreaterThanThreshold"
  threshold           = 0
  evaluation_periods  = 1

  metric_name = "StatusCheckFailed_System"
  namespace   = "AWS/EC2"
  period      = 60
  statistic   = "Maximum"

  dimensions = {
    AutoScalingGroupName = var.asg_name
  }

  alarm_actions = [aws_sns_topic.alerts.arn]
}

##################################
# ANY STATUS CHECK FAILED (INSTANCE + SYSTEM)
##################################
resource "aws_cloudwatch_metric_alarm" "any_status_failed" {
  alarm_name          = "${var.environment}-${var.region}-any-status-failed"
  comparison_operator = "GreaterThanThreshold"
  threshold           = 0
  evaluation_periods  = 1

  metric_name = "StatusCheckFailed"
  namespace   = "AWS/EC2"
  period      = 60
  statistic   = "Maximum"

  dimensions = {
    AutoScalingGroupName = var.asg_name
  }

  alarm_actions = [aws_sns_topic.alerts.arn]
}

##################################
# EBS VOLUME STATUS CHECK FAILED
##################################
resource "aws_cloudwatch_metric_alarm" "ebs_status_failed" {
  alarm_name          = "${var.environment}-${var.region}-ebs-status-failed"
  comparison_operator = "GreaterThanThreshold"
  threshold           = 0
  evaluation_periods  = 1

  metric_name = "VolumeStatusCheckFailed"
  namespace   = "AWS/EBS"
  period      = 60
  statistic   = "Maximum"

  alarm_actions = [aws_sns_topic.alerts.arn]
}

################################
# RDS STORAGE LOW (OPTIONAL)
################################
resource "aws_cloudwatch_metric_alarm" "rds_storage_low" {
  count               = var.rds_identifier == null ? 0 : 1
  alarm_name          = "${var.environment}-${var.region}-rds-storage-low"
  comparison_operator = "LessThanThreshold"
  threshold           = 10737418240
  evaluation_periods  = 2
  period              = 300
  statistic           = "Average"

  metric_name = "FreeStorageSpace"
  namespace   = "AWS/RDS"

  dimensions = {
    DBInstanceIdentifier = var.rds_identifier
  }

  alarm_actions = [aws_sns_topic.alerts.arn]
}

##################################
# CLOUDWATCH DASHBOARD
##################################
resource "aws_cloudwatch_dashboard" "dashboard" {
  dashboard_name = "${var.environment}-${var.region}-ec2-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        width  = 24
        height = 6
        properties = {
          title  = "EC2 Status Checks"
          region = var.region
          metrics = [
            ["AWS/EC2", "StatusCheckFailed", "AutoScalingGroupName", var.asg_name],
            [".", "StatusCheckFailed_Instance", ".", "."],
            [".", "StatusCheckFailed_System", ".", "."]
          ]
          stat   = "Maximum"
          period = 60
        }
      }
    ]
  })
}
