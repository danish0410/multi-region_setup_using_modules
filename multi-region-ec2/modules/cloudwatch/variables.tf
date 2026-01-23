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

# variable "asg" {
#   description = "Name of the Auto Scaling Group to monitor"
#   type        = string
# }

# variable "cpu_threshold" {
#   description = "CPU utilization percentage that triggers the alarm"
#   type        = number
#   default     = 80
# }

# variable "evaluation_periods" {
#   description = "Number of periods over which data is compared to the threshold"
#   type        = number
#   default     = 2
# }

# variable "period" {
#   description = "The period in seconds over which the specified statistic is applied"
#   type        = number
#   default     = 300
# }

# variable "alarm_name_suffix" {
#   description = "Suffix appended to the CloudWatch alarm name"
#   type        = string
#   default     = "cpu-high"
# }

# variable "tags" {
#   description = "Tags to apply to the CloudWatch alarm"
#   type        = map(string)
#   default     = {}
# }
