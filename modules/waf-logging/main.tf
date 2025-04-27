# WAF Logging Module

variable "environment" {
  description = "Environment name (e.g., prod, staging, dev)"
  type        = string
}

variable "log_retention_days" {
  description = "Number of days to retain logs in S3"
  type        = number
  default     = 365
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

# Create a Kinesis Firehose for WAF logs
resource "aws_kinesis_firehose_delivery_stream" "waf_logs" {
  name        = "waf-logs-stream-${var.environment}"
  destination = "s3"

  s3_configuration {
    role_arn           = aws_iam_role.firehose_role.arn
    bucket_arn         = aws_s3_bucket.waf_logs.arn
    buffer_size        = 10
    buffer_interval    = 400
    compression_format = "GZIP"
  }

  tags = merge(
    var.tags,
    {
      Name = "waf-logs-stream-${var.environment}"
    }
  )
}

# Create an S3 bucket for WAF logs
resource "aws_s3_bucket" "waf_logs" {
  bucket = "waf-logs-${var.environment}-${data.aws_caller_identity.current.account_id}"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  versioning {
    enabled = true
  }

  lifecycle_rule {
    enabled = true
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
    transition {
      days          = 90
      storage_class = "GLACIER"
    }
    expiration {
      days = var.log_retention_days
    }
  }

  tags = merge(
    var.tags,
    {
      Name = "waf-logs-bucket-${var.environment}"
    }
  )
}

# Create an IAM role for Kinesis Firehose
resource "aws_iam_role" "firehose_role" {
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

  tags = merge(
    var.tags,
    {
      Name = "waf-logs-firehose-role-${var.environment}"
    }
  )
}

# Create an IAM policy for Kinesis Firehose
resource "aws_iam_role_policy" "firehose_policy" {
  name = "waf-logs-firehose-policy-${var.environment}"
  role = aws_iam_role.firehose_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:AbortMultipartUpload",
          "s3:GetBucketLocation",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:ListBucketMultipartUploads",
          "s3:PutObject"
        ]
        Effect   = "Allow"
        Resource = [
          aws_s3_bucket.waf_logs.arn,
          "${aws_s3_bucket.waf_logs.arn}/*"
        ]
      }
    ]
  })
}

# Get the current AWS account ID
data "aws_caller_identity" "current" {}

output "firehose_arn" {
  description = "ARN of the Kinesis Firehose delivery stream"
  value       = aws_kinesis_firehose_delivery_stream.waf_logs.arn
}

output "bucket_name" {
  description = "Name of the S3 bucket for WAF logs"
  value       = aws_s3_bucket.waf_logs.id
} 