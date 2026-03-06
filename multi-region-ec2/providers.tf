terraform {
  required_version = ">= 1.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.25"
    }
  }
}

# provider "aws" {
#   alias  = "ap_south_1"
#   region = "ap-south-1"
# }

provider "aws" {
  alias  = "ap_south_2"
  region = "ap-south-2"
}

# provider "aws" {
#   alias  = "us_east_1"
#   region = "us-east-1"
# }

# provider "aws" {
#   alias  = "us_east_2"
#   region = "us-east-2"
# }
