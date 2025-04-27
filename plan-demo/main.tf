# Simplified version for planning purposes
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  required_version = ">= 1.0.0"
}

provider "aws" {
  region = var.aws_region
}

# Sample resources for planning
resource "aws_fms_admin_account" "fms_admin" {
  account_id = var.fms_admin_account_id
}

resource "aws_iam_role" "fms_service_role" {
  name = "AWSServiceRoleForFMS"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "fms.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "fms_service_role_policy" {
  role       = aws_iam_role.fms_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSFirewallManagerServiceRole"
}

# Sample WAF policy
resource "aws_fms_policy" "waf_policy" {
  name                  = "FMS-WAF-Policy"
  description           = "WAF policy managed by FMS"
  exclude_resource_tags = false
  remediation_enabled   = true

  security_service_policy_data {
    type = "WAF"
    managed_service_data = jsonencode({
      defaultAction = {
        block = {}
      }
      preProcessRuleGroups = [
        {
          ruleGroupArn = "arn:aws:wafv2:us-east-1:${var.fms_admin_account_id}:regional/rulegroup/AWSManagedRulesCommonRuleSet/12345678-1234-1234-1234-123456789012"
          priority     = 1
          overrideAction = {
            none = {}
          }
        }
      ]
    })
  }

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = "FMS"
  }
}

# DNS Firewall policy
resource "aws_fms_policy" "dns_policy" {
  name                  = "FMS-DNS-Policy"
  description           = "DNS Firewall policy managed by FMS"
  remediation_enabled   = true
  resource_type        = "AWS::Route53Resolver::FirewallRuleGroup"
  exclude_resource_tags = false

  security_service_policy_data {
    type = "DNS_FIREWALL"
    managed_service_data = jsonencode({
      type                 = "DNS_FIREWALL"
      preProcessRuleGroups = []
      overrideCustomerWebACLAssociation = false
      ruleGroups = [
        {
          id = aws_route53_resolver_firewall_rule_group.blocked_domains.id
          priority = 100
        }
      ]
    })
  }

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = "FMS"
  }
}

# Security Group policy
resource "aws_fms_policy" "security_group_policy" {
  name                    = "FMS-SecurityGroup-Policy"
  description             = "Security Group policy managed by FMS"
  remediation_enabled     = true
  resource_type          = "AWS::EC2::SecurityGroup"
  exclude_resource_tags  = false

  security_service_policy_data {
    type = "SECURITY_GROUPS_COMMON"
    managed_service_data = jsonencode({
      type = "SECURITY_GROUPS_COMMON"
      revertManualSecurityGroupChanges = true
      exclusiveResourceSecurityGroupManagement = false
      securityGroups = [
        {
          id = aws_security_group.example.id
        }
      ]
    })
  }

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = "FMS"
  }
}

# Example security group that will be managed by FMS
resource "aws_security_group" "example" {
  name        = "fms-managed-sg"
  description = "Security group managed by FMS"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = "FMS"
  }
}

# Example DNS Firewall rule group
resource "aws_route53_resolver_firewall_rule_group" "blocked_domains" {
  name = "blocked-domains"
  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = "FMS"
  }
}

# Risk Team Default Policies
resource "aws_fms_policy" "risk_alb_policy" {
  name                  = "Risk-ALB-Default-Policy"
  description           = "Default WAF policy for Risk team ALBs"
  exclude_resource_tags = false
  remediation_enabled   = true

  security_service_policy_data {
    type = "WAF"
    managed_service_data = jsonencode({
      defaultAction = {
        block = {}
      }
      preProcessRuleGroups = [
        {
          ruleGroupArn = "arn:aws:wafv2:us-east-1:${var.fms_admin_account_id}:regional/rulegroup/AWSManagedRulesCommonRuleSet/12345678-1234-1234-1234-123456789012"
          priority     = 1
          overrideAction = {
            none = {}
          }
        }
      ]
    })
  }

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = "Risk"
    Team        = "Risk"
  }
}

