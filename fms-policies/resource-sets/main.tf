terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      configuration_aliases = [aws.primary, aws.dr]
    }
  }
}

resource "aws_fms_policy" "resource_set_policy" {
  name                  = "resource-set-policy-${var.environment}"
  exclude_resource_tags = false
  remediation_enabled   = true
  resource_type        = "AWS::ElasticLoadBalancingV2::LoadBalancer"

  security_service_policy_data {
    type = "WAFV2"

    managed_service_data = jsonencode({
      type = "WAFV2"
      ruleGroups = [
        {
          id = var.waf_rule_group_id
          overrideAction = {
            type = "COUNT"
          }
        }
      ]
      defaultAction = {
        type = "ALLOW"
      }
      overrideCustomerWebACLAssociation = false
    })
  }

  resource_tags = {
    Environment = var.environment
  }

  tags = var.tags
}

resource "aws_wafv2_web_acl_association" "production" {
  for_each = toset([
    var.cloudfront_distribution_arn,
    var.alb_arn,
    var.api_gateway_stage_arn
  ])

  resource_arn = each.value
  web_acl_arn  = aws_fms_policy.resource_set_policy.id
}

resource "aws_wafv2_web_acl_association" "development" {
  for_each = toset([
    var.dev_cloudfront_distribution_arn,
    var.dev_alb_arn,
    var.dev_api_gateway_stage_arn
  ])

  resource_arn = each.value
  web_acl_arn  = aws_fms_policy.resource_set_policy.id
}

resource "aws_wafv2_web_acl_association" "restricted" {
  for_each = toset([
    var.restricted_cloudfront_distribution_arn,
    var.restricted_alb_arn,
    var.restricted_api_gateway_stage_arn
  ])

  resource_arn = each.value
  web_acl_arn  = aws_fms_policy.resource_set_policy.id
} 