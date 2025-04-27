terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      configuration_aliases = [aws.primary, aws.dr]
    }
  }
}

resource "aws_wafv2_rule_group" "common" {
  provider = aws.primary
  name     = "common-rules-${var.environment}"
  scope    = "REGIONAL"
  capacity = 100

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name               = "CommonRulesMetric"
    sampled_requests_enabled  = true
  }

  rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 1

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name               = "AWSManagedRulesCommonRuleSetMetric"
      sampled_requests_enabled  = true
    }
  }

  tags = var.tags
}

output "rule_group_arn" {
  value = aws_wafv2_rule_group.common.arn
}

output "rule_group_id" {
  value = aws_wafv2_rule_group.common.id
} 