# Create a WAF policy for FMS
module "waf_rule_groups" {
  source = "../../modules/waf-rule-groups"

  rule_groups = [
    {
      name        = "AWSManagedRulesCommonRuleSet"
      priority    = 1
      rule_group_id = "AWSManagedRulesCommonRuleSet"
    },
    {
      name        = "AWSManagedRulesKnownBadInputsRuleSet"
      priority    = 2
      rule_group_id = "AWSManagedRulesKnownBadInputsRuleSet"
    },
    {
      name        = "AWSManagedRulesAmazonIpReputationList"
      priority    = 3
      rule_group_id = "AWSManagedRulesAmazonIpReputationList"
    },
    {
      name        = "AWSManagedRulesAnonymousIpList"
      priority    = 4
      rule_group_id = "AWSManagedRulesAnonymousIpList"
    },
    {
      name        = "AWSManagedRulesLinuxRuleSet"
      priority    = 5
      rule_group_id = "AWSManagedRulesLinuxRuleSet"
    },
    {
      name        = "AWSManagedRulesUnixRuleSet"
      priority    = 6
      rule_group_id = "AWSManagedRulesUnixRuleSet"
    }
  ]

  default_action = "BLOCK"
  tags = var.tags
}

resource "aws_fms_policy" "waf_policy" {
  name                        = "FMS-WAF-Policy"
  description                 = "WAF policy managed by FMS"
  exclude_resource_tags       = var.exclude_resource_tags
  remediation_enabled         = true
  delete_unused_fm_resources = true

  security_service_policy_data {
    type = "WAF"
    managed_service_data = module.waf_rule_groups.managed_service_data
  }

  tags = merge(
    var.tags,
    {
      Name = "FMS-WAF-Policy"
    }
  )
}

# Create a policy association for the WAF policy
resource "aws_fms_policy_association" "waf_policy_association" {
  policy_id = aws_fms_policy.waf_policy.id
  target_id = var.organization_id
}

# Enable WAF logging
module "waf_logging" {
  source = "../../modules/waf-logging"

  environment = var.environment
  tags = var.tags
}

resource "aws_wafv2_web_acl_logging_configuration" "waf_logging" {
  log_destination_configs = [module.waf_logging.firehose_arn]
  resource_arn           = aws_fms_policy.waf_policy.arn
}

# Enable WAF monitoring
module "waf_monitoring" {
  source = "../../modules/waf-monitoring"

  environment = var.environment
  tags = var.tags
} 