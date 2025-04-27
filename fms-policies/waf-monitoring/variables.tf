variable "environment" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}

variable "web_acl_name" {
  description = "Name of the Web ACL to monitor"
  type        = string
}

variable "primary_region" {
  description = "Primary AWS region (e.g., us-east-1)"
  type        = string
  default     = "us-east-1"
}

variable "dr_region" {
  description = "Disaster recovery AWS region (e.g., us-west-2)"
  type        = string
  default     = "us-west-2"
}

variable "cloudfront_enabled" {
  description = "Whether to enable CloudFront monitoring"
  type        = bool
  default     = true
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