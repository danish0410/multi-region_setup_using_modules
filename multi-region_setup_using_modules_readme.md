README.md

▶ Path: multi-region_setup_using_modules/multi-region-ec2/README.md

# 🌍 Multi-Region EC2 Infrastructure (Terraform Modules)

This project provisions **highly consistent EC2 Auto Scaling infrastructure across multiple AWS regions** using Terraform modules.

## 🌎 Regions
- ap-south-1
- us-east-1
- us-east-2

---

## 🧱 High-Level Architecture

                    ┌──────────────────────────┐
                    │        IAM (Global)      │
                    │  EC2 Role + SSM Profile  │
                    └────────────┬─────────────┘
                                 │
        ┌────────────────────────┼────────────────────────┐
        │                        │                        │
┌───────▼────────┐     ┌─────────▼────────┐     ┌─────────▼────────┐
│ ap-south-1     │     │ us-east-1        │     │ us-east-2        │
│                │     │                  │     │                  │
│  VPC           │     │  VPC             │     │  VPC             │
│   ├─ Subnets   │     │   ├─ Subnets     │     │   ├─ Subnets     │
│   ├─ IGW       │     │   ├─ IGW         │     │   ├─ IGW         │
│   ├─ SGs       │     │   ├─ SGs         │     │   ├─ SGs         │
│   ├─ LT        │     │   ├─ LT          │     │   ├─ LT          │
│   └─ ASG       │     │   └─ ASG         │     │   └─ ASG         │
└────────────────┘     └──────────────────┘     └──────────────────┘
        │                        │                        │
        └─────────────── CloudWatch Alarms ───────────────┘

📌 Architecture Overview

Each region includes:
🔹 VPC with public subnets
🔹 Internet Gateway & route tables
🔹 Security groups (common + user)
🔹 Launch Template (Ubuntu 24.04)
🔹 Auto Scaling Group
🔹 CloudWatch alarms per ASG
Shared (global):
🔹 IAM role + instance profile (SSM enabled)
🔹 Terraform backend (S3 + DynamoDB)
🔹 SSH ED25519 key management

---

## 🔐 Terraform State Backend
- **S3** for remote state
# ap-south-1
aws s3api create-bucket \
  --bucket tfstatebackup-16102025-south \
  --region ap-south-1 \
  --create-bucket-configuration LocationConstraint=ap-south-1

# us-east-1
aws s3api create-bucket \
  --bucket tfstatebackup-16102025-east \
  --region us-east-1

# us-east-2
aws s3api create-bucket \
  --bucket tfstatebackup-16102025-east2 \
  --region us-east-2 \
  --create-bucket-configuration LocationConstraint=us-east-2

- **DynamoDB** for state locking
# ap-south-1
aws dynamodb create-table \
  --table-name terraformsouth-locks \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
  --region ap-south-1

# us-east-1
aws dynamodb create-table \
  --table-name terraformeast-locks \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
  --region us-east-1

# us-east-2
aws dynamodb create-table \
  --table-name terraformeast-locks \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
  --region us-east-2

🔐 SSH Key Management (ED25519)
⚠️ Important: Delete old keys from AWS Console before generating new ones.
🔹 Cleanup Existing Keys
rm -f ~/.ssh/dev-classic-ap-south-1*
rm -f ~/.ssh/dev-classic-us-east-1*
rm -f ~/.ssh/dev-classic-us-east-2*

aws ec2 delete-key-pair --key-name dev-classic-ap-south-1 --region ap-south-1
aws ec2 delete-key-pair --key-name dev-classic-us-east-1  --region us-east-1
aws ec2 delete-key-pair --key-name dev-classic-us-east-2  --region us-east-2

🔹 Generate & Import Keys
chmod +x scripts/generate_ed25519_key.sh

./scripts/generate_ed25519_key.sh dev-classic-ap-south-1 ap-south-1
./scripts/generate_ed25519_key.sh dev-classic-us-east-1  us-east-1
./scripts/generate_ed25519_key.sh dev-classic-us-east-2  us-east-2
✔ Uses ED25519
✔ Idempotent (safe re-runs)
✔ Automatically imports to AWS

- Backend is **pre-created per region**

---

## 🚀 terraform workflow

terraform init -reconfigure
terraform init -upgrade
terraform fmt -recursive
terraform validate
terraform plan
terraform apply

🧨 Destroy Infrastructure

terraform destroy


