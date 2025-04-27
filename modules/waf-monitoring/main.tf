# WAF Monitoring Module

variable "environment" {
  description = "Environment name (e.g., prod, staging, dev)"
  type        = string
}

variable "alarm_threshold" {
  description = "Threshold for WAF rule match alarms"
  type        = number
  default     = 100
}

variable "evaluation_periods" {
  description = "Number of periods to evaluate for alarms"
  type        = number
  default     = 5
}

variable "period" {
  description = "Period in seconds for alarm evaluation"
  type        = number
  default     = 300
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

# Create CloudWatch dashboard for WAF metrics
resource "aws_cloudwatch_dashboard" "waf_dashboard" {
  dashboard_name = "waf-metrics-${var.environment}"

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
            ["AWS/WAFV2", "BlockedRequests", "WebACL", "FMS-WAF-Policy"],
            ["AWS/WAFV2", "AllowedRequests", "WebACL", "FMS-WAF-Policy"]
          ]
          period = 300
          stat   = "Sum"
          region = "us-east-1"
          title  = "WAF Requests"
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
            ["AWS/WAFV2", "RuleGroupBlockedRequests", "WebACL", "FMS-WAF-Policy", "RuleGroup", "AWSManagedRulesCommonRuleSet"],
            ["AWS/WAFV2", "RuleGroupBlockedRequests", "WebACL", "FMS-WAF-Policy", "RuleGroup", "AWSManagedRulesKnownBadInputsRuleSet"]
          ]
          period = 300
          stat   = "Sum"
          region = "us-east-1"
          title  = "Rule Group Blocks"
        }
      }
    ]
  })
}

# Create CloudWatch alarms for WAF metrics
resource "aws_cloudwatch_metric_alarm" "waf_blocked_requests" {
  alarm_name          = "waf-blocked-requests-${var.environment}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.evaluation_periods
  metric_name         = "BlockedRequests"
  namespace           = "AWS/WAFV2"
  period             = var.period
  statistic          = "Sum"
  threshold          = var.alarm_threshold
  alarm_description  = "This alarm monitors WAF blocked requests"
  alarm_actions      = []  # Add SNS topic ARNs here
  ok_actions         = []  # Add SNS topic ARNs here

  dimensions = {
    WebACL = "FMS-WAF-Policy"
  }

  tags = merge(
    var.tags,
    {
      Name = "waf-blocked-requests-alarm-${var.environment}"
    }
  )
}

# Create Athena table for WAF logs
resource "aws_glue_catalog_table" "waf_logs" {
  name          = "waf_logs_${var.environment}"
  database_name = "waf_logs"

  table_type = "EXTERNAL_TABLE"

  storage_descriptor {
    location      = "s3://waf-logs-${var.environment}-${data.aws_caller_identity.current.account_id}/"
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

    ser_de_info {
      serialization_library = "org.openx.data.jsonserde.JsonSerDe"
      parameters = {
        "serialization.format" = "1"
      }
    }
  }
}

# Get the current AWS account ID
data "aws_caller_identity" "current" {}

output "dashboard_name" {
  description = "Name of the CloudWatch dashboard"
  value       = aws_cloudwatch_dashboard.waf_dashboard.dashboard_name
}

output "alarm_arn" {
  description = "ARN of the CloudWatch alarm"
  value       = aws_cloudwatch_metric_alarm.waf_blocked_requests.arn
} 