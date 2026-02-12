# Terraform AI Plan Analyzer Demo

Demo for [terraform-runtask-aws-ai-tf-plan-analyzer](https://github.com/dr-rahulgaikwad/terraform-runtask-aws-ai-tf-plan-analyzer).

## What This Demonstrates

- 2 EC2 instances with different configurations
- EC2Validator: Instance type validation, AMI checks
- CostEstimator: Monthly cost analysis

## HCP Terraform Setup

### Environment Variables
```
AWS_ACCESS_KEY_ID = <your-key>
AWS_SECRET_ACCESS_KEY = <your-secret>
```

### Terraform Variables
```
aws_region = "us-east-1"
instance_type = "t3.micro"
```

### Run Task Configuration
- Stage: Post-plan
- Enforcement: Advisory

## Usage

1. Push code to VCS
2. Connect to HCP Terraform workspace
3. Queue a plan
4. View AI analysis in Run Task output

## Testing Different Scenarios

Change `instance_type` variable to test cost analysis:
- `t3.micro` - ~$15/month
- `t3.medium` - ~$30/month  
- `m5.2xlarge` - ~$280/month (triggers cost threshold alert)

## Local Testing

```bash
terraform init
terraform plan
```
