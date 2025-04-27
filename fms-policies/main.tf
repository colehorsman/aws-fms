terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      configuration_aliases = [aws.primary, aws.dr, aws.lab]
    }
  }
}

# WAF Policies
module "waf_policies" {
  source = "./waf"

  providers = {
    aws.primary = aws.primary
    aws.dr      = aws.dr
  }

  environment = var.environment
  tags        = var.tags
}

# Shield Configuration
module "shield" {
  source = "./shield"

  providers = {
    aws.primary = aws.primary
    aws.dr      = aws.dr
  }

  environment = var.environment
  tags        = var.tags
}

# DNS Firewall
module "dns_firewall" {
  source = "./dns-firewall"

  providers = {
    aws.primary = aws.primary
    aws.dr      = aws.dr
  }

  environment = var.environment
  tags        = var.tags
}

# Resource Sets
module "resource_sets" {
  source = "./resource-sets"

  providers = {
    aws.primary = aws.primary
    aws.dr      = aws.dr
  }

  environment = var.environment
  tags        = var.tags
} 