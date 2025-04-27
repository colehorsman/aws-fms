# Shield Advanced Policy
resource "aws_fms_policy" "shield_advanced_policy" {
  name                  = "fms-shield-advanced-policy"
  description           = "FMS policy for Shield Advanced protection"
  exclude_resource_tags = var.exclude_resource_tags
  remediation_enabled   = true
  resource_type         = "AWS::CloudFront::Distribution"
  security_service_policy_data = jsonencode({
    Type = "SHIELD_ADVANCED"
    ManagedServiceData = jsonencode({
      type = "SHIELD_ADVANCED"
      automaticResponseConfiguration = {
        action = "BLOCK"
      }
      overrideCustomerShieldAdvancedConfiguration = {
        automaticResponseConfiguration = {
          action = "BLOCK"
        }
        proactiveEngagementStatus = "ENABLED"
      }
    })
  })

  tags = local.common_tags
}

# Shield Advanced Protection for CloudFront
resource "aws_shield_protection" "cloudfront_protection" {
  name         = "cloudfront-shield-protection"
  resource_arn = var.cloudfront_distribution_arn

  tags = local.common_tags
}

# Shield Advanced Protection for ALB
resource "aws_shield_protection" "alb_protection" {
  count        = var.enable_alb_protection ? 1 : 0
  name         = "alb-shield-protection"
  resource_arn = var.alb_arn

  tags = local.common_tags
}

# Shield Advanced Protection for API Gateway
resource "aws_shield_protection" "api_gateway_protection" {
  count        = var.enable_api_gateway_protection ? 1 : 0
  name         = "api-gateway-shield-protection"
  resource_arn = var.api_gateway_stage_arn

  tags = local.common_tags
}

# Shield Advanced Subscription
resource "aws_shield_protection_group" "shield_protection_group" {
  protection_group_id = "shield-protection-group"
  aggregation         = "MAX"
  pattern            = "ALL"

  members = [
    var.cloudfront_distribution_arn,
    var.alb_arn,
    var.api_gateway_stage_arn
  ]

  tags = local.common_tags
} 