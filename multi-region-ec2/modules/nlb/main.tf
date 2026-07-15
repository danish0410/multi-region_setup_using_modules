resource "aws_lb" "nlb" {
  name                             = "Xpress-prod-nlb"
  load_balancer_type               = "network"
  internal                         = false
  subnets                          = var.public_subnet_ids
  enable_cross_zone_load_balancing = true
  enable_deletion_protection       = false
}

resource "aws_lb_target_group" "tg" {
  name        = "Xpress-prod-tg"
  port        = 80
  protocol    = "TCP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    protocol = "TCP"
  }
}

resource "aws_lb_target_group" "tgtls" {
  name        = "Xpress-prod-tg-tls"
  port        = 443
  protocol    = "TLS"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    protocol = "TCP"
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

# resource "aws_lb_listener" "listenertls" {
#   load_balancer_arn = aws_lb.nlb.arn
#   port              = 443
#   protocol          = "TLS"
#   # certificate_arn   = "arn:aws:acm:us-east-2:064711806263:certificate/ca635fe5-bf62-403b-b044-22b47741d13d"
#   # certificate_arn = "arn:aws:elasticloadbalancing:ap-south-2:430861662740:loadbalancer/net/Xpress-prod-nlb/81f892b5dc7c4811"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.tgtls.arn
#   }
# }

