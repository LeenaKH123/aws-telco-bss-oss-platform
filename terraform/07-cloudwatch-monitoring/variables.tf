variable "aws_region" {
  default = "us-east-1"
}

variable "project_name" {
  default = "telco-bss-oss"
}

variable "notification_email" {
  description = "Email address to receive CloudWatch alarm notifications"
  type        = string
}
