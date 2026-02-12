# Terraform AI Plan Analyzer Demo

Minimal demo for [terraform-runtask-aws-ai-tf-plan-analyzer](https://github.com/dr-rahulgaikwad/terraform-runtask-aws-ai-tf-plan-analyzer).

## Quick Start

```bash
terraform init
terraform plan
terraform apply
terraform destroy
```

## HCP Terraform Setup

### AWS Credentials (Environment Variables)
- `AWS_ACCESS_KEY_ID` (sensitive)
- `AWS_SECRET_ACCESS_KEY` (sensitive)

### Terraform Variables
- `aws_region` - AWS region (default: us-east-1)
- `ami_id` - AMI ID for your region (default: ami-0e2c8caa4b6378d8c)

## What the AI Analyzer Will Check

- EC2 instance type availability
- AMI validation
- Cost estimation (~$7-8/month for t3.micro)
- Best practices recommendations
