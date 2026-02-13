# Terraform AI Plan Analyzer Demo

Demo for [terraform-runtask-aws-ai-tf-plan-analyzer](https://github.com/dr-rahulgaikwad/terraform-runtask-aws-ai-tf-plan-analyzer).

## Overview

Comprehensive demo with VPC, Security Groups, EC2, and S3 to generate meaningful AI analysis.

## What the AI Analyzer Will Check

✅ **EC2Validator**: Instance types, AMI validation  
✅ **S3Validator**: Unencrypted bucket detection  
✅ **SecurityGroupValidator**: SSH exposed to 0.0.0.0/0 (intentional for demo)  
✅ **CostEstimator**: Monthly cost analysis with threshold alerts

## Prerequisites

✅ IAM role: `arn:aws:iam::825551243480:role/tfc-doormat-demo-role`

## HCP Terraform Setup

**Organization:** `rahul-tfc`  
**Workspace:** `terraform-runtask-demo-ws`

### Variables

- `aws_region` = `us-east-1`
- `instance_type` = `t3.micro`
- `enable_large_instance` = `false` (set to `true` for cost alerts)

### Run Task

- Stage: Post-plan
- Enforcement: Advisory

## Expected AI Findings

🔴 **Security Issues:**
- SSH (port 22) exposed to 0.0.0.0/0
- S3 bucket without encryption

🟢 **Good Practices:**
- EBS volumes encrypted
- IMDSv2 enforced
- VPC with proper networking

💰 **Cost Analysis:**
- Baseline: ~$25/month
- With large instance: ~$300/month (triggers >20% alert)

## Usage

1. Push to VCS
2. Queue plan in HCP Terraform
3. View AI analysis in Run Task output
4. Check "Bedrock-TF-Plan-Analyzer" section for detailed findings

## Demo Scenarios

Toggle `enable_large_instance` to see cost threshold alerts!
