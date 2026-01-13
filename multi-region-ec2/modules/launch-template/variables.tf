variable "instance_type" {
  description = "EC2 instance type for the launch template"
  type        = string
}

variable "iam_instance_profile_name" {
  description = "IAM instance profile name attached to EC2 instances"
  type        = string
}

variable "security_groups" {
  description = "List of security group IDs to attach to the instance"
  type        = list(string)
}

variable "launch_template_name" {
  description = "Name of the launch template"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to the launch template"
  type        = map(string)
  default     = {}
}

variable "key_name" {
  description = "EC2 key pair name"
  type        = string
}

variable "region_name" {
  type = string
}

variable "user_data" {
  type        = string
  description = "User data script (base64 encoded)"
}
