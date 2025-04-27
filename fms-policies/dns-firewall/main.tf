terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      configuration_aliases = [aws.primary, aws.dr]
    }
  }
}

locals {
  blocked_domains = jsondecode(file("${path.module}/../configurations/dns-firewall/blocked-domains.json")).domains
  allowed_domains = jsondecode(file("${path.module}/../configurations/dns-firewall/allowed-domains.json")).domains
  audit_domains = jsondecode(file("${path.module}/../configurations/dns-firewall/audit-domains.json")).domains
}

resource "aws_route53_resolver_firewall_rule_group" "main" {
  provider = aws.primary
  name = "fms-dns-firewall-rules"
  tags = var.tags
}

resource "aws_route53_resolver_firewall_rule" "block" {
  provider = aws.primary
  name                    = "block-malicious-domains"
  action                  = "BLOCK"
  firewall_rule_group_id = aws_route53_resolver_firewall_rule_group.main.id
  priority               = 100

  dynamic "block_response" {
    for_each = local.blocked_domains
    content {
      domain = block_response.value
    }
  }
}

resource "aws_route53_resolver_firewall_rule" "allow" {
  provider = aws.primary
  name                    = "allow-trusted-domains"
  action                  = "ALLOW"
  firewall_rule_group_id = aws_route53_resolver_firewall_rule_group.main.id
  priority               = 200

  dynamic "block_response" {
    for_each = local.allowed_domains
    content {
      domain = block_response.value
    }
  }
}

resource "aws_route53_resolver_firewall_rule" "audit" {
  provider = aws.primary
  name                    = "audit-suspicious-domains"
  action                  = "ALERT"
  firewall_rule_group_id = aws_route53_resolver_firewall_rule_group.main.id
  priority               = 300

  dynamic "block_response" {
    for_each = local.audit_domains
    content {
      domain = block_response.value
    }
  }
}

output "rule_group_id" {
  description = "The ID of the DNS firewall rule group"
  value       = aws_route53_resolver_firewall_rule_group.main.id
}

output "rule_group_arn" {
  description = "The ARN of the DNS firewall rule group"
  value       = aws_route53_resolver_firewall_rule_group.main.arn
} 