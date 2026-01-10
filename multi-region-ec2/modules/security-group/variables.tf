variable "vpc_id" {
  description = "VPC ID where security groups will be created"
  type        = string
}

variable "common_sg_name" {
  description = "Name of the common security group"
  type        = string
  default     = "common-sg"
}

variable "user_sg_name" {
  description = "Name of the user security group"
  type        = string
  default     = "user-sg"
}

variable "allowed_cidr_blocks" {
  description = "Allowed CIDR blocks for common SG ingress rules"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "tags" {
  description = "Tags to apply to security groups"
  type        = map(string)
  default     = {}
}
