locals {
  environments = {
    dev = {
      enforcement_mode = "COUNT"
      override_actions = {
        aws_managed_rules = "count"
        rate_based_rules = "count"
        ip_reputation_lists = "count"
      }
    }
    staging = {
      enforcement_mode = "COUNT"
      override_actions = {
        aws_managed_rules = "none"
        rate_based_rules = "none"
        ip_reputation_lists = "none"
      }
    }
    prod = {
      enforcement_mode = "BLOCK"
      override_actions = {
        aws_managed_rules = "none"
        rate_based_rules = "none"
        ip_reputation_lists = "none"
      }
    }
  }

  current_policy_version = "v1.0.0"
  
  policy_versions = {
    "v1.0.0" = {
      description = "Initial policy version"
      rules = {
        aws_managed = true
        custom_rules = true
        rate_based = true
        ip_reputation = true
      }
    }
  }
}

resource "aws_s3_bucket" "policy_versions" {
  bucket = "${var.name_prefix}-policy-versions"
  
  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  lifecycle_rule {
    enabled = true

    noncurrent_version_expiration {
      days = 90
    }
  }

  tags = merge(var.tags, {
    Environment = var.environment
  })
}

resource "aws_s3_bucket_public_access_block" "policy_versions" {
  bucket = aws_s3_bucket.policy_versions.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_object" "current_policy" {
  bucket = aws_s3_bucket.policy_versions.id
  key    = "${local.current_policy_version}/policy.json"
  content = jsonencode({
    version = local.current_policy_version
    timestamp = timestamp()
    environment = var.environment
    policy_config = local.environments[var.environment]
    rules_enabled = local.policy_versions[local.current_policy_version].rules
  })

  server_side_encryption = "AES256"

  tags = merge(var.tags, {
    Environment = var.environment
    Version = local.current_policy_version
  })
} 