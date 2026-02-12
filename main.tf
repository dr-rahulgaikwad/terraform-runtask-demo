# Comprehensive AWS Terraform Demo for AI Plan Analyzer
# Demonstrates: EC2, S3, Security Groups, Cost Analysis, and Edge Cases

terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Variables
variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "demo"
}

variable "enable_risky_resources" {
  description = "Enable intentionally risky resources for demo"
  type        = bool
  default     = true
}

#############################################
# SCENARIO 1: EC2 Validator - Multiple Cases
#############################################

# Valid EC2 instance with proper configuration
resource "aws_instance" "valid_instance" {
  ami           = "ami-0c55b159cbfafe1f0" # Amazon Linux 2
  instance_type = "t3.micro"

  vpc_security_group_ids = [aws_security_group.secure_sg.id]

  root_block_device {
    encrypted   = true
    volume_size = 20
  }

  metadata_options {
    http_tokens = "required" # IMDSv2 enforced
  }

  tags = {
    Name        = "${var.environment}-valid-instance"
    Environment = var.environment
    CostCenter  = "engineering"
  }
}

# ARM-based Graviton instance (cost-efficient)
resource "aws_instance" "arm_instance" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t4g.micro" # ARM Graviton2

  tags = {
    Name         = "${var.environment}-arm-instance"
    Environment  = var.environment
    Architecture = "ARM64"
  }
}

# Larger instance for cost analysis (triggers cost threshold)
resource "aws_instance" "large_instance" {
  count = var.enable_risky_resources ? 1 : 0

  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "m5.2xlarge" # ~$280/month - triggers cost alerts

  tags = {
    Name        = "${var.environment}-large-instance"
    Environment = var.environment
    Purpose     = "cost-demo"
  }
}

# Instance with potentially deprecated AMI
resource "aws_instance" "old_ami_instance" {
  count = var.enable_risky_resources ? 1 : 0

  ami           = "ami-0abcdef1234567890" # Potentially invalid/deprecated
  instance_type = "t2.micro"

  tags = {
    Name        = "${var.environment}-old-ami"
    Environment = var.environment
  }
}

#############################################
# SCENARIO 2: S3 Validator - Security Issues
#############################################

