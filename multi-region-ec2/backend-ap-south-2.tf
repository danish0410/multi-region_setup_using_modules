# terraform {
#   backend "s3" {
#     bucket         = "arista-xpress-ap-south-2"
#     key            = "multi-region/ap-south-2/terraform.tfstate"
#     region         = "ap-south-2"
#     dynamodb_table = "arista-testing-ap-south-2"
#     encrypt        = true
#   }
# }