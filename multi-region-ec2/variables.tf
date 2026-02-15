variable "project" {
  type    = string
  default = "myproject"
}

variable "regions" {
  type = map(object({
    vpc_cidr = string

    public_subnets = map(object({
      cidr = string
      az   = string
    }))

    # private_subnets = map(object({
    #   cidr = string
    #   az   = string
    # }))

    instance_type    = string
    min_size         = number
    max_size         = number
    desired_capacity = number
  }))
}

variable "ec2_keypair_map" {
  type = map(string)
}

variable "iam_instance_profile_name" {
  type        = string
  description = "IAM instance profile name for EC2"
}

variable "environment" {
  description = "Environment name (dev, qa, prod)"
  type        = string
  default     = "dev"
}

# variable "alert_email" {
#   description = "Email address for CloudWatch SNS alerts"
#   type        = string
# }

variable "ami_map" {
  description = "Region-wise AMI mapping"
  type        = map(string)
  default     = {}
}
