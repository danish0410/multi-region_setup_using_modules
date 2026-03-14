s3 bucket
aws s3api create-bucket \
  --bucket arista-xpress-ap-south-1 \
  --region ap-south-1 \
  --create-bucket-configuration LocationConstraint=ap-south-1

dynamodb
aws dynamodb create-table \
  --table-name arista-testing-ap-south-2 \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
  --region ap-south-1

key
ap-south-2 = "Ubuntu KP-UAT-NViriginia"

terraform init
terraform validate
terraform plan
terraform apply
terraform destroy