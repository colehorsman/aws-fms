resource "aws_cloudwatch_metric_alarm" "waf_blocked_requests" {
  alarm_name          = "${var.name_prefix}-waf-blocked-requests"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "BlockedRequests"
  namespace           = "AWS/WAFV2"
  period              = "300"
  statistic           = "Sum"
  threshold           = var.blocked_requests_threshold
  alarm_description   = "This metric monitors blocked requests by WAF"
  alarm_actions       = [aws_sns_topic.waf_alerts.arn]

  dimensions = {
    WebACL = aws_wafv2_web_acl.main.name
    Region = data.aws_region.current.name
  }

  tags = var.tags
}

resource "aws_cloudwatch_metric_alarm" "ddos_attack_detected" {
  alarm_name          = "${var.name_prefix}-ddos-attack"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "DDoSDetected"
  namespace           = "AWS/Shield"
  period              = "300"
  statistic           = "Maximum"
  threshold           = "1"
  alarm_description   = "This metric monitors DDoS attacks detected by Shield"
  alarm_actions       = [aws_sns_topic.waf_alerts.arn]

  dimensions = {
    Protection = aws_shield_protection.waf.id
  }

  tags = var.tags
}

resource "aws_cloudwatch_dashboard" "waf" {
  dashboard_name = "${var.name_prefix}-waf-dashboard"

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
            ["AWS/WAFV2", "AllowedRequests", "WebACL", aws_wafv2_web_acl.main.name],
            [".", "BlockedRequests", ".", "."],
            [".", "CountedRequests", ".", "."]
          ]
          view    = "timeSeries"
          stacked = false
          region  = data.aws_region.current.name
          title   = "WAF Requests"
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
            ["AWS/Shield", "DDoSDetected", "Protection", aws_shield_protection.waf.id],
            [".", "DDoSAttackBitsPerSecond", ".", "."],
            [".", "DDoSAttackPacketsPerSecond", ".", "."]
          ]
          view    = "timeSeries"
          stacked = false
          region  = data.aws_region.current.name
          title   = "Shield DDoS Metrics"
        }
      }
    ]
  })
}

resource "aws_sns_topic" "waf_alerts" {
  name = "${var.name_prefix}-waf-alerts"
  
  tags = var.tags
}

resource "aws_sns_topic_policy" "waf_alerts" {
  arn = aws_sns_topic.waf_alerts.arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "cloudwatch.amazonaws.com"
        }
        Action   = "SNS:Publish"
        Resource = aws_sns_topic.waf_alerts.arn
      }
    ]
  })
} 