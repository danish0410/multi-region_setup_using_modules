module "region_ap_south_1" {
  source = "./modules/region"

  for_each = {
    for k, v in var.regions : k => v if k == "ap-south-1"
  }

  providers = { aws = aws.ap_south_1 }

  region_name               = each.key
  project                   = var.project
  iam_instance_profile_name = var.iam_instance_profile_name
  config                    = each.value
}

module "region_us_east_1" {
  source = "./modules/region"

  for_each = {
    for k, v in var.regions : k => v if k == "us-east-1"
  }

  providers = { aws = aws.us_east_1 }

  region_name               = each.key
  project                   = var.project
  iam_instance_profile_name = var.iam_instance_profile_name
  config                    = each.value
}

module "region_us_east_2" {
  source = "./modules/region"

  for_each = {
    for k, v in var.regions : k => v if k == "us-east-2"
  }

  providers = { aws = aws.us_east_2 }

  region_name               = each.key
  project                   = var.project
  iam_instance_profile_name = var.iam_instance_profile_name
  config                    = each.value
}

module "iam" {
  source = "./modules/iam"
}
