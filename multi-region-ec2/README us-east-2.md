s3 bucket
aws s3api create-bucket \
  --bucket xpress-prod-hyderabad \
  --region us-east-2 \
  --create-bucket-configuration LocationConstraint=us-east-2

dynamodb
aws dynamodb create-table \
  --table-name arista-prod-us-east-2 \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
  --region us-east-2

key
us-east-2 = "Ubuntu KP-UAT-NViriginia"

terraform init
terraform validate
terraform plan
terraform apply
terraform destroy