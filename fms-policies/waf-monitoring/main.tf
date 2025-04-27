# WAF Monitoring Configuration
# This file configures CloudWatch alarms for WAF blocking thresholds

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      configuration_aliases = [aws.primary, aws.dr]
    }
  }
}

# CloudWatch Alarm for high rate of blocked requests in primary region
resource "aws_cloudwatch_metric_alarm" "waf_blocked_requests_primary" {
  provider            = aws.primary
  alarm_name          = "${var.environment}-waf-blocked-requests-${var.primary_region}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "BlockedRequests"
  namespace           = "AWS/WAFV2"
  period             = "60"  # 1 minute
  statistic          = "Sum"
  threshold          = "5"   # Alert if more than 5 blocks in 1 minute
  alarm_description  = "This alarm monitors WAF blocked requests in primary region. Alert if more than 5 requests are blocked within 1 minute."
  alarm_actions      = [var.sns_topic_arn]
  ok_actions         = [var.sns_topic_arn]

  dimensions = {
    WebACL = var.web_acl_name
    Region = var.primary_region
  }

  tags = var.tags
}

# CloudWatch Alarm for high rate of blocked requests in DR region
resource "aws_cloudwatch_metric_alarm" "waf_blocked_requests_dr" {
  provider            = aws.dr
  alarm_name          = "${var.environment}-waf-blocked-requests-${var.dr_region}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "BlockedRequests"
  namespace           = "AWS/WAFV2"
  period             = "60"  # 1 minute
  statistic          = "Sum"
  threshold          = "5"   # Alert if more than 5 blocks in 1 minute
  alarm_description  = "This alarm monitors WAF blocked requests in DR region. Alert if more than 5 requests are blocked within 1 minute."
  alarm_actions      = [var.sns_topic_arn]
  ok_actions         = [var.sns_topic_arn]

  dimensions = {
    WebACL = var.web_acl_name
    Region = var.dr_region
  }

  tags = var.tags
}

# CloudWatch Alarm for high rate of blocked requests by rule in primary region
resource "aws_cloudwatch_metric_alarm" "waf_blocked_requests_by_rule_primary" {
  provider            = aws.primary
  alarm_name          = "${var.environment}-waf-blocked-requests-by-rule-${var.primary_region}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "BlockedRequests"
  namespace           = "AWS/WAFV2"
  period             = "300"  # 5 minutes
  statistic          = "Sum"
  threshold          = "20"   # Alert if more than 20 blocks in 5 minutes
  alarm_description  = "This alarm monitors WAF blocked requests by rule in primary region. Alert if more than 20 requests are blocked by a specific rule within 5 minutes."
  alarm_actions      = [var.sns_topic_arn]
  ok_actions         = [var.sns_topic_arn]

  dimensions = {
    WebACL = var.web_acl_name
    Region = var.primary_region
    Rule   = "ALL"  # Monitors all rules
  }

  tags = var.tags
}

# CloudWatch Alarm for high rate of blocked requests by rule in DR region
resource "aws_cloudwatch_metric_alarm" "waf_blocked_requests_by_rule_dr" {
  provider            = aws.dr
  alarm_name          = "${var.environment}-waf-blocked-requests-by-rule-${var.dr_region}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "BlockedRequests"
  namespace           = "AWS/WAFV2"
  period             = "300"  # 5 minutes
  statistic          = "Sum"
  threshold          = "20"   # Alert if more than 20 blocks in 5 minutes
  alarm_description  = "This alarm monitors WAF blocked requests by rule in DR region. Alert if more than 20 requests are blocked by a specific rule within 5 minutes."
  alarm_actions      = [var.sns_topic_arn]
  ok_actions         = [var.sns_topic_arn]

  dimensions = {
    WebACL = var.web_acl_name
    Region = var.dr_region
    Rule   = "ALL"  # Monitors all rules
  }

  tags = var.tags
}

# CloudWatch Alarm for high rate of blocked requests by IP in primary region
resource "aws_cloudwatch_metric_alarm" "waf_blocked_requests_by_ip_primary" {
  provider            = aws.primary
  alarm_name          = "${var.environment}-waf-blocked-requests-by-ip-${var.primary_region}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "BlockedRequests"
  namespace           = "AWS/WAFV2"
  period             = "60"  # 1 minute
  statistic          = "Sum"
  threshold          = "10"   # Alert if more than 10 blocks from an IP in 1 minute
  alarm_description  = "This alarm monitors WAF blocked requests by IP in primary region. Alert if more than 10 requests are blocked from a specific IP within 1 minute."
  alarm_actions      = [var.sns_topic_arn]
  ok_actions         = [var.sns_topic_arn]

  dimensions = {
    WebACL = var.web_acl_name
    Region = var.primary_region
  }

  tags = var.tags
}

# CloudWatch Alarm for high rate of blocked requests by IP in DR region
resource "aws_cloudwatch_metric_alarm" "waf_blocked_requests_by_ip_dr" {
  provider            = aws.dr
  alarm_name          = "${var.environment}-waf-blocked-requests-by-ip-${var.dr_region}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "BlockedRequests"
  namespace           = "AWS/WAFV2"
  period             = "60"  # 1 minute
  statistic          = "Sum"
  threshold          = "10"   # Alert if more than 10 blocks from an IP in 1 minute
  alarm_description  = "This alarm monitors WAF blocked requests by IP in DR region. Alert if more than 10 requests are blocked from a specific IP within 1 minute."
  alarm_actions      = [var.sns_topic_arn]
  ok_actions         = [var.sns_topic_arn]

  dimensions = {
    WebACL = var.web_acl_name
    Region = var.dr_region
  }

  tags = var.tags
}

