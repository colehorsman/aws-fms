locals {
  blocked_domains = jsondecode(file("${path.module}/blocked-domains.json")).domains
  allowed_domains = jsondecode(file("${path.module}/allowed-domains.json")).domains
  audit_domains = jsondecode(file("${path.module}/audit-domains.json")).domains
}

resource "aws_route53_resolver_firewall_rule_group" "main" {
  name = "fms-dns-firewall-rules"
  tags = var.tags
}

resource "aws_route53_resolver_firewall_rule" "block" {
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