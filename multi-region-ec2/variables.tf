variable "project" {
  default = "multi-region-ec2"
}

variable "iam_instance_profile_name" {
  type = string
}

variable "regions" {
  type = map(object({
    vpc_cidr         = string
    public_subnets   = list(string)
    private_subnets  = list(string)
    instance_type    = string
    min_size         = number
    max_size         = number
    desired_capacity = number
  }))
}
