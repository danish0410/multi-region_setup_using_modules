#####################################
# module ap-south-2
#####################################
# module "region_ap_south_2" {
#   source = "./modules/region"

#   for_each = {
#     for k, v in var.regions : k => v if k == "ap-south-2"
#   }

#   providers = { aws = aws.ap_south_2 }

#   region_name               = each.key
#   project                   = var.project
#   ami_map                   = var.ami_map
#   environment               = var.environment
#   iam_instance_profile_name = module.iam.instance_profile_name
#   key_name                  = var.ec2_keypair_map[each.key]
#   instance_name_prefix      = var.instance_name_prefix
#   config                    = each.value
# }

#####################################
# module us-east-2
#####################################
module "region_us_east_2" {
  source = "./modules/region"

  for_each = {
    for k, v in var.regions : k => v if k == "us-east-2"
  }

  providers = { aws = aws.us_east_2 }

  region_name               = each.key
  project                   = var.project
  ami_map                   = var.ami_map
  environment               = "prod"
  iam_instance_profile_name = module.iam.instance_profile_name
  key_name                  = var.ec2_keypair_map[each.key]
  instance_name_prefix      = var.instance_name_prefix
  config                    = each.value
}

#####################################
# IAM (GLOBAL / SHARED)
#####################################
# module "iam" {
#   source = "./modules/iam"
# }

module "iam" {
  source      = "./modules/iam"
  project     = var.project
  environment = "prod"
  region      = "us-east-2"
}

# module "iam" {
#   source      = "./modules/iam"
#   project     = var.project
#   environment = "prod"
#   region      = "ap-south-2"
# }

#####################################
# CLOUDWATCH – ap-south-2
#####################################
# module "cloudwatch_ap_south_2" {
#   source = "./modules/cloudwatch"

#   providers = { aws = aws.ap_south_2 }

#   region      = "ap-south-2"
#   environment = var.environment
#   asg_name    = module.region_ap_south_2["ap-south-2"].asg_name
#   # alert_email = var.alert_email
# }

#####################################
# CLOUDWATCH – us-east-2
#####################################
module "cloudwatch_us_east_2" {
  source = "./modules/cloudwatch"

  providers = { aws = aws.us_east_2 }

  region      = "us-east-2"
  environment = "prod"
  asg_name    = module.region_us_east_2["us-east-2"].asg_name
  # alert_email = var.alert_email
}