# CloudWatch Dashboard for WAF metrics in primary region
resource "aws_cloudwatch_dashboard" "waf_dashboard_primary" {
  provider        = aws.primary
  dashboard_name  = "${var.environment}-waf-dashboard-${var.primary_region}"

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
            ["AWS/WAFV2", "BlockedRequests", "WebACL", var.web_acl_name, "Region", var.primary_region],
            ["AWS/WAFV2", "AllowedRequests", "WebACL", var.web_acl_name, "Region", var.primary_region]
          ]
          period = 300
          stat   = "Sum"
          region = var.primary_region
          title  = "WAF Requests (Primary Region)"
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/WAFV2", "BlockedRequests", "WebACL", var.web_acl_name, "Region", var.primary_region, "Rule", "ALL"]
          ]
          period = 300
          stat   = "Sum"
          region = var.primary_region
          title  = "Blocked Requests by Rule (Primary Region)"
        }
      }
    ]
  })
}

# CloudWatch Dashboard for WAF metrics in DR region
resource "aws_cloudwatch_dashboard" "waf_dashboard_dr" {
  provider        = aws.dr
  dashboard_name  = "${var.environment}-waf-dashboard-${var.dr_region}"

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
            ["AWS/WAFV2", "BlockedRequests", "WebACL", var.web_acl_name, "Region", var.dr_region],
            ["AWS/WAFV2", "AllowedRequests", "WebACL", var.web_acl_name, "Region", var.dr_region]
          ]
          period = 300
          stat   = "Sum"
          region = var.dr_region
          title  = "WAF Requests (DR Region)"
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/WAFV2", "BlockedRequests", "WebACL", var.web_acl_name, "Region", var.dr_region, "Rule", "ALL"]
          ]
          period = 300
          stat   = "Sum"
          region = var.dr_region
          title  = "Blocked Requests by Rule (DR Region)"
        }
      }
    ]
  })
}

# CloudFront WAF monitoring (global)
resource "aws_cloudwatch_metric_alarm" "cloudfront_waf_blocked_requests" {
  count               = var.cloudfront_enabled ? 1 : 0
  provider            = aws.primary
  alarm_name          = "${var.environment}-cloudfront-waf-blocked-requests"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "BlockedRequests"
  namespace           = "AWS/WAFV2"
  period             = "60"  # 1 minute
  statistic          = "Sum"
  threshold          = "5"   # Alert if more than 5 blocks in 1 minute
  alarm_description  = "This alarm monitors CloudFront WAF blocked requests. Alert if more than 5 requests are blocked within 1 minute."
  alarm_actions      = [var.sns_topic_arn]
  ok_actions         = [var.sns_topic_arn]

  dimensions = {
    WebACL = var.web_acl_name
    Region = "Global"
  }

  tags = var.tags
}

# CloudFront WAF Dashboard (global)
resource "aws_cloudwatch_dashboard" "cloudfront_waf_dashboard" {
  count       = var.cloudfront_enabled ? 1 : 0
  provider    = aws.primary
  dashboard_name = "${var.environment}-cloudfront-waf-dashboard"

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
            ["AWS/WAFV2", "BlockedRequests", "WebACL", var.web_acl_name, "Region", "Global"],
            ["AWS/WAFV2", "AllowedRequests", "WebACL", var.web_acl_name, "Region", "Global"]
          ]
          period = 300
          stat   = "Sum"
          region = var.primary_region
          title  = "CloudFront WAF Requests"
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/WAFV2", "BlockedRequests", "WebACL", var.web_acl_name, "Region", "Global", "Rule", "ALL"]
          ]
          period = 300
          stat   = "Sum"
          region = var.primary_region
          title  = "CloudFront WAF Blocked Requests by Rule"
        }
      }
    ]
  })
}

resource "aws_cloudwatch_dashboard" "waf" {
  provider = aws.primary
  dashboard_name = "WAF-Monitoring-${var.environment}"
  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/WAF", "BlockedRequests", "WebACL", "FMS-WAF-${var.environment}"]
          ]
          period = 300
          stat   = "Sum"
          title  = "Blocked Requests"
        }
      }
    ]
  })
}

resource "aws_cloudwatch_metric_alarm" "high_blocked_requests" {
  provider = aws.primary
  alarm_name          = "waf-high-blocked-requests-${var.environment}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "BlockedRequests"
  namespace           = "AWS/WAF"
  period             = "300"
  statistic          = "Sum"
  threshold          = var.blocked_requests_threshold
  alarm_description  = "This metric monitors blocked requests by WAF"
  alarm_actions      = [aws_sns_topic.waf_alerts.arn]

  dimensions = {
    WebACL = "FMS-WAF-${var.environment}"
  }
}

# SNS Topic for WAF alerts
resource "aws_sns_topic" "waf_alerts" {
  provider = aws.primary
  name     = "${var.environment}-waf-alerts"
  tags     = var.tags
}

output "sns_topic_arn" {
  value = aws_sns_topic.waf_alerts.arn
} 