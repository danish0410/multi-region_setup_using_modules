output "target_group_arn" {
  # value = aws_lb_target_group.tg.arn
  value = tolist([
    aws_lb_target_group.tg.arn,
    aws_lb_target_group.tgtls.arn
    # add more if needed
  ])
}

output "nlb_dns" {
  value = aws_lb.nlb.dns_name
}
