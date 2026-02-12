# Terraform AI Plan Analyzer Demo

Demo for [terraform-runtask-aws-ai-tf-plan-analyzer](https://github.com/dr-rahulgaikwad/terraform-runtask-aws-ai-tf-plan-analyzer).

## Usage

The AI Run Task analyzer will evaluate the Terraform plan during `terraform plan` in HCP Terraform.

```bash
terraform init
terraform plan
```

## HCP Terraform Setup

1. **AWS Credentials** (Environment Variables):
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`

2. **Terraform Variables**:
   - `aws_region` (default: us-east-1)
   - `ami_id` (default: ami-0e2c8caa4b6378d8c)
   - `enable_large_instance` (default: false)

3. **Configure Run Task**:
   - Stage: Post-plan
   - Enforcement: Advisory

## What the AI Analyzer Checks

- EC2 instance type validation
- AMI availability
- Cost estimation
- Cost threshold alerts (when `enable_large_instance = true`)

### Cost Scenarios

- `enable_large_instance = false`: ~$8/month (t3.micro)
- `enable_large_instance = true`: ~$280/month (adds m5.2xlarge)

## Note

This demo is designed to trigger the AI Run Task analyzer. You don't need to apply - just run `terraform plan` in HCP Terraform to see the AI analysis.
