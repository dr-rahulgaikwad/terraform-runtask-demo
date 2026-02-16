# Example 2 - Infrastructure with Issues

Infrastructure with multiple security issues for demonstration.

## Resources

**Networking (3 public subnets)**
- VPC without DNS configuration
- 3 public subnets with auto-assign public IP
- All subnets exposed to internet
- No private subnets

**Compute**
- 2 large EC2 instances (m5.4xlarge, m5.2xlarge)
- No EBS encryption
- No IMDSv2
- Public subnet placement

**Storage**
- 2 S3 buckets (data, backups)
- No encryption
- Public access allowed
- No versioning

**Security**
- Security group exposes SSH, RDP, MySQL, PostgreSQL to 0.0.0.0/0
- All egress allowed
- Critical ports exposed

## Expected AI Analysis

### Plan-Summary
🔴 2 large EC2 instances without security hardening  
🔴 2 unencrypted S3 buckets with public access  
🔴 3 public subnets with auto-assign IPs  
⚠️ No network segmentation

### Impact-Analysis
🔴 **Security**: Multiple critical vulnerabilities  
  - SSH/RDP exposed to internet
  - Database ports (3306, 5432) exposed
  - Unencrypted storage
  - Public S3 buckets
  
🔴 **Operational**: Single point of failure  
💰 **Cost**: ~$800/month (exceeds threshold by >300%)

### AMI-Summary
✅ AMI validated  
⚠️ Using same AMI for web and database (not best practice)

## Run Task Result

🔴 **FAIL** → Apply blocked (if Mandatory enforcement)

### Critical Findings
1. Security group allows SSH from 0.0.0.0/0
2. Security group allows RDP from 0.0.0.0/0
3. Security group allows MySQL from 0.0.0.0/0
4. Security group allows PostgreSQL from 0.0.0.0/0
5. S3 buckets allow public access
6. S3 buckets not encrypted
7. EC2 instances not encrypted
8. Cost increase >300% (triggers threshold)

## HCP Terraform Setup

**Workspace**: `example-2-ws`  
**Working Directory**: `example-2`  
**Run Task Enforcement**: Mandatory (to block apply)
