# AWS Shield Configuration
# This file configures AWS Shield protection for resources

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      configuration_aliases = [aws.primary, aws.dr]
    }
  }
}

# Shield Advanced subscription
resource "aws_shield_subscription" "advanced" {
  count    = var.shield_advanced_enabled ? 1 : 0
  provider = aws.primary
}

# Shield Advanced protection
resource "aws_shield_protection" "this" {
  count        = var.shield_advanced_enabled ? 1 : 0
  name         = "shield-protection-${var.environment}"
  resource_arn = var.resource_arn

  tags = merge(
    {
      Name        = "shield-protection-${var.environment}"
      Environment = var.environment
    },
    var.tags
  )
}

# Shield Advanced protection group
resource "aws_shield_protection_group" "this" {
  count               = var.shield_advanced_enabled ? 1 : 0
  protection_group_id = "protection-group-${var.environment}"
  aggregation        = "MAX"
  pattern            = "ALL"

  members = [aws_shield_protection.this[0].id]

  tags = merge(
    {
      Name        = "shield-protection-group-${var.environment}"
      Environment = var.environment
    },
    var.tags
  )
}

# Shield Standard protection
resource "aws_shield_protection" "standard" {
  count        = var.shield_standard_enabled ? 1 : 0
  provider     = aws.primary
  name         = "${var.environment}-shield-standard"
  resource_arn = var.resource_arn

  tags = var.tags
}

# Shield response team notification
resource "aws_shield_protection_health_check_association" "this" {
  count              = var.shield_advanced_enabled && var.health_check_arn != null ? 1 : 0
  shield_protection_id = aws_shield_protection.this[0].id
  health_check_arn   = var.health_check_arn
}

# Shield DRT access role
resource "aws_iam_role" "shield_drt" {
  count = var.shield_advanced_enabled ? 1 : 0
  name  = "shield-drt-role-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "drt.shield.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(
    {
      Name        = "shield-drt-role-${var.environment}"
      Environment = var.environment
    },
    var.tags
  )
}

# Shield DRT access role policy
resource "aws_iam_role_policy" "shield_drt" {
  count = var.shield_advanced_enabled ? 1 : 0
  name  = "shield-drt-policy-${var.environment}"
  role  = aws_iam_role.shield_drt[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "shield:*",
          "waf:*",
          "waf-regional:*",
          "cloudfront:*",
          "elasticloadbalancing:*",
          "route53:*"
        ]
        Resource = "*"
      }
    ]
  })
}

# Shield DRT access role ARN association
resource "aws_shield_drt_access_role_arn_association" "this" {
  count     = var.shield_advanced_enabled ? 1 : 0
  role_arn  = aws_iam_role.shield_drt[0].arn
}

# CloudWatch alarm for Shield DDoS attacks
resource "aws_cloudwatch_metric_alarm" "shield_ddos" {
  count               = var.shield_advanced_enabled ? 1 : 0
  alarm_name          = "shield-ddos-alarm-${var.environment}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "DDoSDetected"
  namespace           = "AWS/Shield"
  period             = "300"
  statistic          = "Maximum"
  threshold          = "0"
  alarm_description  = "This metric monitors for DDoS attacks detected by Shield Advanced"
  alarm_actions      = [var.sns_topic_arn]

  dimensions = {
    ResourceArn = var.resource_arn
  }

  tags = merge(
    {
      Name        = "shield-ddos-alarm-${var.environment}"
      Environment = var.environment
    },
    var.tags
  )
}

# Outputs
output "protection_id" {
  description = "The ID of the Shield protection"
  value       = var.shield_advanced_enabled ? aws_shield_protection.this[0].id : null
}

output "protection_arn" {
  description = "The ARN of the Shield protection"
  value       = var.shield_advanced_enabled ? aws_shield_protection.this[0].arn : null
}

# CloudWatch dashboard for Shield metrics
resource "aws_cloudwatch_dashboard" "shield_dashboard" {
  count       = var.shield_advanced_enabled ? 1 : 0
  provider    = aws.primary
  dashboard_name = "${var.environment}-shield-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/Shield", "DDoSDetected", "ProtectionId", aws_shield_protection.this[0].id],
            ["AWS/Shield", "DDoSAttackBitsPerSecond", "ProtectionId", aws_shield_protection.this[0].id],
            ["AWS/Shield", "DDoSAttackPacketsPerSecond", "ProtectionId", aws_shield_protection.this[0].id]
          ]
          period = 300
          stat   = "Sum"
          region = var.primary_region
          title  = "Shield Advanced Metrics"
        }
      }
    ]
  })
} 