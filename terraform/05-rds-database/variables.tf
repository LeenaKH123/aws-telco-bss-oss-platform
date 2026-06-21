variable "aws_region" {
  default = "us-east-1"
}

variable "project_name" {
  default = "telco-bss-oss"
}

variable "db_username" {
  default = "telcoadmin"
}

variable "db_password" {
  default   = "ChangeMe12345!"
  sensitive = true
}
