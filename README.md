# joo-lab — Terraform AWS Elastic Beanstalk Infrastructure

Production-style, modular Terraform for deploying a Node.js application on AWS
Elastic Beanstalk behind an Application Load Balancer, inside a purpose-built
3-tier VPC.

## Structure

```
terraform/
├── modules/
│   ├── networking/        # VPC, subnets, IGW, NAT, route tables
│   ├── security/           # ALB / EC2 / DB security groups
│   ├── iam/                 # EB service role, EC2 role, instance profile
│   ├── s3/                  # App-versions bucket (versioned, encrypted, lifecycle)
│   ├── cloudwatch/          # Log group, CPU + health alarms, SNS topic
│   └── elastic-beanstalk/   # Application + Load-Balanced environment
└── environments/
    └── dev/
        ├── main.tf          # Wires all modules together
        ├── variables.tf
        ├── terraform.tfvars
        ├── outputs.tf
        ├── providers.tf
        └── versions.tf      # Provider pins + commented-out S3 backend
```

## Usage

```bash
cd environments/dev
terraform init
terraform plan
terraform apply
```

To tear everything down:

```bash
terraform destroy
```

## Remote state

The S3 backend is deliberately left commented out in `versions.tf` — a
backend needs its own bucket/table to already exist (a chicken-and-egg
problem), and backend blocks can't reference variables. Bootstrap that
bucket + DynamoDB lock table once (by hand, via a separate tiny Terraform
config, or via the AWS CLI), then uncomment the block and re-run
`terraform init -migrate-state`.

## Variables you'll most likely change

| Variable | Purpose |
|---|---|
| `region` | AWS region to deploy into |
| `ssh_allowed_cidr` | Who can SSH into instances (keep tight) |
| `min_instances` / `max_instances` | Auto Scaling bounds |
| `instance_type` | EC2 instance size |
| `alarm_email` | Subscribe an email to CloudWatch alarms |

See the full explanation, architecture walkthrough, and production
code-review notes in the accompanying response.
