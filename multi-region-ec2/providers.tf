terraform {
  required_version = ">= 1.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.25"
    }
  }

  # backend "s3" {
  #   # bucket         = var.bucket_name_map
  #   # key            = var.terraform_state_key_map
  #   region = var.region_name
  #   # dynamodb_table = var.dynamodb_table_map
  #   encrypt = true
  # }
}

# provider "aws" {
#   alias  = "ap_south_1"
#   region = "ap-south-1"
# }

# provider "aws" {
#   alias  = "ap_south_2"
#   region = "ap-south-2"
# }

# provider "aws" {
#   alias  = "us_east_1"
#   region = "us-east-1"
# }

provider "aws" {
  alias  = "us_east_2"
  region = "us-east-2"
}
