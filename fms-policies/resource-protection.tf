# ALB Protection Policy
resource "aws_fms_policy" "alb_protection" {
  name                        = "FMS-ALB-Protection-Policy"
  description                 = "WAF protection policy for Application Load Balancers"
  exclude_resource_tags       = var.exclude_resource_tags
  remediation_enabled         = true
  delete_unused_fm_resources = true

  security_service_policy_data {
    type = "WAF"

    managed_service_data = jsonencode({
      type = "WAF"
      preProcessRuleGroups = [
        {
          ruleGroupId = {
            id = "AWSManagedRulesCommonRuleSet"
          }
          priority = 1
        },
        {
          ruleGroupId = {
            id = "AWSManagedRulesKnownBadInputsRuleSet"
          }
          priority = 2
        }
      ]
      postProcessRuleGroups = []
      defaultAction = {
        type = "BLOCK"
      }
    })
  }

  resource_type = "AWS::ElasticLoadBalancingV2::LoadBalancer"

  tags = merge(
    var.tags,
    {
      Name = "FMS-ALB-Protection-Policy"
    }
  )
}

# CloudFront Protection Policy
resource "aws_fms_policy" "cloudfront_protection" {
  name                        = "FMS-CloudFront-Protection-Policy"
  description                 = "WAF protection policy for CloudFront distributions"
  exclude_resource_tags       = var.exclude_resource_tags
  remediation_enabled         = true
  delete_unused_fm_resources = true

  security_service_policy_data {
    type = "WAF"

    managed_service_data = jsonencode({
      type = "WAF"
      preProcessRuleGroups = [
        {
          ruleGroupId = {
            id = "AWSManagedRulesCommonRuleSet"
          }
          priority = 1
        },
        {
          ruleGroupId = {
            id = "AWSManagedRulesKnownBadInputsRuleSet"
          }
          priority = 2
        }
      ]
      postProcessRuleGroups = []
      defaultAction = {
        type = "BLOCK"
      }
    })
  }

  resource_type = "AWS::CloudFront::Distribution"

  tags = merge(
    var.tags,
    {
      Name = "FMS-CloudFront-Protection-Policy"
    }
  )
}

# API Gateway Protection Policy
resource "aws_fms_policy" "apigateway_protection" {
  name                        = "FMS-APIGateway-Protection-Policy"
  description                 = "WAF protection policy for API Gateway stages"
  exclude_resource_tags       = var.exclude_resource_tags
  remediation_enabled         = true
  delete_unused_fm_resources = true

  security_service_policy_data {
    type = "WAF"

    managed_service_data = jsonencode({
      type = "WAF"
      preProcessRuleGroups = [
        {
          ruleGroupId = {
            id = "AWSManagedRulesCommonRuleSet"
          }
          priority = 1
        },
        {
          ruleGroupId = {
            id = "AWSManagedRulesKnownBadInputsRuleSet"
          }
          priority = 2
        }
      ]
      postProcessRuleGroups = []
      defaultAction = {
        type = "BLOCK"
      }
    })
  }

  resource_type = "AWS::ApiGateway::Stage"

  tags = merge(
    var.tags,
    {
      Name = "FMS-APIGateway-Protection-Policy"
    }
  )
}

# Policy Associations
resource "aws_fms_policy_association" "alb_policy_association" {
  policy_id = aws_fms_policy.alb_protection.id
  target_id = var.organization_id
}

resource "aws_fms_policy_association" "cloudfront_policy_association" {
  policy_id = aws_fms_policy.cloudfront_protection.id
  target_id = var.organization_id
}

resource "aws_fms_policy_association" "apigateway_policy_association" {
  policy_id = aws_fms_policy.apigateway_protection.id
  target_id = var.organization_id
}

# WAF Logging Configuration for FMS Policies
resource "aws_wafv2_web_acl_logging_configuration" "fms_logging" {
  log_destination_configs = [var.waf_log_destination_arn]
  resource_arn           = aws_fms_policy.alb_protection.arn
}

resource "aws_wafv2_web_acl_logging_configuration" "cloudfront_logging" {
  log_destination_configs = [var.waf_log_destination_arn]
  resource_arn           = aws_fms_policy.cloudfront_protection.arn
}

resource "aws_wafv2_web_acl_logging_configuration" "apigateway_logging" {
  log_destination_configs = [var.waf_log_destination_arn]
  resource_arn           = aws_fms_policy.apigateway_protection.arn
} 