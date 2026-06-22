# AWS Telco BSS/OSS Platform - Architecture Overview

This project simulates a cloud-native telecommunications BSS/OSS platform on AWS using Terraform.

## Architecture Components

- VPC with public and private subnets
- EC2 customer portal
- Application Load Balancer
- Auto Scaling Group
- PostgreSQL RDS database
- S3 document storage
- Secrets Manager for database credentials
- IAM role and instance profile for least-privilege access
- CloudWatch alarms
- SNS email alerts

## Business Scenario

A telecom operator needs a scalable customer-facing platform for customer self-service, document storage, billing records, operational monitoring, and secure application access.

## AWS Solutions Architecture covered

- VPC design
- Public and private subnets
- Security groups
- EC2
- Load balancing
- Auto Scaling
- RDS
- S3
- IAM roles
- Secrets Manager
- CloudWatch
- SNS
- High availability
- Security best practices
