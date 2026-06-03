# provider.tf
This file tells Terraform:
Use AWS as the cloud provider.
Use the AWS provider from HashiCorp.
Deploy resources in the selected AWS region.

# In simple words:
Terraform needs this file to know where and how to connect to AWS.

# variables.tf

This file stores reusable values, such as:
AWS region
Project name
VPC CIDR range
Public subnet CIDR
Private subnet CIDR

Instead of hardcoding values many times, they are written once as variables.

# Example:
variable "aws_region" {
  default = "us-east-1"
}

# Meaning:
Deploy everything in us-east-1 unless I change it later.

# main.tf

This is the main infrastructure file.

It creates:

1. VPC
2. Public subnet
3. Private subnet
4. Internet Gateway
5. Public route table
6. Route from public subnet to internet
7. Association between public subnet and route table
8. Security group for web access

In AWS architecture terms:

You created the network foundation for the Telco BSS/OSS platform.

# The public subnet will later host things like:
Customer Portal
Load Balancer
Bastion Host

# The private subnet will later host things like:
Order Service
Billing Database
Provisioning Service

# outputs.tf

This file prints useful IDs after deployment.
For example:
VPC ID
Public Subnet ID
Private Subnet ID
Security Group ID

After terraform apply, Terraform will show values like:

vpc-xxxxxxxx
subnet-xxxxxxxx
sg-xxxxxxxx

These IDs are useful for future modules.

# How to execute and test

From your terminal:

cd ~/aws-telco-bss-oss-platform/terraform/01-networking-vpc
1. Initialize Terraform
terraform init
This downloads the AWS provider.

2. Format the code
terraform fmt
This cleans the Terraform formatting.

3. Validate the code
terraform validate
This checks if the code syntax is correct.

Expected result:
Success! The configuration is valid.

4. Preview what Terraform will create
terraform plan
This shows what will be created before touching AWS.
Look for:
Plan: 8 to add, 0 to change, 0 to destroy.

5. Create resources in AWS
terraform apply
Then type:
yes
Terraform will create the VPC resources.
How to test in AWS Console
Go to AWS Console → VPC.
Check:
Your VPC exists:
telco-bss-oss-vpc
Then check:
Subnets:
telco-bss-oss-public-subnet
telco-bss-oss-private-subnet
Then check:
Internet Gateway:
telco-bss-oss-igw
Then check:
Route Tables:
telco-bss-oss-public-rt

Inside the route table, you should see:

0.0.0.0/0 → Internet Gateway

That proves the public subnet has internet access.

# Important Concepts:
VPC = isolated AWS network
Public subnet = subnet with route to Internet Gateway
Private subnet = subnet without direct route to Internet Gateway
Internet Gateway = allows internet access
Route table = decides where traffic goes
Security Group = firewall for AWS resources
Outputs = useful IDs for connecting future modules