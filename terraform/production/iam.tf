resource "aws_iam_role" "production_ec2_role" {
  name               = "production-ec2-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}


resource "aws_iam_role_policy_attachment" "production_ec2_role" {
  role       = aws_iam_role.production_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "production_ec2_role" {
  name = "production-ec2-role"
  role = aws_iam_role.production_ec2_role.name
}