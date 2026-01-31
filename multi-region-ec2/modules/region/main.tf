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

  vpc_id = module.vpc.vpc_id

  common_sg_name = "${var.project}-${var.region_name}-common-sg"
  user_sg_name   = "${var.project}-${var.region_name}-user-sg"

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

  instance_type             = var.config.instance_type
  security_groups           = module.sg.all_sg_ids
  iam_instance_profile_name = var.iam_instance_profile_name
  key_name                  = var.key_name
  region_name               = var.region_name
  environment               = var.environment

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
