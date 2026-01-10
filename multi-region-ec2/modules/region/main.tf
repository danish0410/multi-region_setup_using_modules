module "vpc" {
  source  = "../vpc"
  region  = var.region
  project = var.project
  cidr    = var.config.vpc_cidr
}

module "subnets" {
  source          = "../subnets"
  vpc_id          = module.vpc.id
  public_subnets  = var.config.public_subnets
  private_subnets = var.config.private_subnets
}

module "sg" {
  source = "../security-group"
  vpc_id = module.vpc.id
}

module "lt" {
  source                    = "../launch-template"
  instance_type             = var.config.instance_type
  security_groups           = module.sg.ids
  iam_instance_profile_name = var.iam_instance_profile
}

module "asg" {
  source          = "../autoscaling"
  launch_template = module.lt.id
  subnets         = module.subnets.public_ids
  min             = var.config.min_size
  max             = var.config.max_size
  desired         = var.config.desired_capacity
}

module "cw" {
  source = "../cloudwatch"
  asg    = module.asg.name
}
