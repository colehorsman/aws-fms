# ALB WAF Policy
resource "aws_fms_policy" "alb_waf_policy" {
  name                  = "fms-alb-waf-policy"
  description           = "FMS policy for ALB WAF rules"
  exclude_resource_tags = var.exclude_resource_tags
  remediation_enabled   = true
  resource_type         = "AWS::ElasticLoadBalancingV2::LoadBalancer"
  security_service_policy_data = jsonencode({
    Type = "WAF"
    ManagedServiceData = jsonencode({
      type = "WAF"
      preProcessRuleGroups = [
        {
          ruleGroupId = aws_wafv2_rule_group.alb_rule_group.id
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

# WAF Rule Group for ALB
resource "aws_wafv2_rule_group" "alb_rule_group" {
  name        = "alb-waf-rule-group"
  description = "WAF rule group for ALB protection"
  scope       = "REGIONAL"
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
    metric_name               = "alb-waf-rule-group-metric"
    sampled_requests_enabled  = true
  }

  tags = local.common_tags
} 