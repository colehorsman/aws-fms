variable "environment" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}

variable "resource_arn" {
  description = "ARN of the resource to protect with Shield"
  type        = string
}

variable "shield_standard_enabled" {
  description = "Whether to enable Shield Standard protection"
  type        = bool
  default     = true
}

variable "shield_advanced_enabled" {
  description = "Whether to enable Shield Advanced protection"
  type        = bool
  default     = false
}

variable "health_check_arn" {
  description = "ARN of the Route53 health check for Shield Advanced"
  type        = string
  default     = ""
}

variable "primary_region" {
  description = "Primary AWS region (e.g., us-east-1)"
  type        = string
  default     = "us-east-1"
}

variable "sns_topic_arn" {
  description = "ARN of the SNS topic for alarm notifications"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
} 