# Secure S3 bucket (best practices)
resource "aws_s3_bucket" "secure_bucket" {
  bucket = "${var.environment}-secure-bucket-${random_id.bucket_suffix.hex}"

  tags = {
    Name        = "${var.environment}-secure-bucket"
    Environment = var.environment
    Compliance  = "required"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "secure_bucket" {
  bucket = aws_s3_bucket.secure_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "secure_bucket" {
  bucket = aws_s3_bucket.secure_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "secure_bucket" {
  bucket = aws_s3_bucket.secure_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Risky S3 bucket - NO encryption (triggers warning)
resource "aws_s3_bucket" "unencrypted_bucket" {
  count = var.enable_risky_resources ? 1 : 0

  bucket = "${var.environment}-unencrypted-${random_id.bucket_suffix.hex}"

  tags = {
    Name        = "${var.environment}-unencrypted-bucket"
    Environment = var.environment
    Risk        = "high"
  }
}

# Risky S3 bucket - Public access allowed (triggers critical warning)
resource "aws_s3_bucket" "public_bucket" {
  count = var.enable_risky_resources ? 1 : 0

  bucket = "${var.environment}-public-${random_id.bucket_suffix.hex}"

  tags = {
    Name        = "${var.environment}-public-bucket"
    Environment = var.environment
    Risk        = "critical"
  }
}

resource "aws_s3_bucket_public_access_block" "public_bucket" {
  count = var.enable_risky_resources ? 1 : 0

  bucket = aws_s3_bucket.public_bucket[0].id

  block_public_acls       = false # Intentionally risky
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# S3 bucket with KMS encryption (best practice)
resource "aws_s3_bucket" "kms_encrypted_bucket" {
  bucket = "${var.environment}-kms-encrypted-${random_id.bucket_suffix.hex}"

  tags = {
    Name        = "${var.environment}-kms-bucket"
    Environment = var.environment
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "kms_encrypted_bucket" {
  bucket = aws_s3_bucket.kms_encrypted_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.s3_key.arn
    }
  }
}

resource "aws_kms_key" "s3_key" {
  description             = "KMS key for S3 encryption"
  deletion_window_in_days = 10
  enable_key_rotation     = true

  tags = {
    Name        = "${var.environment}-s3-kms-key"
    Environment = var.environment
  }
}

resource "aws_kms_alias" "s3_key" {
  name          = "alias/${var.environment}-s3-encryption"
  target_key_id = aws_kms_key.s3_key.key_id
}

#############################################
# SCENARIO 3: Security Group Validator
#############################################

# Secure security group (restrictive rules)
resource "aws_security_group" "secure_sg" {
  name        = "${var.environment}-secure-sg"
  description = "Secure security group with restrictive rules"

  ingress {
    description = "HTTPS from specific CIDR"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"] # Private network only
  }

  egress {
    description = "HTTPS outbound only"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-secure-sg"
    Environment = var.environment
  }
}

# Risky security group - Multiple high-risk ports exposed
resource "aws_security_group" "risky_sg" {
  count = var.enable_risky_resources ? 1 : 0

  name        = "${var.environment}-risky-sg"
  description = "Intentionally risky security group for demo"

  # SSH from anywhere (high risk)
  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # RDP from anywhere (high risk)
  ingress {
    description = "RDP from anywhere"
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # MySQL from anywhere (database exposure)
  ingress {
    description = "MySQL from anywhere"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # PostgreSQL from anywhere (database exposure)
  ingress {
    description = "PostgreSQL from anywhere"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # MongoDB from anywhere
  ingress {
    description = "MongoDB from anywhere"
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound (overly permissive)
  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-risky-sg"
    Environment = var.environment
    Risk        = "critical"
  }
}

# Security group with IPv6 exposure
resource "aws_security_group" "ipv6_sg" {
  count = var.enable_risky_resources ? 1 : 0

  name        = "${var.environment}-ipv6-sg"
  description = "Security group with IPv6 exposure"

  ingress {
    description      = "HTTP from anywhere (IPv6)"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name        = "${var.environment}-ipv6-sg"
    Environment = var.environment
  }
}

#############################################
# SCENARIO 4: Cost Analysis Scenarios
#############################################

# Multiple instances for cost accumulation
resource "aws_instance" "cost_demo_instances" {
  count = var.enable_risky_resources ? 3 : 0

  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t3.medium" # ~$30/month each

  tags = {
    Name        = "${var.environment}-cost-demo-${count.index + 1}"
    Environment = var.environment
    Purpose     = "cost-accumulation-demo"
  }
}

# EBS volumes for additional cost analysis
resource "aws_ebs_volume" "data_volume" {
  count = var.enable_risky_resources ? 1 : 0

  availability_zone = "${var.aws_region}a"
  size              = 100 # GB
  type              = "gp3"
  encrypted         = true

  tags = {
    Name        = "${var.environment}-data-volume"
    Environment = var.environment
  }
}

#############################################
# SCENARIO 5: IAM and Compliance
#############################################

# IAM role with overly permissive policy (triggers guardrails)
resource "aws_iam_role" "risky_role" {
  count = var.enable_risky_resources ? 1 : 0

  name = "${var.environment}-risky-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name        = "${var.environment}-risky-role"
    Environment = var.environment
  }
}

resource "aws_iam_role_policy" "risky_policy" {
  count = var.enable_risky_resources ? 1 : 0

  name = "${var.environment}-risky-policy"
  role = aws_iam_role.risky_role[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "*" # Overly permissive - full admin access
        Resource = "*"
      }
    ]
  })
}

# Secure IAM role with least privilege
resource "aws_iam_role" "secure_role" {
  name = "${var.environment}-secure-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name        = "${var.environment}-secure-role"
    Environment = var.environment
  }
}

resource "aws_iam_role_policy" "secure_policy" {
  name = "${var.environment}-secure-policy"
  role = aws_iam_role.secure_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.secure_bucket.arn,
          "${aws_s3_bucket.secure_bucket.arn}/*"
        ]
      }
    ]
  })
}

#############################################
# Supporting Resources
#############################################

resource "random_id" "bucket_suffix" {
  byte_length = 4
}

#############################################
# Outputs
#############################################

output "valid_instance_id" {
  description = "Valid EC2 instance ID"
  value       = aws_instance.valid_instance.id
}

output "secure_bucket_name" {
  description = "Secure S3 bucket name"
  value       = aws_s3_bucket.secure_bucket.id
}

output "secure_sg_id" {
  description = "Secure security group ID"
  value       = aws_security_group.secure_sg.id
}

output "risky_resources_enabled" {
  description = "Whether risky demo resources are enabled"
  value       = var.enable_risky_resources
}

output "estimated_monthly_cost" {
  description = "Rough estimate of monthly costs (for reference)"
  value       = var.enable_risky_resources ? "~$350-400/month" : "~$10-15/month"
}

