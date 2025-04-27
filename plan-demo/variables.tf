variable "aws_region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "The environment (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "fms_admin_account_id" {
  description = "The AWS account ID of the FMS administrator account"
  type        = string
  default     = "123456789012"  # Replace with your account ID
}

variable "vpc_id" {
  description = "The VPC ID where the security group will be created"
  type        = string
  default     = "vpc-12345678"  # Replace with your VPC ID
} 