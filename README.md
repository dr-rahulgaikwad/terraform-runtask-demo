# Terraform AI Plan Analyzer Demo

Minimal AWS Terraform demo for [terraform-runtask-aws-ai-tf-plan-analyzer](https://github.com/dr-rahulgaikwad/terraform-runtask-aws-ai-tf-plan-analyzer).

## What's Included

Demonstrates all 4 validator tools with realistic scenarios:

- **EC2Validator**: Valid instances, ARM Graviton, large instances, deprecated AMIs
- **S3Validator**: Encrypted buckets (AES256/KMS), unencrypted buckets, public access
- **SecurityGroupValidator**: Secure rules, risky exposures (SSH, RDP, databases), IPv6
- **CostEstimator**: Monthly cost estimates, threshold alerts

## Quick Start

```bash
# Initialize
terraform init

# Plan with minimal resources (low cost ~$10-15/month)
terraform plan -var="enable_risky_resources=false"

# Plan with all scenarios (higher cost ~$350-400/month)
terraform plan -var="enable_risky_resources=true"

# Apply (optional)
terraform apply

# Cleanup
terraform destroy
```

## Configuration

```bash
# Copy the example file
cp terraform.tfvars.example terraform.tfvars

# Edit as needed
# - Set enable_risky_resources=false for minimal deployment (~$10-15/month)
# - Set enable_risky_resources=true for full demo (~$350-400/month)
```

## Expected AI Findings

### With `enable_risky_resources = true`:

**Critical (🔴)**
- Public S3 bucket
- Unencrypted S3 bucket
- Security groups exposing SSH, RDP, MySQL, PostgreSQL to 0.0.0.0/0
- IAM wildcard permissions
- Invalid AMI

**Warnings (🟡)**
- Large instance (m5.2xlarge ~$280/month)
- Cost increase >20% threshold
- IPv6 exposure

**Good Practices (🟢)**
- KMS encrypted S3 buckets
- IMDSv2 enforced
- Restrictive security groups
- Least privilege IAM

**Cost (💰)**
- Per-resource monthly estimates
- Total: ~$350-400/month

### With `enable_risky_resources = false`:

Only secure resources with best practices, ~$10-15/month

## Prerequisites

- AWS account with credentials configured
- Terraform >= 1.5.0
- HCP Terraform account with Run Task configured (for AI analysis)

## Notes

- AMI IDs may need updating for your region
- Risky resources are intentionally insecure for demonstration
- Use `enable_risky_resources=false` for production-like deployments
