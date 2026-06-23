# Security Design

This document describes the security controls implemented in the AWS Telco BSS/OSS Platform.

## Security Principles

The platform follows secure-by-design principles:

- Least-privilege access
- Private database placement
- Encrypted storage
- Centralized secrets management
- Controlled network access
- Automated infrastructure validation

## Network Security

- The VPC separates public and private subnets.
- The Application Load Balancer is internet-facing.
- The RDS PostgreSQL database is deployed in private subnets.
- Security groups restrict access between layers.

## Identity and Access Management

- EC2 instances use an IAM instance profile.
- The EC2 role has least-privilege access to:
  - Read database credentials from Secrets Manager
  - Access the S3 document bucket
- No long-term AWS credentials are stored on EC2 instances.

## Data Protection

- S3 public access is blocked.
- S3 versioning is enabled.
- S3 server-side encryption is enabled.
- RDS credentials are stored in AWS Secrets Manager.

## Monitoring and Alerts

- CloudWatch monitors application and database health.
- SNS sends alert notifications.
