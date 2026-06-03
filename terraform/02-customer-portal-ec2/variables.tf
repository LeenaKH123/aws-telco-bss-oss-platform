variable "aws_region" { #AWS region where resources will be created
  default = "us-east-1"
}
#common project name used in AWS resource names/tags
variable "project_name" {
  default = "telco-bss-oss"
}
# EC2 keypair used to SSH into the instance
variable "key_name" {
  default = "telco-key"
}