# Terraform Run Task AI Analyzer Demo

Demo repository for [terraform-runtask-aws-ai-tf-plan-analyzer](https://github.com/dr-rahulgaikwad/terraform-runtask-aws-ai-tf-plan-analyzer).

## Repository Structure

```
├── good-example/     # Best practices - Run Task passes
├── bad-example/      # Security issues - Run Task fails
└── doormat-setup/    # IAM role for Doormat authentication
```

## Examples

## Examples

### Good Example
- ✅ 6 subnets across 3 AZs (proper network design)
- ✅ 2 EC2 instances with encryption and IMDSv2
- ✅ 2 S3 buckets with AES256 encryption and versioning
- ✅ Security group restricted to VPC CIDR
- ✅ Private subnet placement
- ✅ Cost-efficient (~$25/month)
- **Result**: Run Task passes, apply proceeds

### Bad Example
- 🔴 3 public subnets with auto-assign IPs
- 🔴 2 large instances (m5.4xlarge, m5.2xlarge) without encryption
- 🔴 2 unencrypted S3 buckets with public access
- 🔴 SSH/RDP/MySQL/PostgreSQL exposed to 0.0.0.0/0
- 🔴 No IMDSv2, no EBS encryption
- 🔴 High cost (~$800/month, >300% increase)
- **Result**: Run Task fails with 8+ critical findings, apply blocked (if Mandatory)

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

### Step 3: Configure Doormat Authentication

**No variables needed!** Doormat provider is configured in the Terraform code.

The IAM role `arn:aws:iam::825551243480:role/tfc-doormat-demo-role` is already created and will be used automatically by Doormat.

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
