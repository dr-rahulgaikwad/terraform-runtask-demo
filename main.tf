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

resource "aws_instance" "demo" {
  ami           = var.ami_id
  instance_type = "t3.micro"

  tags = {
    Name = "demo-instance"
  }
}

output "instance_id" {
  value = aws_instance.demo.id
}
