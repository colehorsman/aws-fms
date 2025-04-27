variable "environment" {
  description = "Environment name (e.g., prod, staging, dev)"
  type        = string
  default     = "prod"
}

variable "tags" {
  description = "Additional tags for all resources"
  type        = map(string)
  default     = {}
} 