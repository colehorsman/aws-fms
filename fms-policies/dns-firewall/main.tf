terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      configuration_aliases = [aws.primary, aws.dr]
    }
  }
}

# Create domain lists
resource "aws_route53_resolver_firewall_domain_list" "blocked" {
  provider = aws.primary
  name     = "blocked-domains-${var.environment}"
  domains  = local.blocked_domains
  tags     = var.tags
}

resource "aws_route53_resolver_firewall_domain_list" "allowed" {
  provider = aws.primary
  name     = "allowed-domains-${var.environment}"
  domains  = local.allowed_domains
  tags     = var.tags
}

resource "aws_route53_resolver_firewall_domain_list" "audit" {
  provider = aws.primary
  name     = "audit-domains-${var.environment}"
  domains  = local.audit_domains
  tags     = var.tags
}

# Create rule group
resource "aws_route53_resolver_firewall_rule_group" "main" {
  provider = aws.primary
  name     = "fms-dns-firewall-rules-${var.environment}"
  tags     = var.tags
}

# Create rules
resource "aws_route53_resolver_firewall_rule" "block" {
  provider               = aws.primary
  name                   = "block-malicious-domains"
  action                 = "BLOCK"
  firewall_rule_group_id = aws_route53_resolver_firewall_rule_group.main.id
  firewall_domain_list_id = aws_route53_resolver_firewall_domain_list.blocked.id
  priority              = 100
}

resource "aws_route53_resolver_firewall_rule" "allow" {
  provider               = aws.primary
  name                   = "allow-trusted-domains"
  action                 = "ALLOW"
  firewall_rule_group_id = aws_route53_resolver_firewall_rule_group.main.id
  firewall_domain_list_id = aws_route53_resolver_firewall_domain_list.allowed.id
  priority              = 200
}

resource "aws_route53_resolver_firewall_rule" "audit" {
  provider               = aws.primary
  name                   = "audit-suspicious-domains"
  action                 = "ALERT"
  firewall_rule_group_id = aws_route53_resolver_firewall_rule_group.main.id
  firewall_domain_list_id = aws_route53_resolver_firewall_domain_list.audit.id
  priority              = 300
}

# Load domain lists from JSON files
locals {
  blocked_domains = jsondecode(file("${path.module}/../configurations/dns-firewall/blocked-domains.json")).domains
  allowed_domains = jsondecode(file("${path.module}/../configurations/dns-firewall/allowed-domains.json")).domains
  audit_domains   = jsondecode(file("${path.module}/../configurations/dns-firewall/audit-domains.json")).domains
}

# Outputs
output "rule_group_id" {
  description = "The ID of the DNS firewall rule group"
  value       = aws_route53_resolver_firewall_rule_group.main.id
}

output "rule_group_arn" {
  description = "The ARN of the DNS firewall rule group"
  value       = aws_route53_resolver_firewall_rule_group.main.arn
} 