data "terraform_remote_state" "security" {
  backend = "local"

  config = {
    path = "../08-security-hardening/terraform.tfstate"
  }
}

data "terraform_remote_state" "s3" {
  backend = "local"

  config = {
    path = "../06-s3-storage/terraform.tfstate"
  }
}

resource "aws_iam_role" "ec2_app_role" {
  name = "${var.project_name}-ec2-app-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "ec2_app_policy" {
  name        = "${var.project_name}-ec2-app-policy"
  description = "Least privilege access for EC2 app instances to S3 and Secrets Manager"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Resource = data.terraform_remote_state.security.outputs.db_secret_arn
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          data.terraform_remote_state.s3.outputs.s3_bucket_arn,
          "${data.terraform_remote_state.s3.outputs.s3_bucket_arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_app_policy_attach" {
  role       = aws_iam_role.ec2_app_role.name
  policy_arn = aws_iam_policy.ec2_app_policy.arn
}

resource "aws_iam_instance_profile" "ec2_app_instance_profile" {
  name = "${var.project_name}-ec2-app-instance-profile"
  role = aws_iam_role.ec2_app_role.name
}
