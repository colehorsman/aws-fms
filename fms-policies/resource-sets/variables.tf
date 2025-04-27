variable "environment" {
  description = "Environment name"
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to resources"
  type        = map(string)
  default     = {}
}

variable "exclude_resource_tags" {
  description = "A set of resource tags to exclude from the policy"
  type        = map(string)
  default     = {}
}

variable "waf_rule_group_id" {
  description = "ID of the WAF rule group"
  type        = string
}

variable "cloudfront_distribution_arn" {
  description = "ARN of the CloudFront distribution"
  type        = string
}

variable "alb_arn" {
  description = "ARN of the Application Load Balancer"
  type        = string
}

variable "api_gateway_stage_arn" {
  description = "ARN of the API Gateway stage"
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
  description = "ARN of the restricted CloudFront distribution"
  type        = string
}

variable "restricted_alb_arn" {
  description = "ARN of the restricted Application Load Balancer"
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