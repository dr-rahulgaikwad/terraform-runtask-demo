terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    doormat = {
      source  = "doormat.hashicorp.services/hashicorp-security/doormat"
      version = "~> 0.0.6"
    }
  }
  cloud {
    organization = "rahul-tfc"
    workspaces {
      name = "good-example-ws"
    }
  }
}

provider "doormat" {}

data "doormat_aws_credentials" "creds" {
  provider = doormat
  role_arn = "arn:aws:iam::825551243480:role/tfc-doormat-demo-role"
}

provider "aws" {
  region     = "us-east-1"
  access_key = data.doormat_aws_credentials.creds.access_key
  secret_key = data.doormat_aws_credentials.creds.secret_key
  token      = data.doormat_aws_credentials.creds.token
}

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "cloud-infra-ai-example"
    environment = "development"
  }
}

resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "private-subnet-1a"
  }
}

resource "aws_subnet" "private_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "private-subnet-1b"
  }
}

resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.10.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "public-subnet-1a"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "public-rt"
  }
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "web" {
  name        = "web-sg-secure"
  description = "Secure web server security group"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    description = "HTTPS outbound"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-sg-secure"
  }
}

resource "aws_instance" "web" {
  ami                    = "ami-0e2c8caa4b6378d8c"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.private_a.id
  vpc_security_group_ids = [aws_security_group.web.id]

  root_block_device {
    encrypted   = true
    volume_size = 20
    volume_type = "gp3"
  }

  metadata_options {
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  tags = {
    Name        = "web-server"
    Environment = "development"
  }
}

resource "aws_instance" "app" {
  ami                    = "ami-0e2c8caa4b6378d8c"
  instance_type          = "t3.small"
  subnet_id              = aws_subnet.private_b.id
  vpc_security_group_ids = [aws_security_group.web.id]

  root_block_device {
    encrypted   = true
    volume_size = 30
    volume_type = "gp3"
  }

  metadata_options {
    http_tokens = "required"
  }

  tags = {
    Name        = "app-server"
    Environment = "development"
  }
}

resource "aws_s3_bucket" "data" {
  bucket = "good-data-bucket-${data.aws_caller_identity.current.account_id}"

  tags = {
    Name        = "data-bucket"
    Environment = "development"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "data" {
  bucket = aws_s3_bucket.data.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "data" {
  bucket = aws_s3_bucket.data.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "data" {
  bucket = aws_s3_bucket.data.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "logs" {
  bucket = "good-logs-bucket-${data.aws_caller_identity.current.account_id}"

  tags = {
    Name        = "logs-bucket"
    Environment = "development"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "logs" {
  bucket = aws_s3_bucket.logs.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "logs" {
  bucket = aws_s3_bucket.logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_caller_identity" "current" {}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "web_instance_id" {
  value = aws_instance.web.id
}

output "app_instance_id" {
  value = aws_instance.app.id
}
