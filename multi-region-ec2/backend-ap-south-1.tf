# terraform {
#   backend "s3" {
#     bucket         = "arista-xpress-ap-south-1"
#     key            = "multi-region/ap-south-1/terraform.tfstate"
#     region         = "ap-south-1"
#     dynamodb_table = "arista-prod-ap-south-1"
#     encrypt        = true
#   }
# }