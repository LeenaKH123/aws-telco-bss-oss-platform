terraform {
  #tell terraform which provider plugin this project needs
  required_providers {
    #define the aws provider
    aws = {
      # download AWS provider from HashiCorp registry
      source = "hashicorp/aws"
      # use AWS provider version 5
      version = "~> 5.0"
    }
  }
}
# configure the AWS provider
provider "aws" {
  # deploy resources in the AWS region defined in variables.tf
  region = var.aws_region
}