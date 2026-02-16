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
      name = "bad-example-ws"
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
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "bad-vpc"
  }
}

resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.48.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "bad-public-1a"
  }
}

resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.49.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "bad-public-1b"
  }
}

resource "aws_subnet" "public_c" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.50.0/24"
  availability_zone       = "us-east-1c"
  map_public_ip_on_launch = true

  tags = {
    Name = "bad-public-1c"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "bad-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "bad-public-rt"
  }
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_c" {
  subnet_id      = aws_subnet.public_c.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "insecure" {
  name        = "bad-insecure-sg"
  description = "Insecure security group with multiple exposures"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "RDP from anywhere"
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "MySQL from anywhere"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "PostgreSQL from anywhere"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bad-insecure-sg"
  }
}

resource "aws_instance" "web" {
  ami                    = "ami-0e2c8caa4b6378d8c"
  instance_type          = "m5.4xlarge"
  subnet_id              = aws_subnet.public_a.id
  vpc_security_group_ids = [aws_security_group.insecure.id]

  tags = {
    Name = "bad-web-server"
  }
}

resource "aws_instance" "db" {
  ami                    = "ami-0e2c8caa4b6378d8c"
  instance_type          = "m5.2xlarge"
  subnet_id              = aws_subnet.public_b.id
  vpc_security_group_ids = [aws_security_group.insecure.id]

  tags = {
    Name = "bad-db-server"
  }
}

resource "aws_s3_bucket" "data" {
  bucket = "bad-data-bucket-${data.aws_caller_identity.current.account_id}"

  tags = {
    Name = "bad-data-bucket"
  }
}

resource "aws_s3_bucket_public_access_block" "data" {
  bucket = aws_s3_bucket.data.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket" "backups" {
  bucket = "bad-backups-bucket-${data.aws_caller_identity.current.account_id}"

  tags = {
    Name = "bad-backups-bucket"
  }
}

data "aws_caller_identity" "current" {}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "web_instance_id" {
  value = aws_instance.web.id
}

output "db_instance_id" {
  value = aws_instance.db.id
}
