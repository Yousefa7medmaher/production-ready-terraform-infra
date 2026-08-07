# joo-lab — Terraform AWS Elastic Beanstalk Infrastructure

A production-style Terraform repository for deploying a Node.js application
on AWS Elastic Beanstalk behind an Application Load Balancer and inside a
purpose-built 3-tier VPC.

## Project overview

This repository is built with modular Terraform patterns and a single
environment configuration for `dev`.

Key goals:

- Deploy Elastic Beanstalk application infrastructure on AWS
- Keep resources isolated using modules and environment-specific config
- Support remote state with an S3 backend plus DynamoDB locking
- Provide bootstrap and destroy workflows for backend and dev infra

## Repository structure

| Path | Description |
|---|---|
| `modules/networking/` | VPC, subnets, internet gateway, NAT gateways, route tables |
| `modules/security/` | Security groups for ALB, EC2, and database communication |
| `modules/iam/` | Elastic Beanstalk service role, EC2 instance role, and profile |
| `modules/s3/` | Application version bucket with encryption, versioning, and lifecycle rules |
| `modules/cloudwatch/` | Log group, alarms, and SNS topic for observability |
| `modules/elastic-beanstalk/` | Elastic Beanstalk application, environment, and ALB wiring |
| `environments/dev/` | Dev environment Terraform configuration and variable values |
| `bootstrap/` | Backend bootstrap config for S3 state bucket and DynamoDB lock table |
| `.github/workflows/` | CI/CD workflows for plan/apply, bootstrap, and destruction |

## Environment layout

| File | Purpose |
|---|---|
| `environments/dev/main.tf` | Assembles module calls and environment-specific resources |
| `environments/dev/providers.tf` | Provider configuration for AWS and any required aliases |
| `environments/dev/variables.tf` | Environment input variables and defaults |
| `environments/dev/terraform.tfvars` | Dev-specific variable values |
| `environments/dev/versions.tf` | Terraform version and provider pins, plus remote backend config |

## Backend bootstrap

The repository includes a standalone bootstrap module at `bootstrap/`.
This module creates:

- AWS S3 bucket for Terraform remote state
- AWS DynamoDB table for state locking

Use the workflow `.github/workflows/bootstrap-backend.yaml` to create these
resources manually from GitHub Actions.

### Bootstrap inputs

| Input | Description |
|---|---|
| `state_bucket_name` | Globally unique S3 bucket name for Terraform state |
| `lock_table_name` | DynamoDB table name for the state lock |
| `aws_region` | AWS region for backend resources |

### Notes

- Backend resources should be created once before enabling remote state.
- After bootstrap, update `environments/dev/versions.tf` to enable the S3 backend
  and run `terraform init -migrate-state`.

## GitHub Actions workflows

| Workflow | Purpose |
|---|---|
| `.github/workflows/terraform.yaml` | Plan and apply the dev environment on `main` push |
| `.github/workflows/bootstrap-backend.yaml` | Create Terraform backend resources in AWS |
| `.github/workflows/destroy-backend.yaml` | Destroy backend resources created by bootstrap |
| `.github/workflows/destroy-dev.yaml` | Destroy the dev environment infrastructure |

## Local usage

### Initialize and deploy dev environment

```bash
cd environments/dev
terraform init
terraform plan
terraform apply
```

### Destroy dev infrastructure

```bash
cd environments/dev
terraform destroy
```

### Use remote state after bootstrapping

1. Bootstrap backend resources using GitHub Actions or the `bootstrap/` config.
2. Enable the S3 backend block in `environments/dev/versions.tf`.
3. Run:

```bash
cd environments/dev
terraform init -migrate-state
```

## Recommended workflow

1. Bootstrap backend resources once.
2. Enable remote state in `environments/dev/versions.tf`.
3. Use the CI workflow on `main` for plan/apply.
4. Use `destroy-dev.yaml` and `destroy-backend.yaml` only when you want
   to remove resources permanently.

## Important variable summary

| Variable | Purpose | Example |
|---|---|---|
| `region` | AWS region to deploy into | `us-east-1` |
| `ssh_allowed_cidr` | CIDR range allowed to SSH into instances | `203.0.113.0/32` |
| `min_instances` / `max_instances` | Auto Scaling group size bounds | `1 / 3` |
| `instance_type` | EC2 instance flavor for worker/EB instances | `t3.small` |
| `alarm_email` | Email address for CloudWatch alarm subscriptions | `alerts@example.com` |

## Notes and caveats

- The `environments/dev` configuration is intentionally isolated from the
  bootstrap backend config.
- Backend blocks cannot use variables, so the bootstrap step is necessary
  before enabling remote state.
- The workflows assume AWS credentials are provided by `aws-actions/configure-aws-credentials`
  and a role with the required IAM permissions is available.
