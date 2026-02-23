variable "domain_name" {
  description = "Domain name for ACM certificate"
  type        = string
}

variable "validation_method" {
  description = "Validation method for ACM"
  type        = string
  default     = "DNS"
}