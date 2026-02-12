terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

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

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_ami" "amazon_linux_2_arm" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-arm64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "valid_instance" {
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = "t3.micro"

  root_block_device {
    encrypted   = true
    volume_size = 20
  }

  metadata_options {
    http_tokens = "required"
  }

  tags = {
    Name        = "${var.environment}-valid-instance"
    Environment = var.environment
    CostCenter  = "engineering"
  }
}

resource "aws_instance" "arm_instance" {
  ami           = data.aws_ami.amazon_linux_2_arm.id
  instance_type = "t4g.micro"

  tags = {
    Name         = "${var.environment}-arm-instance"
    Environment  = var.environment
    Architecture = "ARM64"
  }
}

resource "aws_instance" "large_instance" {
  count = var.enable_risky_resources ? 1 : 0

  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = "m5.2xlarge"

  tags = {
    Name        = "${var.environment}-large-instance"
    Environment = var.environment
    Purpose     = "cost-demo"
  }
}

resource "aws_instance" "cost_demo_instances" {
  count = var.enable_risky_resources ? 3 : 0

  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = "t3.medium"

  tags = {
    Name        = "${var.environment}-cost-demo-${count.index + 1}"
    Environment = var.environment
    Purpose     = "cost-accumulation-demo"
  }
}

output "valid_instance_id" {
  description = "Valid EC2 instance ID"
  value       = aws_instance.valid_instance.id
}

output "arm_instance_id" {
  description = "ARM EC2 instance ID"
  value       = aws_instance.arm_instance.id
}

output "risky_resources_enabled" {
  description = "Whether risky demo resources are enabled"
  value       = var.enable_risky_resources
}

output "estimated_monthly_cost" {
  description = "Rough estimate of monthly costs"
  value       = var.enable_risky_resources ? "~$350-400/month" : "~$15-20/month"
}
