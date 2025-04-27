terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      configuration_aliases = [aws.primary, aws.dr]
    }
  }
}

resource "aws_wafv2_rule_group" "common" {
  name        = "common-rule-group-${var.environment}"
  description = "Common WAF rules for all environments"
  scope       = "REGIONAL"
  capacity    = 100

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name               = "CommonRuleGroupMetrics"
    sampled_requests_enabled  = true
  }

  rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 1

    action {
      count {}
    }

    statement {
      byte_match_statement {
        positional_constraint = "CONTAINS"
        search_string        = "badbot"

        field_to_match {
          single_header {
            name = "user-agent"
          }
        }

        text_transformation {
          priority = 1
          type     = "NONE"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name               = "AWSManagedRulesCommonRuleSetMetrics"
      sampled_requests_enabled  = true
    }
  }

  tags = var.tags
}

resource "aws_wafv2_rule_group" "ip_rate_based" {
  name        = "ip-rate-based-${var.environment}"
  description = "IP rate-based rules"
  scope       = "REGIONAL"
  capacity    = 50

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name               = "IPRateBasedRuleGroupMetrics"
    sampled_requests_enabled  = true
  }

  rule {
    name     = "IPRateLimit"
    priority = 1

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit              = 2000
        aggregate_key_type = "IP"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name               = "IPRateLimitMetrics"
      sampled_requests_enabled  = true
    }
  }

  tags = var.tags
}

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

output "rule_group_arn" {
  value = aws_wafv2_rule_group.common.arn
}

output "rule_group_id" {
  value = aws_wafv2_rule_group.common.id
} 