terraform {
  backend "s3" {
    bucket         = "arista-xpress-us-east-2"
    key            = "multi-region/us-east-2/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "arista-prod-us-east-2"
    encrypt        = true
  }
}