resource "aws_fms_policy" "risk_api_gateway_policy" {
  name                  = "Risk-APIGateway-Default-Policy"
  description           = "Default WAF policy for Risk team API Gateways"
  exclude_resource_tags = false
  remediation_enabled   = true

  security_service_policy_data {
    type = "WAF"
    managed_service_data = jsonencode({
      defaultAction = {
        block = {}
      }
      preProcessRuleGroups = [
        {
          ruleGroupArn = "arn:aws:wafv2:us-east-1:${var.fms_admin_account_id}:regional/rulegroup/AWSManagedRulesCommonRuleSet/12345678-1234-1234-1234-123456789012"
          priority     = 1
          overrideAction = {
            none = {}
          }
        }
      ]
    })
  }

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = "Risk"
    Team        = "Risk"
  }
}

resource "aws_fms_policy" "risk_cloudfront_policy" {
  name                  = "Risk-CloudFront-Default-Policy"
  description           = "Default WAF policy for Risk team CloudFront distributions"
  exclude_resource_tags = false
  remediation_enabled   = true

  security_service_policy_data {
    type = "WAF"
    managed_service_data = jsonencode({
      defaultAction = {
        block = {}
      }
      preProcessRuleGroups = [
        {
          ruleGroupArn = "arn:aws:wafv2:global:${var.fms_admin_account_id}:global/rulegroup/AWSManagedRulesCommonRuleSet/12345678-1234-1234-1234-123456789012"
          priority     = 1
          overrideAction = {
            none = {}
          }
        }
      ]
    })
  }

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = "Risk"
    Team        = "Risk"
  }
}

# Life Team Default Policies
resource "aws_fms_policy" "life_alb_policy" {
  name                  = "Life-ALB-Default-Policy"
  description           = "Default WAF policy for Life team ALBs"
  exclude_resource_tags = false
  remediation_enabled   = true

  security_service_policy_data {
    type = "WAF"
    managed_service_data = jsonencode({
      defaultAction = {
        block = {}
      }
      preProcessRuleGroups = [
        {
          ruleGroupArn = "arn:aws:wafv2:us-east-1:${var.fms_admin_account_id}:regional/rulegroup/AWSManagedRulesCommonRuleSet/12345678-1234-1234-1234-123456789012"
          priority     = 1
          overrideAction = {
            none = {}
          }
        }
      ]
    })
  }

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = "Life"
    Team        = "Life"
  }
}

resource "aws_fms_policy" "life_api_gateway_policy" {
  name                  = "Life-APIGateway-Default-Policy"
  description           = "Default WAF policy for Life team API Gateways"
  exclude_resource_tags = false
  remediation_enabled   = true

  security_service_policy_data {
    type = "WAF"
    managed_service_data = jsonencode({
      defaultAction = {
        block = {}
      }
      preProcessRuleGroups = [
        {
          ruleGroupArn = "arn:aws:wafv2:us-east-1:${var.fms_admin_account_id}:regional/rulegroup/AWSManagedRulesCommonRuleSet/12345678-1234-1234-1234-123456789012"
          priority     = 1
          overrideAction = {
            none = {}
          }
        }
      ]
    })
  }

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = "Life"
    Team        = "Life"
  }
}

resource "aws_fms_policy" "life_cloudfront_policy" {
  name                  = "Life-CloudFront-Default-Policy"
  description           = "Default WAF policy for Life team CloudFront distributions"
  exclude_resource_tags = false
  remediation_enabled   = true

  security_service_policy_data {
    type = "WAF"
    managed_service_data = jsonencode({
      defaultAction = {
        block = {}
      }
      preProcessRuleGroups = [
        {
          ruleGroupArn = "arn:aws:wafv2:global:${var.fms_admin_account_id}:global/rulegroup/AWSManagedRulesCommonRuleSet/12345678-1234-1234-1234-123456789012"
          priority     = 1
          overrideAction = {
            none = {}
          }
        }
      ]
    })
  }

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = "Life"
    Team        = "Life"
  }
}

# Beacon Team Default Policies
resource "aws_fms_policy" "beacon_alb_policy" {
  name                  = "Beacon-ALB-Default-Policy"
  description           = "Default WAF policy for Beacon team ALBs"
  exclude_resource_tags = false
  remediation_enabled   = true

  security_service_policy_data {
    type = "WAF"
    managed_service_data = jsonencode({
      defaultAction = {
        block = {}
      }
      preProcessRuleGroups = [
        {
          ruleGroupArn = "arn:aws:wafv2:us-east-1:${var.fms_admin_account_id}:regional/rulegroup/AWSManagedRulesCommonRuleSet/12345678-1234-1234-1234-123456789012"
          priority     = 1
          overrideAction = {
            none = {}
          }
        }
      ]
    })
  }

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = "Beacon"
    Team        = "Beacon"
  }
}

