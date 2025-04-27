terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      configuration_aliases = [aws.primary, aws.dr]
    }
  }
}

resource "aws_kinesis_firehose_delivery_stream" "waf_logs" {
  provider = aws.primary
  name        = "aws-waf-logs-${var.environment}"
  destination = "s3"

  s3_configuration {
    role_arn   = aws_iam_role.firehose_role.arn
    bucket_arn = aws_s3_bucket.waf_logs.arn
    prefix     = "waf-logs/"
  }

  tags = var.tags
}

resource "aws_s3_bucket" "waf_logs" {
  provider = aws.primary
  bucket = "aws-waf-logs-${var.environment}-${data.aws_caller_identity.current.account_id}"
  tags   = var.tags
}

data "aws_caller_identity" "current" {
  provider = aws.primary
}

resource "aws_iam_role" "firehose_role" {
  provider = aws.primary
  name = "waf-logs-firehose-role-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "firehose.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}

output "waf_logs_firehose_arn" {
  value = aws_kinesis_firehose_delivery_stream.waf_logs.arn
} 