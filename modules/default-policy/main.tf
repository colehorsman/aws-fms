# Default Policy Module

variable "environment" {
  description = "Environment name (e.g., prod, staging, dev)"
  type        = string
}

variable "team_name" {
  description = "Name of the team (e.g., risk, edh, beacon)"
  type        = string
}

variable "exclude_tags" {
  description = "Map of tags to exclude from the policy"
  type = map(list(string))
  default = {}
}

variable "rule_groups" {
  description = "List of WAF rule groups to apply"
  type = list(object({
    name        = string
    priority    = number
    rule_group_id = string
  }))
  default = []
}

variable "default_action" {
  description = "Default action for the WAF policy"
  type = string
  default = "BLOCK"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type = map(string)
  default = {}
}

# Create a WAF policy for FMS
module "waf_rule_groups" {
  source = "../waf-rule-groups"

  rule_groups = var.rule_groups
  default_action = var.default_action
  tags = var.tags
}

# Create the default policy
resource "aws_fms_policy" "default_policy" {
  name                        = "FMS-${var.team_name}-${var.environment}-Default-Policy"
  description                 = "Default WAF policy for ${var.team_name} team in ${var.environment} environment"
  exclude_resource_tags       = [for tag_key, tag_values in var.exclude_tags : "${tag_key}=${join(",", tag_values)}"]
  remediation_enabled         = true
  delete_unused_fm_resources = true

  security_service_policy_data {
    type = "WAF"
    managed_service_data = module.waf_rule_groups.managed_service_data
  }

  tags = merge(
    var.tags,
    {
      Name = "FMS-${var.team_name}-${var.environment}-Default-Policy"
    }
  )
}

# Create a policy association for the default policy
resource "aws_fms_policy_association" "default_policy_association" {
  policy_id = aws_fms_policy.default_policy.id
  target_id = var.organization_id
}

# Enable WAF logging for the default policy
module "waf_logging" {
  source = "../waf-logging"

  environment = var.environment
  tags = var.tags
}

resource "aws_wafv2_web_acl_logging_configuration" "default_policy_logging" {
  log_destination_configs = [module.waf_logging.firehose_arn]
  resource_arn           = aws_fms_policy.default_policy.arn
}

# Enable WAF monitoring for the default policy
module "waf_monitoring" {
  source = "../waf-monitoring"

  environment = var.environment
  tags = var.tags
}

output "policy_id" {
  description = "ID of the default policy"
  value       = aws_fms_policy.default_policy.id
}

output "policy_arn" {
  description = "ARN of the default policy"
  value       = aws_fms_policy.default_policy.arn
} 