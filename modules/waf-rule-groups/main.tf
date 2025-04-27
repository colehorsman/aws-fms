# WAF Rule Groups Module

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

locals {
  pre_process_rule_groups = [
    for rule in var.rule_groups : {
      ruleGroupId = {
        id = rule.rule_group_id
      }
      priority = rule.priority
    }
  ]
}

output "managed_service_data" {
  description = "Managed service data for FMS policy"
  value = jsonencode({
    type = "WAF"
    preProcessRuleGroups = local.pre_process_rule_groups
    postProcessRuleGroups = []
    defaultAction = {
      type = var.default_action
    }
  })
} 