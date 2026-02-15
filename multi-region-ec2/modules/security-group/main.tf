resource "aws_security_group" "common" {
  name        = var.common_sg_name
  description = "Common security group with HTTP and HTTPS access"
  vpc_id      = var.vpc_id

  # ingress {
  #   description = "HTTP"
  #   from_port   = 80
  #   to_port     = 80
  #   protocol    = "tcp"
  #   cidr_blocks = var.allowed_cidr_blocks
  # }

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    { Name = var.common_sg_name }
  )
}

resource "aws_security_group" "user" {
  name        = var.user_sg_name
  description = "User security group with no ingress rules"
  vpc_id      = var.vpc_id

  # No ingress rules (intentional)

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    { Name = var.user_sg_name }
  )
}
