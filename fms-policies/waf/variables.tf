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

variable "organization_id" {
  description = "The ID of the AWS Organizations organization"
  type        = string
} 