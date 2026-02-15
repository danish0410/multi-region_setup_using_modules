# module "region_ap_south_1" {
#   source = "./modules/region"

#   for_each = {
#     for k, v in var.regions : k => v if k == "ap-south-1"
#   }

#   providers = { aws = aws.ap_south_1 }

#   region_name               = each.key
#   project                   = var.project
#   ami_map                   = var.ami_map
#   environment               = var.environment
#   iam_instance_profile_name = module.iam.instance_profile_name
#   key_name                  = var.ec2_keypair_map[each.key]

#   config = each.value
# }

module "region_ap_south_2" {
  source = "./modules/region"

  for_each = {
    for k, v in var.regions : k => v if k == "ap-south-2"
  }

  providers = { aws = aws.ap_south_2 }

  region_name               = each.key
  project                   = var.project
  ami_map                   = var.ami_map
  environment               = var.environment
  iam_instance_profile_name = module.iam.instance_profile_name
  key_name                  = var.ec2_keypair_map[each.key]

  config = each.value
}

# module "region_us_east_1" {
#   source = "./modules/region"

#   for_each = {
#     for k, v in var.regions : k => v if k == "us-east-1"
#   }

#   providers = { aws = aws.us_east_1 }

#   region_name               = each.key
#   project                   = var.project
#   ami_map                   = var.ami_map
#   environment               = var.environment
#   iam_instance_profile_name = module.iam.instance_profile_name
#   key_name                  = var.ec2_keypair_map[each.key]

#   config = each.value
# }

# module "region_us_east_2" {
#   source = "./modules/region"

#   for_each = {
#     for k, v in var.regions : k => v if k == "us-east-2"
#   }

#   providers = { aws = aws.us_east_2 }

#   region_name               = each.key
#   project                   = var.project
#   ami_map                   = var.ami_map
#   environment               = var.environment
#   iam_instance_profile_name = module.iam.instance_profile_name
#   key_name                  = var.ec2_keypair_map[each.key]

#   config = each.value
# }

#####################################
# IAM (GLOBAL / SHARED)
#####################################
module "iam" {
  source = "./modules/iam"
}

#####################################
# CLOUDWATCH – ap-south-1
#####################################
# module "cloudwatch_ap_south_1" {
#   source = "./modules/cloudwatch"

#   providers = { aws = aws.ap_south_1 }

#   region      = "ap-south-1"
#   environment = var.environment
#   asg_name    = module.region_ap_south_1["ap-south-1"].asg_name
#   alert_email = var.alert_email
# }

#####################################
# CLOUDWATCH – ap-south-2
#####################################
module "cloudwatch_ap_south_2" {
  source = "./modules/cloudwatch"

  providers = { aws = aws.ap_south_2 }

  region      = "ap-south-2"
  environment = var.environment
  asg_name    = module.region_ap_south_2["ap-south-2"].asg_name
  # alert_email = var.alert_email
}

#####################################
# CLOUDWATCH – us-east-1
#####################################
# module "cloudwatch_us_east_1" {
#   source = "./modules/cloudwatch"

#   providers = { aws = aws.us_east_1 }

#   region      = "us-east-1"
#   environment = var.environment
#   asg_name    = module.region_us_east_1["us-east-1"].asg_name
#   alert_email = var.alert_email
# }

#####################################
# CLOUDWATCH – us-east-2
#####################################
# module "cloudwatch_us_east_2" {
#   source = "./modules/cloudwatch"

#   providers = { aws = aws.us_east_2 }

#   region      = "us-east-2"
#   environment = var.environment
#   asg_name    = module.region_us_east_2["us-east-2"].asg_name
#   alert_email = var.alert_email
# }
