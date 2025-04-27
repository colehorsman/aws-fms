terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      configuration_aliases = [aws.primary, aws.dr]
    }
  }
}

# Create a WAF policy for FMS
module "waf_rule_groups" {
  source = "../../modules/waf_rule_groups"

  providers = {
    aws.primary = aws.primary
    aws.dr      = aws.dr
  }

  environment = var.environment
  region     = data.aws_region.current.name
  tags       = var.tags
}

data "aws_region" "current" {}

resource "aws_fms_policy" "waf_policy" {
  provider = aws.primary
  name                        = "FMS-WAF-Policy"
  description                 = "WAF policy managed by FMS"
  exclude_resource_tags       = false
  remediation_enabled         = true

  security_service_policy_data {
    type = "WAFV2"
    managed_service_data = jsonencode({
      type = "WAFV2"
      defaultAction = {
        type = "ALLOW"
      }
      overrideCustomerWebACLAssociation = false
      ruleGroups = [
        {
          id = module.waf_rule_groups.rule_group_id
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
resource "aws_fms_admin_account" "waf_policy_association" {
  provider = aws.primary
  account_id = var.fms_admin_account_id
}

# Enable WAF logging
module "waf_logging" {
  source = "../../modules/waf_logging"

  providers = {
    aws.primary = aws.primary
    aws.dr      = aws.dr
  }

  environment = var.environment
  tags = var.tags
}

resource "aws_wafv2_web_acl_logging_configuration" "waf_logging" {
  provider = aws.primary
  log_destination_configs = [module.waf_logging.waf_logs_firehose_arn]
  resource_arn           = aws_fms_policy.waf_policy.arn
}

# Enable WAF monitoring
module "waf_monitoring" {
  source = "../../modules/waf_monitoring"

  providers = {
    aws.primary = aws.primary
    aws.dr      = aws.dr
  }

  environment = var.environment
  tags = var.tags
}

output "waf_rule_group_id" {
  value = module.waf_rule_groups.rule_group_id
}

output "waf_rule_group_arn" {
  value = module.waf_rule_groups.rule_group_arn
} 