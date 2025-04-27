output "fms_admin_account_id" {
  description = "The AWS Account ID of the FMS administrator account"
  value       = aws_fms_admin_account.fms_admin.account_id
}

output "fms_service_role_arn" {
  description = "The ARN of the FMS service role"
  value       = aws_iam_role.fms_service_role.arn
}

# WAF Policies outputs
output "waf_rule_group_id" {
  description = "The ID of the WAF rule group"
  value       = module.waf_policies.waf_rule_group_id
}

output "waf_rule_group_arn" {
  description = "The ARN of the WAF rule group"
  value       = module.waf_policies.waf_rule_group_arn
}

# WAF Monitoring outputs
output "waf_sns_topic_arn" {
  description = "The ARN of the SNS topic for WAF alerts"
  value       = module.waf_monitoring.sns_topic_arn
}

# Shield outputs
output "shield_protection_id" {
  description = "The ID of the Shield protection"
  value       = var.shield_advanced_enabled ? module.shield.protection_id : null
}

output "shield_protection_arn" {
  description = "The ARN of the Shield protection"
  value       = var.shield_advanced_enabled ? module.shield.protection_arn : null
}

# DNS Firewall outputs
output "dns_firewall_rule_group_id" {
  description = "The ID of the DNS firewall rule group"
  value       = module.dns_firewall.rule_group_id
}

output "dns_firewall_rule_group_arn" {
  description = "The ARN of the DNS firewall rule group"
  value       = module.dns_firewall.rule_group_arn
} 