Modules
|-------------------|---------------------------------------|
|Module				| Purpose								|
|-------------------|---------------------------------------|
|vpc				| VPC, subnets, routing					|
|subnets			| Provides subnet CIDR range allocation	|
|security-group		| HTTP/HTTPS + restricted SGs			|
|launch-template	| EC2 bootstrap definition				|
|autoscaling		| Auto Scaling Groups					|
|iam				| Shared EC2 IAM role					|
|cloudwatch			| ASG monitoring						|
|region				| Regional composition					|
|-------------------|---------------------------------------|

composition
🛡️ Best Practices Used

🔹 Modular design
🔹 Region isolation
🔹 SSM-only access (no SSH needed)
🔹 ED25519 keysv
🔹 create_before_destroy
🔹 Dynamic AMI resolution

*************************************************************
*************************************************************
*************************************************************

# 📄 Module README: `vpc`
**Path:** `modules/vpc/README.md`

```md
# 📦 VPC Module

Creates a fully functional **public VPC** per region.

---

## 🧱 Architecture

VPC
 ├── Internet Gateway
 ├── Public Subnets (multi-AZ)
 ├── Route Table (0.0.0.0/0 → IGW)
 └── Route Table Associations

---

## Resources
- aws_vpc
- aws_internet_gateway
- aws_subnet (public)
- aws_route_table
- aws_route_table_association

## Inputs
|-------------------|-----------------------|
| Name 				| Description 			|
|-------------------|-----------------------|
| project 			| Project name 			|
| region 			| AWS region 			|
| cidr_block 		| VPC CIDR 				|
| public_subnets 	| Subnet CIDRs & AZs 	|
| tags 				| Tags 					|
|-------------------|-----------------------|

## Outputs
|-------------------|-----------------------|
| Name 				| Description 			|
|-------------------|-----------------------|
| vpc_id 			| VPC ID 				|
| public_subnet_ids | Public subnet IDs 	|
|-------------------|-----------------------|

## Notes
- DNS hostnames enabled
- Ready for ALB / NAT expansion

*************************************************************
*************************************************************
*************************************************************
# 📄 Module README: subnets
**Path:** modules/subnets/README.md

# 📦 Subnets Module
Creates **public subnets** inside an existing VPC.

---

## 🧱 Architecture

VPC
 ├── Public Subnet 1
 ├── Public Subnet 2
 ├── Public Subnet 3
 └── Auto-assign Public IPs

---

## Resources
- aws_subnet (public)

---

## Inputs
|-------------------|---------------------------------------|
| Name 				| Description 							|
|-------------------|---------------------------------------|
| vpc_id 			| VPC ID where subnets will be created	|
| public_subnets 	| List of public subnet CIDR blocks		|
|-------------------|---------------------------------------|

---

## Outputs
|-------------------|---------------------------------------|
| Name 				| Description 							|
|-------------------|---------------------------------------|
| public_subnet_ids | List of created public subnet IDs 	|
|-------------------|---------------------------------------|
---

## Notes
- Subnets are created using `count` for scalability
- Public IPs are automatically assigned on instance launch
- AZ selection can be extended if required
- Designed for **multi-region reusable modules**

*************************************************************
*************************************************************
*************************************************************
# 📄 Module README: security-group
**Path:** 'modules/security-group/README.md'

# 🔐 Security Group Module

Creates **two security groups** per VPC.

---

## 🧱 Architecture

Security Groups
 ├── Common SG
 │    ├─ Ingress: 80 / 443
 │    └─ Egress: All
 └── User SG
      └─ Egress: All

---

## Resources
- aws_security_group.common
- aws_security_group.user

---

## Inputs
|-----------------------|-----------------------------------|
| Name 					| Description						|
|-----------------------|-----------------------------------|
| vpc_id 				| Target VPC 						|
| common_sg_name 		| HTTP/HTTPS SG 					|
| user_sg_name 			| Restricted SG 					|
| allowed_cidr_blocks	| Allowed ingress CIDRs 			|
| tags 					| Tags 								|
|-----------------------|-----------------------------------|

---

## Outputs
|-----------------------|-----------------------------------|
| Name 					| Description 						|
|-----------------------|-----------------------------------|
| common_sg_id 			| Common SG 						|
| user_sg_id 			| User SG 							|
| all_sg_ids 			| All SG IDs 						|
|-----------------------|-----------------------------------|

---

## Notes
- SSH intentionally excluded
- Safe default posture

*************************************************************
*************************************************************
*************************************************************
Module README: launch-template
Path: modules/launch-template/README.md

# 🚀 Launch Template Module

Defines how EC2 instances are launched.
---

## 🧱 Architecture

Launch Template
 ├── Ubuntu 24.04 (Latest)
 ├── Instance Type
 ├── Security Groups
 ├── IAM Instance Profile
 ├── ED25519 Key Pair
 └── User Data Script

---

## Resources
- aws_launch_template
- data.aws_ami (Ubuntu)

---

## Inputs
|---------------------------|-------------------------------|
| Name 						| Description					|
|---------------------------|-------------------------------|
| instance_type 			| EC2 size 						|
| security_groups 			| SG IDs 						|
| iam_instance_profile_name | IAM profile 					|
| key_name 					| SSH key 						|
| user_data 				| Base64 script 				|
|---------------------------|-------------------------------|
---

## Outputs
|---------------------------|-------------------------------|
| Name 						| Description 					|
|---------------------------|-------------------------------|
| launch_template_id 		| Template ID 					|
| launch_template_arn 		| Template ARN 					|
| launch_template_latest_ver| Latest version 				|
|---------------------------|-------------------------------|
---

## Notes
- AMI resolved dynamically
- Docker + Ansible preinstalled

*************************************************************
*************************************************************
*************************************************************
Module README: autoscaling
Path: modules/autoscaling/README.md

# 📈 Auto Scaling Module

Creates an **Auto Scaling Group** per region.

---

## 🧱 Architecture

Auto Scaling Group
 ├── Launch Template
 ├── Public Subnets
 ├── Min / Max / Desired
 └── Rolling Updates

---

## Resources
- aws_autoscaling_group

---

## Inputs
|---------------------------|-------------------------------|
| Name 						| Description 					|
|---------------------------|-------------------------------|
| min 						| Minimum instances 			|
| max 						| Maximum instances 			|
| desired 					| Desired capacity 				|
| subnets 					| Subnet IDs 					|
| launch_template 			| Template ID 					|
| environment 				| Env name 						|
| region 					| Region 						|
|---------------------------|-------------------------------|
---

## Outputs
|---------------------------|-------------------------------|
| Name 						| Description 					|
|---------------------------|-------------------------------|
| asg_name 					| ASG name 						|
| autoscaling_group_id 		| ASG ID 						|
| autoscaling_group_arn 	| ASG ARN 						|
|---------------------------|-------------------------------|
---

## Best Practices
- create_before_destroy enabled
- Tag propagation enabled

*************************************************************
*************************************************************
*************************************************************
Module README: iam
Path: modules/iam/README.md

# 🔑 IAM Module

Creates **shared IAM resources** for all EC2 instances.

---

## 🧱 Architecture

IAM
 ├── EC2 Role
 ├── AmazonSSMManagedInstanceCore
 └── Instance Profile

---

## Resources
- aws_iam_role
- aws_iam_role_policy_attachment
- aws_iam_instance_profile

---

## Outputs
|---------------------------|-------------------------------|
| Name 						| Description 					|
|---------------------------|-------------------------------|
| instance_profile_name 	| Profile name 					|
|---------------------------|-------------------------------|
---

## Notes
- Enables SSM Session Manager
- No SSH required

*************************************************************
*************************************************************
*************************************************************
Module README: cloudwatch
Path: modules/cloudwatch/README.md

# 📊 CloudWatch Module

Creates **region-specific monitoring** for Auto Scaling Groups.

---

## 🧱 Architecture

CloudWatch
 ├── ASG Metrics
 ├── CPU Alarms
 └── (Optional) RDS Alarms

---

## Inputs
|-------------------|---------------|
| Name 				| Description 	|
|-------------------|---------------|
| region 			| AWS region 	|
| asg_name 			| ASG name 		|
| environment 		| Env 			|
| rds_identifier	| Optional 		|
|-------------------|---------------|
---

## Notes
- One module instance per region
- Easy to extend for ALB / memory

*************************************************************
*************************************************************
*************************************************************
Module README: region
Path: modules/region/README.md

# 🌎 Region Module

Acts as a **composition layer** for regional infrastructure.

---

## 🧱 Architecture

Region Module
 ├── VPC
 ├── Security Groups
 ├── Launch Template
 └── Auto Scaling Group

---

## Inputs
|---------------------------|-------------------------------|
| Name 						| Description 					|
|---------------------------|-------------------------------|
| region_name 				| Region 						|
| project 					| Project 						|
| environment 				| Env 							|
| key_name 					| EC2 key 						|
| iam_instance_profile_name | IAM 							|
| config 					| Region config 				|
|---------------------------|-------------------------------|
---

## Outputs
|---------------------------|-------------------------------|
| Name 						| Description 					|
|---------------------------|-------------------------------|
| asg_name 					| ASG name 						|
|---------------------------|-------------------------------|
---

## Why This Exists?
- Keeps root `main.tf` clean
- Encapsulates regional logic
- Easy to scale to new regions

*************************************************************
*************************************************************
*************************************************************