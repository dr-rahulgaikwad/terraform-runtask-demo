# Terraform AI Plan Analyzer Demo

Demo for [terraform-runtask-aws-ai-tf-plan-analyzer](https://github.com/dr-rahulgaikwad/terraform-runtask-aws-ai-tf-plan-analyzer).

## Overview

This demo runs exclusively in HCP Terraform using Doormat for dynamic AWS credentials. No static credentials required.

## Prerequisites

✅ IAM role created: `arn:aws:iam::825551243480:role/tfc-doormat-demo-role`
- Tagged: `app.terraform.io/rahul-tfc/terraform-runtask-demo-ws`
- Trusts: `arn:aws:iam::397512762488:user/doormatServiceUser`
- Permissions: EC2 full access

## HCP Terraform Workspace Setup

**Organization:** `rahul-tfc`  
**Workspace:** `terraform-runtask-demo-ws`

### Variables to Set

**Terraform Variables:**
- `aws_region` = `us-east-1`
- `instance_type` = `t3.micro` (or `t3.medium`, `m5.2xlarge` for cost testing)

**No AWS credentials needed** - Doormat provides them automatically!

### Run Task Configuration
- Stage: Post-plan
- Enforcement: Advisory

## Usage

1. Push this code to your VCS repository
2. Connect repository to HCP Terraform workspace
3. Queue a plan
4. Doormat assumes IAM role and provides credentials
5. AI Run Task analyzer evaluates the plan
6. View AI analysis in Run Task output

## What the AI Analyzer Checks

- EC2 instance type validation
- AMI availability
- Cost estimation (~$15/month for t3.micro, ~$280/month for m5.2xlarge)
- Cost threshold alerts (>20% increase)

## Testing Cost Scenarios

Change `instance_type` variable in workspace:
- `t3.micro` → ~$15/month baseline
- `t3.medium` → ~$30/month
- `m5.2xlarge` → ~$280/month (triggers cost alert)

## Files

- `main.tf` - Infrastructure code with Doormat integration
- `DOORMAT_SETUP.md` - IAM role creation guide
- `doormat-setup/` - One-time IAM role setup (already completed)
