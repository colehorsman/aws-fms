# Resource Sets for FMS Policies
resource "aws_fms_resource_set" "production_resources" {
  name = "production-resources"
  description = "Production resources for FMS policies"
  resource_type_list = ["AWS::CloudFront::Distribution", "AWS::ElasticLoadBalancingV2::LoadBalancer", "AWS::ApiGateway::Stage"]
  
  resources = [
    var.cloudfront_distribution_arn,
    var.alb_arn,
    var.api_gateway_stage_arn
  ]

  tags = local.common_tags
}

resource "aws_fms_resource_set" "development_resources" {
  name = "development-resources"
  description = "Development resources for FMS policies"
  resource_type_list = ["AWS::CloudFront::Distribution", "AWS::ElasticLoadBalancingV2::LoadBalancer", "AWS::ApiGateway::Stage"]
  
  resources = [
    var.dev_cloudfront_distribution_arn,
    var.dev_alb_arn,
    var.dev_api_gateway_stage_arn
  ]

  tags = local.common_tags
}

resource "aws_fms_resource_set" "restricted_resources" {
  name = "restricted-resources"
  description = "Resources with restricted data classification"
  resource_type_list = ["AWS::CloudFront::Distribution", "AWS::ElasticLoadBalancingV2::LoadBalancer", "AWS::ApiGateway::Stage"]
  
  resources = [
    var.restricted_cloudfront_distribution_arn,
    var.restricted_alb_arn,
    var.restricted_api_gateway_stage_arn
  ]

  tags = local.common_tags
}

# FMS Policy with Resource Set
resource "aws_fms_policy" "resource_set_policy" {
  name                  = "fms-resource-set-policy"
  description           = "FMS policy using resource sets"
  exclude_resource_tags = var.exclude_resource_tags
  remediation_enabled   = true
  resource_type         = "AWS::CloudFront::Distribution"
  security_service_policy_data = jsonencode({
    Type = "WAF"
    ManagedServiceData = jsonencode({
      type = "WAF"
      preProcessRuleGroups = [
        {
          ruleGroupId = var.waf_rule_group_id
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

# Policy Association with Resource Set
resource "aws_fms_policy_association" "production_policy_association" {
  policy_id = aws_fms_policy.resource_set_policy.id
  resource_set_id = aws_fms_resource_set.production_resources.id
}

resource "aws_fms_policy_association" "development_policy_association" {
  policy_id = aws_fms_policy.resource_set_policy.id
  resource_set_id = aws_fms_resource_set.development_resources.id
}

resource "aws_fms_policy_association" "restricted_policy_association" {
  policy_id = aws_fms_policy.resource_set_policy.id
  resource_set_id = aws_fms_resource_set.restricted_resources.id
} 