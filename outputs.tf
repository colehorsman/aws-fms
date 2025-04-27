output "fms_admin_account_id" {
  description = "The AWS Account ID of the FMS administrator account"
  value       = aws_fms_admin_account.fms_admin.account_id
}

output "waf_policy_id" {
  description = "The ID of the WAF policy"
  value       = aws_fms_policy.waf_policy.id
}

output "waf_policy_arn" {
  description = "The ARN of the WAF policy"
  value       = aws_fms_policy.waf_policy.arn
}

output "fms_service_role_arn" {
  description = "The ARN of the FMS service role"
  value       = aws_iam_role.fms_service_role.arn
}

output "alb_protection_policy_id" {
  description = "The ID of the ALB protection policy"
  value       = aws_fms_policy.alb_protection.id
}

output "cloudfront_protection_policy_id" {
  description = "The ID of the CloudFront protection policy"
  value       = aws_fms_policy.cloudfront_protection.id
}

output "apigateway_protection_policy_id" {
  description = "The ID of the API Gateway protection policy"
  value       = aws_fms_policy.apigateway_protection.id
}

# Centrally managed IP sets
output "internal_ip_set_id" {
  description = "The ID of the internal IP set"
  value       = aws_wafv2_ip_set.internal.id
}

# Team-specific IP sets
output "mendix_ip_set_id" {
  description = "The ID of the Mendix IP set"
  value       = aws_wafv2_ip_set.mendix.id
}

output "beacon_ip_set_id" {
  description = "The ID of the Beacon IP set"
  value       = aws_wafv2_ip_set.beacon.id
}

# WAF Logging Configuration
output "waf_logs_bucket_name" {
  description = "The name of the S3 bucket for WAF logs"
  value       = aws_s3_bucket.waf_logs.id
}

output "waf_logs_firehose_arn" {
  description = "The ARN of the Kinesis Firehose delivery stream for WAF logs"
  value       = aws_kinesis_firehose_delivery_stream.waf_logs.arn
}

output "dns_firewall_rule_group_id" {
  description = "The ID of the DNS firewall rule group"
  value       = module.dns_firewall.rule_group_id
}

output "dns_firewall_rule_group_arn" {
  description = "The ARN of the DNS firewall rule group"
  value       = module.dns_firewall.rule_group_arn
} 