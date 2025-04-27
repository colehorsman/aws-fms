# AWS Shield Configuration
# This file configures AWS Shield protection for resources

# Shield Advanced subscription
resource "aws_shield_protection" "advanced_protection" {
  count        = var.shield_advanced_enabled ? 1 : 0
  name         = "${var.environment}-shield-advanced"
  resource_arn = var.resource_arn

  tags = var.tags
}

# Shield Advanced subscription
resource "aws_shield_subscription" "advanced" {
  count = var.shield_advanced_enabled ? 1 : 0

  auto_renew = true

  tags = var.tags
}

# Shield Advanced protection group
resource "aws_shield_protection_group" "advanced_group" {
  count = var.shield_advanced_enabled ? 1 : 0

  protection_group_id = "${var.environment}-shield-advanced-group"
  aggregation         = "MAX"
  pattern            = "ALL"

  tags = var.tags
}

# Shield Standard protection
resource "aws_shield_protection" "standard_protection" {
  count        = var.shield_standard_enabled ? 1 : 0
  name         = "${var.environment}-shield-standard"
  resource_arn = var.resource_arn

  tags = var.tags
}

# Shield response team notification
resource "aws_shield_protection_health_check_association" "health_check" {
  count = var.shield_advanced_enabled ? 1 : 0

  shield_protection_id = aws_shield_protection.advanced_protection[0].id
  health_check_arn    = var.health_check_arn
}

# Shield DRT access role
resource "aws_shield_drt_access_role_arn_association" "drt_access" {
  count = var.shield_advanced_enabled ? 1 : 0

  role_arn = aws_iam_role.shield_drt_access[0].arn
}

# IAM role for Shield DRT access
resource "aws_iam_role" "shield_drt_access" {
  count = var.shield_advanced_enabled ? 1 : 0

  name = "${var.environment}-shield-drt-access"

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

  tags = var.tags
}

# IAM policy for Shield DRT access
resource "aws_iam_role_policy" "shield_drt_access" {
  count = var.shield_advanced_enabled ? 1 : 0

  name = "${var.environment}-shield-drt-access-policy"
  role = aws_iam_role.shield_drt_access[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "cloudwatch:DescribeAlarms",
          "cloudwatch:GetMetricStatistics",
          "cloudwatch:ListMetrics",
          "ec2:DescribeInstances",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSubnets",
          "ec2:DescribeVpcs",
          "elasticloadbalancing:DescribeLoadBalancers",
          "elasticloadbalancing:DescribeLoadBalancerAttributes",
          "elasticloadbalancing:DescribeLoadBalancerPolicies",
          "elasticloadbalancing:DescribeLoadBalancerPolicyTypes",
          "elasticloadbalancing:DescribeLoadBalancers",
          "elasticloadbalancing:DescribeLoadBalancerAttributes",
          "elasticloadbalancing:DescribeLoadBalancerPolicies",
          "elasticloadbalancing:DescribeLoadBalancerPolicyTypes",
          "route53:GetHostedZone",
          "route53:ListHostedZones",
          "route53:ListResourceRecordSets",
          "route53:GetChange",
          "route53:GetHealthCheck",
          "route53:GetHealthCheckStatus",
          "route53:ListHealthChecks",
          "route53:ListTagsForResource",
          "route53:ListTagsForResources",
          "route53:ListHostedZonesByName",
          "route53:ListResourceRecordSets",
          "route53:GetChange",
          "route53:GetHealthCheck",
          "route53:GetHealthCheckStatus",
          "route53:ListHealthChecks",
          "route53:ListTagsForResource",
          "route53:ListTagsForResources",
          "route53:ListHostedZonesByName"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

# CloudWatch alarms for Shield metrics
resource "aws_cloudwatch_metric_alarm" "shield_ddos_attack" {
  count               = var.shield_advanced_enabled ? 1 : 0
  provider            = aws.primary
  alarm_name          = "${var.environment}-shield-ddos-attack"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "DDoSDetected"
  namespace           = "AWS/Shield"
  period             = "60"
  statistic          = "Sum"
  threshold          = "0"
  alarm_description  = "This alarm monitors for DDoS attacks detected by Shield Advanced"
  alarm_actions      = [var.sns_topic_arn]
  ok_actions         = [var.sns_topic_arn]

  dimensions = {
    ProtectionId = aws_shield_protection.advanced_protection[0].id
  }

  tags = var.tags
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
            ["AWS/Shield", "DDoSDetected", "ProtectionId", aws_shield_protection.advanced_protection[0].id],
            ["AWS/Shield", "DDoSAttackBitsPerSecond", "ProtectionId", aws_shield_protection.advanced_protection[0].id],
            ["AWS/Shield", "DDoSAttackPacketsPerSecond", "ProtectionId", aws_shield_protection.advanced_protection[0].id]
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