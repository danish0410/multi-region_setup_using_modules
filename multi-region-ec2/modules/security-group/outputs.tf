output "common_security_group_id" {
  description = "ID of the common security group"
  value       = aws_security_group.common.id
}

output "user_security_group_id" {
  description = "ID of the user security group"
  value       = aws_security_group.user.id
}

output "common_security_group_arn" {
  description = "ARN of the common security group"
  value       = aws_security_group.common.arn
}

output "user_security_group_arn" {
  description = "ARN of the user security group"
  value       = aws_security_group.user.arn
}
