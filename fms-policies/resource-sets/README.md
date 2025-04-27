# AWS FMS Resource Sets Module

This module creates AWS Firewall Manager (FMS) resource sets and policies for managing security policies across multiple AWS resources.

## Features

- Creates FMS resource sets for different environments (Production, Development, Restricted)
- Supports multiple resource types:
  - CloudFront distributions
  - Application Load Balancers (ALB)
  - API Gateway stages
- Configurable WAF rule group associations
- Environment-specific tagging

## Usage

```hcl
module "resource_sets" {
  source = "./resource-sets"

  # Environment configuration
  environment = "dev"
  tags = {
    Environment = "dev"
    ManagedBy   = "terraform"
    Project     = "fms"
  }

  # WAF configuration
  waf_rule_group_id = "arn:aws:wafv2:us-east-1:123456789012:regional/rulegroup/example"

  # Production resources
  prod_cloudfront_distribution_arn = "arn:aws:cloudfront::123456789012:distribution/EXAMPLE"
  prod_alb_arn                    = "arn:aws:elasticloadbalancing:us-east-1:123456789012:loadbalancer/app/example"
  prod_api_gateway_stage_arn      = "arn:aws:apigateway:us-east-1::/restapis/example/stages/prod"

  # Development resources
  dev_cloudfront_distribution_arn = "arn:aws:cloudfront::123456789012:distribution/EXAMPLE"
  dev_alb_arn                    = "arn:aws:elasticloadbalancing:us-east-1:123456789012:loadbalancer/app/example"
  dev_api_gateway_stage_arn      = "arn:aws:apigateway:us-east-1::/restapis/example/stages/dev"

  # Restricted resources
  restricted_cloudfront_distribution_arn = "arn:aws:cloudfront::123456789012:distribution/EXAMPLE"
  restricted_alb_arn                    = "arn:aws:elasticloadbalancing:us-east-1:123456789012:loadbalancer/app/example"
  restricted_api_gateway_stage_arn      = "arn:aws:apigateway:us-east-1::/restapis/example/stages/restricted"
}
```

## Inputs

| Name | Description | Type | Required |
|------|-------------|------|----------|
| environment | Environment name (e.g., dev, prod) | string | Yes |
| tags | Tags to apply to all resources | map(string) | Yes |
| waf_rule_group_id | ID of the WAF rule group to use | string | Yes |
| prod_cloudfront_distribution_arn | ARN of the production CloudFront distribution | string | No |
| prod_alb_arn | ARN of the production ALB | string | No |
| prod_api_gateway_stage_arn | ARN of the production API Gateway stage | string | No |
| dev_cloudfront_distribution_arn | ARN of the development CloudFront distribution | string | No |
| dev_alb_arn | ARN of the development ALB | string | No |
| dev_api_gateway_stage_arn | ARN of the development API Gateway stage | string | No |
| restricted_cloudfront_distribution_arn | ARN of the restricted CloudFront distribution | string | No |
| restricted_alb_arn | ARN of the restricted ALB | string | No |
| restricted_api_gateway_stage_arn | ARN of the restricted API Gateway stage | string | No |

## Outputs

| Name | Description |
|------|-------------|
| fms_policy_id | ID of the FMS policy |
| fms_policy_arn | ARN of the FMS policy | 