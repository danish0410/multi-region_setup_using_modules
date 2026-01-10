locals {
  region_providers = {
    ap-south-1 = aws.ap_south_1
    us-east-1  = aws.us_east_1
    us-east-2  = aws.us_east_2
  }
}

module "region" {
  for_each = var.regions

  source    = "./modules/region"
  providers = { aws = local.region_providers[each.key] }

  region               = each.key
  project              = var.project
  iam_instance_profile = var.iam_instance_profile_name
  config               = each.value
}
