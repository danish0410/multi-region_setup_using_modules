################################
# VPC
################################
module "vpc" {
  source = "../vpc"

  project    = var.project
  region     = var.region_name
  cidr_block = var.config.vpc_cidr

  public_subnets = var.config.public_subnets

  tags = {
    Project = var.project
    Region  = var.region_name
  }
}

################################
# Security Groups
################################
module "sg" {
  source = "../security-group"

  vpc_id   = module.vpc.vpc_id
  vpc_cidr = module.vpc.vpc_cidr

  common_sg_name = "Xpress-prod-common-sg"
  user_sg_name   = "Xpress-prod-user-sg"

  allowed_cidr_blocks = ["0.0.0.0/0"]

  tags = {
    Project = var.project
    Region  = var.region_name
  }
}

################################
# Launch Template
################################
module "lt" {
  source = "../launch-template"

  ami_id = lookup(var.ami_map, var.region_name, null)

  instance_type             = var.config.instance_type
  security_groups           = module.sg.all_sg_ids
  iam_instance_profile_name = var.iam_instance_profile_name
  key_name                  = var.key_name
  region_name               = var.region_name
  environment               = var.environment
  instance_name_prefix      = "Xpress-prod"

  user_data = base64encode(
    templatefile("${path.module}/userdata/dev_classic_userdata.sh", {
      region = var.region_name
    })
  )
}

################################
# Auto Scaling Group
################################
module "asg" {
  source = "../autoscaling"

  environment     = var.environment
  region          = var.region_name
  launch_template = module.lt.launch_template_id
  subnets         = module.vpc.public_subnet_ids

  min     = var.config.min_size
  max     = var.config.max_size
  desired = var.config.desired_capacity

  target_group_arns = module.nlb.target_group_arn
}

# ################################
# # Network Load Balancer
# ################################
module "nlb" {
  source = "../nlb"

  environment       = var.environment
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
}


# ################################
# # Auto Scaling Group
# ################################
# module "asg" {
#   source = "../autoscaling"

#   launch_template = module.lt.launch_template_id
#   subnets         = module.vpc.public_subnet_ids

#   min     = var.config.min_size
#   max     = var.config.max_size
#   desired = var.config.desired_capacity
# }
