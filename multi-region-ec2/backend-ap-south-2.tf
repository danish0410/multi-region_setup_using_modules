terraform {
  backend "s3" {
    bucket         = "xpress-prod-hyderabad"
    key            = "multi-region/ap-south-2/terraform.tfstate"
    region         = "ap-south-2"
    dynamodb_table = "arista-prod-us-east-2"
    encrypt        = true
  }
}