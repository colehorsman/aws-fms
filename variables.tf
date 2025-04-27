variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name (e.g., prod, dev)"
  type        = string
}

variable "organization_id" {
  description = "AWS Organizations ID"
  type        = string
}

variable "fms_admin_account_id" {
  description = "AWS Account ID that will be the FMS administrator account"
  type        = string
}

variable "exclude_resource_tags" {
  description = "A list of resource tags to exclude from FMS policies"
  type        = list(string)
  default     = ["fms-exclude=true"]
}

variable "primary_region" {
  description = "Primary AWS region"
  type        = string
  default     = "us-east-1"
}

variable "dr_region" {
  description = "Disaster recovery AWS region"
  type        = string
  default     = "us-west-2"
}

variable "waf_log_destination_arn" {
  description = "ARN of the WAF log destination"
  type        = string
}

variable "tags" {
  description = "Default tags for all resources"
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "VPC ID for DNS Firewall and security groups"
  type        = string
}

# Production resources
variable "cloudfront_distribution_arn" {
  description = "ARN of the production CloudFront distribution"
  type        = string
  default     = ""
}

variable "alb_arn" {
  description = "ARN of the production ALB"
  type        = string
  default     = ""
}

variable "api_gateway_stage_arn" {
  description = "ARN of the production API Gateway stage"
  type        = string
  default     = ""
}

# Development resources
variable "dev_cloudfront_distribution_arn" {
  description = "ARN of the development CloudFront distribution"
  type        = string
  default     = ""
}

variable "dev_alb_arn" {
  description = "ARN of the development ALB"
  type        = string
  default     = ""
}

variable "dev_api_gateway_stage_arn" {
  description = "ARN of the development API Gateway stage"
  type        = string
  default     = ""
}

# Restricted resources
variable "restricted_cloudfront_distribution_arn" {
  description = "ARN of the restricted CloudFront distribution"
  type        = string
  default     = ""
}

variable "restricted_alb_arn" {
  description = "ARN of the restricted ALB"
  type        = string
  default     = ""
}

variable "restricted_api_gateway_stage_arn" {
  description = "ARN of the restricted API Gateway stage"
  type        = string
  default     = ""
}

# Local variables for delegated FMS accounts
locals {
  delegated_fms_accounts = {
    security_lab = {
      id   = "101010101010"
      name = "Security Lab Environment"
    }
    security_prod = {
      id   = "202020202020"
      name = "Security Production Environment"
    }
  }
} 