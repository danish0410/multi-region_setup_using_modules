resource "aws_lb" "nlb" {
  name               = "${var.environment}-nlb"
  load_balancer_type = "network"
  internal           = false
  subnets            = var.public_subnet_ids

  enable_deletion_protection = false
}

resource "aws_lb_target_group" "tg" {
  name        = "${var.environment}-tg"
  port        = 80
  protocol    = "TCP"
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
