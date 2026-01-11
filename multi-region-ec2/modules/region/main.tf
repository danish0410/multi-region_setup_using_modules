module "vpc" {
  source     = "../vpc"
  region     = var.region_name
  project    = var.project
  cidr_block = var.config.vpc_cidr
}

module "subnets" {
  source          = "../subnets"
  vpc_id          = module.vpc.vpc_id
  public_subnets  = var.config.public_subnets
  private_subnets = var.config.private_subnets
}

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

module "lt" {
  source                    = "../launch-template"
  instance_type             = var.config.instance_type
  security_groups           = module.sg.all_sg_ids
  iam_instance_profile_name = var.iam_instance_profile_name
}

module "asg" {
  source          = "../autoscaling"
  launch_template = module.lt.launch_template_id
  subnets         = module.subnets.public_subnet_ids
  min             = var.config.min_size
  max             = var.config.max_size
  desired         = var.config.desired_capacity
}

module "cw" {
  source = "../cloudwatch"
  asg    = module.asg.name
}
