variable "environment" {
  description = "Environment name for WAF rule groups"
  type        = string
}

variable "region" {
  description = "AWS region for WAF rule groups"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all WAF rule group resources"
  type        = map(string)
  default     = {}
} 