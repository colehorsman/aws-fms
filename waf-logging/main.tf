# WAF Logging Configuration

# Create KMS key for encryption
resource "aws_kms_key" "waf_logs" {
  description             = "KMS key for WAF logs encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "Allow Kinesis Firehose to use the key"
        Effect = "Allow"
        Principal = {
          Service = "firehose.amazonaws.com"
        }
        Action = [
          "kms:Decrypt",
          "kms:GenerateDataKey"
        ]
        Resource = "*"
      },
      {
        Sid    = "Allow S3 to use the key"
        Effect = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
        Action = [
          "kms:Decrypt",
          "kms:GenerateDataKey"
        ]
        Resource = "*"
      }
    ]
  })

  tags = merge(
    var.tags,
    {
      Name = "waf-logs-kms-key"
    }
  )
}

# Create KMS alias
resource "aws_kms_alias" "waf_logs" {
  name          = "alias/waf-logs-${var.environment}"
  target_key_id = aws_kms_key.waf_logs.key_id
}

# Create a Kinesis Firehose for WAF logs
resource "aws_kinesis_firehose_delivery_stream" "waf_logs" {
  name        = "waf-logs-stream"
  destination = "s3"

  s3_configuration {
    role_arn           = aws_iam_role.firehose_role.arn
    bucket_arn         = aws_s3_bucket.waf_logs.arn
    buffer_size        = 10
    buffer_interval    = 400
    compression_format = "GZIP"
    kms_key_arn        = aws_kms_key.waf_logs.arn
  }

  tags = merge(
    var.tags,
    {
      Name = "waf-logs-stream"
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
        kms_master_key_id = aws_kms_key.waf_logs.arn
        sse_algorithm     = "aws:kms"
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
      days = 365
    }
  }

  tags = merge(
    var.tags,
    {
      Name = "waf-logs-bucket"
    }
  )
}

# Create an IAM role for Kinesis Firehose
resource "aws_iam_role" "firehose_role" {
  name = "waf-logs-firehose-role"

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
      Name = "waf-logs-firehose-role"
    }
  )
}

# Create an IAM policy for Kinesis Firehose
resource "aws_iam_role_policy" "firehose_policy" {
  name = "waf-logs-firehose-policy"
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
      },
      {
        Action = [
          "kms:Decrypt",
          "kms:GenerateDataKey"
        ]
        Effect   = "Allow"
        Resource = [
          aws_kms_key.waf_logs.arn
        ]
      }
    ]
  })
}

# Get the current AWS account ID
data "aws_caller_identity" "current" {} 