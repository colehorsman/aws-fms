variable "environment" {
  description = "Environment name"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "exclude_resource_tags" {
  description = "A set of resource tags to exclude from the policy"
  type        = map(string)
  default     = {}
}

variable "waf_rule_group_id" {
  description = "ID of the WAF rule group to use"
  type        = string
}

# Production environment ARNs
variable "cloudfront_distribution_arn" {
  description = "ARN of the production CloudFront distribution"
  type        = string
}

variable "alb_arn" {
  description = "ARN of the production ALB"
  type        = string
}

variable "api_gateway_stage_arn" {
  description = "ARN of the production API Gateway stage"
  type        = string
}

# Development environment ARNs
variable "dev_cloudfront_distribution_arn" {
  description = "ARN of the development CloudFront distribution"
  type        = string
}

variable "dev_alb_arn" {
  description = "ARN of the development ALB"
  type        = string
}

variable "dev_api_gateway_stage_arn" {
  description = "ARN of the development API Gateway stage"
  type        = string
}

# Restricted environment ARNs
variable "restricted_cloudfront_distribution_arn" {
  description = "ARN of the restricted CloudFront distribution"
  type        = string
}

variable "restricted_alb_arn" {
  description = "ARN of the restricted ALB"
  type        = string
}

variable "restricted_api_gateway_stage_arn" {
  description = "ARN of the restricted API Gateway stage"
  type        = string
}

variable "data_class" {
  description = "Data classification level (e.g., public, internal, confidential, restricted)"
  type        = string
  default     = "internal"
}

variable "owner" {
  description = "Owner of the resource (e.g., team name, individual)"
  type        = string
  default     = "security-team"
}

variable "name" {
  description = "Name of the resource"
  type        = string
  default     = ""
}

# Local variables for common tags
locals {
  common_tags = merge(
    var.tags,
    {
      Name        = var.name
      Environment = var.environment
      DataClass   = var.data_class
      Owner       = var.owner
      ManagedBy   = "Terraform"
      Project     = "FMS"
    }
  )
} 