terraform {
  backend "s3" {
    bucket         = "telco-bss-oss-terraform-state-a7015e3f"
    key            = "05-rds-database/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "telco-bss-oss-terraform-locks"
    encrypt        = true
  }
}
