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

variable "vpc_id" {
  description = "VPC ID for DNS Firewall rule group association"
  type        = string
}

variable "malicious_domains" {
  description = "List of malicious domains to block"
  type        = list(string)
  default     = ["malicious-domain.com"]
}

variable "exfiltration_domains" {
  description = "List of data exfiltration domains to block"
  type        = list(string)
  default     = ["data-exfiltration.com"]
}

variable "suspicious_domains" {
  description = "List of suspicious domains to alert on"
  type        = list(string)
  default     = ["suspicious-domain.com"]
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