resource "aws_fms_policy" "beacon_api_gateway_policy" {
  name                  = "Beacon-APIGateway-Default-Policy"
  description           = "Default WAF policy for Beacon team API Gateways"
  exclude_resource_tags = false
  remediation_enabled   = true

  security_service_policy_data {
    type = "WAF"
    managed_service_data = jsonencode({
      defaultAction = {
        block = {}
      }
      preProcessRuleGroups = [
        {
          ruleGroupArn = "arn:aws:wafv2:us-east-1:${var.fms_admin_account_id}:regional/rulegroup/AWSManagedRulesCommonRuleSet/12345678-1234-1234-1234-123456789012"
          priority     = 1
          overrideAction = {
            none = {}
          }
        }
      ]
    })
  }

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = "Beacon"
    Team        = "Beacon"
  }
}

resource "aws_fms_policy" "beacon_cloudfront_policy" {
  name                  = "Beacon-CloudFront-Default-Policy"
  description           = "Default WAF policy for Beacon team CloudFront distributions"
  exclude_resource_tags = false
  remediation_enabled   = true

  security_service_policy_data {
    type = "WAF"
    managed_service_data = jsonencode({
      defaultAction = {
        block = {}
      }
      preProcessRuleGroups = [
        {
          ruleGroupArn = "arn:aws:wafv2:global:${var.fms_admin_account_id}:global/rulegroup/AWSManagedRulesCommonRuleSet/12345678-1234-1234-1234-123456789012"
          priority     = 1
          overrideAction = {
            none = {}
          }
        }
      ]
    })
  }

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = "Beacon"
    Team        = "Beacon"
  }
}

# EDH Team Default Policies
resource "aws_fms_policy" "edh_alb_policy" {
  name                  = "EDH-ALB-Default-Policy"
  description           = "Default WAF policy for EDH team ALBs"
  exclude_resource_tags = false
  remediation_enabled   = true

  security_service_policy_data {
    type = "WAF"
    managed_service_data = jsonencode({
      defaultAction = {
        block = {}
      }
      preProcessRuleGroups = [
        {
          ruleGroupArn = "arn:aws:wafv2:us-east-1:${var.fms_admin_account_id}:regional/rulegroup/AWSManagedRulesCommonRuleSet/12345678-1234-1234-1234-123456789012"
          priority     = 1
          overrideAction = {
            none = {}
          }
        }
      ]
    })
  }

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = "EDH"
    Team        = "EDH"
  }
}

resource "aws_fms_policy" "edh_api_gateway_policy" {
  name                  = "EDH-APIGateway-Default-Policy"
  description           = "Default WAF policy for EDH team API Gateways"
  exclude_resource_tags = false
  remediation_enabled   = true

  security_service_policy_data {
    type = "WAF"
    managed_service_data = jsonencode({
      defaultAction = {
        block = {}
      }
      preProcessRuleGroups = [
        {
          ruleGroupArn = "arn:aws:wafv2:us-east-1:${var.fms_admin_account_id}:regional/rulegroup/AWSManagedRulesCommonRuleSet/12345678-1234-1234-1234-123456789012"
          priority     = 1
          overrideAction = {
            none = {}
          }
        }
      ]
    })
  }

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = "EDH"
    Team        = "EDH"
  }
}

resource "aws_fms_policy" "edh_cloudfront_policy" {
  name                  = "EDH-CloudFront-Default-Policy"
  description           = "Default WAF policy for EDH team CloudFront distributions"
  exclude_resource_tags = false
  remediation_enabled   = true

  security_service_policy_data {
    type = "WAF"
    managed_service_data = jsonencode({
      defaultAction = {
        block = {}
      }
      preProcessRuleGroups = [
        {
          ruleGroupArn = "arn:aws:wafv2:global:${var.fms_admin_account_id}:global/rulegroup/AWSManagedRulesCommonRuleSet/12345678-1234-1234-1234-123456789012"
          priority     = 1
          overrideAction = {
            none = {}
          }
        }
      ]
    })
  }

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = "EDH"
    Team        = "EDH"
  }
} 