# Terraform AI Plan Analyzer Demo

Minimal AWS Terraform demo for [terraform-runtask-aws-ai-tf-plan-analyzer](https://github.com/dr-rahulgaikwad/terraform-runtask-aws-ai-tf-plan-analyzer).

## What's Included

Demonstrates EC2Validator and CostEstimator with realistic scenarios:

- **EC2Validator**: Valid instances with encryption and IMDSv2, ARM Graviton instances, large instances
- **CostEstimator**: Monthly cost estimates, threshold alerts for cost increases

## Quick Start

```bash
# Initialize
terraform init

# Plan with minimal resources (~$15-20/month)
terraform plan -var="enable_risky_resources=false"

# Plan with all scenarios (~$350-400/month)
terraform plan -var="enable_risky_resources=true"

# Apply
terraform apply

# Cleanup
terraform destroy
```

## Configuration

```bash
# Copy the example file
cp terraform.tfvars.example terraform.tfvars

# Edit as needed
# - Set enable_risky_resources=false for minimal deployment (~$15-20/month)
# - Set enable_risky_resources=true for full demo (~$350-400/month)
```

## Expected AI Findings

### With `enable_risky_resources = true`:

**Warnings (🟡)**
- Large instance (m5.2xlarge ~$280/month)
- Cost increase >20% threshold
- Multiple instances increasing cost footprint

**Good Practices (🟢)**
- IMDSv2 enforced on EC2 instances
- EBS encryption enabled
- ARM Graviton instances for cost optimization

**Cost (💰)**
- Per-resource monthly estimates
- Total: ~$350-400/month
- Cost breakdown by instance type

### With `enable_risky_resources = false`:

Only secure resources with best practices, ~$15-20/month

## Prerequisites

- AWS account with credentials configured
- Terraform >= 1.5.0
- HCP Terraform account with Run Task configured (for AI analysis)

## Notes

- Uses data sources to fetch latest Amazon Linux 2 AMIs automatically
- Demonstrates cost analysis with various instance types
- ARM Graviton instances show cost optimization opportunities
