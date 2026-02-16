# Good Example - Best Practices

Comprehensive infrastructure demonstrating security best practices.

## Resources

**Networking (6 subnets across 3 AZs)**
- VPC with DNS enabled
- 2 private subnets (10.0.1.0/24, 10.0.2.0/24)
- 1 public subnet (10.0.10.0/24)
- Internet Gateway
- Route tables with proper associations

**Compute**
- 2 EC2 instances (t3.micro, t3.small)
- Encrypted EBS volumes
- IMDSv2 enforced
- Private subnet placement

**Storage**
- 2 S3 buckets (data, logs)
- AES256 encryption enabled
- Versioning enabled on data bucket
- Public access completely blocked

**Security**
- Security group restricted to VPC CIDR
- HTTPS-only egress
- No public exposure

## Expected AI Analysis

### Plan-Summary
✅ 2 EC2 instances with proper security configuration  
✅ 2 S3 buckets with encryption and access controls  
✅ 6 subnets across 3 availability zones  
✅ Proper network segmentation

### Impact-Analysis
🟢 **Security**: All best practices followed  
🟢 **Operational**: High availability with multi-AZ  
💰 **Cost**: ~$25/month (cost-efficient)

### AMI-Summary
✅ AMI validated and available  
✅ Architecture: x86_64  
✅ OS: Amazon Linux 2

## Run Task Result

✅ **PASS** → Apply proceeds
