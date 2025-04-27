# FMS Modules

This directory contains reusable Terraform modules for AWS Firewall Manager (FMS) configurations.

## Available Modules

### Default Policy Module
The `default-policy` module provides a way to create default WAF policies with tag-based exclusions:
- Team-specific default policies
- Tag-based resource exclusions
- Integrated logging and monitoring
- Customizable rule groups

Example usage:
```hcl
module "team_default_policy" {
  source = "../../modules/default-policy"

  environment = "prod"
  team_name   = "risk"

  # Exclude resources with specific tags
  exclude_tags = {
    "repo" = ["edh", "beacon"]
  }

  # Default rule groups
  rule_groups = [
    {
      name        = "AWSManagedRulesCommonRuleSet"
      priority    = 1
      rule_group_id = "AWSManagedRulesCommonRuleSet"
    }
  ]

  default_action = "BLOCK"
  tags = var.tags
}
```

### WAF Rule Groups Module
The `waf-rule-groups` module provides a reusable configuration for WAF rule groups. It supports:
- Multiple rule groups with priorities
- Default action configuration
- Tag management

Example usage:
```hcl
module "waf_rule_groups" {
  source = "../../modules/waf-rule-groups"

  rule_groups = [
    {
      name        = "AWSManagedRulesCommonRuleSet"
      priority    = 1
      rule_group_id = "AWSManagedRulesCommonRuleSet"
    }
  ]

  default_action = "BLOCK"
  tags = var.tags
}
```

### WAF Logging Module
The `waf-logging` module sets up WAF logging infrastructure:
- Kinesis Firehose delivery stream
- S3 bucket for log storage
- IAM roles and policies
- Log retention policies

Example usage:
```hcl
module "waf_logging" {
  source = "../../modules/waf-logging"

  environment = var.environment
  log_retention_days = 365
  tags = var.tags
}
```

### WAF Monitoring Module
The `waf-monitoring` module provides monitoring and alerting capabilities:
- CloudWatch dashboard for WAF metrics
- CloudWatch alarms for WAF events
- Athena table for log analysis

Example usage:
```hcl
module "waf_monitoring" {
  source = "../../modules/waf-monitoring"

  environment = var.environment
  alarm_threshold = 100
  tags = var.tags
}
```

## Best Practices

1. **Module Versioning**
   - Use semantic versioning for modules
   - Pin module versions in production
   - Document breaking changes

2. **Security**
   - Enable encryption for all resources
   - Implement least privilege IAM policies
   - Use secure defaults

3. **Monitoring**
   - Enable logging for all resources
   - Set up appropriate alarms
   - Monitor resource usage

4. **Maintenance**
   - Keep modules up to date
   - Document all changes
   - Test changes in non-production

## Contributing

1. Create a new branch for your changes
2. Update module documentation
3. Add tests for new functionality
4. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details. 