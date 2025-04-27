variable "environment" {
  description = "Environment name (e.g., prod, dev)"
  type        = string
}

variable "exclude_resource_tags" {
  description = "A list of resource tags to exclude from FMS policies"
  type        = list(string)
  default     = ["fms-exclude=true"]
}

variable "tags" {
  description = "Default tags for all resources"
  type        = map(string)
  default     = {}
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

variable "cloudfront_distribution_arn" {
  description = "ARN of the CloudFront distribution to protect"
  type        = string
}

variable "alb_arn" {
  description = "ARN of the ALB to protect"
  type        = string
  default     = ""
}

variable "api_gateway_stage_arn" {
  description = "ARN of the API Gateway stage to protect"
  type        = string
  default     = ""
}

variable "enable_alb_protection" {
  description = "Whether to enable Shield Advanced protection for ALB"
  type        = bool
  default     = false
}

variable "enable_api_gateway_protection" {
  description = "Whether to enable Shield Advanced protection for API Gateway"
  type        = bool
  default     = false
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