# Good Example - Best Practices

This example demonstrates security best practices that will pass AI analysis.

## Features

✅ **Security Group**: Restricted to VPC CIDR only  
✅ **S3 Bucket**: Encrypted with AES256, public access blocked  
✅ **EC2 Instance**: Encrypted EBS, IMDSv2 enforced, small instance type  
✅ **Network**: Private subnet, no public IPs

## Expected AI Analysis

🟢 All security checks pass  
💰 Low cost (~$10/month)  
✅ Run Task: **PASS** → Apply proceeds

## HCP Terraform Setup

**Workspace**: `good-example-ws`  
**Run Task Enforcement**: Advisory or Mandatory (will pass either way)
