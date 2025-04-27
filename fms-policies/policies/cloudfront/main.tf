# CloudFront WAF Policy
resource "aws_fms_policy" "cloudfront_waf_policy" {
  name                  = "fms-cloudfront-waf-policy"
  description           = "FMS policy for CloudFront WAF rules"
  exclude_resource_tags = var.exclude_resource_tags
  remediation_enabled   = true
  resource_type         = "AWS::CloudFront::Distribution"
  security_service_policy_data = jsonencode({
    Type = "WAF"
    ManagedServiceData = jsonencode({
      type = "WAF"
      preProcessRuleGroups = [
        {
          ruleGroupId = aws_wafv2_rule_group.cloudfront_rule_group.id
          priority    = 1
          overrideAction = {
            type = "NONE"
          }
        }
      ]
      postProcessRuleGroups = []
      defaultAction = {
        type = "BLOCK"
      }
    })
  })

  tags = local.common_tags
}

# WAF Rule Group for CloudFront
resource "aws_wafv2_rule_group" "cloudfront_rule_group" {
  name        = "cloudfront-waf-rule-group"
  description = "WAF rule group for CloudFront protection"
  scope       = "CLOUDFRONT"
  capacity    = 100

  rule {
    name     = "BlockMaliciousRequests"
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
      metric_name               = "BlockMaliciousRequestsMetric"
      sampled_requests_enabled  = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name               = "cloudfront-waf-rule-group-metric"
    sampled_requests_enabled  = true
  }

  tags = local.common_tags
} 