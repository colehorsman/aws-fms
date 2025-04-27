# Test file for security group policy
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Test provider configuration
provider "aws" {
  region = "us-east-1"
}

# Test that the security group policy exists
data "aws_fms_policy" "security_group_policy" {
  id = aws_fms_policy.security_group_policy.id
}

# Test that the security group exists
data "aws_security_group" "security_scanners" {
  id = aws_security_group.security_scanners.id
}

# Test that the security group has the correct rules
data "aws_security_group_rules" "scanner_rules" {
  security_group_id = aws_security_group.security_scanners.id
}

# Test assertions
locals {
  # Test that the policy has the correct name
  policy_name_test = data.aws_fms_policy.security_group_policy.name == "fms-security-group-policy"

  # Test that the security group has the correct description
  security_group_description_test = data.aws_security_group.security_scanners.description == "Security group for managed security scanners"

  # Test that the security group has the correct inbound rule
  inbound_rule_test = length([
    for rule in data.aws_security_group_rules.scanner_rules.ingress :
    rule if rule.from_port == 0 && rule.to_port == 65535 && rule.protocol == "-1"
  ]) > 0

  # Test that the security group has the correct outbound rule
  outbound_rule_test = length([
    for rule in data.aws_security_group_rules.scanner_rules.egress :
    rule if rule.from_port == 0 && rule.to_port == 65535 && rule.protocol == "-1"
  ]) > 0
}

# Output test results
output "test_results" {
  value = {
    policy_name_test                = local.policy_name_test
    security_group_description_test = local.security_group_description_test
    inbound_rule_test              = local.inbound_rule_test
    outbound_rule_test             = local.outbound_rule_test
  }
} 