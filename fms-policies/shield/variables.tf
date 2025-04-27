variable "environment" {
  description = "Environment name for the Shield resources"
  type        = string
}

variable "shield_advanced_enabled" {
  description = "Whether to enable Shield Advanced protection"
  type        = bool
  default     = true
}

variable "resource_arn" {
  description = "ARN of the resource to protect with Shield Advanced"
  type        = string
}

variable "health_check_arn" {
  description = "ARN of the Route53 health check to associate with Shield protection"
  type        = string
  default     = null
}

variable "sns_topic_arn" {
  description = "ARN of the SNS topic for Shield DDoS attack notifications"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all Shield resources"
  type        = map(string)
  default     = {}
} 