# Architecture Review & Cost Estimate — joo-lab Terraform

Date: 2026-08-07

This report evaluates repository structure, Terraform patterns, security and
operational best practices, known issues/risk areas, and provides a short
cost estimate for running the `dev` environment for short durations (4h, 9h).

## 1) Executive summary

- Overall: repository is well-structured and modular. Modules separate
  networking, security, IAM, S3, CloudWatch, and Elastic Beanstalk cleanly.
- It includes a `bootstrap/` module and GitHub Actions workflows to create
  and destroy backend resources — this is good for automation and repeatable
  environments.
- Main risks: remote-state bootstrapping is manual (expected), IAM roles for
  CI must be scoped correctly, and some destructive workflows are exposed as
  manual Actions (good but must be guarded).

## 2) Good practices observed

- Modular layout: `modules/*` with single-responsibility modules is clear and
  maintainable.
- Environment separation: `environments/dev/` keeps per-env values out of
  modules and supports multiple environments in future.
- Backend bootstrap: a dedicated `bootstrap/` module avoids the chicken-and-egg
  problem for S3/DynamoDB remote state resources.
- CI automation: GitHub Actions for plan/apply, bootstrap, and destroy make
  operations reproducible and auditable.
- Security defaults in modules: S3 public access blocks, SSE for buckets,
  and VPC/private subnets are enabled by default.
- Rolling deployments and managed platform updates for Elastic Beanstalk are
  explicitly configured.

## 3) Issues, risks, and recommended fixes

- IAM scope for GitHub Actions role:
  - Risk: `arn:aws:iam::${{ AWS_ACCOUNT_ID }}:role/github-actions-terraform` may
    be too permissive. Recommendation: restrict to least-privilege (limit
    resources and actions) and use separate role for bootstrap vs env
    apply.

- Workflows and secrets:
  - Risk: destructive workflows (`destroy-*`) are `workflow_dispatch` but
    still run in `production` environment. Recommendation: protect those
    workflows with required reviewers or environment protection rules in
    GitHub and log approvals.

- Remote state lifecycle:
  - Risk: deleting the S3 bucket or accidentally destroying the backend can
    permanently remove state. Recommendation: enable MFA-delete on the
    state bucket (if possible), retain a single, protected admin account,
    and tag the bucket clearly.

- NAT gateway costs:
  - Observation: `single_nat_gateway = true` reduces cost but creates a single
    availability-zone egress point. For resilience, consider multi-AZ NATs in
    production (but cost increases).

- Logging and retention:
  - CloudWatch logs are enabled; ensure retention and lifecycle are tuned to
    control costs (30 days by default in dev is reasonable).

- Missing automated policy checks:
  - Suggest adding policy-as-code checks (Sentinel/OPA or more Checkov rules)
    to block IAM or public-s3 misconfigurations in PR pipeline.

## 4) Operational suggestions

- Add a small `README` under `bootstrap/` showing the exact `backend` block to
  paste into `environments/dev/versions.tf` to enable S3 remote state.

- Add gating to `apply` job (e.g., `workflow_run` approval or GitHub
  environment protection) to prevent accidental applies from any push.

- Add a pre-deploy check that `terraform init` shows the configured backend
  (to avoid accidental runs against local state).

- Add tagging and cost-center tags across all resources (most modules already
  merge tags — confirm `Owner` and `Environment` are always applied).

## 5) Cost estimation (short-run)

Notes and assumptions (important):
- Estimates use typical on-demand public AWS rates (rounded) for `us-east-1`.
  Exact charges vary by account, region, OS, and data transfer. Treat numbers
  below as order-of-magnitude estimates.
- Key assumptions from `environments/dev/terraform.tfvars`:
  - `instance_type = t3.micro`
  - `min_instances = 2`, `max_instances = 4`
  - `single_nat_gateway = true`
  - ALB (Application Load Balancer) used by Elastic Beanstalk
  - Minimal storage usage (S3 < 1 GB), low data transfer
- Per-hour unit costs used (rounded):
  - `t3.micro` (Linux, on-demand): $0.0104 / hour per instance
  - ALB fixed charge: $0.0225 / hour
  - ALB LCU (light): ≈ $0.008 / LCU-hour (assume 1 LCU for low traffic)
  - NAT Gateway: $0.045 / hour
  - EBS (8 GiB root per instance): ≈ $0.10 / GiB-month → ≈ $0.0011 / hour per instance (8 GiB)
  - S3 / DynamoDB / CloudWatch: small contributions; include a ~$0.01/hr buffer

Breakdown (baseline = `min_instances = 2`):

- EC2 instances (2 × t3.micro):
  - 2 × $0.0104 = $0.0208 / hour
  - EBS (2 × 8 GiB): 2 × 0.0011 = $0.0022 / hour
- ALB (fixed + 1 LCU): $0.0225 + $0.008 = $0.0305 / hour
- NAT Gateway (single AZ): $0.045 / hour
- S3/DynamoDB/CloudWatch buffer: $0.01 / hour

Total (min=2) ≈ 0.0208 + 0.0022 + 0.0305 + 0.045 + 0.01 = $0.1085 / hour

- Running 4 hours: 4 × $0.1085 ≈ $0.43
- Running 9 hours: 9 × $0.1085 ≈ $0.98

If scaled to `max_instances = 4` (peak):
- EC2 instances (4 × t3.micro): 4 × $0.0104 = $0.0416 / hour
- EBS: 4 × 0.0011 = $0.0044 / hour
- ALB/NAT/small buffer unchanged → 0.0305 + 0.045 + 0.01 = $0.0855 / hour

Total (max=4) ≈ 0.0416 + 0.0044 + 0.0855 = $0.1315 / hour

- Running 4 hours (max) ≈ 4 × $0.1315 ≈ $0.53
- Running 9 hours (max) ≈ 9 × $0.1315 ≈ $1.18

Observations:
- This architecture is inexpensive for short experiments (< $1 for a single-day
  short run) when using `t3.micro` and low traffic.
- The largest single contributor for short runs is the NAT Gateway ($0.045/hr)
  and the ALB (~$0.03/hr). For labs, consider removing the NAT gateway or
  using direct internet access in public subnets for test runs to save cost.

## 6) Quick wins to reduce cost for short experiments

- Use spot or smaller instance types for non-production testing (be aware
  of preemption).
- For short-lived labs, create a `terraform destroy` workflow run after tests
  or use a scheduled job to tear down resources.
- Use no-NAT lab topology (put instances in public subnets with tighter SGs)
  to remove NAT Gateway cost while keeping security acceptable for short runs.

## 7) Next steps I can take for you

- Add a short `bootstrap/README.md` with the exact `backend` block to paste
  into `environments/dev/versions.tf` and a sample `terraform init` flow.
- Add protective guards to destructive workflows (approval or required
  reviewers) in GitHub Actions.
- Produce an automated estimator script (small `estimate_cost.py`) that reads
  `terraform.tfvars` and produces a cost estimate using today’s live price
  APIs or a simple rate table.

---

If you want, I can now add the `bootstrap/README.md` and an `estimate_cost.py` script. Reply which of those you'd like next.