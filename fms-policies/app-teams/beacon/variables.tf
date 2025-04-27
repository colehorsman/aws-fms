variable "organization_id" {
  description = "AWS Organizations ID"
  type        = string
}

variable "exclude_resource_tags" {
  description = "A list of resource tags to exclude from FMS policies"
  type        = list(string)
  default     = ["fms-exclude=true"]
}

variable "tags" {
  description = "Additional tags for all resources"
  type        = map(string)
  default     = {}
} 