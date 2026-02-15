variable "region" {
  description = "AWS region"
  type        = string
}

variable "asg_name" {
  description = "Auto Scaling Group name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "rds_identifier" {
  description = "RDS instance identifier (optional)"
  type        = string
  default     = null
}

# variable "alert_email" {
#   description = "Email address for SNS alerts"
#   type        = string
# }
