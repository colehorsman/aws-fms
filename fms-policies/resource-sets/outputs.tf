output "fms_policy_id" {
  description = "ID of the FMS policy"
  value       = aws_fms_policy.resource_set_policy.id
}

output "fms_policy_arn" {
  description = "ARN of the FMS policy"
  value       = aws_fms_policy.resource_set_policy.arn
} 