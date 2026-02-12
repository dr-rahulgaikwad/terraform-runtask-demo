# Terraform AI Plan Analyzer Demo

Minimal AWS Terraform demo for [terraform-runtask-aws-ai-tf-plan-analyzer](https://github.com/dr-rahulgaikwad/terraform-runtask-aws-ai-tf-plan-analyzer).

## What's Included

Demonstrates EC2Validator and CostEstimator:

- Valid EC2 instances with encryption and IMDSv2
- ARM Graviton instances for cost optimization
- Large instances for cost threshold alerts
- Multiple instances for cost accumulation analysis

## Quick Start

```bash
terraform init
terraform plan
terraform apply
terraform destroy
```

## Configuration

```bash
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars as needed
```

### Variables

- `enable_large_instances = false` - Minimal deployment (~$15-20/month)
- `enable_large_instances = true` - Full cost demo (~$350-400/month)
- Update `ami_id` and `ami_id_arm` for your region if needed

## Expected AI Findings

### Minimal Mode (`enable_large_instances = false`)

**Good Practices (🟢)**
- IMDSv2 enforced
- EBS encryption enabled
- ARM Graviton cost optimization

**Cost (💰)**
- ~$15-20/month total

### Full Demo (`enable_large_instances = true`)

**Warnings (🟡)**
- Large instance (m5.2xlarge ~$280/month)
- Cost increase >20% threshold

**Cost (💰)**
- ~$350-400/month total
- Per-resource breakdown

## Prerequisites

- AWS account with EC2 permissions
- Terraform >= 1.5.0
- HCP Terraform account with Run Task configured

## HCP Terraform Setup

### 1. Configure AWS Credentials

In your HCP Terraform workspace, add these environment variables:

- `AWS_ACCESS_KEY_ID` (sensitive)
- `AWS_SECRET_ACCESS_KEY` (sensitive)
- `AWS_SESSION_TOKEN` (sensitive, if using temporary credentials)

Or use dynamic credentials with OIDC (recommended):
- Configure AWS IAM OIDC provider
- Set `TFC_AWS_PROVIDER_AUTH=true`
- Set `TFC_AWS_RUN_ROLE_ARN=<your-role-arn>`

### 2. Configure Terraform Variables

In your workspace, set these Terraform variables:
- `aws_region` (e.g., "us-east-1")
- `environment` (e.g., "demo")
- `enable_large_instances` (true/false)
- `ami_id` (update for your region)
- `ami_id_arm` (update for your region)

## Notes

Default AMI IDs are for us-east-1 (Amazon Linux 2023). Update in terraform.tfvars for other regions.
