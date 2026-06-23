# Operations Runbook

## Purpose

This runbook provides operational procedures for the AWS Telco BSS/OSS Platform.

---

## Health Checks

### Application Layer

Verify:

- Application Load Balancer is healthy
- Auto Scaling Group instances are running
- EC2 instances are responding to HTTP requests

Commands:

```bash
aws autoscaling describe-auto-scaling-groups
aws elbv2 describe-target-health
