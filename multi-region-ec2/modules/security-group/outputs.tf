output "common_sg_id" {
  description = "ID of common security group"
  value       = aws_security_group.common.id
}

output "user_sg_id" {
  description = "ID of user security group"
  value       = aws_security_group.user.id
}

output "all_sg_ids" {
  value = [
    aws_security_group.common.id,
    aws_security_group.user.id
  ]
}
