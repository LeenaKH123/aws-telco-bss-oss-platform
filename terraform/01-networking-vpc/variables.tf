variable "aws_region" { #creates reusable variables
  default = "us-east-1" #default aws region
}

variable "project_name" { #common name used across resources
  default = "telco-bss-oss" #resources will be tagged, telco-bss-oss-vpc, telco-bss-oss-web-sg
}

variable "vpc_cidr" {
  default = "10.0.0.0/16" #cidr block for the vpc, this means 10.0.x.x provides about 65,536 IP addresses
}

variable "public_subnet_cidr" {#public subnet network
  default = "10.0.1.0/24" #subnet inside VPC 256 addresses
}

variable "private_subnet_cidr" { #private subnet
  default = "10.0.2.0/24" #another subnet inside the VPC
}