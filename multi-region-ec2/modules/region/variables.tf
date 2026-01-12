variable "region_name" {
  type = string
}

variable "project" {
  type = string
}

variable "iam_instance_profile_name" {
  type = string
}

variable "config" {
  type = object({
    vpc_cidr         = string
    public_subnets   = list(string)
    private_subnets  = list(string)
    instance_type    = string
    min_size         = number
    max_size         = number
    desired_capacity = number
  })
}

variable "key_name" {
  type = string
}
