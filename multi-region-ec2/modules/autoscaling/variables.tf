variable "min" {
  description = "Minimum number of EC2 instances in the Auto Scaling Group"
  type        = number
}

variable "max" {
  description = "Maximum number of EC2 instances in the Auto Scaling Group"
  type        = number
}

variable "desired" {
  description = "Desired number of EC2 instances in the Auto Scaling Group"
  type        = number
}

variable "subnets" {
  description = "List of subnet IDs for the Auto Scaling Group"
  type        = list(string)
}

variable "launch_template" {
  description = "Launch Template ID used by the Auto Scaling Group"
  type        = string
}

variable "asg_name" {
  description = "Name of the Auto Scaling Group"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to instances launched by ASG"
  type        = map(string)
  default     = {}
}

variable "environment" {
  type = string
}

variable "region" {
  type = string
}

variable "rds_identifier" {
  type    = string
  default = null
}

variable "target_group_arns" {
  type    = list(string)
  default = []
}

variable "min_healthy_percentage" {
  description = "Minimum healthy instances during refresh"
  type        = number
  default     = 50
}

variable "instance_warmup" {
  description = "Time for instance warmup in seconds"
  type        = number
  default     = 300
}

variable "max_healthy_percentage" {
  description = "Maximum healthy instances allowed during refresh"
  type        = number
  default     = 200
}
