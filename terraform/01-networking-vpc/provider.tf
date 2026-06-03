#defines terraform settings
terraform {
  #tells terraform which cloud provider plugins are needed
  required_providers {
    aws = {
      source  = "hashicorp/aws" # download the AWS provider from HashiCorp, Terraform --> AWS API
      version = "~> 5.0" # use version 5 of aws
    }
  }
}

provider "aws" { # configure AWS connection
  region = var.aws_region # use region from variables
}