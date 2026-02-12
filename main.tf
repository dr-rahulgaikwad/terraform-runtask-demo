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
  type    = string
  default = "us-east-1"
}

variable "ami_id" {
  type    = string
  default = "ami-0e2c8caa4b6378d8c"
}

variable "enable_large_instance" {
  type    = bool
  default = false
}

resource "aws_instance" "small" {
  ami           = var.ami_id
  instance_type = "t3.micro"

  tags = {
    Name = "demo-small"
  }
}

resource "aws_instance" "large" {
  count = var.enable_large_instance ? 1 : 0

  ami           = var.ami_id
  instance_type = "m5.2xlarge"

  tags = {
    Name = "demo-large"
  }
}

output "small_instance_id" {
  value = aws_instance.small.id
}

output "estimated_cost" {
  value = var.enable_large_instance ? "~$280/month" : "~$8/month"
}
