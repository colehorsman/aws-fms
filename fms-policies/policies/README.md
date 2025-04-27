# FMS Policies

This directory contains the Firewall Manager Service (FMS) policies organized by resource type.

## Directory Structure

```
policies/
├── alb/              # Application Load Balancer policies
├── api-gateway/      # API Gateway policies
├── cloudfront/       # CloudFront distribution policies
└── security-groups/  # Security Group policies
```

## Policy Types

### ALB Policies
- WAF rules for Application Load Balancers
- Regional scope
- Common rule sets for web application protection

### API Gateway Policies
- WAF rules for API Gateway stages
- Regional scope
- API-specific protection rules

### CloudFront Policies
- WAF rules for CloudFront distributions
- Global scope
- CDN-specific protection rules

### Security Group Policies
- Security group rules for managed scanners
- VPC-specific configurations
- Scanner access management

## Usage

Each policy type is implemented as a separate module with its own:
- `main.tf` - Main policy configuration
- `variables.tf` - Input variables
- `outputs.tf` - Output values

## Variables

Common variables used across all policies:
- `environment` - Environment name (e.g., prod, dev)
- `exclude_resource_tags` - Tags to exclude from FMS policies
- `tags` - Default tags for resources
- `vpc_id` - VPC ID for security group creation
- `data_class` - Data classification level (e.g., public, internal, confidential, restricted)
- `owner` - Owner of the resource (e.g., team name, individual)
- `name` - Name of the resource

## Tagging Requirements

All resources that support tagging must include the following tags:
- `Name` - Resource name
- `Environment` - Environment name (e.g., prod, dev)
- `DataClass` - Data classification level
- `Owner` - Owner of the resource
- `ManagedBy` - Set to "Terraform"
- `Project` - Set to "FMS"

These tags are automatically applied through the `common_tags` local variable.

## Best Practices

1. Always use the provided variables for consistency
2. Follow the naming convention: `fms-<resource-type>-<policy-type>`
3. Enable remediation for automatic policy enforcement
4. Configure appropriate logging and monitoring
5. Use tags for resource organization
6. Ensure all resources have the required tags 