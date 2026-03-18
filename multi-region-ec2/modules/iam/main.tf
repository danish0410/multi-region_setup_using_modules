resource "aws_iam_role" "ec2_role" {
  name = "Xpress-prod-ec2-role-us-east-2"
  # name = "${var.project}-${var.environment}-ec2-role-${var.region}"


  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "Xpress-prod-ssm-profile-us-east-2"
  # name = "${var.project}-${var.environment}-ec2-profile-${var.region}"
  role = aws_iam_role.ec2_role.name
}

resource "aws_iam_role_policy_attachment" "cw_agent" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}
