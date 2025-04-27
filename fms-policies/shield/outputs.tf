output "shield_protection_id" {
  description = "The ID of the Shield Advanced protection"
  value       = try(aws_shield_protection.this[0].id, null)
}

output "shield_protection_arn" {
  description = "The ARN of the Shield Advanced protection"
  value       = try(aws_shield_protection.this[0].arn, null)
}

output "shield_protection_group_id" {
  description = "The ID of the Shield protection group"
  value       = try(aws_shield_protection_group.this[0].protection_group_id, null)
}

output "shield_drt_role_arn" {
  description = "The ARN of the IAM role for Shield DRT access"
  value       = try(aws_iam_role.shield_drt[0].arn, null)
}

output "shield_alarm_arn" {
  description = "The ARN of the CloudWatch alarm for DDoS attacks"
  value       = try(aws_cloudwatch_metric_alarm.shield_ddos[0].arn, null)
}

output "shield_dashboard_arn" {
  description = "The ARN of the CloudWatch dashboard for Shield metrics"
  value       = try(aws_cloudwatch_dashboard.shield_dashboard[0].dashboard_arn, null)
}

output "shield_subscription_arn" {
  description = "The ARN of the Shield Advanced subscription"
  value       = try(aws_shield_subscription.advanced[0].arn, null)
} 