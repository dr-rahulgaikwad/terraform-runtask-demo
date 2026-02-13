provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role_policy" "s3_permissions" {
  name = "S3Permissions"
  role = "tfc-doormat-demo-role"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:*"
        ]
        Resource = "*"
      }
    ]
  })
}

output "policy_attached" {
  value = "S3 permissions added to tfc-doormat-demo-role"
}
