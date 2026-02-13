# Bad Example - Security Issues

This example demonstrates security anti-patterns that will trigger AI warnings.

## Issues

🔴 **Security Group**: SSH, RDP, MySQL exposed to 0.0.0.0/0  
🔴 **S3 Bucket**: No encryption, public access allowed  
🔴 **EC2 Instance**: No encryption, no IMDSv2, oversized (m5.4xlarge)  
🔴 **Network**: Public subnet with auto-assign public IP  
💰 **Cost**: High (~$560/month) - triggers threshold alert

## Expected AI Analysis

🔴 Multiple critical security findings  
🔴 Cost threshold exceeded (>20%)  
⚠️ Run Task: **FAIL**

- **Advisory mode**: Apply proceeds with warnings
- **Mandatory mode**: Apply blocked

## HCP Terraform Setup

**Workspace**: `bad-example-ws`  
**Run Task Enforcement**: Set to Mandatory to block apply
