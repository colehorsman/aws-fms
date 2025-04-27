# Delegated Firewall Manager Accounts
# This file defines the delegated accounts for Firewall Manager

locals {
  # Delegated Firewall Manager accounts
  delegated_fms_accounts = {
    security_lab = "101010101010"  # Security Lab Environment for testing rules
    security_prod = "202020202020" # Security Production Environment
  }
}

# Output the delegated account IDs for reference
output "delegated_fms_account_ids" {
  description = "Delegated Firewall Manager account IDs"
  value = local.delegated_fms_accounts
}

# Output the delegated account ARNs for reference
output "delegated_fms_account_arns" {
  description = "Delegated Firewall Manager account ARNs"
  value = {
    security_lab = "arn:aws:organizations::${data.aws_caller_identity.current.account_id}:account/${local.delegated_fms_accounts.security_lab}"
    security_prod = "arn:aws:organizations::${data.aws_caller_identity.current.account_id}:account/${local.delegated_fms_accounts.security_prod}"
  }
}

# Get current AWS account ID
data "aws_caller_identity" "current" {} 