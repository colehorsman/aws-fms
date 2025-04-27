variable "environment" {
  description = "Environment name for WAF monitoring resources"
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

variable "sns_topic_arn" {
  description = "ARN of the SNS topic for WAF alerts"
  type        = string
}

variable "cloudfront_enabled" {
  description = "Whether to enable CloudFront monitoring"
  type        = bool
  default     = true
}

variable "web_acl_name" {
  description = "Name of the WAF ACL to monitor"
  type        = string
}

variable "blocked_requests_threshold" {
  description = "Threshold for WAF blocked requests alarm"
  type        = number
  default     = 100
}

variable "tags" {
  description = "Tags to apply to all WAF monitoring resources"
  type        = map(string)
  default     = {}
} 