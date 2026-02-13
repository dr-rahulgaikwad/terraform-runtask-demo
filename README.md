# Terraform Run Task AI Analyzer Demo

Demo repository for [terraform-runtask-aws-ai-tf-plan-analyzer](https://github.com/dr-rahulgaikwad/terraform-runtask-aws-ai-tf-plan-analyzer).

## Repository Structure

```
├── good-example/     # Best practices - Run Task passes
├── bad-example/      # Security issues - Run Task fails
└── doormat-setup/    # IAM role for Doormat authentication
```

## Examples

### Good Example
- ✅ Secure security groups (VPC-only access)
- ✅ Encrypted S3 bucket with public access blocked
- ✅ Encrypted EBS, IMDSv2 enforced
- ✅ Cost-efficient instance (t3.micro)
- **Result**: Run Task passes, apply proceeds

### Bad Example
- 🔴 SSH/RDP/MySQL exposed to 0.0.0.0/0
- 🔴 Unencrypted S3 bucket, public access allowed
- 🔴 No EBS encryption, no IMDSv2
- 🔴 Oversized instance (m5.4xlarge, ~$560/month)
- **Result**: Run Task fails, apply blocked (if Mandatory)

## Setup

### Step 1: Push to Git

Ensure all files are committed and pushed:
```bash
git add .
git commit -m "Add good and bad examples"
git push
```

### Step 2: Create HCP Terraform Workspaces

**Good Example Workspace:**
1. Create workspace: `good-example-ws`
2. Connect to VCS (this repository)
3. **Settings → General → Terraform Working Directory**: `good-example`
4. Save settings

**Bad Example Workspace:**
1. Create workspace: `bad-example-ws`
2. Connect to VCS (this repository)
3. **Settings → General → Terraform Working Directory**: `bad-example`
4. Save settings

### Step 3: Configure AWS Credentials

In each workspace, add environment variables:
- `AWS_ACCESS_KEY_ID` (mark as sensitive)
- `AWS_SECRET_ACCESS_KEY` (mark as sensitive)

### Step 4: Configure Run Task

In each workspace:
- Go to Settings → Run Tasks
- Add the AI Plan Analyzer Run Task
- Stage: Post-plan
- Enforcement:
  - `good-example-ws`: Advisory
  - `bad-example-ws`: Mandatory

### Step 5: Queue Plans

Queue a plan in each workspace to see the AI analysis!

## Demo Flow

1. **Good Example**: Queue plan → AI analysis passes → Apply succeeds
2. **Bad Example**: Queue plan → AI analysis fails → Apply blocked (if Mandatory)

## What the AI Analyzer Checks

- EC2Validator: Instance types, AMI validation
- S3Validator: Encryption, public access
- SecurityGroupValidator: Port exposure, 0.0.0.0/0 rules
- CostEstimator: Monthly costs, threshold alerts (>20%)
