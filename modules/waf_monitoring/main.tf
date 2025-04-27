terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      configuration_aliases = [aws.primary, aws.dr]
    }
  }
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

resource "aws_sns_topic" "waf_alerts" {
  provider = aws.primary
  name = "waf-alerts-${var.environment}"
  tags = var.tags
}

output "sns_topic_arn" {
  value = aws_sns_topic.waf_alerts.arn
} 