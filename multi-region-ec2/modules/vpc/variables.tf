variable "cidr_block" {
  type = string
}

variable "project" {
  type = string
}

variable "region" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}
