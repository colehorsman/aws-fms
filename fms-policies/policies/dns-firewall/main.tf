# DNS Firewall Policy
resource "aws_fms_policy" "dns_firewall_policy" {
  name                  = "fms-dns-firewall-policy"
  description           = "FMS policy for DNS Firewall rules"
  exclude_resource_tags = var.exclude_resource_tags
  remediation_enabled   = true
  resource_type         = "AWS::Route53Resolver::ResolverRule"
  security_service_policy_data = jsonencode({
    Type = "DNS_FIREWALL"
    ManagedServiceData = jsonencode({
      type = "DNS_FIREWALL"
      overrideCustomerDNSFirewallConfiguration = {
        defaultAction = "BLOCK"
        firewallRules = [
          {
            action = "BLOCK"
            priority = 1
            domainName = "malicious-domain.com"
            qtype = "ANY"
          },
          {
            action = "BLOCK"
            priority = 2
            domainName = "data-exfiltration.com"
            qtype = "ANY"
          },
          {
            action = "ALERT"
            priority = 3
            domainName = "suspicious-domain.com"
            qtype = "ANY"
          }
        ]
      }
    })
  })

  tags = local.common_tags
}

# DNS Firewall Rule Group
resource "aws_route53_resolver_firewall_rule_group" "dns_firewall_rule_group" {
  name = "dns-firewall-rule-group"

  tags = local.common_tags
}

# DNS Firewall Rules
resource "aws_route53_resolver_firewall_rule" "block_malicious" {
  name                    = "block-malicious-domains"
  action                  = "BLOCK"
  firewall_rule_group_id = aws_route53_resolver_firewall_rule_group.dns_firewall_rule_group.id
  priority                = 1
  domain_name             = "malicious-domain.com"
  qtype                   = "ANY"
}

resource "aws_route53_resolver_firewall_rule" "block_exfiltration" {
  name                    = "block-data-exfiltration"
  action                  = "BLOCK"
  firewall_rule_group_id = aws_route53_resolver_firewall_rule_group.dns_firewall_rule_group.id
  priority                = 2
  domain_name             = "data-exfiltration.com"
  qtype                   = "ANY"
}

resource "aws_route53_resolver_firewall_rule" "alert_suspicious" {
  name                    = "alert-suspicious-domains"
  action                  = "ALERT"
  firewall_rule_group_id = aws_route53_resolver_firewall_rule_group.dns_firewall_rule_group.id
  priority                = 3
  domain_name             = "suspicious-domain.com"
  qtype                   = "ANY"
}

# DNS Firewall Rule Group Association
resource "aws_route53_resolver_firewall_rule_group_association" "dns_firewall_association" {
  name                   = "dns-firewall-association"
  firewall_rule_group_id = aws_route53_resolver_firewall_rule_group.dns_firewall_rule_group.id
  vpc_id                 = var.vpc_id
  priority               = 100

  tags = local.common_tags
} 