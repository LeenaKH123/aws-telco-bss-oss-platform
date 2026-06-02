# AWS Telco BSS/OSS Platform

This project is a hands-on AWS Solutions Architecture based on a telecom BSS/OSS use case.

## Business Scenario

A telecom operator wants to launch a cloud-based customer activation platform.

The platform will simulate:

- Customer onboarding
- Order capture
- Service activation
- Provisioning
- Billing integration
- Customer notification
- Monitoring and audit

## AWS Concepts Covered

- VPC
- Public and private subnets
- EC2
- Application Load Balancer
- Auto Scaling
- DynamoDB
- SQS
- SNS
- RDS
- IAM
- CloudWatch
- CloudTrail
- S3

## Telecom Mapping

| Telecom Concept | AWS Implementation |
|---|---|
| CRM | Customer Portal |
| OSM | Order Service |
| ASAP / Provisioning | Provisioning Worker |
| BRM / Billing | RDS Billing Database |
| OSB / AIA | SQS / API Integration |
| Notifications | SNS |
| Monitoring | CloudWatch |