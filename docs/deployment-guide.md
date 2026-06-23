# Deployment Guide

This guide explains how to deploy the AWS Telco BSS/OSS Platform using Terraform.

## Deployment Order

1. `10-terraform-backend`
2. `01-networking-vpc`
3. `02-customer-portal-ec2`
4. `03-application-load-balancer`
5. `08-security-hardening`
6. `06-s3-storage`
7. `09-iam-roles`
8. `04-auto-scaling-group`
9. `05-rds-database`
10. `07-cloudwatch-monitoring`

## Notes

- Terraform state is stored remotely in S3.
- State locking is handled through DynamoDB.
- Modules depend on remote state outputs from earlier modules.
