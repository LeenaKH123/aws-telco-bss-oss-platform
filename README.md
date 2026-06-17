# AWS Telco BSS/OSS Platform

A hands-on cloud architecture project that models a **Telecom Business Support System (BSS) and Operations Support System (OSS)** using AWS services and Terraform Infrastructure as Code.

Designed from real-world telco domain knowledge, this project demonstrates how a telecommunications operator can migrate customer-facing and operational platforms to AWS — covering everything from customer onboarding through to billing, provisioning, monitoring, and audit.

---

## Business Scenario

A telecom operator wants to launch a cloud-based customer activation platform. This project simulates the core BSS/OSS components that power that platform end-to-end:

- Customer onboarding & CRM
- Order capture & management
- Service activation & provisioning
- Billing integration
- Customer notifications
- Monitoring, audit & compliance

---

## Architecture

### Telecom-to-AWS Mapping

| Telecom Domain | AWS Implementation |
|---|---|
| CRM / Customer Portal | EC2 + Application Load Balancer |
| Order Service Manager (OSM) | SQS Queue + EC2 Workers |
| Provisioning / ASAP | EC2 Auto Scaling Group |
| Billing System (BRM) | RDS (Billing Database) |
| Integration Layer (OSB/AIA) | SQS + API Integration |
| Customer Notifications | SNS |
| Monitoring & Audit | CloudWatch + CloudTrail |
| Data Storage | S3 + DynamoDB |

### AWS Services Used

`VPC` · `Public & Private Subnets` · `EC2` · `Application Load Balancer` · `Auto Scaling` · `RDS` · `DynamoDB` · `SQS` · `SNS` · `S3` · `IAM` · `CloudWatch` · `CloudTrail`

---

## Project Structure

```
aws-telco-bss-oss-platform/
├── terraform/          # Infrastructure as Code (HCL)
├── .gitignore
└── README.md
```

---

## Infrastructure as Code

All infrastructure is defined using **Terraform (HCL)**, enabling:

- Repeatable, version-controlled deployments
- Environment consistency across dev/staging/production
- Infrastructure review and auditability via code

---

## Key Concepts Demonstrated

- **Multi-tier VPC design** with public and private subnet separation
- **High availability** through Auto Scaling and Load Balancing
- **Event-driven architecture** using SQS for async order and provisioning flows
- **Managed database layer** with RDS for billing data persistence
- **Observability** through CloudWatch metrics, alarms, and CloudTrail audit logs
- **IAM least-privilege** security model

---

## Domain Context

This project draws on real-world telco architecture experience. BSS/OSS platforms are the operational backbone of any telecommunications provider — managing everything from the moment a customer places an order to when their service is active and their bill is generated.

Mapping these telco concepts to AWS services demonstrates both **cloud architecture skills** and **deep telecommunications domain knowledge**.

---

## Author

**Leena Al-Khalili** — Digital Transformation Leader | AWS Solutions Architect  
[LinkedIn](https://www.linkedin.com/in/leena-alkhalili/) · [GitHub](https://github.com/LeenaKH123)
