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

variable "enable_large_instances" {
  description = "Enable large instances for cost demo"
  type        = bool
  default     = false
}

variable "ami_id" {
  description = "AMI ID for x86_64 instances"
  type        = string
  default     = "ami-0e2c8caa4b6378d8c"
}

variable "ami_id_arm" {
  description = "AMI ID for ARM64 instances"
  type        = string
  default     = "ami-0ddc798b3f1a5117e"
}

resource "aws_instance" "valid_instance" {
  ami           = var.ami_id
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
  }
}

resource "aws_instance" "arm_instance" {
  ami           = var.ami_id_arm
  instance_type = "t4g.micro"

  tags = {
    Name         = "${var.environment}-arm-instance"
    Environment  = var.environment
    Architecture = "ARM64"
  }
}

resource "aws_instance" "large_instance" {
  count = var.enable_large_instances ? 1 : 0

  ami           = var.ami_id
  instance_type = "m5.2xlarge"

  tags = {
    Name        = "${var.environment}-large-instance"
    Environment = var.environment
  }
}

resource "aws_instance" "cost_demo_instances" {
  count = var.enable_large_instances ? 3 : 0

  ami           = var.ami_id
  instance_type = "t3.medium"

  tags = {
    Name        = "${var.environment}-cost-demo-${count.index + 1}"
    Environment = var.environment
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

output "estimated_monthly_cost" {
  description = "Estimated monthly cost"
  value       = var.enable_large_instances ? "~$350-400/month" : "~$15-20/month"
}
