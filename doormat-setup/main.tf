/*provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "doormat_role" {
  name                 = "tfc-doormat-demo-role"
  max_session_duration = 43200

  tags = {
    hc-service-uri = "app.terraform.io/rahul-tfc/terraform-runtask-demo-ws"
  }

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "sts:AssumeRole",
        "sts:SetSourceIdentity",
        "sts:TagSession"
      ]
      Principal = {
        AWS = "arn:aws:iam::397512762488:user/doormatServiceUser"
      }
    }]
  })

  inline_policy {
    name = "EC2Permissions"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [{
        Effect   = "Allow"
        Action   = ["ec2:*"]
        Resource = "*"
      }]
    })
  }
}

output "doormat_role_arn" {
  value       = aws_iam_role.doormat_role.arn
  description = "Copy this ARN and add it to HCP Terraform workspace as doormat_role_arn variable"
}

*/