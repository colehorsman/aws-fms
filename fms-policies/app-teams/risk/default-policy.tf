# Risk Team Default Policy
# WARNING: This file is managed by the security team only.
# App teams should not modify this file.
# For custom rules, create a new policy file in your team's directory.

module "risk_default_policy" {
  source = "../../../modules/default-policy"

  environment = var.environment
  team_name   = "risk"

  # AWS Account scoping
  scope_accounts = [
    "333333333333",  # Risk Development
    "444444444444",  # Risk QA
    "555555555555"   # Risk Production
  ]

  # Exclude resources with specific tags
  exclude_tags = {
    "repo" = ["edh", "beacon", "life"]
  }

  # Default rule groups for all Risk team resources
  rule_groups = [
    {
      name        = "InternalIPSet"
      priority    = 1
      rule_group_id = "InternalIPSet"
      override_action = "BLOCK"
    },
    {
      name        = "AWSManagedRulesCommonRuleSet"
      priority    = 2
      rule_group_id = "AWSManagedRulesCommonRuleSet"
    },
    {
      name        = "AWSManagedRulesKnownBadInputsRuleSet"
      priority    = 3
      rule_group_id = "AWSManagedRulesKnownBadInputsRuleSet"
    },
    {
      name        = "AWSManagedRulesAmazonIpReputationList"
      priority    = 4
      rule_group_id = "AWSManagedRulesAmazonIpReputationList"
    }
  ]

  default_action = "BLOCK"
  tags = var.tags
}

# Enable WAF logging for the default policy
resource "aws_wafv2_web_acl_logging_configuration" "risk_default_policy_logging" {
  log_destination_configs = [var.waf_log_destination_arn]
  resource_arn           = module.risk_default_policy.policy_arn
  sampling_rate          = 100  # Log all requests
} 