terraform {
  backend "s3" {
    bucket = "tfstatebackup-16102025-east2"
    key    = "multi-region/us-east-2/terraform.tfstate"
    region = "us-east-2"
    # dynamodb_table = "arista-prod-us-east-2"
    dynamodb_table = "terraformeast-locks"

    encrypt = true
  }
}