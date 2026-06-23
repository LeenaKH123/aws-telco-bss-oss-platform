# AWS Telco BSS/OSS Platform

A cloud-native telecommunications reference architecture demonstrating how a telecom operator can modernize customer-facing BSS/OSS workloads on AWS using Infrastructure as Code, automated governance, and secure-by-design principles.

The solution models a production-oriented architecture including high availability, automated scaling, secure database access, centralized secrets management, monitoring, alerting, and CI/CD validation.

---

## Business Scenario

Telecommunications operators typically manage multiple customer-facing and operational systems that support customer onboarding, service activation, billing, document management, monitoring, and operational support.

This project demonstrates how these capabilities can be implemented using AWS managed services and Infrastructure as Code while following modern cloud architecture principles.

---
## Business Capabilities

This platform models core telecommunications BSS/OSS capabilities:

- Customer Onboarding
- Order Management
- Service Provisioning
- Billing and Customer Records
- Monitoring and Operations
- Security and Compliance

See `docs/business-capabilities.md` for details.
---
## Architecture

Architecture documentation is available in:

* `diagrams/architecture.mmd`
* `docs/architecture-overview.md`

### Core Components

* VPC with public and private subnets
* Application Load Balancer
* Auto Scaling Group
* Amazon EC2 customer portal
* Amazon RDS PostgreSQL database
* Amazon S3 document repository
* AWS Secrets Manager
* IAM roles and instance profiles
* Amazon CloudWatch monitoring
* Amazon SNS alerting
* GitHub Actions CI/CD validation

---

## Terraform Modules

| Module                       | Description                                 |
| ---------------------------- | ------------------------------------------- |
| 01-networking-vpc            | VPC, subnets, routing, security groups      |
| 02-customer-portal-ec2       | Customer portal EC2 deployment              |
| 03-application-load-balancer | Application Load Balancer and target groups |
| 04-auto-scaling-group        | Launch templates and Auto Scaling Group     |
| 05-rds-database              | PostgreSQL database layer                   |
| 06-s3-storage                | Secure document storage                     |
| 07-cloudwatch-monitoring     | Monitoring and alerting                     |
| 08-security-hardening        | Secrets Manager integration                 |
| 09-iam-roles                 | Least-privilege IAM architecture            |

---

## Architecture Capabilities

### High Availability

* Multi-subnet architecture
* Application Load Balancer
* Auto Scaling Group
* Managed database services

### Security

* Private database deployment
* Secrets stored in AWS Secrets Manager
* IAM least-privilege model
* S3 public access blocked
* Encrypted storage

### Scalability

* Elastic application tier
* Auto Scaling Group
* Managed storage services

### Observability

* CloudWatch alarms
* SNS notifications
* Infrastructure validation pipeline

---

## AWS Services Used

### Compute

* Amazon EC2
* Auto Scaling Group

### Networking

* Amazon VPC
* Public Subnets
* Private Subnets
* Security Groups
* Application Load Balancer

### Data Layer

* Amazon RDS PostgreSQL
* Amazon S3

### Security

* IAM
* Secrets Manager

### Operations

* CloudWatch
* SNS
* GitHub Actions

---

## Project Structure

```text
aws-telco-bss-oss-platform/
├── diagrams/
│   └── architecture.mmd
├── docs/
│   └── architecture-overview.md
├── terraform/
│   ├── 01-networking-vpc/
│   ├── 02-customer-portal-ec2/
│   ├── 03-application-load-balancer/
│   ├── 04-auto-scaling-group/
│   ├── 05-rds-database/
│   ├── 06-s3-storage/
│   ├── 07-cloudwatch-monitoring/
│   ├── 08-security-hardening/
│   └── 09-iam-roles/
└── .github/
    └── workflows/
        └── terraform.yml
```

---

## CI/CD

GitHub Actions automatically performs:

* Terraform format validation
* Terraform initialization
* Terraform configuration validation

on every push and pull request.

---

## Roadmap

Future enhancements include:

* Terraform remote backend using S3 and DynamoDB
* Route 53 custom domain integration
* AWS WAF protection
* CloudTrail audit logging
* ECS/Fargate containerization
* Multi-environment deployment strategy

---

## Author

**Leena Al-Khalili**

LinkedIn: https://www.linkedin.com/in/leena-alkhalili/

GitHub: https://github.com/LeenaKH123
