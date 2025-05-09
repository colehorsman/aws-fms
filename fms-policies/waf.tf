# Create a WAF policy for FMS
module "waf_rule_groups" {
  source = "../modules/waf_rule_groups"

  providers = {
    aws.primary = aws.primary
    aws.dr      = aws.dr
  }

  environment = var.environment
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
    managed_service_data = jsonencode({
      type = "WAF"
      defaultAction = {
        type = "BLOCK"
      }
      overrideCustomerWebACLAssociation = false
      preProcessRuleGroups = []
      postProcessRuleGroups = [
        {
          ruleGroupArn = module.waf_rule_groups.rule_group_arn
          overrideAction = {
            type = "NONE"
          }
        }
      ]
    })
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
  source = "../modules/waf_logging"

  providers = {
    aws.primary = aws.primary
    aws.dr      = aws.dr
  }

  environment = var.environment
  tags = var.tags
}

resource "aws_wafv2_web_acl_logging_configuration" "waf_logging" {
  log_destination_configs = [module.waf_logging.waf_logs_firehose_arn]
  resource_arn           = aws_fms_policy.waf_policy.arn
}

# Enable WAF monitoring
module "waf_monitoring" {
  source = "../modules/waf_monitoring"

  providers = {
    aws.primary = aws.primary
    aws.dr      = aws.dr
  }

  environment = var.environment
  tags = var.tags
} 