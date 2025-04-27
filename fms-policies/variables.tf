variable "environment" {
  description = "Environment name"
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to resources"
  type        = map(string)
  default     = {}
}

variable "primary_region" {
  description = "AWS region for primary deployment"
  type        = string
  default     = "us-east-1"
}

variable "dr_region" {
  description = "AWS region for DR deployment"
  type        = string
  default     = "us-west-2"
}

variable "waf_log_destination_arn" {
  description = "ARN of the WAF log destination"
  type        = string
} 