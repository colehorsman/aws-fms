# Enable FMS administrator account
resource "aws_fms_admin_account" "fms_admin" {
  account_id = var.fms_admin_account_id
}

# Create an IAM role for FMS to assume in member accounts
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

# Attach the AWS managed policy for FMS service role
resource "aws_iam_role_policy_attachment" "fms_service_role_policy" {
  role       = aws_iam_role.fms_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSFirewallManagerServiceRole"
}

# Enable policy versioning
resource "aws_fms_policy_versioning" "policy_versioning" {
  enabled = true
}

# Reference the WAF logging configuration
data "terraform_remote_state" "waf_logging" {
  backend = "s3"
  config = {
    bucket = "terraform-state-bucket"
    key    = "waf-logging/terraform.tfstate"
    region = var.aws_region
  }
}

# Set the WAF log destination ARN
locals {
  waf_log_destination_arn = data.terraform_remote_state.waf_logging.outputs.waf_logs_firehose_arn
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  required_version = ">= 1.0.0"
}

# Provider configuration for the primary region (us-east-1)
provider "aws" {
  region = var.primary_region
  alias  = "primary"

  assume_role {
    role_arn = "arn:aws:iam::${local.delegated_fms_accounts.security_prod.id}:role/OrganizationAccountAccessRole"
  }
}

# Provider configuration for the DR region (us-west-2)
provider "aws" {
  region = var.dr_region
  alias  = "dr"

  assume_role {
    role_arn = "arn:aws:iam::${local.delegated_fms_accounts.security_prod.id}:role/OrganizationAccountAccessRole"
  }
}

# Provider configuration for the security lab environment
provider "aws" {
  region = var.primary_region
  alias  = "lab"

  assume_role {
    role_arn = "arn:aws:iam::${local.delegated_fms_accounts.security_lab.id}:role/OrganizationAccountAccessRole"
  }
}

# Local variables
locals {
  common_tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = "FMS"
  }
}

# Module for WAF policies
module "waf_policies" {
  source = "./fms-policies"

  providers = {
    aws.primary = aws.primary
    aws.dr      = aws.dr
    aws.lab     = aws.lab
  }

  environment                = var.environment
  primary_region            = var.primary_region
  dr_region                 = var.dr_region
  waf_log_destination_arn   = var.waf_log_destination_arn
  delegated_fms_accounts    = local.delegated_fms_accounts
  tags                      = local.common_tags
}

# Module for WAF monitoring
module "waf_monitoring" {
  source = "./fms-policies/waf-monitoring"

  providers = {
    aws.primary = aws.primary
    aws.dr      = aws.dr
  }

  environment              = var.environment
  primary_region          = var.primary_region
  dr_region               = var.dr_region
  waf_log_destination_arn = var.waf_log_destination_arn
  tags                    = local.common_tags
}

# Module for Shield configuration
module "shield" {
  source = "./fms-policies/shield"

  providers = {
    aws.primary = aws.primary
    aws.dr      = aws.dr
  }

  environment     = var.environment
  primary_region  = var.primary_region
  dr_region       = var.dr_region
  tags            = local.common_tags
}

# Module for DNS Firewall
module "dns_firewall" {
  source = "./fms-policies/dns-firewall"

  providers = {
    aws.primary = aws.primary
    aws.dr      = aws.dr
  }

  environment     = var.environment
  vpc_id          = var.vpc_id
  tags            = local.common_tags
}

# Module for Resource Sets
module "resource_sets" {
  source = "./fms-policies/resource-sets"

  providers = {
    aws.primary = aws.primary
    aws.dr      = aws.dr
  }

  environment     = var.environment
  waf_rule_group_id = module.waf_policies.waf_rule_group_id
  tags            = local.common_tags
  
  # Production resources
  cloudfront_distribution_arn = var.cloudfront_distribution_arn
  alb_arn                    = var.alb_arn
  api_gateway_stage_arn      = var.api_gateway_stage_arn
  
  # Development resources
  dev_cloudfront_distribution_arn = var.dev_cloudfront_distribution_arn
  dev_alb_arn                    = var.dev_alb_arn
  dev_api_gateway_stage_arn      = var.dev_api_gateway_stage_arn
  
  # Restricted resources
  restricted_cloudfront_distribution_arn = var.restricted_cloudfront_distribution_arn
  restricted_alb_arn                    = var.restricted_alb_arn
  restricted_api_gateway_stage_arn      = var.restricted_api_gateway_stage_arn
} 