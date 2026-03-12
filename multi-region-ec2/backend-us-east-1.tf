# terraform {
#   backend "s3" {
#     bucket         = "arista-xpress-us-east-1"
#     key            = "multi-region/us-east-1/terraform.tfstate"
#     region         = "us-east-1"
#     dynamodb_table = "arista-prod-us-east-1"
#     encrypt        = true
#   }
# }