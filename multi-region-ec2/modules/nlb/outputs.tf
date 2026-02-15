output "target_group_arn" {
  value = aws_lb_target_group.tg.arn
}

output "nlb_dns" {
  value = aws_lb.nlb.dns_name
}
