variable "environment" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}

variable "fms_admin_account_id" {
  description = "AWS account ID of the Firewall Manager administrator account"
  type        = string
}

variable "organization_account_access_role_arn" {
  description = "ARN of the IAM role used for cross-account access within the organization"
  type        = string
}

variable "organization_id" {
  description = "AWS Organizations ID"
  type        = string
}

variable "terraform_state_bucket" {
  description = "S3 bucket name for storing Terraform state"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where resources will be deployed"
  type        = string
}

variable "waf_log_destination_arn" {
  description = "ARN of the Kinesis Firehose for WAF logging"
  type        = string
}

variable "cloudfront_distribution_arn" {
  description = "ARN of the production CloudFront distribution"
  type        = string
}

variable "alb_arn" {
  description = "ARN of the production Application Load Balancer"
  type        = string
}

variable "api_gateway_stage_arn" {
  description = "ARN of the production API Gateway stage"
  type        = string
}

variable "dev_cloudfront_distribution_arn" {
  description = "ARN of the development CloudFront distribution"
  type        = string
}

variable "dev_alb_arn" {
  description = "ARN of the development Application Load Balancer"
  type        = string
}

variable "dev_api_gateway_stage_arn" {
  description = "ARN of the development API Gateway stage"
  type        = string
}

variable "restricted_cloudfront_distribution_arn" {
  description = "ARN of the restricted environment CloudFront distribution"
  type        = string
}

variable "restricted_alb_arn" {
  description = "ARN of the restricted environment Application Load Balancer"
  type        = string
}

variable "restricted_api_gateway_stage_arn" {
  description = "ARN of the restricted environment API Gateway stage"
  type        = string
}

variable "health_check_arn" {
  description = "ARN of the Route53 health check for Shield Advanced"
  type        = string
}

variable "sns_topic_arn" {
  description = "ARN of the SNS topic for WAF alerts"
  type        = string
}

variable "primary_region" {
  description = "Primary AWS region for resource deployment"
  type        = string
}

variable "dr_region" {
  description = "Disaster recovery AWS region"
  type        = string
}

variable "tags" {
  description = "Map of tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "exclude_resource_tags" {
  description = "A list of resource tags to exclude from FMS policies"
  type        = list(string)
  default     = ["fms-exclude=true"]
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