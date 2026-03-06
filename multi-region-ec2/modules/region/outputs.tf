output "private_subnets" {
  value = module.vpc.public_subnet_ids
}

output "launch_template_id" {
  value = module.lt.launch_template_id
}

output "target_group_arn" {
  value = module.nlb.target_group_arn
}

output "asg_name" {
  value = module.asg.asg_name
}