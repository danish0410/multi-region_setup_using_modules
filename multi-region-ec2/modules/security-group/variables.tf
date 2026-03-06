variable "vpc_id" {
  type        = string
  description = "VPC ID where security groups are created"
}

variable "common_sg_name" {
  type        = string
  description = "Name of the common security group"
}

variable "user_sg_name" {
  type        = string
  description = "Name of the user security group"
}

variable "allowed_cidr_blocks" {
  type        = list(string)
  description = "Allowed CIDR blocks for ingress rules"
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "vpc_cidr" {
  type = string
}
