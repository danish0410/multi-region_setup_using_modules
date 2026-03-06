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
#   certificate_arn   = "arn:aws:acm:ap-south-2:064711806263:certificate/75eddb06-b5fc-4d06-8171-d445d4014861"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.tgtls.arn
#   }
# }

